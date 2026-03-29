local layout_defaults = {
  horizontal = {
    width = 0.8,
    height = 0.9,
    prompt_position = "bottom",
    preview_cutoff = 120,
    mirror = false,
  },
  vertical = {
    width = 0.8,
    height = 0.9,
    prompt_position = "bottom",
    preview_cutoff = 40,
    mirror = false,
  },
  center = {
    width = 0.5,
    height = 0.4,
    preview_cutoff = 40,
    prompt_position = "top",
    mirror = false,
  },
  cursor = {
    width = 0.8,
    height = 0.9,
    preview_cutoff = 40,
  },
  bottom_pane = {
    height = 25,
    prompt_position = "top",
    preview_cutoff = 120,
    mirror = false,
  },
  flex = {
    -- flip_columns = 120, -- default: horizontal.preview_cutoff
    -- flip_lines = 40, --   default: vertical.preview_cutoff
  },
}
-- preview.height: <30 lines * 0.4, <40  10, >40   20
-- preview.width:  <150 cols * 0.4, <200 80, >200 120
-- scroll_speed:  vim.api.nvim_win_get_height(preview_winid) / 2

return {
  -- create_layout = require("telescope._layouts.default"),
  border_chars = {
    preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    results = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  },
  layout_strategy = "flex",
  layout_config = {
    bottom_pane = { height = 25 },
    center = { height = 0.4, width = 0.5, preview_height = 0.5 },
    cursor = { height = 80, width = 9 },
  },

  dynamic_preview_title = true,
  no_ignore = false,
  preview = {
    enable_type = true,
    check_mime_type = true,
    ls_short = true,
    filesize_limit = 2,
    timeout = 1000, -- default 250
  },
}
