---@diagnostic disable: missing-parameter
---@diagnostic disable: param-type-mismatch

local crc = require('tracker.diff.crc')

local get_item_id = function(item, fields)
  local item_id = nil
  if fields then
    fields = type(fields) == 'string' and { fields } or fields
    for _, field in ipairs(fields) do
      if type(item.value[field]) ~= 'nil' and item.value[field] ~= '' then
        item_id = item_id == nil and '' or item_id
        item_id = item_id .. ' ' .. tostring(item.value[field])
      end
    end
    item_id = item_id == nil and tostring(item.value) or item_id
  end
  if item_id == nil then
    item_id = (item._key and item._key .. '=' or '') .. item.value
  end
  return item_id
end

local serialize_data = function(data, id_fields)
  local items = {}
  local function serialize_item(value, key)
    id_fields = id_fields or type(value) == 'table' and vim.tbl_keys(value) or nil
    local item = { value = value, _key = key }
    local item_id = get_item_id(item, id_fields)
    if type(item_id) ~= 'nil' and item_id ~= '' then
      local crc_hash = crc.get_crc(item_id)
      item.item_id = item_id
      items[tostring(crc_hash)] = item
    end
  end
  if vim.tbl_islist(data) then
    for i, item in ipairs(data) do
      serialize_item(item)
    end
  else
    for key, item in pairs(data) do
      serialize_item(item, key)
    end
  end
  return items
end

local get_diff = function(prev, next)
  local delta = { added = {}, removed = {}, count = #vim.tbl_keys(next) }
  for hash_next, next_item in pairs(next) do
    for hash_prev, _ in pairs(prev) do
      if hash_prev == hash_next then
        goto continue
      end
    end
    table.insert(delta.added, next_item)
    ::continue::
  end

  for hash_prev, prev_item in pairs(prev) do
    for hash_next, _ in pairs(next) do
      if hash_prev == hash_next then
        goto continue
      end
    end
    table.insert(delta.removed, prev_item)
    ::continue::
  end
  return delta
end

return {
  serialize_data = serialize_data,
  get_diff = get_diff,
}
