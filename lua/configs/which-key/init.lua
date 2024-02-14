-- u = { name = " 󰕌 Undo" },
-- o = { name = "  Options" },
-- p = { name = " 󰏗 Packages" },
-- c = { name = "  Code Action" },
-- i = { name = " 󱡴 Inspect" },

-- stylua: ignore
local config = {
  plugins = {
    registers = false,
    -- marks = true,
    -- spelling = {
    --   enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
    --   suggestions = 20, -- how many suggestions should be shown in the list?
    -- },
    -- presets = {
    --   operators = true, -- adds help for operators like d, y, ...
    --   motions = true, -- adds help for motions
    --   text_objects = true, -- help for text objects triggered after entering an operator
    --   windows = true, -- default bindings on <c-w>
    --   nav = true, -- misc bindings to work with windows
    --   z = true, -- bindings for folds, spelling and others prefixed with z
    --   g = true, -- bindings for prefixed with g
    --   mouse = false,
    --   extra = false
    -- },
  },
  operators = {
    S = 'substitute  ',
    X = 'exchange  ',
    s = 'surround 󰅪',
    ys = 'surround 󰅪',
    ['cx'] = 'exchange  ',
    ['gtoc'] = 'change to camel case',
    ['gtod'] = 'change to dash case',
    ['gtos'] = 'change to snake case',
    ['gb'] = 'comments (block)  ',
    ['gc'] = 'comments (line)  ',
  },
  presets = {
    -- 'text_objects',
    -- 'windows',
    -- 'nav',
    -- 'z',
    -- 'g',
    operators = function()
      return {
        d = 'Delete ',
        c = 'Change ',
        y = 'Yank  ',
        ['='] = "filter through 'equalprg'",
        ['g~'] = 'Toggle case',
        ['gu'] = 'Lowercase',
        ['gU'] = 'Uppercase',
        ['gq'] = 'format text',
        ['gw'] = 'format text, keep cursor',
        ['>'] = 'Indent right',
        ['<lt>'] = 'Indent left',
        ['zf'] = 'Create fold',
        ['!'] = 'Filter external command',
        -- ['v'] = 'Visual Character Mode',
        -- ["V"] = "Visual Line Mode",
      }
    end,
    -- motions = {
    --   ['h'] = 'Left',
    --   ['j'] = 'Down',
    --   ['k'] = 'Up',
    --   ['l'] = 'Right',
    --   ['w'] = 'Next word',
    --   ['%'] = "Matching character: '()', '{}', '[]'",
    --   ['b'] = 'Previous word',
    --   ['e'] = 'Next end of word',
    --   ['ge'] ='Previous end of word',
    --   ['0'] = 'Start of line',
    --   ['^'] = 'Start of line (non-blank)',
    --   ['$'] = 'End of line',
    --   ['f'] = 'Move to next char',
    --   ['F'] = 'Move to previous char',
    --   ['t'] = 'Move before next char',
    --   ['T'] = 'Move before previous char',
    --   ['gg'] = 'First line',
    --   ['G'] = 'Last line',
    --   ['{'] = 'Previous empty line',
    --   ['}'] = 'Next empty line',
    -- },
  },
  ignore_missing = false,
  -- autokey replacements
  --   ['<M-g>'] = '<C-g>',
  --   ['<M-G>'] = '<C-G>',
  triggers = 'auto', -- automatically setup triggers
  triggers_blacklist = {
    -- n = { 'v' },
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
    -- '"',
    -- '<c-r>',
    -- spelling
    'z=',
  },
  key_labels = {
    ['telescope']     = ' ',
    ['Telescope']     = ' ',
    ['operator']      = '',
    ['<CR>']          = '↵',
    ['<BS>']          = '⌫',
    ['<Tab>']         = '󰌒',
    ['<Esc>']         = '⎋',
    -- ['<space>']    = '󱁐',
    ['<S-PageDown>']  = '<S-PgDown>',
    ['<S-PageUp>']    = '<S-PgUp>',
    ['<PageDown>']    = '<PgDown>',
    ['<PageUp>']      = '<PgUp>',
    ['<M-Bslash>']    = '<M-\\>',
    ['<C-Bslash>']    = '<C-\\>',
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
    debug_mode   = '<F3>',       -- show detailed keymapping information
    options_menu = '<F2>',       -- launch options menu
    launch_wk    = '<F1>',       -- launch which-key manually
    help_menu    = '<M-C-_>',    -- binding to scroll down inside the popup
    scroll_down  = '<C-S-Down>', -- binding to scroll down inside the popup
    scroll_up    = '<C-S-Up>',   -- binding to scroll up inside the popup
    page_down    = '<M-f>',      -- binding to scroll down inside the popup
    page_up      = '<M-b>',      -- binding to scroll up inside the popup
  },
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
  hooks = {
    list_pre = function(items)
      vim.dbglog('list_items', #items)
      return items
    end,
    list_post = function(text)
      vim.dbglog('list_post', vim.tbl_keys(text))
      return text
    end,
    breadcrumbs = function(breadcrumbs, cmd_line, results)
      vim.dbglog('breadcrumbs', breadcrumbs, cmd_line, vim.tbl_keys(results))
      return breadcrumbs
    end
  },
  mode_highlights = {}, -- separator, group, desc float value, border, mode
  debug = true,
  vimade_fade = true,
}

require('which-key').setup(config)

_G._wk_timing = function()
  vim.dbg(require('which-key.logger').timing_summary())
end

local get_hooks = function()
  local all_hooks = require('which-key.keys.hooks')
  local hooks = {}
  for _, key in ipairs({ 'nop', 'auto', 'fast' }) do
    for k, _ in pairs(all_hooks['hooked_' .. key]) do
      local mode = k:sub(1, 1)
      if type(tonumber(k:sub(2, 2))) == 'number' then
        local pfx = 'buf_' .. k:sub(2, 2)
        hooks[pfx] = hooks[pfx] or {}
        hooks[pfx][mode] = hooks[pfx][mode] or {}
        hooks[pfx][mode][k:sub(3)] = key
      else
        hooks[mode] = hooks[mode] or {}
        hooks[mode][k:sub(2)] = key
      end
    end
  end
  return hooks
end

_G._wk_counts = function()
  local counts = require('which-key.mapper').get_counts()
  local hooks = get_hooks()
  for key, val in pairs(hooks) do
    if key:match('^buf_') then
      counts['hook_' .. key] = counts['hook_' .. key] or {}
      for k, v in pairs(val) do
        counts['hook_' .. key][k] = #vim.tbl_keys(v)
      end
    else
      counts['hook_' .. key] = #vim.tbl_keys(val)
    end
  end
  vim.dbg(counts)
end

_G._wk_hooks = function()
  local hooks = get_hooks()
  vim.dbg(hooks)
end

-- require('which-key').register({ ['<C-Q>'] = { name = '+Test' }, { mode = 'n' } })

-- :WhichKey " show all mappings
-- :WhichKey <leader> " show all <leader> mappings
-- :WhichKey <leader> v " show all <leader> mappings for VISUAL mode
-- :WhichKey '' v " show ALL mappings for VISUAL mode
--

-- hotkeys
-- n-0 n-9 tabtree
-- csn dsn ysn
