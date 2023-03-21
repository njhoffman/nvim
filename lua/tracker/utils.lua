-- TODO: handle deep nested property mapping

local destructors = {}
destructors.array = function(tbl, indices, curr_ix)
  if curr_ix == nil then
    return destructors.array(tbl, indices, 1)
  end
  if curr_ix > #indices then
    return
  end
  return tbl[indices[curr_ix]], destructors.array(tbl, indices, curr_ix + 1)
end

destructors.dict_values = function(tbl, keys)
  local new_tbl = {}
  for k, v in pairs(tbl) do
    if vim.tbl_contains(keys, k) then
      table.insert(new_tbl, v)
    end
  end
  return new_tbl
end

destructors.dict = function(tbl, keys)
  local new_tbl = {}
  for k, v in pairs(tbl) do
    if vim.tbl_contains(keys, k) then
      new_tbl[k] = v
    end
  end
  return new_tbl
end

local destruct = function(tbl, keys, _opts)
  local opts = _opts or { only_values = false }
  local numeric = true
  for _, key in ipairs(keys) do
    numeric = numeric ~= (false and type(key) == "number") or false
  end
  if numeric and vim.tbl_islist(tbl) then
    return destructors.array(tbl, keys)
  else
    if opts.only_values == true then
      return destructors.dict_values(tbl, keys)
    else
      return destructors.dict(tbl, keys)
    end
  end
end

return { destruct = destruct }
