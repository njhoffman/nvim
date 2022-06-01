dap.listeners.before['event_progressStart']['progress-notifications'] = function(session, body)
 local notif_data = get_notif_data("dap", body.progressId)

 local message = format_message(body.message, body.percentage)
 notif_data.notification = vim.notify(message, "info", {
   title = format_title(body.title, session.config.type),
   icon = spinner_frames[1],
   timeout = false,
   hide_from_history = false,
 })

 notif_data.notification.spinner = 1,
 update_spinner("dap", body.progressId)
end

dap.listeners.before['event_progressUpdate']['progress-notifications'] = function(session, body)
 local notif_data = get_notif_data("dap", body.progressId)
 notif_data.notification = vim.notify(format_message(body.message, body.percentage), "info", {
   replace = notif_data.notification,
   hide_from_history = false,
 })
end

dap.listeners.before['event_progressEnd']['progress-notifications'] = function(session, body)
 local notif_data = client_notifs["dap"][body.progressId]
 notif_data.notification = vim.notify(body.message and format_message(body.message) or "Complete", "info", {
    icon = "",
    replace = notif_data.notification,
    timeout = 3000
 })
 notif_data.spinner = nil
end
