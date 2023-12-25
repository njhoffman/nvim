local base_source = require('tracker.sources._base')

local get_code_target = function(self)
  local location = self:_get_opt('location')
  local target = self:_get_opt('target')
  if not location then
    vim.notify('No location provided for code_target source', 3)
  else
    local parsed_values = {}
    local target_values = vim.fn.deepcopy(target and require(location)[target] or require(location))
    if vim.tbl_islist(target_values) then
      for i, val in ipairs(target_values) do
        table.insert(parsed_values, { key = i, value = val })
      end
    else
      for key, val in pairs(target_values) do
        table.insert(parsed_values, { key = key, value = val })
      end
    end
    local results = {}
    self:_build_results(results, parsed_values)
    return results.items, results.columns
  end
end

-- stylua: ignore
  return vim.tbl_extend('force', base_source, {
    name      = 'code_target',
    icon      = '', --   什
    get       = get_code_target,
    -- get       = demo_code_target('tables', 1)
    -- output    = output_highlights,
  })

-- name = 'notify_state',
-- location = 'noice.view.backend.state',
