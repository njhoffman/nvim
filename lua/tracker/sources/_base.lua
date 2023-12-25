local diff_delta = require('tracker.diff.delta')

local build_fields = function(items)
  local fields = {}
  for _, item in ipairs(items) do
    for key in pairs(item) do
      fields[key] = true
    end
  end
  return vim.tbl_keys(fields)
end

-- local get_func = function(self, name)
--   return type(self[name]) == 'function' and self[name] or defaults[name]
-- end

local source_base = {}

source_base._get_opt = function(self, opt_name)
  local names = type(opt_name) == 'table' and opt_name or { opt_name }
  for _, name in ipairs(names) do
    if self._opts and self._opts[name] ~= nil then
      return self._opts[name]
    elseif self[name] ~= nil then
      return self[name]
    end
  end
end

source_base._init = function(self, opts, source_cfg)
  self._opts = vim.tbl_deep_extend('force', opts or {}, source_cfg or {})
  self.icon = self:_get_opt('icon')
  self.name = self:_get_opt('name')
  self.label = self:_get_opt('label') or self.name
  return self
end

source_base._diff = function(_, prev_items, curr_items)
  return diff_delta.get_diff(prev_items, curr_items)
end

source_base._serialize = function(self, items)
  local fields = self:_get_opt({ 'id_fields', 'data_fields', 'desc_fields', 'fields' }) or build_fields(items)
  return diff_delta.serialize_data(items, fields)
end

source_base._build_results = function(self, results, items, opts)
  results.items = results.items or {}
  results.columns = results.columns or {}
  opts = opts or {}
  local fields = self:_get_opt({ 'data_fields', 'id_fields', 'desc_fields', 'fields' }) or build_fields(items)
  for _, item in ipairs(items) do
    local result = {}
    for _, field in ipairs(fields) do
      if item[field] ~= nil then
        result[field] = item[field]
        results.columns[field] = results.columns[field] and math.max(#tostring(item[field]), results.columns[field])
          or #tostring(item[field])
      end
    end
    for key, val in pairs(opts.extra or {}) do
      result[key] = tostring(val)
      results.columns[key] = results.columns[key] and math.max(#tostring(val), results.columns[key]) or #tostring(val)
    end
    table.insert(results.items, result)
  end
end

local log_func = vim.dbglog or print
source_base._output_diff = function(self, delta)
  local diff_items = vim.tbl_flatten({ vim.tbl_get(delta, 'added'), vim.tbl_get(delta, 'removed') })
  local fields = self:_get_opt({ 'desc_fields', 'id_fields', 'data_fields', 'fields' }) or build_fields(diff_items)

  local desc_fields = function(item)
    local ignore = { 'scope', 'mode', 'bufnr', 'winnr', 'buffer' }
    fields = type(fields) == 'string' and { fields } or fields
    local desc_field = nil
    for _, field in ipairs(fields) do
      if not vim.tbl_contains(ignore, field) and type(item.value[field]) ~= 'nil' and item.value[field] ~= '' then
        desc_field = desc_field == nil and '' or desc_field
        desc_field = desc_field .. ' ' .. tostring(item.value[field])
      end
    end
    return desc_field
  end
  local output = function(symbol, item)
    local icon = (self.icon and self.icon .. ' ') or ' '
    local scope = item.value.scope == 'global' and 'g'
      or item.value.scope == 'buf' and 'b'
      or item.value.scope == 'win' and 'w'
      or item.value.scope
      or ' '
    local prefix = icon .. ' ' .. scope .. (item.value.mode or ' ')
    local desc = desc_fields(item) or item.item_id
    local nr = item.value.bufnr or item.value.winnr or item.value.buffer or ''
    desc = (nr ~= '' and ' ' .. nr or '') .. desc
    local msg = symbol .. desc .. (self.show_delta and ' (' .. delta.count .. ')' or '')
    local suffix = (#icon == 0 or self.show_name and ' [' .. self.name .. ']') or ''
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

return source_base
