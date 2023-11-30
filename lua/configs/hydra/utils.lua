local get_severity = function(type)
  local severity = vim.tbl_get(vim.diagnostic.config(), type, 'severity', 'min') or vim.diagnostic.config()[type]
  if severity == true then
    severity = 4
  elseif severity == false then
    severity = 0
  end
  vim.dbglog('SEVERE', severity)
  return severity
end

--- deeply compare two objects and return the diff
local function get_difference(original, modified)
  if original == modified then
    return nil
  end -- no changes
  if not (type(original) == 'table' and type(modified) == 'table') then
    return { from = original, to = modified }
  end -- primitive types
  local result = {}
  for k, v in pairs(original) do
    result[k] = get_difference(v, modified[k])
  end
  for k, v in pairs(modified) do
    if original[k] == nil then
      result[k] = get_difference(nil, v)
    end
  end
  return next(result) and result -- return nil for an empty table (no changes)
end

local output_difference = function(title, old, curr)
  vim.dbglog(title, get_difference(old, curr))
end

local update_diagnostic = function(type, level)
  return function()
    local old = vim.diagnostic.config()
    -- if level == 4 then
    --   vim.diagnostic.config({ [type] = true })
    -- elseif level == 0 then
    --   vim.diagnostic.config({ [type] = false })
    -- else
    vim.diagnostic.config({ [type] = { severity = { min = level } } })
    -- end
    output_difference(type .. '=' .. level, old, vim.diagnostic.config())
  end
end

local toggle_diagnostic = function(type)
  return function()
    local old_config = vim.diagnostic.config()
    -- TODO: make into a map, add virtual text handler
    if type == 'buffer' then
      if vim.diagnostic.is_disabled(0) then
        vim.diagnostic.enable(0)
      else
        vim.diagnostic.disable(0)
      end
    elseif type == 'global' then
      if vim.diagnostic.is_disabled() then
        vim.diagnostic.enable()
      else
        vim.diagnostic.disable()
      end
    elseif type == 'format' then
      vim.b.format_on_write = vim.b.format_on_write == 0 and 1 or 0
    elseif type == 'vl_toggle' then
      local severity = get_severity('virtual_lines')
      local only_current = vim.tbl_get(old_config, 'virtual_lines', 'only_current_line')
      -- local whole_line = vim.tbl_get(old_config, 'virtual_lines', 'only_current_line')
      if severity > 0 then
        vim.diagnostic.config({ virtual_lines = { only_current_line = only_current, severity = { min = 0 } } })
      else
        vim.diagnostic.config({
          virtual_lines = { only_current_line = only_current, severity = { min = 4 } },
          virtual_text = false,
        })
      end
    elseif type == 'vl_current' then
      local severity = get_severity('virtual_lines')
      local only_current = vim.tbl_get(old_config, 'virtual_lines', 'only_current_line')
      vim.diagnostic.config({
        virtual_lines = { only_current_line = not only_current, severity = { min = severity } },
      })
    else
      local val = vim.diagnostic.config()[type]
      val = val ~= 5 and val ~= false
      vim.diagnostic.config({ [type] = not val })
    end
    output_difference(type, old_config, vim.diagnostic.config())
  end
end

return {
  get_severity = get_severity,
  get_difference = get_difference,
  update_diagnostic = update_diagnostic,
  toggle_diagnostic = toggle_diagnostic,
}
