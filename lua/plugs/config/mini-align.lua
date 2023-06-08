-- No need to copy this inside `setup()`. Will be used automatically.
local align = require('mini.align')

local ns_id = {
  -- Track user input
  input = vim.api.nvim_create_namespace('MiniAlignInput'),
}

local user_input = function(prompt, text)
  -- Register temporary keystroke listener to distinguish between cancel with
  -- `<Esc>` and immediate `<CR>`.
  local on_key = vim.on_key or vim.register_keystroke_callback
  local was_cancelled = false
  on_key(function(key)
    if key == '\27' then
      was_cancelled = true
    end
  end, ns_id.input)

  -- Ask for input
  local opts = { prompt = '(mini.align) ' .. prompt .. ': ', default = text or '' }
  vim.cmd('echohl Question')
  -- Use `pcall` to allow `<C-c>` to cancel user input
  local ok, res = pcall(vim.fn.input, opts)
  vim.cmd('echohl None | redraw')

  -- Stop key listening
  on_key(nil, ns_id.input)

  if not ok or was_cancelled then
    return
  end
  return res
end

local opts = {
  -- options = {
  --   split_pattern = '',
  --   justify_side = 'left',
  --   merge_delimiter = '',
  -- },
  -- steps = {
  --   pre_justify = { align.gen_step.filter('n == 1') },
  --   pre_split = {},
  --   split = nil,
  --   pre_justify = {},
  --   justify = nil,
  --   pre_merge = {},
  --   merge = nil,
  -- },
  modifiers = {
    --   -- Main option modifiers
    --   ['s'] = --<function: enter split pattern>,
    --   ['j'] = --<function: choose justify side>,
    --   ['m'] = --<function: enter merge delimiter>,
    --
    --   -- Modifiers adding pre-steps
    --   ['f'] = --<function: filter parts by entering Lua expression>,
    --   ['i'] = --<function: ignore some split matches>,
    --   ['p'] = --<function: pair parts>,
    --   ['t'] = --<function: trim parts>,
    --
    --   -- Delete some last pre-step
    --   ['<BS>'] = --<function: delete some last pre-step>,
    --
    --   -- Special configurations for common splits
    --   ['='] = --<function: enhanced setup for '='>,
    --   [','] = --<function: enhanced setup for ','>,
    --   [' '] = --<function: enhanced setup for ' '>,
    -- - Tweak `j` modifier to cycle through available "justify_side" options (like in 'vim-easy-align'):
    j = function(_, opts)
      local next_option = ({
        left = 'center',
        center = 'right',
        right = 'none',
        none = 'left',
      })[opts.justify_side]
      opts.justify_side = next_option or 'left'
    end,
    -- Use 'T' modifier to remove both whitespace and indent
    T = function(steps, _)
      table.insert(steps.pre_justify, align.gen_step.trim('both', 'remove'))
    end,
    -- specify columns to align
    ['n'] = function(steps, _)
      local input = user_input('Enter column expression')
      local step = align.gen_step.filter('n == ' .. input)
      if step == nil then
        return
      end
      table.insert(steps.pre_justify, step)
    end,
    ['1'] = function(steps, _)
      table.insert(steps.pre_justify, align.gen_step.filter('n == 1'))
    end,
    ['2'] = function(steps, _)
      table.insert(steps.pre_justify, align.gen_step.filter('n == 2'))
    end,
    ['3'] = function(steps, _)
      table.insert(steps.pre_justify, align.gen_step.filter('n == 3'))
    end,
    ['4'] = function(steps, _)
      table.insert(steps.pre_justify, align.gen_step.filter('n == 4'))
    end,
    ['5'] = function(steps, _)
      table.insert(steps.pre_justify, align.gen_step.filter('n == 5'))
    end,
    ['6'] = function(steps, _)
      table.insert(steps.pre_justify, align.gen_step.filter('n == 6'))
    end,
    ['7'] = function(steps, _)
      table.insert(steps.pre_justify, align.gen_step.filter('n == 7'))
    end,
    ['8'] = function(steps, _)
      table.insert(steps.pre_justify, align.gen_step.filter('n == 8'))
    end,
    ['9'] = function(steps, _)
      table.insert(steps.pre_justify, align.gen_step.filter('n == 9'))
    end,
    -- last column
    ['0'] = function(steps, _)
      table.insert(steps.pre_justify, align.gen_step.filter('n >= (N - 1)'))
    end,
  },
  mappings = {
    start = 'ga',
    start_with_preview = 'gA',
  },
}

require('mini.align').setup(opts)

-- Press s to enter split Lua pattern.
-- Press j to choose justification side from available ones ("left", "center", "right", "none").
-- Press m to enter merge delimiter.
-- Press f to enter filter Lua expression to configure which parts will be affected (like "align only first column").
-- Press i to ignore some commonly unwanted split matches.
-- Press p to pair neighboring parts so they be aligned together.
-- Press t to trim whitespace from parts.
-- Press <BS> (backspace) to delete some last pre-step.

-- TODO: create new step for column alignment (align.new_step('col', func/table))
-- [' '] = function(steps, opts)
--   table.insert(
--     steps.pre_split,
--     MiniAlign.new_step('squash', function(strings)
--       -- Replace all space sequences with single space (except indent)
--       for i, s in ipairs(strings) do
--         strings[i] = s:gsub('()(%s+)', function(n, space) return n == 1 and space or ' ' end)
--       end
--     end)
--   )
--   -- Don't use `' '` to respect indent
--   opts.split_pattern = '%s+'
-- end,

-- TODO: make help/tip screen
-- NOTE: gAip then these key sequences:
--       =  =jc  =jr  =m!<CR>  =p  =i  =<BS>  =<BS>p
--       =fn==1<CR>  =<BS>fn==1<CR>t  =frow>7<CR>

-- # This=is=assumed=to be a comment
-- "a ="
-- a =
-- a = 1
-- bbbb = 2
-- ccccccc = 3
-- ccccccccccccccc
-- ddd = 4
-- eeee === eee = eee = eee=f
-- fff = ggg += gg &&= gg
-- g != hhhhhhhh == 888
-- i   := 5
-- i     %= 5
-- i       *= 5
-- j     =~ 5
-- j   >= 5
-- aa      =>         123
-- aa <<= 123
-- aa        >>= 123
-- bbb               => 123
-- c     => 1233123
-- d   =>      123
-- dddddd &&= 123
-- dddddd ||= 123
-- dddddd /= 123
-- gg <=> ee
