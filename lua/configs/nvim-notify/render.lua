local notify = require('notify')
local render_user_options = function(bufnr, notif, highlights)
  -- [global-opt]
  --   notify_level_show   = debug
  --   notify_level_record = trace
  --   notify_level_log    = trace
  --   lsptagfuncenabled   = true
  --   useroptions_output  = notify
  --   shell               = pwsh
  local namespace = vim.api.nvim_create_namespace('notify')
  local msgs = { notif.message.msg }
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, msgs)
  vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
    hl_group = highlights.icon,
    end_line = #msgs - 1,
    end_col = msgs[#msgs][1],
    -- end_col = notif.message[#msg][1],
  })
  -- nvim_buf_add_highlight({buffer}, {ns_id}, {hl_group}, {line}, {col_start},
  --                        {col_end})
end

local notify_user_options = function()
  notify({
    scope = 'global',
    options = {
      notify_level_show = 'debug',
      notify_level_record = 'trace',
      useroptions_output = 'notify',
    },
  }, 'task', { title = 'test', render = render_user_options })
end

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
