local inspect = require('debuglog.parsers.inspect')

-- options.depth
-- options.depth sets the maximum depth that will be printed out. When the max depth is reached, inspect will stop parsing tables and just return {...}:

local t5 = {a = {b = {c = {d = {e = 5}}}}}

assert(inspect(t5, {depth = 4}) == [[{
  a = {
    b = {
      c = {
        d = {...}
      }
    }
  }
}]])

assert(inspect(t5, {depth = 2}) == [[{
  a = {
    b = {...}
  }
}]])
-- Remove a particular metatable from the result:

local t = {1,2,3}
local mt = {b = 2}
setmetatable(t, mt)

local remove_mt = function(item)
  if item ~= mt then return item end
end

-- mt does not appear
assert(inspect(t, {process = remove_mt}) == "{ 1, 2, 3 }")
-- The previous example only works for a particular metatable. If you want to make all metatables, you can use the path parameter to check wether the last element is inspect.METATABLE, and return nil instead of the item:

local t, mt = ... -- (defined as before)

local remove_all_metatables = function(item, path)
  if path[#path] ~= inspect.METATABLE then return item end
end

assert(inspect(t, {process = remove_all_metatables}) == "{ 1, 2, 3 }")

-- Filter a value:

local anonymize_password = function(item, path)
  if path[#path] == 'password' then return "XXXX" end
  return item
end

local info = {user = 'peter', password = 'secret'}

assert(inspect(info, {process = anonymize_password}) == [[{
  password = "XXXX",
  user     = "peter"
}]])
