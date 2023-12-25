local log_func = vim.dbglog

local desc_fields = function(item, fields)
  local ignore = { 'scope', 'mode' }
  fields = type(fields) == 'string' and { fields } or fields
  local desc_field = nil
  for _, field in ipairs(fields) do
    if not vim.tbl_contains(ignore, field) and type(item.value[field]) ~= 'nil' and item.value[field] ~= '' then
      desc_field = desc_field == nil and '' or desc_field
      desc_field = desc_field .. ' ' .. item.value[field]
    end
  end
  return desc_field
end

local output_diff = function(props, delta)
  local output = function(symbol, item)
    local icon = (props.icon and props.icon .. ' ') or ''
    local prefix = icon .. ' ' .. (item.value.scope or '') .. ' ' .. (item.value.mode or '') .. ' '
    local item_fields = item.desc_fields or item.id_fields or vim.tbl_keys(item.value)

    local desc = desc_fields(item, item_fields, props) or item.item_id
    local msg = symbol .. desc .. (props.show_delta and ' (' .. delta.count .. ')' or '')
    local suffix = (#icon == 0 or props.show_name and ' [' .. props.name .. ']') or ''
    log_func(prefix .. msg .. suffix)
  end

  local added = vim.tbl_get(delta, 'added') or {}
  local removed = vim.tbl_get(delta, 'removed') or {}

  --      
  if #added > 0 or #removed > 0 then
    for _, add_item in ipairs(added) do
      output('  ', add_item)
    end
    for _, rm_item in ipairs(removed) do
      output('  ', rm_item)
    end
  end
end

local output_count = function(props, delta)
  if #delta.added > 0 then
    log_func('  +' .. #delta.added .. '  ' .. props.name .. ' (' .. delta.count .. ')')
  elseif #delta.removed > 0 then
    log_func('  -' .. #delta.removed .. '  ' .. props.name .. ' (' .. delta.count .. ')')
  end
end

return {
  output_diff = output_diff,
}
