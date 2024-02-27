-- let s:shade_hl_defaults = {
--     \   'gui'     : ['NONE', '#777777' , 'NONE']
--     \ , 'cterm256': ['NONE', '242'     , 'NONE']
--     \ , 'cterm'   : ['NONE', 'grey'    , 'NONE']
-- vimade_3670    xxx ctermfg=146 guifg=#264e8e

local modes = {
  search = {
    enabled = false,
    highlight = { backdrop = false },
    jump = { history = true, register = true, nohlsearch = true },
    search = {
      -- `forward` will be automatically set to the search direction
      -- `mode` is always set to `search`
      -- `incremental` is set to `true` when `incsearch` is enabled
    },
  },
  char = {
    enabled = true,
    keys = { 'f', 'F', 't', 'T', ';', ':' },
    highlight = { backdrop = true },
    jump = { history = true, nohlsearch = true, register = false },
    jump_labels = false,
    search = { wrap = false },
    multi_line = true,
    config = function(opts)
      -- -- autohide flash when in operator-pending mode
      opts.autohide = opts.autohide or vim.fn.mode(true):find('no')
      opts.jump_labels = not vim.fn.mode(true):find('o')
        and vim.v.count == 0
        and vim.fn.reg_executing() == ''
        and vim.fn.reg_recording() == ''
      -- Show jump labels only in operator-pending mode
      -- opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find('o')
    end,
    autohide = function(motion)
      -- autohide flash when the operator is `y` or `d`
      return vim.fn.mode(true):find('no') and (vim.v.operator == 'y' or vim.v.operator == 'd')
    end,
    char_actions = function(motion)
      return {
        [';'] = 'next', -- set to `right` to always go right
        [':'] = 'prev', -- set to `left` to always go left
        [motion:lower()] = 'next',
        [motion:upper()] = 'prev',
        -- jump2d style: same case goes next, opposite case goes prev
        -- [motion] = "next",
        -- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
      }
    end,
  },
  -- options used for remote flash
  remote = {
    remote_op = { restore = true, motion = true },
  },
  treesitter = {
    labels = 'asdfghjklqwertyuiopzxcvbnm',
    -- labels = 'abcdefghijklmnopqrstuvwxyz',
    jump = { pos = 'range' },
    search = { incremental = false },
    label = { before = true, after = false, style = 'inline' },
    highlight = {
      backdrop = true,
      matches = true,
    },
  },
  treesitter_search = {
    jump = { pos = 'range' },
    search = { multi_window = true, wrap = true, incremental = false },
    remote_op = { restore = true },
    label = { before = true, after = false, style = 'inline' },
    highlight = {
      backdrop = true,
      matches = true,
    },
  },
}

local cfg = {
  modes = modes,
  search = {
    exclude = {
      'notify',
      'cmp_menu',
      'noice',
      'flash_prompt',
      function(win)
        -- exclude non-focusable windows
        return not vim.api.nvim_win_get_config(win).focusable
      end,
    },
  },
  highlight = {
    -- show a backdrop with hl FlashBackdrop
    backdrop = true,
    -- Highlight the search matches
    matches = true,
    -- extmark priority
    priority = 5000,
    groups = {
      match = 'FlashMatch',
      current = 'FlashCurrent',
      backdrop = 'FlashBackdrop',
      label = 'FlashLabel',
    },
  },
  jump = {
    -- save location in the jumplist
    jumplist = true,
    -- jump position
    pos = 'start', ---@type "start" | "end" | "range"
    -- add pattern to search history
    history = false,
    -- add pattern to search register
    register = false,
    -- clear highlight after jump
    nohlsearch = true,
    -- automatically jump when there is only one match
    autojump = true,
    -- You can force inclusive/exclusive jumps by setting the
    -- `inclusive` option. By default it will be automatically
    -- set based on the mode.
    inclusive = nil, ---@type boolean?
    -- jump position offset. Not used for range jumps.
    -- 0: default
    -- 1: when pos == "end" and pos < current position
    offset = nil, ---@type number
  },
  label = {
    -- after = {0, 2}
    after = false,
    before = true, ---@type boolean|number[]
    -- minimum pattern length to show labels Ignored for custom labelers.
    min_pattern_length = 0,
    rainbow = {
      enabled = false,
      -- number between 1 and 9
      shade = 5,
    },
  },
  prompt = {
    enabled = true,
    prefix = { { '⚡', 'FlashPromptIcon' } },
    win_config = {
      row = 15,
      col = (vim.o.columns / 2) - 15,
      width = 30,
      height = 1,
      border = 'rounded',
      relative = 'editor',
      zindex = 1000,
    },
  },
  -- options for remote operator pending mode
  remote_op = {
    -- restore window views and cursor position after doing a remote operation
    restore = false,
    -- For `jump.pos = "range"`, this setting is ignored.
    -- `true`: always enter a new motion when doing a remote operation
    -- `false`: use the window's cursor position and jump target
    -- `nil`: act as `true` for remote windows, `false` for the current window
    motion = false,
  },
}

require('flash').setup(cfg)
require('configs.flash.mappings').setup()
