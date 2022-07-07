local import_status = {
  fail = {},
  success = {},
  info = {},
  in_error_state = false,
  printed_error_state = false
}
local print_logs = {}
local error_logs = {}
local replay_log = {}

local log_format = '%s - [%s] %s'
local log_timestamp_format = '%Y-%m-%d %H:%M:%S'

-- print/error shim function to collect statements sent to both
local print_shim = function(...)
  local print_safe_args = {}
  local _ = { ... }
  for i = 1, #_ do
    table.insert(print_safe_args, tostring(_[i]))
  end
  local print_log = string.format(log_format, path, os.date(log_timestamp_format), table.concat(print_safe_args))
  table.insert(print_logs, print_log)
  if M.user_opts.import_enable_better_printing then
    table.insert(replay_log, { level = 'print', log = print_log })
  else
    table.insert(replay_log, { level = 'print', log = ... })
  end
end

-- redirect errors to print to avoid breaking import
local error_shim = function(...)
  local print_safe_args = {}
  local _ = { ... }
  for i = 1, #_ do
    table.insert(print_safe_args, tostring(_[i]))
  end
  local error_log = string.format(
    'ERROR: ' .. log_format,
    path,
    os.date(log_timestamp_format), table.concat(print_safe_args)
  )
  table.insert(error_logs, error_log)
  table.insert(replay_log, { level = 'error', log = error_log })
  -- old printing
  -- table.insert(replay_log, { level = 'error', log = ... })
end

local import = function(path)
  local _, level = string.gsub(path, "%.", "")
  local start_time = vim.loop.hrtime()
  local target_ok, target_mod = pcall(require, path)
  local duration = vim.loop.hrtime() - start_time
  if not target_ok then
    import_status.fail[path] = 1
    import_status.in_error_state = true
    error_shim(target_mod)
  else
    import_status.success[path] = 1
  end
  import_status.info[path] = {
    path_depth     = level + 1,
    import_message = target_mod,
    import_time    = duration,
    print_logs     = print_logs,
    error_logs     = error_logs,
    -- success_callback = success_callback,
  }
  return target_mod
end

return {
  import = import,
  import_status = import_status
}
