local completion = function(stats_map)
  return function(query, cmd)
    if query == '' then
      cmd = string.gsub(string.gsub(cmd, 'Stats ', ''), ' $', '')
      local cmds = {}
      if #cmd > 0 then
        local stats_cmd = vim.tbl_get(stats_map, unpack(vim.split(cmd, ' ')))
        if stats_cmd ~= nil then
          if vim.tbl_isarray(stats_cmd) then
            cmds = vim.tbl_values(stats_cmd)
          else
            cmds = vim.tbl_keys(stats_cmd)
          end
        end
      else
        cmds = vim.tbl_keys(stats_map)
      end
      return cmds
    end
  end
end

local command = function(cmd)
  local cmd_map = {
    keys = require('stats.commands.keys'),
    lazy = require('stats.commands.lazy'),
  }
  if cmd_map[cmd.fargs[1]] then
    cmd_map[cmd.fargs[1]].stats(cmd.fargs)
  end
end

return { command, completion }
