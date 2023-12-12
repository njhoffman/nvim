local error_patterns = {
  -- '^E[%d]+: Error',
  '^E[%d]+:',
  '^Error executing Lua callback',
  '^Vim:Error executing Lua callback',
}

local title_ignore = {
  'Notify',
  'Notification',
  'Messages',
  'Warning',
  'hardtime',
}

local render = function(bufnr, notif, highlights, config)
  local title = (notif.title and type(notif.title) == 'table' and notif.title[1]) and notif.title[1] or ''
  -- if notif.level == 'ERROR' and #title == 0 then
  --   title = 'ERROR'
  --   notif.title[1] = title
  -- end

  local render_title = notif.render_title or 'default'
  local first_line = type(notif.message) == 'table' and notif.message[1] or vim.fn.split(notif.message, '\n')[1]

  local is_error = false
  for _, pattern in ipairs(error_patterns) do
    is_error = is_error or string.match(first_line, pattern)
  end

  if is_error then
    -- return require('notify.render.error')(bufnr, notif, highlights, config)
    vim.dbglog('SKIPPING ERROR')
    return require('notify.render.default')(bufnr, notif, highlights, config)
  elseif #title > 0 and not vim.tbl_contains(title_ignore, title) then
    return require('notify.render.compact')(bufnr, notif, highlights, config)
    -- return require('notify.render.wrapped-compact')(bufnr, notif, highlights, config)
    -- return require('notify.render.' .. render_title)(bufnr, notif, highlights, config)
  else
    -- return require('notify.')(bufnr, notif, highlights)
    return require('notify.render.simple-notitle')(bufnr, notif, highlights, config)
    -- return require('notify.render.wrapped-compact')(bufnr, notif, highlights, config)
    -- return require('notify.render.simple-notitle')(bufnr, notif, highlights)
  end
end

return render

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

-- highlights:
-- body = "NotifyDEBUGBody18",
-- border = "NotifyDEBUGBorder18",
-- buffer = 18,
-- groups = {
--     NotifyDEBUGBody18 = {
--         foreground = 8623801
--     },
--     NotifyDEBUGBorder18 = {
--         foreground = 4942779
--     },
--     NotifyDEBUGIcon18 = {
--         foreground = 7048191
--     },
--     NotifyDEBUGTitle18 = {
--         foreground = 7048191
--     }
-- },
--
