local output = require('tracker.output')
local diff_delta = require('tracker.diff.delta')

-- local get_col_lengths = function(source, data)
--   local col_lengths = {}
--   local fields = source.desc_fields or source.id_fields or vim.tbl_keys(data[1])
--   -- local cols = vim.tbl_deep_extend('force', fields, source._opts and source._opts.align_cols)
--   source._col_lengths = {}
--   for _, field in ipairs(fields) do
--     col_lengths[field] = 0
--   end
--   for _, item in ipairs(data) do
--     for _, col in ipairs(fields) do
--       -- vim.dbglog(item)
--       -- local field = item.value[col]
--       -- if type(field) == 'string' and #field > col_lengths[col] then
--       --   col_lengths[col] = #field
--       -- end
--     end
--   end
--   return col_lengths
-- end

local defaults = {}
defaults.output = function(source, delta)
  if #delta.added > 0 or #delta.removed > 0 then
    -- stylua: ignore
    local props   = {
      name        = source.name,
      icon        = source.icon or ' ',
      label       = source.label or source.name,
      desc_fields = source.desc_fields,
    }
    output.output_diff(props, delta)
    -- if opts.only_metrics then
    --   output.output_metric(props, delta)
    -- else
    -- end
  end
end

defaults.serialize = function(items, id_fields)
  return diff_delta.serialize_data(items, id_fields)
end

defaults.diff = function(prev_items, curr_items)
  return diff_delta.get_diff(prev_items, curr_items)
end

defaults.init = function(opts)
  return opts.interval or 1000
end

return defaults
