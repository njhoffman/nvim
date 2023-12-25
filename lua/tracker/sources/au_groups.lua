local base_source = require('tracker.sources._base')

local get_augroups = function(self)
  local aucmds = vim.api.nvim_get_autocmds({})
  local augroups = {}
  for _, aucmd in ipairs(aucmds) do
    local name = aucmd.group_name or 'anonymous'
    augroups[name] = augroups[name] or { name = name }
    if aucmd.buflocal then
      augroups[name].buffer_cmds = augroups[name].buffer_cmds and augroups[name].buffer_cmds + 1 or 1
      if not augroups[name].buffers or not augroups[name].buffers[aucmd.buffer] then
        augroups[name].buffers = augroups[name].buffers or {}
        augroups[name].buffers[aucmd.buffer] = true
      end
    else
      augroups[name].global_cmds = augroups[name].global_cmds and augroups[name].global_cmds + 1 or 1
    end
  end
  local results = {}
  local parsed_groups = {}
  for key, group in pairs(augroups) do
    if group.buffers and #vim.tbl_keys(group.buffers) > 0 then
      group.buffers = 'bufs: ' .. vim.fn.join(vim.tbl_keys(group.buffers), ',')
    end
    if group.buffer_cmds and group.buffer_cmds > 0 then
      group.buffer_cmds = 'b:' .. group.buffer_cmds
    end
    if group.global_cmds and group.global_cmds > 0 then
      group.global_cmds = 'g:' .. group.global_cmds
    end
    table.insert(parsed_groups, group)
  end
  self:_build_results(results, parsed_groups)
  return results.items, results.columns
end

return vim.tbl_extend('force', base_source, {
  name = 'au_groups',
  label = 'auto groups',
  icon = '', --     
  fields = {
    'name',
    'global_cmds',
    'buffer_cmds',
    'buffers',
  },
  -- output = output_au_cmds(queue, opts),
  get = get_augroups,
})
