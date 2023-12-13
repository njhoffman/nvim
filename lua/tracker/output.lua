local desc_fields = function(item, fields)
  fields = type(fields) == 'string' and { fields } or fields
  local desc_field = nil
  for _, field in ipairs(fields) do
    if type(item[field]) ~= 'nil' and item[field] ~= '' then
      desc_field = desc_field == nil and '' or desc_field
      desc_field = desc_field .. ' ' .. item[field]
    end
  end
  return desc_field
end

local output_diff = function(props, delta)
  local output = function(symbol, item)
    vim.dbglog('output item', item)
    local icon = (props.icon and props.icon .. ' ') or ''
    local desc = item.desc_fields and desc_fields(item, item.desc_fields) or item.item_id
    local msg = ' ' .. symbol .. ' ' .. props.name
    msg = icon .. msg .. desc .. ' (' .. delta.count .. ')'
    vim.dbglog(msg)
  end

  local added = vim.tbl_get(delta, 'added') or {}
  local removed = vim.tbl_get(delta, 'removed') or {}

  if #added > 0 or #removed > 0 then
    for _, add_item in ipairs(added) do
      output(' ++ ', add_item)
    end
    for _, rm_item in ipairs(removed) do
      output(' -- ', rm_item)
    end
  end
end

local output_group = function(props, delta)
  if #delta.added > 0 then
    vim.dbglog('  +' .. #delta.added .. '  ' .. props.name .. ' (' .. delta.count .. ')')
  elseif #delta.removed > 0 then
    vim.dbglog('  -' .. #delta.removed .. '  ' .. props.name .. ' (' .. delta.count .. ')')
  end
end

return {
  output_diff = output_diff,
  output_group = output_group,
}
