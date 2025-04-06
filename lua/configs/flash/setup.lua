local modes = require("configs.flash.modes")
local config = {
  labels = "asdfghjklqwertyuiopzxcvbnm",
  use_upper_select_visual_line = false,
  modes = modes,
  search = {
    trigger = "",
    max_length = false,
    wrap = true,
    multi_window = true,
    incremental = false,
    exclude = {
      "notify",
      "cmp_menu",
      "noice",
      "flash_prompt",
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
      match = "FlashMatch",
      current = "FlashCurrent",
      backdrop = "FlashBackdrop",
      label = "FlashLabel",
    },
  },
  jump = {
    -- save location in the jumplist
    jumplist = true,
    -- jump position
    pos = "start", ---@type "start" | "end" | "range"
    -- add pattern to search history
    history = true,
    -- add pattern to search register
    register = true,
    -- clear highlight after jump
    nohlsearch = true,
    -- automatically jump when there is only one match
    autojump = false,
    -- You can force inclusive/exclusive jumps by setting the `inclusive` option.
    -- By default it will be automatically set based on the mode.
    inclusive = nil, ---@type boolean?
    -- jump position offset. Not used for range jumps.
    -- 0: default
    -- 1: when pos == "end" and pos < current position
    offset = nil, ---@type number
  },
  label = {
    current = true,
    -- after = {0, 2}
    after = false,
    before = true, ---@type boolean|number[]
    -- minimum pattern length to show labels Ignored for custom labelers.
    min_pattern_length = 0,
  },
  prompt = {
    enabled = true,
    prefix = { { "⚡", "FlashPromptIcon" } },
    win_config = {
      row = 15,
      col = (vim.o.columns / 2) - 15,
      width = 30,
      height = 1,
      border = "rounded",
      relative = "editor",
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
    motion = true,
  },
}

local setup_mappings = require("configs.flash.mappings").setup

local get_config = function()
  setup_mappings()
  return config
end

return { get_config = get_config, setup_mappings = setup_mappings }
