local lang_utils = require('treesj.langs.utils')
local langs = require('treesj.langs')['presets']
local presets = {
  bash = require('treesj.langs.bash'),
  css = require('treesj.langs.css'),
  go = require('treesj.langs.go'),
  javascript = require('treesj.langs.javascript'),
  kotlin = require('treesj.langs.kotlin'),
  lua = require('treesj.langs.lua'),
  python = require('treesj.langs.python'),
  ruby = require('treesj.langs.ruby'),
  rust = require('treesj.langs.rust'),
  tsx = require('treesj.langs.tsx'),
}

langs.default_preset = {
  both = {
    no_format_with = {},
    fallback = function(_)
      vim.dbglog('falling back to mini')
      MiniSplitjoin.toggle()
    end,
    format_tree = function(tsj)
      if tsj:type() ~= 'statement_block' then
        local body = tsj:child(2)
        if body:will_be_formatted() then
          local set_return
          if body:has_preset('split') then
            set_return = body:child(1)
          else
            set_return = body:child(1):child(1)
          end
          set_return:update_text('return ' .. set_return:text())
        else
          body:update_text('return ' .. body:text())
        end
      end
    end,
  },
}

langs.scss = lang_utils.merge_preset(presets.css, {})
langs.sh = lang_utils.merge_preset(presets.bash, {})
langs.typescriptreact = lang_utils.merge_preset(presets.tsx, {})

langs.kotlin = lang_utils.merge_preset(presets.kotlin, {
  -- The difficulty is that the last element in `function_declaration` is
  -- `function_body`, which must remain unchanged and can be multi-line.
  function_declaration = lang_utils.set_preset_for_args({
    both = {
      non_bracket_node = true,
      shrink_node = { from = '(', to = ')' },
    },
  }),
  -- Kotlin's 'statements' should be separated with ';' after each child
  -- when it joins, but for the last named child it is not necessary, and we want to skip it
  statements = lang_utils.set_preset_for_non_bracket({
    join = {
      force_insert = ';',
      no_insert_if = {
        lang_utils.helpers.if_penultimate,
      },
    },
  }),
})

langs.javascript = lang_utils.merge_preset(presets.javascript, {
  object = lang_utils.set_preset_for_dict(),
  array = lang_utils.set_preset_for_list(),
  formal_parameters = lang_utils.set_preset_for_args(),
  arguments = lang_utils.set_preset_for_args(),
  statement_block = lang_utils.set_preset_for_statement({
    join = {
      no_insert_if = {
        'function_declaration',
        'try_statement',
        'if_statement',
      },
    },
  }),
})

-- `block` in Lua does not have parentheses, but when it joins,
-- it must jump up a line and pull an `end` node that is not part of it.
-- To do this, you need to create imitators of framing nodes one line above and one line below
langs.lua = lang_utils.merge_preset(presets.lua, {
  -- table_constructor = lang_utils.set_preset_for_dict(),
  -- arguments = lang_utils.set_preset_for_args(),
  -- parameters = lang_utils.set_preset_for_args(),
  block = {
    both = {
      non_bracket_node = true,
      -- non_bracket_node = { left = '', right = '' }, - it is similar
    },
    join = {
      space_in_brackets = true,
    },
  },
})

-- but disable 'import_spec_list' when two or more 'import_spec' inside and
-- disable 'import_spec' when it already inside 'import_spec_list'
langs.go = lang_utils.merge_preset(presets.go, {
  import_spec = lang_utils.set_preset_for_args({
    both = {
      -- If the parent is a 'import_spec_list', then skip this node and
      -- look for a suitable one for formatting further
      enable = function(tsn)
        return tsn:parent():type() ~= 'import_spec_list'
      end,
    },
    split = {
      -- If the parent was something else, then wrap the import in parentheses,
      -- which actually converts the 'import_spec' into the 'import_spec_list'
      format_tree = function(tsj)
        tsj:wrap({ left = '(', right = ')' })
      end,
    },
  }),
  import_spec_list = lang_utils.set_preset_for_args({
    join = {
      enable = function(tsn)
        -- If the node contains more than one named child node, then disable
        return tsn:named_child_count() < 2
      end,
      format_tree = function(tsj)
        -- If there was only one named element, then remove the brackets
        tsj:remove_child({ '(', ')' })
      end,
    },
  }),
})

langs.ruby = lang_utils.merge_preset(presets.ruby, {
  -- split nested ruby class into modules (class Foo::Bar::Baz < Quux ... module Foo module Bar class Baz < Quux)
  module = {
    both = {
      no_format_with = {}, -- Need to avoid 'no format with comment'
      fallback = function(_)
        -- vim.cmd('SplitjoinJoin')
        MiniSplitjoin.join()
      end,
    },
  },
  class = {
    both = {
      no_format_with = {},
      fallback = function(_)
        -- vim.cmd('SplitjoinSplit')
        MiniSplitjoin.split()
      end,
    },
  },
  -- split ternary into if statements: cond ? do_that('cond') : do_this('not nond')
  -- ... if cond do_that('cond') else do_this('not nond') end
  conditional = lang_utils.set_default_preset({
    join = { enable = false },
    split = {
      omit = { lang_utils.helpers.if_second },
      format_tree = function(tsj)
        local children = tsj:children()
        table.insert(children, tsj:create_child({ text = 'end', type = 'end' }))
        tsj:child('?'):update_text('if ')
        tsj:child(':'):update_text('else')
        local first, second = tsj:child(1), tsj:child(2)
        children[1] = second
        children[2] = first
        tsj:update_children(children)
      end,
      format_resulted_lines = function(lines)
        return vim.tbl_map(function(line)
          -- Need to remove one indent on `else` element
          if line:match('%s.else$') then
            local rgx = '^' .. (' '):rep(vim.fn.shiftwidth())
            return line:gsub(rgx, '')
          else
            return line
          end
        end, lines)
      end,
    },
  }),
})

langs.rust = lang_utils.merge_preset(presets.rust, {
  --   `integer_literal` is not configured and can't be configured
  --   but you can transform this field into a `block` node
  match_arm = {
    target_nodes = { 'value' },
  },
  value = lang_utils.set_preset_for_statement({
    split = {
      format_tree = function(tsj)
        if tsj:type() ~= 'block' then
          tsj:wrap({ left = '{', right = '}' })
        end
      end,
    },
    join = {
      no_insert_if = { lang_utils.helpers.if_penultimate },
      format_tree = function(tsj)
        local node = tsj:tsnode()
        local parents = { 'match_arm', 'closure_expression' }
        local has_parent = vim.tbl_contains(parents, node:parent():type())
        if has_parent and node:named_child_count() == 1 then
          tsj:remove_child({ '{', '}' })
        end
      end,
    },
  }),
})

langs.python = lang_utils.merge_preset(presets.python, {
  -- Python's `import_from_statement` does not have a container for a list of imported modules.
  -- Need to add parentheses to the middle and end of TreeSJ when splitting these parentheses when joining.
  import_from_statement = lang_utils.set_preset_for_args({
    both = {
      -- There is no need to wrap the second element, the 'import' node,
      -- and the first parenthesis, which does not already exist.
      omit = { lang_utils.helpers.if_second, 'import', ' (' },
    },
    split = {
      last_separator = true,
      format_tree = function(tsj)
        -- If there are no brackets, then create them
        if not tsj:has_children({ '(', ')' }) then
          tsj:create_child({ text = ' (' }, 4)
          tsj:create_child({ text = ')' }, #tsj:children() + 1)
          -- Since the elements have moved, you need to add the penultimate
          -- separator manually
          local penult = tsj:child(-2)
          penult:update_text(penult:text() .. ',')
        end
      end,
    },
    join = {
      format_tree = function(tsj)
        -- Remove brackets
        tsj:remove_child({ '(', ')' })
      end,
    },
  }),
})

return langs
