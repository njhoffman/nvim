-- stylua: ignore
local config = {
  show_help = false,
  show_keys = false,
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

  -- stylua: ignore
  operators = {
    ['!'] = 'filter external',
    ['='] = 'indent  ',
    ['>'] = 'indent right ﲒ ',
    ['<'] = 'indent left ﲑ ',
    ['zf'] = 'create fold  ', --    ﬡ
    ['g~'] = 'toggle case  ',
    ['gu'] = 'lowercase  ',
    ['gU'] = 'uppercase  ',
    d = 'delete ',
    c = 'change ',
    y = 'yank  ',
    S = 'substitute  ',
    X = 'exchange  ',
    cx = 'exchange  ',
    s    = 'add surround 󰅪',
    -- ys   = 'yank surround 󰅪',
    -- ds   = 'delete surround 󰅪',
    -- cs   = 'change surround 󰅪',
    -- sF   = 'surround find right 󰅪',
    -- sf   = 'surround find left 󰅪',
    -- evaluate = { prefix = 'g=' },
    -- -- Exchange text regions
    -- exchange = { prefix = 'gtx', reindent_linewise = true },
    -- -- Multiply (duplicate) text
    -- multiply = { prefix = 'gtm', func = nil },
    -- -- Replace text with register
    -- replace = { prefix = 'gtr', reindent_linewise = true },
    -- -- Sort text
    -- sort = { prefix = 'gts' },
    gb   = 'comments (block)  ',
    gc   = 'comments (line)  ',
    goo  = 'debugprint out t',
    gtf = 'format',
    gtF = 'format (restore cursor)',
    gtoc = 'change toCamelCase  ',
    gtod = 'change to-dash-case  ',
    gtoD = 'change to.dot.case  ',
    gtof = 'change to/path/case  ',
    gton = 'change TO_CONSTANT_CASE  ',
    gtop = 'change ToPascalCase  ',
    gtoP = 'change To phrase case  ',
    gtos = 'change to_snake_case  ',
    gtot = 'change To Title Case  ',
    gtou = 'change to lower case  ',
    gtoU = 'change TO UPPER CASE  ',
  },
  presets = {
    'text_objects',
    -- 'windows',
    -- 'nav',
    'z',
    'g',
    operators = function()
      return {
        d            =   'Delete',
        c            =   'Change',
        y            =   'Yank ',
        ['=']        =   "Filter 'equalprg'",
        ['g~']       =   'Toggle case',
        ['gu']       =   'Lowercase',
        ['gU']       =   'Uppercase',
        -- ['gq']       =   'Format text',
        ['g=']       =   'Format text (keep cursor)',
        ['>']        =   'Indent right',
        -- ['<lt>']  =   'Indent left',
        ['<']        =   'Indent left',
        ['zf']       =   'Create fold',
        ['!']        =   'Filter command',
        ['v']     =   'Visual Character Mode',
        ["V"]     =   "Visual Line Mode",
        ["<C-v>"] =   "Visual Block Mode",
      }
    end,
    'motions'
  },
  ignore_unnamed_groups = false,
  ignore_missing_desc = false,
  triggers = {}, --  'auto', -- auto, all, or list
  triggers_auto = {
    groups = true,
    presets = true
  },
  triggers_blacklist = {
    n = { 'v' },
    i = { 'j', 'k' },
    v = { 'j', 'k' },
  },
  triggers_nowait = {
    'y',
    'v',
    -- -- marks
    '`',
    "'",
    'g`',
    "g'",
    -- -- registers
    -- -- '"',
    -- -- '<c-r>',
    -- -- spelling
    -- 'z=',
  },
 -- <M-C-A> הּ דּ A
 -- <C-M-K> דּ הּ K
--  בּ וּ הּ גּ דּ     壟   
  key_brackets = false,  -- { '<','>' } {'', ''} false
  key_connector = ' ', -- '-' ' '
  key_metakeys = { M = 'הּ', C = 'דּ', S = 'וּ' },

  replace = {
    key = {
      function(key)
        return require("what-key.mapper").format_keys(key)
      end,
    {'PageDown', 'PgDn'},
    {'PageUp', 'PgUp'},
    {'lt', '<'},
    {'Bslash', '\\'},
    {'space', '󱁐'},
      -- { "<Space>", "SPC" },
    },
    desc = {
--       { "<Plug>%(?(.*)%)?", "%1" },
      { "<Plug>(.*)", "%1" },
      { "^%+", "" },
      { "<[cC]md>", "" },
      { "<[cC][rR]>", "" },
      { "<[sS]ilent>", "" },
      { "^lua%s+", "" },
      { "^call%s+", "" },
      { "^:%s*", "" },
--     '<silent>',
--     '<cmd>',
--     '<Cmd>',
--     '<CR>',
--     '^call',
--     '^lua',
--     '^:',
--     '^ ',
--     'require',
--     'escope',
--     'erator',
--     '"',
    },
  },

  key_labels = {
    ["<ScrollWheelDown>"] = "󱕐",
    ["<ScrollWheelUp>"]   = "󱕑",
    ['<leader>']        = ',', -- ' ',
    -- ['<space>']      = '󱁐',
    ['<space>']         = 'SPC',
    ['<S-PageDown>']    = '<S-PgDn>',
    ['<S-PageUp>']      = '<S-PgUp>',
    -- ['<M-Bslash>']    = '<M-\\>',
    -- ['<C-Bslash>']    = '<C-\\>',
    -- ['<M-Space>']    = 'M-SPC',
    -- ['<C-Space>']    = 'C-SPC',
    -- ['<M-C-Space>']  = 'M-C-SPC',
    -- ['<M-C-S-Down>']    = '<C-M-J>',
    -- ['<M-C-S-Up>']      = '<C-M-K>',
    -- ['<M-C-S-Left>']    = '<C-M-H>',
    -- ['<M-C-S-Right>']   = '<C-M-L>',
    ['<C-S-Down>']      = '<C-S-j>',
    ['<C-S-Up>']        = '<C-S-k>',
    ['<C-S-Left>']      = '<C-S-h>',
    ['<C-S-Right>']     = '<C-S-l>',
    ['telescope']       = ' ',
    ['Telescope']       = ' ',
    ['operator']        = '',
  },
  ignored = {
    '<RightMouse>',
    '<2-LeftMouse>',
  },
  mappings = {
    toggle_debug = '<F3>',       -- show detailed keymapping information
    options_menu = '<F2>',       -- launch options menu
    launch_wk    = '<F1>',       -- launch which-key manually
    help_menu    = '<M-C-_>',    -- binding to scroll down inside the popup
    scroll_down  = '<C-S-Down>', -- binding to scroll down inside the popup
    scroll_up    = '<C-S-Up>',   -- binding to scroll up inside the popup
    page_down    = '<M-f>',      -- binding to scroll down inside the popup
    page_up      = '<M-b>',      -- binding to scroll up inside the popup
  },
  mappings_user = {
    ['<M-C-T>'] = function(key, mode)
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
    border = { '╭', '─', '─', '', '', ' ', '│', '│' },
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
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
    ellipsis = "…",
    -- ellipsis = "…",
    -- -- set to false to disable all mapping icons, both those explicitly added in a mapping and those from rules
    -- mappings = true,
    -- --- Set to `false` to disable keymap icons from rules
    -- ---@type wk.IconRule[]|false
    -- rules = {},
    -- -- use the highlights from mini.icons When `false`, it will use `WhichKeyIcon` instead
    -- colors = true,
    -- -- used by key format
    keys = {
      -- , , , , 󰁝, , , , , 󰁅, 󰁍, 󰁔,
      Up = "",
      Down = "",
      Left = "",
      Right = "",
      C = "󰘴 ",
      M = "󰘵 ",
      D = "󰘳 ",
      S = "󰘶 ",
      CR = "󰌑",
      Esc = "󱊷",
      ScrollWheelDown = "󱕐",
      ScrollWheelUp = "󱕑",
      NL = "󰌑",
      BS = "󰭜",
      Space = "󱁐",
      Tab = "󰌒",
      F1 = "󱊫",
      F2 = "󱊬",
      F3 = "󱊭",
      F4 = "󱊮",
      F5 = "󱊯",
      F6 = "󱊰",
      F7 = "󱊱",
      F8 = "󱊲",
      F9 = "󱊳",
      F10 = "󱊴",
      F11 = "󱊵",
      F12 = "󱊶",
    },
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
  vimade_fade = false,
}

require("what-key").setup(config)
require("configs.what-key.globals")

-- require('which-key').register({ ['<C-Q>'] = { name = '+Test' }, { mode = 'n' } })

-- :WhichKey " show all mappings
-- :WhichKey <leader> " show all <leader> mappings
-- :WhichKey <leader> v " show all <leader> mappings for VISUAL mode
-- :WhichKey '' v " show ALL mappings for VISUAL mode
--

-- hotkeys
-- n-0 n-9 tabtree
-- csn dsn ysn
