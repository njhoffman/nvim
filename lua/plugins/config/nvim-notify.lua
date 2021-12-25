
-- increase fade in frequency
local fade_in_slide_out_stages = require("notify.stages").fade_in_slide_out
fade_in_slide_out_stages[2] = function()
  return {
    opacity = { 100, frequency = 2 },
    col = { vim.opt.columns:get() },
  }
end

local notify = require("notify").setup({
  -- stages = "fade_in_slide_out", "fade", "slide", "static"
  stages = fade_in_slide_out_stages,
  -- Default timeout for notifications
  timeout = 4000,
  -- Function called when a window is closed
  on_close = nil,
  -- For stages that change opacity this is treated as the highlight behind the window
  -- background_colour = "none",
  -- Icons for the different levels
  icons = { ERROR = "", WARN = "", INFO = "", DEBUG = "", TRACE = "✎" },
  -- Minimum width for notification windows
  minimum_width = 20,
  on_open = function(win)
    -- vim.api.nvim_win_set_option(win, "wrap", true)
    -- vim.api.nvim_win_set_config(win, { zindex = 100 })
  end,
  render = 'default'
})

return notify

-- notify.dismiss
-- notify({ "Fixing problem.", "Please wait..." }, "info", {
--   title = plugin,
--   timeout = 3000,
--   on_close = function()
--     notify("Problem solved", nil, { title = plugin })
--     notify("Error code 0x0395AF", 1, { title = plugin })
--   end,
-- })
-- timeout: Number of milliseconds to show the window (default 5000)
-- on_open: A function to call with the window ID as an argument after opening
-- on_close: A function to call with the window ID as an argument after closing
-- title: Title string for the header
-- icon: Icon to use for the header
-- keep: Function that returns whether or not to keep the window open instead of using a timeout

-- You can also use plenary's async library to avoid using callbacks:
-- local async = require("plenary.async")
-- local notify = require("notify").async
-- async.run(function()
--   notify("Let's wait for this to close").close()
--   notify("It closed!")
-- end)

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
