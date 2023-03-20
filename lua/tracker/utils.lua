local M = {}
function M.unpack_indices(tbl, indices, curr_ix)
  if curr_ix == nil then
    return M.unpack_indices(tbl, indices, 1)
  end
  if curr_ix > #indices then
    return
  end
  --Recursive call
  return tbl[indices[curr_ix]], M.unpack_indices(tbl, indices, curr_ix + 1)
end

return M
