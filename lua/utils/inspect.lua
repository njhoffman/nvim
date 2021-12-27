
local M = {}
M.inspect = function(tbl, depth, n)
  n = n or 2
  depth = depth or 5

  if depth == 0 then
    print(string.rep(" ", n) .. "...")
    return
  end

  if n == 0 then
    print(" ")
  end

  for key, value in pairs(tbl) do
    if key and type(key) == "number" or type(key) == "string" then
      key = string.format('["%s"]', key)

      if type(value) == "table" then
        if next(value) then
          print(string.rep(" ", n) .. key .. " = {")
          M.inspect(value, depth - 1, n + 4)
          print(string.rep(" ", n) .. "},")
        else
          print(string.rep(" ", n) .. key .. " = {},")
        end
      else
        if type(value) == "string" then
          value = string.format('"%s"', value)
        else
          value = tostring(value)
        end

        print(string.rep(" ", n) .. key .. " = " .. value .. ",")
      end
    end
  end

  if n == 0 then
    print(" ")
  end
end
