-- increase fade in frequency
local stages = require("plugins.config.nvim-notify-stages")
local cols = math.floor(vim.opt.columns:get() / 3 * 2)

local baseConfig = {
  level = "info",
  fps = 30,
  render = 'default',
  stages = stages.fade_in_slide_out_stages,
  background_colour = "FloatShadow",
  -- background_colour = "#000000",
  -- Default timeout for notifications
  timeout = 5000,
  -- maximium_width = 90,
  minimum_width = 20,
  maximum_width = cols,
  -- For stages that change opacity this is treated as the highlight behind the window
  -- Icons for the different levels
  icons = {
    ERROR = "",
    WARN = "",
    INFO = "",
    DEBUG = "",
    TRACE = "✎",
    INSPECT = "",
    TASK = "",
    STATUS = ""
  }
}

require("notify").setup(baseConfig)

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

-- default render
-- local api = vim.api
-- local namespace = api.nvim_create_namespace("nvim-notify")

-- return function(bufnr, notif, highlights)
--   local left_icon = notif.icon .. " "
--   local max_width = math.max(
--     math.max(unpack(vim.tbl_map(function(line)
--       return vim.fn.strchars(line)
--     end, notif.message))),
--     50
--   )
--   local left_title = notif.title[1] .. string.rep(" ", max_width)
--   local right_title = notif.title[2]
--   api.nvim_buf_set_lines(bufnr, 0, 1, false, { "", "" })
--   api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
--     virt_text = {
--       { " " },
--       { left_icon, highlights.icon },
--       { left_title, highlights.title },
--     },
--     virt_text_win_col = 0,
--     priority = max_width,
--   })
--   api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
--     virt_text = { { right_title, highlights.title }, { " " } },
--     virt_text_pos = "right_align",
--     priority = max_width,
--   })
--   api.nvim_buf_set_extmark(bufnr, namespace, 1, 0, {
--     virt_text = { { string.rep("━", max_width), highlights.border } },
--     virt_text_win_col = 0,
--     priority = max_width,
--   })
--   api.nvim_buf_set_lines(bufnr, 2, 2 + #notif.message, false, notif.message)

--   api.nvim_buf_set_extmark(bufnr, namespace, 2, 0, {
--     hl_group = highlights.body,
--     end_line = 1 + #notif.message,
--     end_col = #notif.message[#notif.message],
--   })
-- end
