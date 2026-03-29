local toggle_cfg = {
  ---@class snacks.toggle.Config
  ---@field icon? string|{ enabled: string, disabled: string }
  map = require("mapper").map, -- keymap.set function to use
  which_key = true, -- integrate with which-key to show enabled/disabled icons and colors
  notify = true, -- show a notification when toggling
  -- icons for enabled/disabled states
  icon = {
    enabled = " ",
    disabled = " ",
  },
  -- colors for enabled/disabled states
  color = {
    enabled = "green",
    disabled = "yellow",
  },
}

return toggle_cfg
