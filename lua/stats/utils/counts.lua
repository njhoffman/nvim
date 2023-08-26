-- getcompletion({pat}, {type} [, {filtered}])
-- { arglist, augroup, buffer, breakpoint, cmdline, color, command, compiler, diff_buffer}
-- { dir, environment, event, expression, file, file_in_path, filetype, function, help }
-- { highlight, history, locale, mapclear, mapping, menu, messages, option, packadd  }
-- { runtime, scriptnames, shellcmd, sign, syntax, syntime, tag, tag_listfiles, user, var  }

local counts = {}

counts.aucommands = function()
  local aucounts = require('stats.utils.aucommands').traverse()
  return aucounts.total
end

counts.augroups = function()
  local aucounts = require('stats.utils.aucommands').traverse()
  return aucounts.groups
end

counts.memory = function()
  local pid = vim.fn.getpid()
  return table.remove(vim.fn.systemlist('ps h -p ' .. pid .. ' -o rss'), 1)
end

counts.virtual = function()
  local pid = vim.fn.getpid()
  return table.remove(vim.fn.systemlist('ps h -p ' .. pid .. ' -o vsz'), 1)
end

local exe_output = function(cmd)
  local cmd_lines = [[
    let temp_reg = @" | redir @" | silent! execute "]] .. cmd .. [[" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  vim.cmd(cmd_lines)
  return vim.api.nvim_eval('w:output_len')
end

for key, cmd in pairs({
  changes = ':changes',
  commands = ':command',
  functions = ':function',
  highlights = ':highlight',
  history = ':history',
  menu = ':menu',
  messages = ':message',
  oldfiles = ':oldfiles',
  options = ':set',
  scriptnames = ':scriptnames',
  syntax = ':syntax',
  variables = ':let',
}) do
  counts[key] = function()
    return exe_output(cmd)
  end
end

local get_counts = function(keys)
  keys = keys or vim.tbl_keys(counts)
  local results = {}
  for _, key in ipairs(keys) do
    results[key] = counts[key]()
  end
  return results
end

return { counts = counts, get_counts = get_counts }
