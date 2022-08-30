local import_status = {
  failures = {},
  successes = {},
  info = {},
  _is_in_error_state = false,
  _printed_error_state = false
}

--- Returns the number of failed imports
local get_failure_count = function()
  local count = 0
  for _, _ in pairs(import_status.failures) do
    count = count + 1
  end
  return count
end

--- Returns the number of successful imports
local get_success_count = function()
  local count = 0
  for _, _ in pairs(import_status.successes) do
    count = count + 1
  end
  return count
end

--- Returns table (array) of modules (strings) that were imported (successfully or otherwise)
local get_all_modules = function()
  local results = {}
  for path, _ in pairs(import_status.info) do
    table.insert(results, path)
  end
  table.sort(results, function(a, b) return a:upper() < b:upper() end)
  return results
end

--- Returns import information about the provided path
--- @param module string
---     The path to check import details for
--- @return table
---     A table that contains either
---     {status = "unknown"}, if the path provided was not imported via the import method
---     or
---     {
---         status  = status,  -- String: This will be either success or failed
---         message = message, -- String: This will be either the error that was provided on import, or nil
---         errors  = errors,  -- Table: Any errors that the path threw during its import attempt
---         logs    = logs,    -- Table: Anything that was printed during the import (with approximate timestamps)
---     }
local get_status = function(module)
  local details = { status = "unknown", imported = false, import_time = -1 }
  if not import_status.info[module] then return details end
  if import_status.failures[module] then
    details.status = "failed"
  else
    details.status = "success"
    details.imported = true
  end
  local message = {}

-- Error detected while processing CursorMoved Autocommands for "<buffer=6>":
-- Error executing lua callback: /home/nicholas/.config/nvim/lua/import/ui/state.lua:18: attempt t
-- o index field 'lines' (a nil value)
-- stack traceback:
  if import_status.info[module].import_message then
    for line, _ in import_status.info[module].import_message:gmatch('([^\r\n]*)') do
      table.insert(message, line)
    end
  end
  details.message = message
  details.import_time  = import_status.info[module].import_time
  details.import_start = import_status.info[module].import_start
  details.import_end   = import_status.info[module].import_end
  details.errors       = import_status.info[module].error_logs
  details.load_n       = import_status.info[module].load_n
  details.logs         = import_status.info[module].print_logs
  details.report       = import_status.info[module].report

  return details
end

return {
  import_status     = import_status,
  get_status        = get_status,
  get_failure_count = get_failure_count,
  get_success_count = get_success_count,
  get_all_modules   = get_all_modules
}
