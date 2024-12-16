return {
  -- create_layout = require("telescope._layouts.default"),
  border_chars = {
    preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    results = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  },
  layout_strategy = "flex",
  layout_config = {
    prompt_position = "top",
    mirror = true,
    preview_cutoff = 20,
    bottom_pane = {
      height = 25,
    },
    center = {
      preview_height = 0.5,
      height = 0.4,
      width = 0.5,
    },
    cursor = {
      height = 0.9,
      width = 0.8,
    },
    flex = {
      width = 0.8,
      flip_columns = 120,
      -- flip_lines = 40,
      horizontal = {
        height = 0.7,
      },
      vertical = {
        height = 0.9,
      },
    },
  },
  dynamic_preview_title = true,
  hidden = true,
  no_ignore = false,
  preview = {
    hide_on_startup = vim.o.columns > 80,
    check_mime_type = true,
    ls_short = true,
    filesize_limit = 2,
    timeout = 1000, -- default 250
  },
}
