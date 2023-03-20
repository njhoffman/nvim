---@diagnostic disable: missing-parameter
---@diagnostic disable: param-type-mismatch

local crc = require("tracker.crc")

local parse_data = function(provider)
  local data = provider.get_data()
  local items = {}
  for _, item in ipairs(data) do
    local item_id = item[provider.id_field]
    if type(item_id) ~= "nil" and item_id ~= "" then
      local crc_hash = crc.get_crc(item_id)
      items[tostring(crc_hash)] = item
    end
  end
  return items
end

local get_diff = function(prev, next)
  local delta = { added = {}, removed = {} }
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

local check_diff = function(provider, prov_state)
  local start = vim.fn.reltime()
  if type(prov_state.time_get) == "nil" then
    prov_state.time_get = 0
    prov_state.prev_items = provider.parse_data(provider)
  else
    local curr_items = provider.parse_data(provider)
    prov_state.time_get = vim.fn.reltimestr(vim.fn.reltime(start)) * 100000
    start = vim.fn.reltime()
    local diff = get_diff(prov_state.prev_items, curr_items)
    prov_state.time_diff = vim.fn.reltimestr(vim.fn.reltime(start)) * 100000
    prov_state.prev_items = curr_items
    return diff
  end
end

return {
  parse_data = parse_data,
  check_diff = check_diff,
  get_diff = get_diff,
}
