local traceback = function()
  -- The main introspective function in the debug library is the debug.getinfo function. Its first parameter may be a function or a stack level. When you call debug.getinfo(foo) for some function foo, you get a table with some data about that function. The table may have the following fields:
  -- source --- Where the function was defined. If the function was defined in a string (through loadstring), source is that string. If the function was defined in a file, source is the file name prefixed with a `@´.
  -- short_src --- A short version of source (up to 60 characters), useful for error messages.
  -- linedefined --- The line of the source where the function was defined.
  -- what --- What this function is. Options are "Lua" if foo is a regular Lua function, "C" if it is a C function, or "main" if it is the main part of a Lua chunk.
  -- name --- A reasonable name for the function.
  -- namewhat --- What the previous field means. This field may be "global", "local", "method", "field", or "" (the empty string). The empty string means that Lua did not find a name for the function.
  -- nups --- Number of upvalues of that function.
  -- func --- The function itself; see later.
  -- When foo is a C function, Lua does not have much data about it. For such functions, only the fields what, name, and namewhat are relevant.
  -- When you call debug.getinfo(n) for some number n, you get data about the function active at that stack level. For instance, if n is 1, you get data about the function doing the call. (When n is 0, you get data about getinfo itself, a C function.) If n is larger than the number of active functions in the stack, debug.getinfo returns nil. When you query an active function, calling debug.getinfo with a number, the result table has an extra field, currentline, with the line where the function is at that moment. Moreover, func has the function that is active at that level.
  -- The field name is tricky. Remember that, because functions are first-class values in Lua, a function may not have a name, or may have several names. Lua tries to find a name for a function by looking for a global variable with that value, or else looking into the code that called the function, to see how it was called. This second option works only when we call getinfo with a number, that is, we get information about a particular invocation.
  -- The getinfo function is not efficient. Lua keeps debug information in a form that does not impair program execution; efficient retrieval is a secondary goal here. To achieve better performance, getinfo has an optional second parameter that selects what information to get. With this parameter, it does not waste time collecting data that the user does not need. The format of this parameter is a string, where each letter selects a group of data, according to the following table:
  -- `n´	selects fields name and namewhat
  -- `f´	selects field func
  -- `S´	selects fields source, short_src, what, and linedefined
  -- `l´	selects field currentline
  -- `u´	selects field nup
  local level = 1
  local out = {}
  while true do
    local info = debug.getinfo(level, "Sln")
    if not info then
      break
    end
    local msg = ""
    if info.what == "C" then -- is a C function?
      msg = level .. ": " .. "C function"
      if type(info.name) == "string" and info.name ~= "" then
        msg = msg .. " -> " .. info.namewhat .. ":" .. info.name
      end
    else -- a Lua function
      -- out = out .. '\n' .. string.format('[%s]:%d', info.short_src, info.currentline)
      msg = string.format("%d:[%s]:%d", level, info.source, info.currentline)
      if type(info.name) == "string" and info.name ~= "" then
        msg = msg .. " -> " .. info.namewhat .. ":" .. info.name
      end
    end
    table.insert(out, msg)
    level = level + 1
  end
  return out
end

return traceback
