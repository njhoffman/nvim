local function link(group1, group2)
  vim.api.nvim_set_hl(0, group1, { link = group2, default = true })
end

local setup_highlights = function()
  local aerial_def = vim.api.nvim_get_hl(0, { name = 'AerialDefault', link = false })
  if vim.tbl_isempty(aerial_def) then
    local normal_def = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
    if not vim.tbl_isempty(normal_def) then
      if normal_def.fg or normal_def.bg then
        vim.api.nvim_set_hl(0, 'AerialDefault', normal_def)
        -- else
        --   vim.dbglog('aerial invalid normal_def', normal_def)
      end
    end
  end

  local symbol_kinds = {
    'Array',
    'Boolean',
    'Class',
    'Constant',
    'Constructor',
    'Enum',
    'EnumMember',
    'Event',
    'Field',
    'File',
    'Function',
    'Interface',
    'Key',
    'Method',
    'Module',
    'Namespace',
    'Null',
    'Number',
    'Object',
    'Operator',
    'Package',
    'Property',
    'String',
    'Struct',
    'TypeParameter',
    'Variable',
  }

  -- The name of the symbol
  for _, symbol_kind in ipairs(symbol_kinds) do
    vim.api.nvim_set_hl(0, string.format('Aerial%s', symbol_kind), { fg = 'none' })
    -- link(string.format("Aerial%s", symbol_kind), "AerialDefault")
  end
end

return { setup = setup_highlights }
