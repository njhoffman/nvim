local task_error = require('notifications.task-error')
local task_success = require('notifications.task-success')
local utils = require('runner.utils')

local handle_shell_output = function(output, cmd, time)
  -- if false and task_error.is_match(output) then
  --   task_error.notify(output, cmd, time)
  -- else
  --   task_success.notify(output, cmd, time)
  -- end
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

local config = {
  save_path = vim.fn.stdpath('data') .. '/runner',
  save_file = 'last_cmd',
}

local exec_shell_cmd = function(run_cmd, no_notify)
  -- check vim.fn.system
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
  if not no_notify then
    handle_shell_output(output, run_cmd, diff_time)
  end
end

local exec_vim_cmd = function(run_cmd, no_notify)
  ---@diagnostic disable-next-line: missing-parameter
  local start_time = vim.fn.reltime()
  local ok, output = pcall(vim.fn.execute, run_cmd)
  ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
  local diff_time = vim.fn.reltimestr(vim.fn.reltime(start_time)) * 10000
  local output_list = type(output) ~= 'table' and vim.fn.split(output, '\n') or output
  if not no_notify then
    if not ok then
      return task_error.notify(output_list, run_cmd, diff_time)
    else
      return task_success.notify(output_list, run_cmd, diff_time)
    end
  end
end

local exec_run_cmd = function(run_cmd, no_notify)
  if vim.fn.match(run_cmd, '!') == 0 then
    exec_shell_cmd(run_cmd, no_notify)
  else
    exec_vim_cmd(run_cmd)
  end
end
-- local default_cmd = "luafile " .. utils.path_nvim(vim.api.nvim_buf_get_name(0))
-- local default_cmd = 'luafile scratch/tmp.lua'
-- local default_cmd = 'luafile %'
-- local default_cmd = "!grc -es --colour=on netstat -t"
-- local default_cmd = "!ls --color=always -alh"
-- local default_cmd = "!rg --color=always --line-number ."
-- local default_cmd = '!tmux display-popup -E /bin/zsh -c $HOME/git/quilr-server/bin/request.sh &'
-- local default_cmd = '!tmux display-popup -e FZF_TMUX=1 -E /bin/zsh -c $HOME/git/quilr-server/bin/request.sh &'
-- local default_cmd = '!tmux FZF_TMUX=1 -E /bin/zsh -c $HOME/git/quilr-server/bin/request.sh &'

local get_run_cmd = function(default_cmd, callback)
  local width = #default_cmd + 6
  local winhl = 'FloatBorder:TaskFloatBorder'
  -- local winhl = 'NormalFloat:TaskFloat,FloatBorder:TaskFloatBorder'
  -- vim.api.nvim_set_hl(0, 'FloatTitle', { fg = '#22aaff' })
  vim.ui.input({
    prompt = ' runner',
    input_options = {
      relative = 'win',
      prompt_align = 'left',
      width = width,
      max_width = { 480, 0.9 },
      buf_options = {
        swapfile = false,
      },
      win_options = {
        winhighlight = winhl,
      },
    },
    default = default_cmd or '',
  }, callback)
end

local save_run_cmd = function(run_cmd)
  vim.fn.mkdir(config.save_path, 'p')
  local f = io.open(config.save_path .. '/' .. config.save_file, 'w')
  if f then
    f:write(run_cmd)
    f:close()
  end
  vim.api.nvim_set_var('run_cmd', run_cmd)
end

local get_last_cmd = function()
  local f = io.open(config.save_path .. '/' .. config.save_file, 'r')
  if f then
    local run_cmd = f:read('*a')
    f:close()
    return run_cmd
  end
  return nil
end

local run_cmd = function(params, no_notify)
  local cmd = params.args or ''
  if cmd == '' then
    local run_ok, run_cmd = pcall(vim.api.nvim_get_var, 'run_cmd')
    if run_ok and type(run_cmd) == 'string' and #run_cmd > 0 then
      cmd = run_cmd
      -- elseif last_cmd ~= nil then
      --   cmd = last_cmd
    end
  end
  no_notify = no_notify or params.no_notify

  -- if cmd not set show popup to assign it, otherwise run the command
  if string.len(cmd) == 0 then
    local default_cmd = params.default_cmd or get_last_cmd() or ''
    get_run_cmd(default_cmd, function(run_cmd)
      if run_cmd ~= nil then
        save_run_cmd(run_cmd)
        exec_run_cmd(run_cmd, no_notify)
      elseif default_cmd ~= nil then
        save_run_cmd(default_cmd)
      end
    end)
  else
    exec_run_cmd(cmd, no_notify)
  end
end

local select_cmd = function(params)
  local run_ok, saved_run_cmd = pcall(vim.api.nvim_get_var, 'run_cmd')
  if run_ok then
    vim.api.nvim_del_var('run_cmd')
  end
  params.default_cmd = saved_run_cmd or ('luafile ' .. utils.path_nvim(vim.api.nvim_buf_get_name(0)))
  run_cmd(params)
end

return {
  run = run_cmd,
  select = select_cmd,
}
