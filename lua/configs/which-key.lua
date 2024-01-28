local default_config = {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    presets = {
      operators = true, -- adds help for operators like d, y, ...
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  operators = { gc = 'Comments' },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    -- ["<space>"] = "SPC",
    -- ["<cr>"] = "RET",
    -- ["<tab>"] = "TAB",
  },
  motions = {
    count = true,
  },
  icons = {
    breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
    separator = '➜', -- symbol used between a key and it's label
    group = '+', -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = '<c-d>', -- binding to scroll down inside the popup
    scroll_up = '<c-u>', -- binding to scroll up inside the popup
  },
  window = {
    border = 'none', -- none, single, double, shadow
    position = 'bottom', -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
    padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
    zindex = 1000, -- positive value to position WhichKey above other floating windows.
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = 'left', -- align columns left, center or right
  },
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', '^:', '^ ', '^call ', '^lua ' }, -- hide mapping boilerplate
  show_help = true, -- show a help message in the command line for using WhichKey
  show_keys = true, -- show the currently pressed key and its label as a message in the command line
  triggers = 'auto', -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specifiy a list manually
  -- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
  triggers_nowait = {
    -- marks
    '`',
    "'",
    'g`',
    "g'",
    -- registers
    '"',
    '<c-r>',
    -- spelling
    'z=',
  },
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for keymaps that start with a native binding
    i = { 'j', 'k' },
    v = { 'j', 'k' },
  },
  -- disable the WhichKey popup for certain buf types and file types.
  -- Disabled by default for Telescope
  disable = {
    buftypes = {},
    filetypes = {},
  },
}

-- u = { name = " 󰕌 Undo" },
-- o = { name = "  Options" },
-- p = { name = " 󰏗 Packages" },
-- c = { name = "  Code Action" },
-- i = { name = " 󱡴 Inspect" },

-- stylua: ignore
local config = {
  plugins = {
    registers = false,
  },
  presets = {
    operators = true, -- adds help for operators like d, y, ...
    motions = true, -- adds help for motions
    text_objects = true, -- help for text objects triggered after entering an operator
    windows = true, -- default bindings on <c-w>
    nav = true, -- misc bindings to work with windows
    z = true, -- bindings for folds, spelling and others prefixed with z
    g = true, -- bindings for prefixed with g
  },
  ignore_missing = false,
  -- autokey replacements
  --   ['<M-g>'] = '<C-g>',
  --   ['<M-G>'] = '<C-G>',
  triggers = 'auto', -- automatically setup triggers
  triggers_blacklist = {
    n = {  'c', 'C', 'y', 'Y' },
    i = { 'j', 'k' },
    v = { 'j', 'k' },
  },
  triggers_nowait = {
    -- marks
    '`',
    "'",
    'g`',
    "g'",
    -- registers
    '"',
    -- '<c-r>',
    -- spelling
    'z=',
  },
  key_labels = {
    ['telescope'] = ' ',
    ['Telescope'] = ' ',
    ['operator']  = '',
    ['<CR>']      = '↵',
    ['<BS>']      = '⌫',
    ['<Tab>']     = '󰌒',
    ['<Esc>']     = '⎋',
    -- ['<space>']   = '󱁐',
    ['<PageDown>']    = '<PgDown>',
    ['<PageUp>']      = '<PgUp>',
    ['<M-Bslash>']     = '<M-\\>',
    ['<C-Bslash>']     = '<C-\\>',
    ['<space>']       = 'SPC',
    ['<M-Space>']     = 'M-SPC',
    ['<C-Space>']     = 'C-SPC',
    ['<M-C-Space>']   = 'M-C-SPC',
    ['<M-C-S-Down>']  = '<C-M-J>',
    ['<M-C-S-Up>']    = '<C-M-K>',
    ['<M-C-S-Left>']  = '<C-M-H>',
    ['<M-C-S-Right>'] = '<C-M-L>',
    ['<C-S-Down>']    = '<C-M-j>',
    ['<C-S-Up>']      = '<C-M-k>',
    ['<C-S-Left>']    = '<C-M-h>',
    ['<C-S-Right>']   = '<C-M-l>',
  },
  hidden = {
    '<silent>',
    '<cmd>',
    '<Cmd>',
    '<CR>',
    '^call',
    '^lua',
    '^:',
    '^ ',
    'require',
    'escope',
    'erator',
    '"',
  },
  ignored = {
    '<2-LeftMouse>',
    '<ScrollWheelDown>',
    '<ScrollWheelUp>'
  },
  popup_mappings = {
    scroll_down = '<C-S-Down>', -- binding to scroll down inside the popup
    scroll_up = '<C-S-Up>', -- binding to scroll up inside the popup
    page_down = '<M-f>', -- binding to scroll down inside the popup
    page_up = '<M-b>', -- binding to scroll up inside the popup
  },
  show_help = true, -- show a help message in the command line for using WhichKey,
  popup_user_mappings = {
    ['<M-C-_>'] = function(key, mode)
      require('telescope.builtin').keymaps {
        modes = { mode },
        lhs_filter = function(lhs)
          return vim.startswith(lhs, key)
        end,
      }
    end,
  },
  window = {
    winblend = 20,
    -- border = "rounded", -- none, single, double, shadow
    -- border = { '╭', '─', '╮', '│', '│', '_', '│', '│' },
    border = { '╭', '─', '─', '', '│', '_', '│', '│' },
    position = 'bottom', -- bottom, top
    margin = { 1, 0, 0, 0.7 }, -- extra window margin [top, right, bottom, left]
    padding = { 0, 0, 0, 0 }, -- extra window padding [top, right, bottom, left]
  },
  layout = {
    height = {
      min = 4,
      max = function() return tonumber(vim.o.lines) - 5 end,
    }, -- min and max height of the columns
    width = {
      max = function()
        return math.min(80, math.floor(tonumber(vim.o.columns * 0.4) or 80))
      end,
      min = 40,
    }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = 'center', -- left, center, right
  },
  other_layouts = {
    {
      name = 'bottom',
      layout = {
        height = { min = 10, max = 40 }, -- min and max height of the columns
        width = { min = 20, max = 40 }, -- min and max width of the columns
        spacing = 1, -- spacing between columns
        align = 'right', -- left, center, right
      },
      window = {
        winblend = 20,
        margin = { 5, 5, 5, 70 }, -- extra window margin [top, right, bottom, left]
        padding = { 0, 0, 0, 0 }, -- extra window padding [top, right, bottom, left]
        border = 'rounded', -- none, single, double, shadow
        position = 'bottom', -- bottom, top
      },
    }
  },
icons = {
  breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
  separator = '➜', -- symbol used between a key and it's label
  group = '+', -- symbol prepended to a group
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
