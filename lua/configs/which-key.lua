local default_config = {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    presets = {
      operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
      extra = false,
      mouse = false,
    },
  },
  popup_mappings = {
    -- scroll_down = '<c-f>', -- binding to scroll down inside the popup
    -- scroll_up = '<c-b>', -- binding to scroll up inside the popup
    scroll_down = 'j', -- binding to scroll down inside the popup
    scroll_up = 'k', -- binding to scroll up inside the popup
  },
  hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', '^:', '^ ', '^call ', '^lua ' }, -- hide mapping boilerplate
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    ['<space>'] = 'SPC',
    ['<cr>'] = 'RET',
    ['<tab>'] = 'TAB',
  },
  motions = {
    count = true,
  },
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above

  --   hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
  --   show_help = true, -- show help message on the command line when the popup is visible
  operators = { gc = 'Comments' },
  icons = {
    breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
    separator = '➜', -- symbol used between a key and it's label
    group = '+', -- symbol prepended to a group
  },
  window = {
    winblend = 30,
    border = 'rounded', -- none, single, double, shadow
    position = 'bottom', -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 1, 0, 1, 0 }, -- extra window padding [top, right, bottom, left]
  },
  layout = {
    height = { min = 4, max = 15 }, -- min and max height of the columns
    width = { min = 25, max = 40 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = 'center', -- left, center, right
  },
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = 'auto', -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specifiy a list manually
  spelling = {
    enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
    suggestions = 20, -- how many suggestions should be shown in the list?
  },
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    -- c = { ";", ":", "%" },
    -- n = { ">", "<", "@", "x" },
    i = { 'j', 'k' },
    v = { 'j', 'k' },
    -- prefix = { "<leader>" },
  },
}

local config = {
  plugins = {
    registers = false,
  },
  ignore_missing = false,
  -- autokey replacements
  key_labels = {
    ['<space>'] = 'SPC',
    ['<cr>'] = 'RET',
    ['<tab>'] = 'TAB',
    ['<M-g>'] = '<C-g>',
    ['<M-G>'] = '<C-G>',
  },
  hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', '^:', '^ ', '^call ', '^lua ' }, -- hide mapping boilerplate
  popup_mappings = {
    -- scroll_down = '<c-f>', -- binding to scroll down inside the popup
    -- scroll_up = '<c-b>', -- binding to scroll up inside the popup
    scroll_down = '<M-f>', -- binding to scroll down inside the popup
    scroll_up = '<M-b>', -- binding to scroll up inside the popup
  },
  window = {
    winblend = 20,
    -- border = "rounded", -- none, single, double, shadow
    border = { '╭', '─', '╮', '│', '│', '_', '│', '│' },
    position = 'bottom', -- bottom, top
    margin = { 1, 10, 1, 10 }, -- extra window margin [top, right, bottom, left]
    padding = { 0, 0, 0, 0 }, -- extra window padding [top, right, bottom, left]
  },
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    c = { ';', ':', '%' },
    -- n = { ">", "<", "@", "x" },
    n = { 'i', 'a' },
    -- v = { 'j', 'k' },
    -- prefix = { "<leader>" },
  },
  layout = {
    height = { min = 4, max = 10 }, -- min and max height of the columns
    width = {
      min = 25,
      max = 40,
    }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = 'center', -- left, center, right
  },
}

local alt_config = {
  layout = {
    height = { min = 10, max = 40 }, -- min and max height of the columns
    width = { min = 20, max = 40 }, -- min and max width of the columns
    spacing = 1, -- spacing between columns
    align = 'right', -- left, center, right
  },
  window = {
    winblend = 20,
    margin = { 5, 70, 5, 5 }, -- extra window margin [top, right, bottom, left]
    padding = { 0, 0, 0, 0 }, -- extra window padding [top, right, bottom, left]
    border = 'rounded', -- none, single, double, shadow
    position = 'top', -- bottom, top
  },
}

require('which-key').setup(config)
-- :WhichKey " show all mappings
-- :WhichKey <leader> " show all <leader> mappings
-- :WhichKey <leader> v " show all <leader> mappings for VISUAL mode
-- :WhichKey '' v " show ALL mappings for VISUAL mode

---PATCH from https://github.com/folke/which-key.nvim/pull/305
local wk_view = require('which-key.view')
wk_view.hide = function()
  vim.api.nvim_echo({ { '' } }, false, {})
  vim.cmd('redraw')
  wk_view.hide_cursor()
  if wk_view.buf and vim.api.nvim_buf_is_valid(wk_view.buf) then
    vim.api.nvim_buf_delete(wk_view.buf, { force = true })
    wk_view.buf = nil
  end
  if wk_view.win and vim.api.nvim_win_is_valid(wk_view.win) then
    vim.api.nvim_win_close(wk_view.win, { force = true })
    wk_view.win = nil
  end
end
