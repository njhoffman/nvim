local task_error = require('notifications.task-error')
local task_success = require('notifications.task-success')
local utils = require('runner.utils')

local handle_shell_output = function(output, cmd, time)
  if false and task_error.is_match(output) then
    task_error.notify(output, cmd, time)
  else
    task_success.notify(output, cmd, time)
  end
end
-- local job = require('plenary.job')
--  job:new({
--      command = 'curl',
--      args = {'icanhazip.com'},
--      on_exit = function(j, exit_code)
--          local res = table.concat(j:result(), "\n")
--          local type = "Success!"
--
--          if exit_code ~=0 then
--              type = "Error!"
--          end
--          print(type, res)
--      end,
--  }):start()

local exec_shell_cmd = function(run_cmd)
  ---@diagnostic disable-next-line: missing-parameter
  local start_time = vim.fn.reltime()
  vim.cmd([[ let temp_reg = @" | redir @" ]])
  vim.cmd('silent execute ":' .. run_cmd .. '"')
  vim.cmd([[
    redir END | let output = copy(@")  | let @" = temp_reg
    let w:command_output=split(output, "\n")
  ]])

  local output = vim.api.nvim_eval('w:command_output') or { '' }
  output = vim.tbl_map(function(line)
    line = string.gsub(line, '%^%[%[', '\x1b[')
    line = string.gsub(line, '\\x1b%[', '\x1b[')
    return line
  end, vim.api.nvim_eval('w:command_output') or { '' })
  output = #output > 4 and vim.list_slice(output, 4) or output
  ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
  local diff_time = vim.fn.reltimestr(vim.fn.reltime(start_time)) * 10000
  handle_shell_output(output, run_cmd, diff_time)
end

local exec_vim_cmd = function(run_cmd)
  ---@diagnostic disable-next-line: missing-parameter
  local start_time = vim.fn.reltime()
  local ok, output = pcall(vim.fn.execute, run_cmd, 'silent')
  ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
  local diff_time = vim.fn.reltimestr(vim.fn.reltime(start_time)) * 10000
  vim.dbglog('ORIG OUTPUT', output)
  if not ok then
    return task_error.notify(vim.fn.split(output, '\n'), run_cmd, diff_time)
  else
    return task_success.notify(vim.fn.split(output, '\n'), run_cmd, diff_time)
  end
end

local exec_run_cmd = function(run_cmd)
  if vim.fn.match(run_cmd, '!') == 0 then
    exec_shell_cmd(run_cmd)
  else
    exec_vim_cmd(run_cmd)
  end
end

local get_run_cmd = function(callback)
  -- local default_cmd = "luafile " .. utils.path_nvim(vim.api.nvim_buf_get_name(0))
  local default_cmd = 'luafile scratch/tmp.lua'
  -- local default_cmd = 'luafile %'
  -- local default_cmd = "!grc -es --colour=on netstat -t"
  -- local default_cmd = "!ls --color=always -alh"
  -- local default_cmd = "!rg --color=always --line-number ."
  local width = #default_cmd + 6
  local winhl = 'NormalFloat:TaskFloat,FloatBorder:TaskFloatBorder'
  vim.api.nvim_set_hl(0, 'FloatTitle', { fg = '#22aaff' })
  require('dressing').setup({
    input = {
      win_options = {
        winhighlight = winhl,
      },
      buf_options = {
        syntax = 'vim',
        swapfile = false,
      },
      relative = 'win',
      prompt_align = 'left',
      width = width,
      max_width = { 480, 0.9 },
    },
  })
  vim.ui.input({ prompt = 'runner', default = default_cmd }, callback)
end

local run_cmd = function(params)
  local cmd = params.args or vim.g.run_cmd or ''
  -- if cmd not set show popup to assign it, otherwise run the command
  if string.len(cmd) == 0 then
    get_run_cmd(function(run_cmd)
      if run_cmd ~= nil then
        vim.api.nvim_set_var('run_cmd', run_cmd)
        exec_run_cmd(run_cmd)
      end
    end)
  else
    exec_run_cmd(cmd)
  end
end

return run_cmd
