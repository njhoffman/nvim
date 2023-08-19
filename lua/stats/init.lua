local commands = require('stats.commands')

--   68 loaded : 216 checked
--   88 exist  : 128 not exist
--   nvim_dirs = 163
--   nvim_files = 1,007
--   nvim_lines = 97,393
--   nvim_size  = "6.1M"
--   plugin_dirs  = 6,031,
--   plugin_files = 29,271
--   plugin_lines = 15,629,291
--   plugins_size = "2.3G"

local stats_complete = function(query, cmd)
  local cmds = {
    'aucommands',
    'environment',
    'highlights',
    'files',
    'keys',
    'lazy',
    'vars',
  }
  local key_cmds = {
    'list',
    'tree',
    'table',
  }
  local lazy_cmds = {
    'configs',
    'plugins',
  }
  local files_cmds = {
    'runtime',
    'scriptnames',
  }
  local view_cmds = {
    'float',
    'notify',
    'logfile',
    'print',
    'new_buffer',
    'split_buffer',
  }

  if query == '' then
    if cmd == 'Stats keys ' then
      return key_cmds
    elseif cmd == 'Stats lazy ' then
      return lazy_cmds
    elseif cmd == 'Stats files ' then
      return files_cmds
    elseif cmd ~= 'Stats ' then
      return view_cmds
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

vim.api.nvim_create_user_command(
  'Stats',
  stats_command,
  { desc = 'Internal stats output and monitoring', complete = stats_complete, nargs = '*' }
)
