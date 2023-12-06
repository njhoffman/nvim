local utils = require('notify.util.render')

local file_pfx = string.gsub(vim.fn.stdpath('config') .. '/', os.getenv('HOME') .. '/', '')

local get_path = function(file)
  local path = vim.fn.trim(file) or file
  local file_match = string.match(path, '.*' .. file_pfx)
  if file_match then
    path = vim.fn.stdpath('config') .. '/' .. string.gsub(path, file_match, '')
  elseif not string.match(path, '^/') then
    path = vim.fn.stdpath('config') .. '/' .. string.gsub(path, '^./', '')
  end
  return path
end

local logger = require('logger').init('notify')
local log_parts = function(parts)
  if #parts.title == 0 or #parts.stack == 0 then
    logger:warn('Invalid error parsing: \n' .. vim.inspect(parts))
  else
    logger:debug('Parsed error parts: \n' .. vim.inspect(parts))
  end
end

local get_error_parts = function(lines)
  local stack_line_idx = 0
  for i, line in pairs(lines) do
    if stack_line_idx == 0 and line.match(line, 'stack traceback:$') then
      stack_line_idx = i
    end
  end

  local title_line = lines[stack_line_idx > 1 and (stack_line_idx - 1) or 1]
  local parts = {
    code = string.match(title_line, '(E[%d]+)') or '',
    title = string.match(title_line, ': ([^:]+:[^:]+:[^:]+)') or '',
    stack = {},
  }
  local inner = {
    title = string.match(title_line, ':E[%d]+: ([^:]+:[^:]+:[^:]+)') or '',
    code = string.match(title_line, ':(E[%d]+)') or '',
  }

  parts.code = inner.code or parts.code

  local title = inner.title and #inner.title > 0 and inner.title or parts.title
  parts.file = string.match(title, '([^: ]*):') or ''
  parts.line = string.match(title, '[^: ]*:([^:]*):') or ''
  parts.message = string.match(title, '[^: ]*:[^:]*: ([^:]*)') or ''
  parts.title = string.match(title, '([^:]*)')
  parts.title = vim.trim(parts.title)
  parts.path = get_path(parts.file)
  parts.shortfile = utils.path_nvim(string.gsub(parts.path, '^%s+', ''))

  for i, line in pairs(lines) do
    if i >= stack_line_idx then
      line = utils.path_nvim(string.gsub(line, '^%s+', ''))
      if string.len(line) > 0 then
        table.insert(parts.stack, line)
      end
    end
  end

  log_parts(parts)
  return parts
end

local msg = [[
  Error detected while processing QuickFixCmdPost Autocommands for "vimgrep":
  Error executing lua callback: vim/_editor.lua:0: QuickFixCmdPost Autocommands for "vimgrep"..script nvim_exec2() called at QuickFixCmdPost Autocommands for "vimgrep":0..function <lambda>39, line 1: Vim(copen):E5108: Error executing lua scratch/tmp3.lua:17: attempt to compare number with nil
  stack traceback:
    scratch/tmp3.lua:17: in function 'format_filename'
    scratch/tmp3.lua:34: in function 'get_max_filename_width'
    scratch/tmp3.lua:63: in function <scratch/tmp3.lua:46>
    [C]: in function 'nvim_exec2'
    vim/_editor.lua: in function 'cmd'
    /home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:301: in function 'open'
    /home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:934: in function </home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:933>
  stack traceback:
    [C]: in function 'nvim_exec2'
    vim/_editor.lua: in function 'cmd'
    /home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:301: in function 'open'
    /home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:934: in function </home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:933>
      ]]

local parts = get_error_parts(vim.fn.split(msg, '\n'))
vim.dbglog('ERROR', parts)
