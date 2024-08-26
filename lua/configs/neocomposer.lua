-- :EditMacros
-- :ClearNeoComposer
-- :Telescope macros

local config = {
  status_bg = "#000000", -- Background color of status line component
  preview_fg = "#ff9e64", -- Foreground color of macro preview text
  notify = true,
  delay_timer = "150",
  keymaps = {
    play_macro = "qq",
    yank_macro = "yq",
    stop_macro = "cq",
    toggle_record = "Q",
    cycle_next = "<leader>Qn",
    cycle_prev = "<leader>Qp",
    toggle_macro_menu = "<m-q>",
  },
}

require("NeoComposer").setup(config)
require("NeoComposer.state").set_delay(true)
require("telescope").load_extension("macros")
