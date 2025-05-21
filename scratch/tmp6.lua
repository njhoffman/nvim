local output_item = function(line)
  -- print(line)
  vim.dbglog(line)
end

local M = {}
local list_check = function(tbl)
  local count = 0
  for k, v in pairs(tbl) do
    if type(k) == "number" and math.floor(k) == k and k > 0 then -- Ensure that the key is a positive integer
      count = count + 1
    else
      return false, 0
    end
  end
  return true, count
end
local cfg = { max_depth = 0 }

M.print_table_outline = function(tbl, depth)
  depth = depth or 0
  local indent = string.rep("  ", depth) -- Create an indent based on depth

  if depth > cfg.max_depth then
    output_item(indent .. " (max)")
    return
  end

  for k, v in pairs(tbl) do
    if type(v) == "table" then
      -- Check if the table is a sequence (list)
      local is_list, count = list_check(v)
      if is_list then
        output_item(indent .. tostring(k) .. ": " .. "(List of size " .. count .. ")")
      else
        output_item(indent .. tostring(k) .. ": ")
        M.print_table_outline(v, depth + 1) -- Recursion to handle nested tables
      end
    else
      output_item(indent .. tostring(k) .. ": " .. tostring(v))
    end
  end
end

M.print_table_outline(package.loaded)
