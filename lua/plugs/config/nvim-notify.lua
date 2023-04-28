-- https://raw.githubusercontent.com/rcarriga/nvim-notify/master/README.md
-- increase fade in frequency
-- local render = require("plugs.config.nvim-notify-render")

local baseConfig = {

  level = vim.log.levels.DEBUG,
  -- level = 0,
  fps = 30,
  render = 'default',
  -- render = "compact",
  stages = 'fade_in_slide_out',
  -- background_colour = "FloatShadow",
  background_colour = '#000000',
  -- Default timeout for notifications
  timeout = 5000,
  -- maximium_width = 90,
  minimum_width = 5,
  max_height = function()
    return math.floor(vim.opt.lines:get() / 5 * 4)
  end,
  max_width = function()
    return math.floor(vim.opt.columns:get() / 3 * 2)
  end,
  icons = { ERROR = '', WARN = '', INFO = '', DEBUG = '', TRACE = '✎', INSPECT = '', TASK = '', STATUS = '' },
  on_open = function(win)
    vim.api.nvim_win_set_option(win, 'winblend', 20)
    vim.api.nvim_win_set_config(win, { zindex = 100 })
  end,
}

require('notify').setup(baseConfig)

-- You can also use plenary's async library to avoid using callbacks:
-- local async = require("plenary.async")
-- local notify = require("notify").async
-- async.run(
--   function()
--     notify("Let's wait for this to close").close()
--     notify("It closed!")
--   end
-- )

-- Custom functions should accept a buffer, a notification record and a highlights table
--   render: fun(buf: integer, notification: NotificationRecord, highlights: NotificationHighlights)
-- You should use the provided highlight groups to take advantage of opacity changes as they will be updated as the notification is animated
-- NotificationHighlights                                *NotificationHighlights*
--  Fields: ~
--    {title}  (string)
--    {icon}   (string)
--    {border} (string)
--    {body}   (string)

-- minimal render
-- local api = vim.api
-- local namespace = api.nvim_create_namespace("nvim-notify")

-- return function(bufnr, notif, highlights)
--   api.nvim_buf_set_lines(bufnr, 0, -1, false, notif.message)

--   api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
--     hl_group = highlights.icon,
--     end_line = #notif.message - 1,
--     end_col = #notif.message[#notif.message],
--   })
-- end
