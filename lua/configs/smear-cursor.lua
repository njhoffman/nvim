local cfg = {
  stiffness = 0.8, -- 0.6      [0, 1]
  trailing_stiffness = 0.5, -- 0.3      [0, 1]
  distance_stop_animating = 0.5, -- 0.1      > 0
  hide_target_hack = false, -- true     boolean

  -- Smear cursor color. Defaults to Cursor GUI color if not set.
  -- Set to "none" to match the text color at the target cursor position.
  -- cursor_color = "#d3cdc3",

  -- Background color. Defaults to Normal GUI background color if not set.
  -- normal_bg = "#282828",

  -- Smear cursor when switching buffers or windows.
  smear_between_buffers = true,

  -- Smear cursor when moving within line or to neighbor lines.
  smear_between_neighbor_lines = true,

  -- Draw the smear in buffer space instead of screen space when scrolling
  scroll_buffer_space = true,

  -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
  -- Smears will blend better on all backgrounds.
  legacy_computing_symbols_support = false,
}
require("smear_cursor").setup(cfg)

-- color_levels = 16,
-- distance_stop_animating = 0.5,
-- filetypes_disabled = {},
-- gamma = 2.2,
-- hide_target_hack = false,
-- legacy_computing_symbols_support = false,
-- logging_level = 2,
-- matrix_pixel_min_factor = 0.5,
-- matrix_pixel_threshold = 0.7,
-- max_kept_windows = 50,
-- max_length = 25,
-- max_shade_no_matrix = 0.75,
-- max_slope_horizontal = 0.5,
-- min_slope_vertical = 2,
-- minimum_volume_factor = 0.7,
-- scroll_buffer_space = true,
-- slowdown_exponent = 0,
-- smear_between_buffers = true,
-- smear_between_neighbor_lines = true,
-- stiffness = 0.8,
-- time_interval = 17,
-- trailing_exponent = 2,
-- trailing_stiffness = 0.5,
-- vertical_bar_cursor = false,
-- volume_reduction_exponent = 0.3
