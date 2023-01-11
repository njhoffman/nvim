local status = {
  -- list of import names that failed
  failures = {},
  -- list of import names that succeeded
  successes = {},
  -- contains details of module and load status
  info = {},
  -- holds diagnostic data for later processing
  benchmarks = {},
  _error_state = false,
  _error_printed = false,
}

--- Returns the number of failed imports
local get_failure_count = function()
  local count = 0
  for _, _ in pairs(status.failures) do
    count = count + 1
  end
  return count
end

--- Returns the number of successful imports
local get_success_count = function()
  local count = 0
  for _, _ in pairs(status.successes) do
    count = count + 1
  end
  return count
end

--- Returns table (array) of modules (strings) that were imported (successfully or otherwise)
local get_all_modules = function()
  local results = {}
  for path, _ in pairs(status.info) do
    table.insert(results, path)
  end
  table.sort(results, function(a, b)
    return a:upper() < b:upper()
  end)
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

local get_mod_status = function(module)
  local details = {
    status = "unknown",
    imported = false,
    import_time = -1,
    summary = "",
    report = "",
    message = {},
  }

  local mod_info = status.info[module]
  local mod_fail = status.failures[module]

  if not mod_info then
    details.summary = "Missing import state: " .. module
    return details
  end

  if mod_fail then
    details.status = "failed"
  else
    details.status = "success"
    details.imported = true
  end

  if type(mod_info.import_message) == "string" then
    details.stack = {}
    for line, _ in mod_info.import_message:gmatch("([^\r\n]*)") do
      table.insert(details.message, line)
      table.insert(details.stack, line)
    end
  end

  local keymap = {
    { "import_time", "import_time" },
    { "errors", "error_logs" },
    { "logs", "print_logs" },
    { "summary", "summary" },
    { "report", "report" },
    { "load_n", "load_n" },
  }

  for _, v in pairs(keymap) do
    details[v[1]] = mod_info[v[2]]
  end

  -- vim.dbglog(details)
  return details
end

return {
  status = status,
  get_mod_status = get_mod_status,
  get_failure_count = get_failure_count,
  get_success_count = get_success_count,
  get_all_modules = get_all_modules,
}
