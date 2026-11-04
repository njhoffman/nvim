-- let s:shade_hl_defaults = {
--     \   'gui'     : ['NONE', '#777777' , 'NONE']
--     \ , 'cterm256': ['NONE', '242'     , 'NONE']
--     \ , 'cterm'   : ['NONE', 'grey'    , 'NONE']
-- vimade_3670    xxx ctermfg=146 guifg=#264e8e

-- https://github.com/vsedov/nvim/blob/master/lua/modules/movement/flash/nav/lib.lua
-- https://github.com/folke/flash.nvim/discussions/24
-- https://github.com/folke/flash.nvim/pull/51
-- hit a upper label of above labels to select a visual by line in range jumps,
-- if label is upper, do nothing.

local modes = {
  -- config = function() end
  search = {
    enabled = false,
    trigger = "<Cr>",
    multi_line = false,
    -- keys = { "/", "?" },
    highlight = { backdrop = false },
    jump = { history = true, register = true, nohlsearch = true },
  },
  char = {
    enabled = false,

    keys = {
      "f",
      "F",
      "t",
      "T",
      [";"] = "+",
      [","] = "-",
    },
    label = {
      style = "overlay",
      current = false,
      after = false,
      before = false,
      distance = false,
    },

    highlight = {
      backdrop = true,
      matches = true,
      priority = 5000,
      groups = {
        label = "FlashCharLabel", -- :hi for f/F
        match = "FlashCharMatch", -- :hi for t/T
      },
    },
    jump = { history = false, nohlsearch = true, register = false },
    jump_labels = true,
    search = { wrap = false, multi_window = false, incremental = false },
    multi_line = true,
    config = function(opts)
      -- `mode` is always set to `search`
      -- autohide flash when in operator-pending mode
      opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")
      -- disable jump labels when not enabled, when using a count,
      -- or when recording/executing registers
      opts.jump_labels = opts.jump_labels
        and vim.v.count == 0
        and vim.fn.reg_executing() == ""
        and vim.fn.reg_recording() == ""
      -- Show jump labels only in operator-pending mode
      -- opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find("o")
    end,
    char_actions = function(motion)
      return {
        [";"] = "right", -- set to `right` to always go right
        [","] = "left", -- set to `left` to always go left
        [motion:lower()] = "right",
        [motion:upper()] = "left",
        -- jump2d style: same case goes next, opposite case goes prev
        -- [motion] = "next",
        -- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
      }
    end,
  },
  treesitter = {
    jump = { pos = "range" },
    -- labels = 'abcdefghijklmnopqrstuvwxyz',
    labels = "abcdefghijklmnopqrstuvwxyz",
    -- labels = "sfnjklhodwembuyvrgtcxzszfnjklhodwembuyvrgtcxz/?.,;#",

    config = function(opts)
      if false and vim.fn.mode() == "v" then
        opts.labels:gsub("[cdyrx]", "") -- todo: remove all operations
      end
    end,
    -- treesitter = { containing_end_pos = true },
    label = { before = true, after = true, style = "inline" },
    highlight = {
      backdrop = false,
      matches = false,
    },
    keys = {
      [";"] = "+",
      [","] = "-",
    },
  },
  treesitter_search = {
    jump = { pos = "range" },
    search = { multi_window = true, wrap = true, incremental = true },
    remote_op = { restore = true },
    label = {
      before = true,
      after = true,
      style = "inline",
      rainbow = { enabled = true, shade = 2 },
    },
    highlight = {
      backdrop = true,
      matches = true,
    },
  },
  -- options used for remote flash
  remote = {
    search = { multi_window = true, wrap = true, incremental = false },
    remote_op = { restore = true, motion = true },
    highlight = {
      backdrop = true,
      matches = true,
    },
  },
}

return modes
