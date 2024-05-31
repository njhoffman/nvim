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

-- matcher = function(win)
--   -- limit matches to the current label
--   return vim.tbl_filter(function(m)
--     return m.label == match.label and m.win == win
--   end, state.results)
-- end,
-- labeler = function(matches)
--   for _, m in ipairs(matches) do
--     m.label = m.label2 -- use the second label
--   end
-- end,

-- labeler = function(matches, state)
--   local labels = state:labels()
--   for m, match in ipairs(matches) do
--     match.label1 = labels[math.floor((m - 1) / #labels) + 1]
--     match.label2 = labels[(m - 1) % #labels + 1]
--     match.label = match.label1
--   end
-- end,
local modes = {
  -- config = function() end
  search = {
    keys = { '/', '?' },
    enabled = false,
    highlight = { backdrop = false },
    jump = { history = true, register = true, nohlsearch = true },
  },

  char = {
    enabled = false,

    keys = {
      'f',
      'F',
      't',
      'T',
      [';'] = '+',
      [','] = '-',
    },
    label = {
      -- format = function(opts)
      --   -- always show first and second label
      --   return {
      --     { opts.match.label1, 'FlashMatch' },
      --     { opts.match.label2, 'FlashLabel' },
      --   }
      -- end,
      style = 'overlay',
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
        label = 'FlashCharLabel', -- :hi for f/F
        match = 'FlashCharMatch', -- :hi for t/T
      },
    },
    jump = { history = false, nohlsearch = true, register = false },
    jump_labels = true,
    remote_op = { restore = true, motion = false },
    search = { wrap = false, multi_window = false, incremental = false },
    multi_line = true,
    config = function(opts)
      opts.autohide = vim.fn.mode(true):find('no')
      -- Show jump labels not in operator-pending mode
      -- opts.jump_labels = not vim.fn.mode(true):find('o')
      --   and vim.v.count == 0
      --   and vim.fn.reg_executing() == ''
      --   and vim.fn.reg_recording() == ''
      -- Show jump labels only in operator-pending mode
      -- opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find('o')
    end,
    char_actions = function(motion)
      return {
        [';'] = 'right', -- set to `right` to always go right
        [','] = 'left', -- set to `left` to always go left
        [motion:lower()] = 'right',
        [motion:upper()] = 'left',
        -- jump2d style: same case goes next, opposite case goes prev
        -- [motion] = "next",
        -- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
      }
    end,
  },
  treesitter = {
    jump = { pos = 'range' },
    -- labels = 'abcdefghijklmnopqrstuvwxyz',
    labels = 'abcdefghijklmnopqrstuvwxyz',
    -- labels = "sfnjklhodwembuyvrgtcxzszfnjklhodwembuyvrgtcxz/?.,;#",

    config = function(opts)
      if false and vim.fn.mode() == 'v' then
        opts.labels:gsub('[cdyrx]', '') -- todo: remove all operations
      end
    end,
    -- treesitter = { containing_end_pos = true },
    label = { before = true, after = true, style = 'inline' },
    highlight = {
      backdrop = false,
      matches = false,
    },
    keys = {
      [';'] = '+',
      [','] = '-',
    },
    -- search = { multi_window = false, wrap = true, incremental = true, max_length = 0 },
    -- matcher = lib.custom_ts,
    -- actions = lib.ts_actions,
    -- multi_line = true,
    -- label = {
    --   distance = true,
    --   min_pattern_length = 0,
    --   before = true,
    --   after = true,
    --   style = 'inline',
    --   rainbow = {
    --     enabled = true,
    --     -- number between 1 and 9
    --     shade = 5,
    --   },
    -- },
  },
  treesitter_search = {
    jump = { pos = 'range' },
    search = { multi_window = true, wrap = true, incremental = true },
    remote_op = { restore = true },
    label = {
      before = true,
      after = true,
      style = 'inline',
      rainbow = { enabled = true, shade = 2 },
    },
    highlight = {
      backdrop = true,
      matches = true,
    },
  },
  -- options used for remote flash
  remote = {
    search = { multi_window = true, wrap = true, incremental = true },
    remote_op = { restore = true, motion = true },
    highlight = {
      backdrop = true,
      matches = true,
    },
  },
}

return modes
