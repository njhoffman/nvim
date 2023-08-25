local commands = require('stats.commands')

-- local cmds = { 'aucommands', 'environment', 'highlights', 'files', 'keys',  'vars' }
-- local files_cmds = { 'runtime', 'scriptnames' }
-- local view_cmds = { 'float', 'notify', 'logfile', 'print', 'new_buffer', 'split_buffer' }

local stats_complete = function(query, cmd)
  local stats_map = {
    keys = {
      list = { 'logfile', 'notify' },
      tree = { 'logfile', 'notify' },
      table = { 'logfile', 'notify' },
    },
    lazy = {
      configs = {
        all = { 'logfile', 'buffer', 'split' },
        dependency = { 'logfile', 'buffer', 'split' },
        checked = { 'logfile', 'buffer', 'split' },
        stray = { 'logfile', 'buffer', 'split' },
        exists = { 'logfile', 'buffer', 'split' },
        missing = { 'logfile', 'buffer', 'split' },
      },
    },
  }
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

local stats_command = function(cmd)
  local cmd_map = {
    keys = require('stats.commands.keys'),
    lazy = require('stats.commands.lazy'),
  }
  if cmd_map[cmd.fargs[1]] then
    cmd_map[cmd.fargs[1]].stats(cmd.fargs)
  end
end

vim.api.nvim_create_user_command('Stats', stats_command, {
  desc = 'Internal stats output and monitoring',
  complete = stats_complete,
  nargs = '*',
})
