local import = require("import.commands.import")
local state = require("import.commands.state")

--- Will unload and reload the path (with import). Safe to call if path was not imported via the import function
--- @param path string
---     The path to import
--- @param success_callback function
---     Optional. Note, if not provided but one was used for the original import, we will simply call the
---     previous callback.
---     **To prevent this, pass "false" to success_callback, or provide a new callback**

local reload = function(path, success_callback)
  package.loaded[path] = nil
  state.import_status.failures[path] = nil
  state.import_status.successes[path] = nil
  local callback_message = ""
  if state.import_status.info[path] then
    local _success_callback = state.import_status.info[path].success_callback
    if success_callback == nil then
      success_callback = _success_callback
      callback_message = "with cached callback"
    end
  end
  if callback_message == "" and success_callback then
    callback_message = "with provided callback"
  end
  local message = "Reloading"
  if not state.import_status.info[path] then
    message = "Importing"
  end
  state.import_status.info[path] = nil
  print(message, path, callback_message)
  import(path, success_callback)
end

return reload
