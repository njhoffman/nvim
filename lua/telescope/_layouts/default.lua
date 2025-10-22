local layout_defaults = {
  horizontal  = { width  = 0.8, height          = 0.9,   prompt_position = "bottom", preview_cutoff  = 120    },
  vertical    = { width  = 0.8, height          = 0.9,   prompt_position = "bottom", preview_cutoff  = 40     },
  center      = { width  = 0.5, height          = 0.4,   preview_cutoff  = 40,       prompt_position = "top", },
  cursor      = { width  = 0.8, height          = 0.9,   preview_cutoff  = 40,       },
  bottom_pane = { height = 25,  prompt_position = "top", preview_cutoff  = 120,      },
}

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
    -- preview_cutoff = 20,
    preview_cutoff = 40,
    bottom_pane = { height = 25   },
    center      = { height = 0.4, width = 0.5, preview_height = 0.5 },
    cursor      = { height = 80,  width = 9    },
    flex = {
      width = 0.8,
      flip_columns = 120,
      -- flip_lines = 40,
      horizontal = {
        height = 0.7,
        mirror = false,
      },
      vertical = {
        mirror = true,
        height = 0.9,
      },
    },
  },
  dynamic_preview_title = true,
  no_ignore = false,
  preview = {
    -- hide_on_startup = vim.o.columns < 80,
    check_mime_type = true,
    ls_short = true,
    filesize_limit = 2,
    timeout = 1000, -- default 250
  },
}
