local import = require("import.commands.import")
local state = require("import.commands.state")

--- Will unload and reload the path (with import). Safe to call if path was not imported via the import function
--- @string path
---     The path to import
--- @function[opt] success_cb
---     Optional. Note, if not provided but one was used for the original import, we will simply call the
---     previous callback.
---     **To prevent this, pass "false" to success_cb, or provide a new callback**
local reload = function(path, success_cb)
  package.loaded[path] = nil
  state.status.failures[path] = nil
  state.status.successes[path] = nil
  local cb_message = ""
  if state.status.info[path] then
    local _success_cb = state.status.info[path].success_cb
    if success_cb == nil then
      success_cb = _success_cb
      cb_message = "with cached callback"
    end
  end
  if cb_message == "" and success_cb then
    cb_message = "with provided callback"
  end
  local message = "Reloading"
  if not state.status.info[path] then
    message = "Importing"
  end
  state.status.info[path] = nil
  print(message, path, cb_message)
  import(path, success_cb)
end

return reload
