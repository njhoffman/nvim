local notify = require("notify").notify
local notify_util = require("lsp.notify_util")

-- table from lsp severity to vim severity.
local severity = {
  "error",
  "warn",
  "info",
  "debug", -- map both hint and info to info?
}

local M = {}
M.message_handler = function(err, method, params, client_id)
  notify(method.message, severity[params.type])
end

-- It's good practice to namespace custom handlers to avoid collisions
M.diagnostic_handler = {
  show = function(namespace, bufnr, diagnostics, opts)
    -- In our example, the opts table has a "log_level" option
    local level = opts["my/notify"].log_level
    local name = vim.diagnostic.get_namespace(namespace).name
    local msg = string.format("%d diagnostics in buffer %d from %s", #diagnostics, bufnr, name)
    vim.notify(msg, level)
  end,
}

M.progress_handler = function(_, result, ctx)
  local client_id = ctx.client_id
  local val = result.value
  if not val.kind then
    return
  end

  local notif_data = notify_util.get_notif_data(client_id, result.token)
  if val.kind == "begin" then
    local message = notify_util.format_message(val.message, val.percentage)
    notif_data.notification = notify(message, "info", {
      title = notify_util.format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
      icon = notify_util.spinner_frames[1],
      timeout = false,
      hide_from_history = false,
    })
    notif_data.spinner = 1
    notify_util.update_spinner(client_id, result.token)
  elseif val.kind == "report" and notif_data then
    notif_data.notification = notify(notify_util.format_message(val.message, val.percentage), "info", {
      replace = notif_data.notification,
      hide_from_history = false,
    })
  elseif val.kind == "end" and notif_data then
    notif_data.notification = notify(val.message and notify_util.format_message(val.message) or "Complete", "info", {
      icon = "",
      replace = notif_data.notification,
      timeout = 3000,
    })
    notif_data.spinner = nil
  end
end

return M
