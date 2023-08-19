local default_cfg = {
  backend = 'ueberzug',
  integrations = {
    markdown = {
      enabled = true,
      sizing_strategy = 'auto',
      download_remote_images = true,
      clear_in_insert_mode = false,
    },
    neorg = {
      enabled = true,
      download_remote_images = true,
      clear_in_insert_mode = false,
    },
  },
  max_width = nil,
  max_height = nil,
  max_width_window_percentage = nil,
  max_height_window_percentage = 50,
  window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
  -- window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
  -- kitty_method = "normal",
  -- kitty_tmux_write_delay = 10, -- makes rendering more reliable with Kitty+Tmux
}
require('image').setup(default_cfg)
-- local api = require("image")
--
-- -- from a file (absolute path)
-- local image = api.from_file("/path/to/image.png", {
--   id = "my_image_id", -- optional, defaults to a random string
--   window = 1000, -- optional, binds image to a window and its bounds
--   buffer = 1000, -- optional, binds image to a buffer (paired with window binding)
--   with_virtual_padding = true, -- optional, pads vertically with extmarks
--   ...geometry, -- optional, { x, y, width, height }
-- })
--
-- -- from a URL
-- local image = api.from_file("https://gist.ro/s/remote.png", {
--   id = "my_image_id", -- optional, defaults to a random string
--   window = 1000, -- optional, binds image to a window and its bounds
--   buffer = 1000, -- optional, binds image to a buffer (paired with window binding)
--   with_virtual_padding = true, -- optional, pads vertically with extmarks
--   ...geometry, -- optional, { x, y, width, height }
-- })
--
-- image:render() -- render image
-- image:render(geometry) -- update image geometry and render it
-- image:clear()
--
-- image:move(x, y) -- move image
-- image:brightness(value) -- change brightness
-- image:saturation(value) -- change saturation
-- image:hue(value) -- change hue
