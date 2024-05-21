local default_opts = {
  keymaps = {
    insert = '<C-g>s',
    insert_line = '<C-g>S',
    normal = 'ys',
    normal_cur = 'yss',
    normal_line = 'yS',
    normal_cur_line = 'ySS',
    visual = 'S',
    visual_line = 'gS',
    delete = 'ds',
    change = 'cs',
    change_line = 'cS',
  },
  surrounds = {
    ['('] = {
      add = { '( ', ' )' },
      find = function()
        return M.get_selection({ motion = 'a(' })
      end,
      delete = '^(. ?)().-( ?.)()$',
    },
    [')'] = {
      add = { '(', ')' },
      find = function()
        return M.get_selection({ motion = 'a)' })
      end,
      delete = '^(.)().-(.)()$',
    },
    ['{'] = {
      add = { '{ ', ' }' },
      find = function()
        return M.get_selection({ motion = 'a{' })
      end,
      delete = '^(. ?)().-( ?.)()$',
    },
    ['}'] = {
      add = { '{', '}' },
      find = function()
        return M.get_selection({ motion = 'a}' })
      end,
      delete = '^(.)().-(.)()$',
    },
    ['<'] = {
      add = { '< ', ' >' },
      find = function()
        return M.get_selection({ motion = 'a<' })
      end,
      delete = '^(. ?)().-( ?.)()$',
    },
    ['>'] = {
      add = { '<', '>' },
      find = function()
        return M.get_selection({ motion = 'a>' })
      end,
      delete = '^(.)().-(.)()$',
    },
    ['['] = {
      add = { '[ ', ' ]' },
      find = function()
        return M.get_selection({ motion = 'a[' })
      end,
      delete = '^(. ?)().-( ?.)()$',
    },
    [']'] = {
      add = { '[', ']' },
      find = function()
        return M.get_selection({ motion = 'a]' })
      end,
      delete = '^(.)().-(.)()$',
    },
    ["'"] = {
      add = { "'", "'" },
      find = function()
        return M.get_selection({ motion = "a'" })
      end,
      delete = '^(.)().-(.)()$',
    },
    ['"'] = {
      add = { '"', '"' },
      find = function()
        return M.get_selection({ motion = 'a"' })
      end,
      delete = '^(.)().-(.)()$',
    },
    ['`'] = {
      add = { '`', '`' },
      find = function()
        return M.get_selection({ motion = 'a`' })
      end,
      delete = '^(.)().-(.)()$',
    },
    ['i'] = { -- TODO: Add find/delete/change functions
      add = function()
        local left_delimiter = M.get_input('Enter the left delimiter: ')
        local right_delimiter = left_delimiter and M.get_input('Enter the right delimiter: ')
        if right_delimiter then
          return { { left_delimiter }, { right_delimiter } }
        end
      end,
      find = function() end,
      delete = function() end,
    },
    ['t'] = {
      add = function()
        local user_input = M.get_input('Enter the HTML tag: ')
        if user_input then
          local element = user_input:match('^<?([^%s>]*)')
          local attributes = user_input:match('^<?[^%s>]*%s+(.-)>?$')

          local open = attributes and element .. ' ' .. attributes or element
          local close = element

          return { { '<' .. open .. '>' }, { '</' .. close .. '>' } }
        end
      end,
      find = function()
        return M.get_selection({ motion = 'at' })
      end,
      delete = '^(%b<>)().-(%b<>)()$',
      change = {
        target = '^<([^%s<>]*)().-([^/]*)()>$',
        replacement = function()
          local user_input = M.get_input('Enter the HTML tag: ')
          if user_input then
            local element = user_input:match('^<?([^%s>]*)')
            local attributes = user_input:match('^<?[^%s>]*%s+(.-)>?$')

            local open = attributes and element .. ' ' .. attributes or element
            local close = element

            return { { open }, { close } }
          end
        end,
      },
    },
    ['T'] = {
      add = function()
        local user_input = M.get_input('Enter the HTML tag: ')
        if user_input then
          local element = user_input:match('^<?([^%s>]*)')
          local attributes = user_input:match('^<?[^%s>]*%s+(.-)>?$')

          local open = attributes and element .. ' ' .. attributes or element
          local close = element

          return { { '<' .. open .. '>' }, { '</' .. close .. '>' } }
        end
      end,
      find = function()
        return M.get_selection({ motion = 'at' })
      end,
      delete = '^(%b<>)().-(%b<>)()$',
      change = {
        target = '^<([^>]*)().-([^/]*)()>$',
        replacement = function()
          local user_input = M.get_input('Enter the HTML tag: ')
          if user_input then
            local element = user_input:match('^<?([^%s>]*)')
            local attributes = user_input:match('^<?[^%s>]*%s+(.-)>?$')

            local open = attributes and element .. ' ' .. attributes or element
            local close = element

            return { { open }, { close } }
          end
        end,
      },
    },
    ['f'] = {
      add = function()
        local result = M.get_input('Enter the function name: ')
        if result then
          return { { result .. '(' }, { ')' } }
        end
      end,
      find = function()
        if vim.g.loaded_nvim_treesitter then
          local selection = M.get_selection({
            query = {
              capture = '@call.outer',
              type = 'textobjects',
            },
          })
          if selection then
            return selection
          end
        end
        return M.get_selection({ pattern = '[^=%s%(%){}]+%b()' })
      end,
      delete = '^(.-%()().-(%))()$',
      change = {
        target = '^.-([%w_]+)()%(.-%)()()$',
        replacement = function()
          local result = M.get_input('Enter the function name: ')
          if result then
            return { { result }, { '' } }
          end
        end,
      },
    },
    invalid_key_behavior = {
      add = function(char)
        if not char or char:find('%c') then
          return nil
        end
        return { { char }, { char } }
      end,
      find = function(char)
        if not char or char:find('%c') then
          return nil
        end
        return M.get_selection({
          pattern = vim.pesc(char) .. '.-' .. vim.pesc(char),
        })
      end,
      delete = function(char)
        if not char or char:find('%c') then
          return nil
        end
        return M.get_selections({
          char = char,
          pattern = '^(.)().-(.)()$',
        })
      end,
    },
  },
  aliases = {
    ['a'] = '>',
    ['b'] = ')',
    ['B'] = '}',
    ['r'] = ']',
    ['q'] = { '"', "'", '`' },
    ['s'] = { '}', ']', ')', '>', '"', "'", '`' },
  },
  highlight = {
    duration = 0,
  },
  move_cursor = 'begin',
  indent_lines = function(start, stop)
    local b = vim.bo
    -- Only re-indent the selection if a formatter is set up already
    if
      start < stop
      and (b.equalprg ~= '' or b.indentexpr ~= '' or b.cindent or b.smartindent or b.lisp)
    then
      vim.cmd(string.format('silent normal! %dG=%dG', start, stop))
      require('nvim-surround.cache').set_callback('')
    end
  end,
}

local function surroundConfig()
  local u = require('config.utils')
  local textobjectRemaps = require('config.utils').textobjRemaps
  local maps = require('config.utils').textobjMaps

  -- https://github.com/kylechui/nvim-surround/blob/main/doc/nvim-surround.txt#L483
  local config = require('nvim-surround.config')
  require('nvim-surround').setup({
    move_cursor = false,
    aliases = textobjectRemaps,
    keymaps = {
      visual = 's',
      normal_line = false,
      normal_cur_line = false,
      visual_line = false,
      insert_line = false,
      insert = false,
    },
    surrounds = {
      invalid_key_behavior = { add = false, find = false, delete = false, change = false },
      [maps.wikilink] = {
        find = '%[%[.-%]%]',
        add = { '[[', ']]' },
        delete = '(%[%[)().-(%]%])()',
        change = {
          target = '(%[%[)().-(%]%])()',
        },
      },
      ['/'] = {
        find = '/.-/',
        add = { '/', '/' },
        delete = '(/)().-(/)()',
        change = {
          target = '(/)().-(/)()',
        },
      },
      [maps.codeblock] = {
        add = function()
          if vim.bo.ft ~= 'markdown' then
            return { { '' }, { '' } }
          end
          return {
            { '```', '' },
            { '', '```' },
          }
        end,
      },
      [maps.func] = {
        find = function()
          return config.get_selection({ motion = 'a' .. maps.func })
        end,
        delete = function()
          local ft = vim.bo.filetype
          local patt
          if ft == 'lua' then
            patt = '^(.-function.-%b() ?)().-( ?end)()$'
          elseif
            ft == 'javascript'
            or ft == 'typescript'
            or ft == 'bash'
            or ft == 'zsh'
            or ft == 'sh'
          then
            patt = '^(.-function.-%b() ?{)().*(})()$'
          else
            u.notify('Surround', 'No function-surround defined for ' .. ft)
            patt = '()()()()'
          end
          return config.get_selections({
            char = maps.func,
            pattern = patt,
          })
        end,
        add = function()
          local ft = vim.bo.filetype
          if ft == 'lua' then
            -- function as one line
            return { { 'function() ' }, { ' end' } }
          elseif
            ft == 'typescript'
            or ft == 'javascript'
            or ft == 'bash'
            or ft == 'zsh'
            or ft == 'sh'
          then
            -- function on surrounding lines
            return {
              { 'function () {', '\t' },
              { '', '}' },
            }
          end
          u.notify('Surround', 'No function-surround defined for ' .. ft)
          return { { '' }, { '' } }
        end,
      },
      [maps.call] = {
        find = function()
          return config.get_selection({ motion = 'a' .. maps.call })
        end,
        delete = '^([^=%s]+%()().-(%))()$', -- https://github.com/kylechui/nvim-surround/blob/main/doc/nvim-surround.txt#L357
      },
      [maps.cond] = {
        find = function()
          return config.get_selection({ motion = 'a' .. maps.cond })
        end,
        delete = function()
          local ft = vim.bo.filetype
          local patt
          if ft == 'lua' then
            patt = '^(if .- then)().-( ?end)()$'
          elseif ft == 'javascript' or ft == 'typescript' then
            patt = '^(if %b() ?{?)().-( ?}?)()$'
          else
            u.notify('Surround', 'No conditional-surround defined for ' .. ft)
            patt = '()()()()'
          end
          return config.get_selections({
            char = maps.cond,
            pattern = patt,
          })
        end,
        add = function()
          local ft = vim.bo.filetype
          if ft == 'lua' then
            return {
              { 'if true then', '\t' },
              { '', 'end' },
            }
          elseif ft == 'typescript' or ft == 'javascript' then
            return {
              { 'if (true) {', '\t' },
              { '', '}' },
            }
          end
          u.notify('Surround', 'No if-surround defined for ' .. ft)
          return { { '' }, { '' } }
        end,
      },
    },
  })
end

--------------------------------------------------------------------------------

return {
  { -- surround
    'kylechui/nvim-surround',
    keys = {
      { 'ys', desc = '󰅪 Add Surround Operator' },
      { 's', mode = 'x', desc = '󰅪 Add Surround Operator' },
      { 'yS', 'ys$', desc = '󰅪 Surround to EoL', remap = true },
      { 'ds', desc = '󰅪 Delete Surround Operator' },
      { 'cs', desc = '󰅪 Change Surround Operator' },
    },
    config = surroundConfig,
  },
}
