---@diagnostic disable: param-type-mismatch
local auid = nil

local output_lines = function(lines)
  local out = '\n\n'
  for _, line in ipairs(lines) do
    if type(line) == 'table' then
      out = out .. '\n\t' .. vim.fn.join(line, '\n\t\t')
    elseif type(line) == 'string' and line ~= '' then
      out = out .. '\n\t' .. line
    end
  end
  -- vim.dbglog(out .. '\n\n')
end

local log_pos = function(obj, _)
  local name = vim.fn.bufname(obj.buffer)
  local lines = {}
  local main_line = { { vim.fn.getftype(name), '[' .. obj.row .. ':' .. obj.col .. ']', 'buf: ' .. obj.buffer, '-- ' .. name } }
  if not vim.tbl_isempty(obj.treesitter) then
    for _, ts in ipairs(obj.treesitter) do
      table.insert(main_line, { ts.lang, ts.capture, ts.hl_group, ts.hl_group_link })
    end
  end

  -- if not vim.tbl_isempty(obj.semantic_tokens) then
  --   table.insert(lines, { semantic_tokens = obj.semantic_tokens })
  -- end
  -- if not vim.tbl_isempty(obj.syntax) then
  --   table.insert(lines, { syntax = obj.syntax })
  -- end
  vim.dbglog(main_line)
  table.insert(lines, vim.fn.join(main_line, '   '))

  -- if not vim.tbl_isempty(obj.extmarks) then
  --   for _, ext in ipairs(obj.extmarks) do
  --     local o = ext.opts
  --     local extline = {}
  --     table.insert(extline, {
  --       ext.row .. ':' .. ext.col,
  --       ext.end_row .. ':' .. ext.end_col,
  --       ext.ns,
  --       o.priority,
  --     })
  --
  --     if o.virt_text then
  --       local virt_text = ''
  --       table.insert(extline, {
  --         o.virt_text_hide and '[hidden]' or '',
  --         o.virt_text_pos,
  --         virt_text,
  --       })
  --     else
  --       table.insert(extline, {
  --         'highlight',
  --         o.hl_mode and ('(' .. o.hl_mode .. ')') or '',
  --         o.hl_group_link,
  --         '[' .. o.hl_group .. ']',
  --       })
  --     end
  --     table.insert(lines, vim.fn.join(extline, '   '))
  --     for _, vt in ipairs(o.virt_text or {}) do
  --       table.insert(lines, vt[1] .. (vt[2] and ' [' .. vt[2] .. ']' or ''))
  --     end
  -- end
  -- end
  output_lines(lines)
end

local create_aucmd = function(show_popup)
  local inspect_pos = function(event)
    local opts = { extmarks = 'all', syntax = true, semantic_tokens = true, treesitter = true }
    local results = vim.inspect_pos(nil, nil, nil, opts)
    log_pos(results, event)
    if show_popup then
      vim.show_pos(nil, nil, nil, opts)
    end
  end

  return function()
    if auid == nil then
      auid = vim.api.nvim_create_autocmd('CursorMoved', {
        buffer = vim.fn.bufnr(),
        desc = 'Inspecting nodes and syntax under cursor',
        callback = inspect_pos,
      })
    else
      auid = vim.api.nvim_del_autocmd(auid)
    end
  end
end

vim.api.nvim_create_user_command('InspectSticky', create_aucmd(true), { desc = 'Toggle sticky inspector (:Inspect) popup and logger' })
vim.api.nvim_create_user_command('InspectLogSticky', create_aucmd(false), { desc = 'Toggle sticky inspector logger' })
