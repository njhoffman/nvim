local stats_map = require('stats.commands-stats')
local watch_map = require('stats.commands-watch')
local track_map = require('stats.commands-track')
--
local function build_cmds(cmd, map, view, results)
  results = results or {}
  if vim.tbl_isarray(map) then
    if not view then
      for _, name in ipairs(map) do
        table.insert(results, cmd .. ' ' .. name)
      end
    end
  else
    for name, cmd_list in pairs(map) do
      local new_cmd = cmd .. ' ' .. name
      if view then
        table.insert(results, new_cmd .. ' ' .. view)
        build_cmds(new_cmd, cmd_list, view, results)
      else
        table.insert(results, new_cmd)
        build_cmds(new_cmd, cmd_list, view, results)
      end
    end
  end
  return results
end

local get_commands = function(target, view)
  local targets = vim.fn.split(target, ' ')
  local cmd_map = vim.tbl_get(stats_map, unpack(targets))
  local commands = build_cmds(target, cmd_map, view)
  table.insert(commands, target .. (view and ' ' .. view or ''))
  table.sort(commands)
  return commands
end

local load_set = function(target, view, timeout)
  if not timeout then
    timeout = 3000
    if view == 'notify' then
      timeout = 6000
    end
  end

  local commands = get_commands(target, view)

  for i, cmd in ipairs(commands) do
    vim.defer_fn(function()
      vim.dbglog(
        '\n\n\n---------------------------------------------\n'
          .. i
          .. ': '
          .. cmd
          .. '\n---------------------------------------------'
      )
      vim.cmd('Stats ' .. cmd)
    end, timeout * i)
  end
end

load_set('lazy configs', 'logfile', timeout)
