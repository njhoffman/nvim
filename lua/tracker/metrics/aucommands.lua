local queue = {}
local debuglog = require('debuglog').log

local output_aucommands = function(queue, opts)
  local aucmd_n = 0
  local last_aucmd = ''
  local combined = {}
  for _, ev in ipairs(queue) do
    if ev == last_aucmd or last_aucmd == '' then
      aucmd_n = aucmd_n + 1
      last_aucmd = ev
    else
      last_aucmd = aucmd_n > 1 and last_aucmd .. ' x' .. aucmd_n or last_aucmd
      table.insert(combined, last_aucmd)
      aucmd_n = 1
      last_aucmd = ev
    end
  end

  if aucmd_n > 0 then
    last_aucmd = aucmd_n > 1 and last_aucmd .. ' x' .. aucmd_n or last_aucmd
    table.insert(combined, last_aucmd)
  end

  for _, ev_out in ipairs(combined) do
    debuglog(ev_out)
  end
end

local provider = function(_)
  return {
    name = 'aucommands',
    icon = '',
    id_fields = { 'pattern', 'event' },
    desc_fields = { 'group_name', 'pattern', 'event' },
    output_data = output_aucommands,
    get_data = function()
      return vim.api.nvim_get_autocmds({})
    end,
    -- parse_data = function() end
  }
end

return provider
