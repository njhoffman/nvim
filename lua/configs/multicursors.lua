local default = {
  DEBUG_MODE = false,
  create_commands = true, -- create Multicursor user commands
  updatetime = 50, -- selections get updated if this many milliseconds nothing is typed in the insert mode see :help updatetime
  nowait = true, -- see :help :map-nowait
  mode_keys = {
    append = 'a',
    change = 'c',
    extend = 'e',
    insert = 'i',
  }, -- set bindings to start these modes
  -- normal_keys = normal_keys,
  -- insert_keys = insert_keys,
  -- extend_keys = extend_keys,
  -- see :help hydra-config.hint
  hint_config = {
    float_opts = {
      -- row, col, height, width, relative, and anchor should not be
      -- overridden
      border = 'rounded',
      style = 'minimal',
      focusable = false,
      noautocmd = true,
    },
    position = 'bottom',
  },
  -- accepted values:
  -- -1 true: generate hints
  -- -2 false: don't generate hints
  -- -3 [[multi line string]] provide your own hints
  -- -4 fun(heads: Head[]): string - provide your own hints
  generate_hints = {
    normal = true,
    insert = true,
    extend = true,
    config = {
      -- determines how many columns are used to display the hints.
      -- If you leave this option nil, the number of columns will depend on the size of your window.
      column_count = nil,
      -- maximum width of a column.
      max_hint_length = 25,
    },
  },
  -- normal_keys = {
  -- to change default lhs of key mapping change the key
  -- assigning nil to method exits from multi cursor mode
  -- assigning false to method removes the binding
  -- [','] = { method = N.clear_others, opts = { desc = 'Clear others' } }
  -- }
}

local N = require('multicursors.normal_mode')

local cfg = {
  hint_config = {
    float_opts = {
      -- row, col, height, width, relative, and anchor should not be
      -- overridden
      border = 'rounded',
      style = 'minimal',
      focusable = false,
      noautocmd = true,
    },
    position = 'bottom-right',
  },
  generate_hints = {
    normal = true,
    insert = true,
    extend = true,
    config = {
      column_count = 1,
    },
  },
  normal_keys = {
    -- TODO: switch j/J and k/K except right after ctrl-n or if line already has selection
    ['j'] = { method = N.create_down, opts = { desc = 'Create down' } },
    ['J'] = { method = N.skip_create_down, opts = { desc = 'Skip create down' } },
    ['k'] = { method = N.create_up, opts = { desc = 'Create up' } },
    ['K'] = { method = N.skip_create_up, opts = { desc = 'Skip create up' } },
  },
}

vim.keymap.set('n', '<M-C-N>', '<cmd>MCstart<cr>', { noremap = false, desc = 'multicursor start' })
vim.keymap.set(
  'x',
  '<M-C-N>',
  '<cmd>MCvisual<cr>',
  { noremap = false, desc = 'multicursor visual start' }
)

require('multicursors').setup(cfg)

-- Create custom mapping for editing selections.
-- require('multicursors').setup({
--   normal_keys = {
--     -- to change default lhs of key mapping change the key
--     [','] = {
--       -- assigning nil to method exits from multi cursor mode
--       -- assigning false to method removes the binding
--       method = N.clear_others,
--       -- you can pass :map-arguments here
--       opts = { desc = 'Clear others' },
--     },
--     ['<C-/>'] = {
--       method = function()
--         require('multicursors.utils').call_on_selections(function(selection)
--           vim.api.nvim_win_set_cursor(0, { selection.row + 1, selection.col + 1 })
--           local line_count = selection.end_row - selection.row + 1
--           vim.cmd('normal ' .. line_count .. 'gcc')
--         end)
--       end,
--       opts = { desc = 'comment selections' },
--     },
--   },
-- })
