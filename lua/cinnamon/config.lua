return {
  default_keymaps = true,
  disabled = false,
  extra_keymaps = false,
  extended_keymaps = false,
  override_keymaps = false,
  always_scroll = false,
  centered = true,
  default_delay = 7,
  hide_cursor = false,
  horizontal_scroll = true,
  max_length = -1,
  scroll_limit = 150,
  smallest_delay_per_frame = 0.5,
  -- Smallest delay of one frame when scrolling. If the delay
  -- would be shorter than this (when scrolling many lines),
  -- then multiple lines are scrolled in order to get a
  -- faster scrolling. Slower terminal emulators probably need
  -- a larger value.
}
