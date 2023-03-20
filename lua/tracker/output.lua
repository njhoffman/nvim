local output_diff = function(props, delta)
  local added = vim.tbl_get(delta, "added") or {}
  local removed = vim.tbl_get(delta, "removed") or {}
  if #added > 0 or #removed > 0 then
    for _, add_item in ipairs(added) do
      local id = add_item[props.id_field]
      vim.dbglog(" ++ augroup " .. id)
    end
    for _, rm_item in ipairs(removed) do
      local id = rm_item[props.id_field]
      vim.dbglog(" -- augroup " .. id)
    end
  end
end

return {
  output_diff = output_diff,
}
