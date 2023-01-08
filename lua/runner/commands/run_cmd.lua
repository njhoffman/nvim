local task_error = require('notifications.task-error')
local task_success = require('notifications.task-success')
local utils = require('runner.utils')

local _parse_output = function(output, cmd, time)
  if task_error.is_match(output) then
    task_error.notify(output, cmd, time)
  else
    task_success.notify(output, cmd, time)
  end
end

local _exec_run_cmd = function(run_cmd)
  local start_time = vim.loop.hrtime()
  vim.cmd [[ let temp_reg = @" | redir @" ]]
  vim.cmd('silent! execute ":' .. run_cmd .. '"')
  vim.cmd([[
    redir END | let output = copy(@")  | let @" = temp_reg 
    let w:command_output=split(output, "\n")
  ]])

  local diff_time = (vim.loop.hrtime() - start_time) / 1000
  local output = vim.api.nvim_eval("w:command_output") or { '' }
  _parse_output(output, run_cmd, diff_time)
end

local _get_run_cmd = function(callback)
  local default_cmd = 'luafile ' .. utils.path_nvim(vim.api.nvim_buf_get_name(0))
  local width = #default_cmd + 6
  local winhl = "NormalFloat:TaskFloat,FloatBorder:TaskFloatBorder"
  vim.api.nvim_set_hl(0, 'FloatTitle', { fg = '#22aaff' })
  require("dressing").setup({
    input = {
      winhighlight = winhl,
      relative     = 'win',
      prompt_align = 'left',
      width        = width,
      max_width    = { 480, 0.9 },
    }
  })
  vim.ui.input({ prompt = 'runner notify', default = default_cmd }, callback)
end

local run_cmd = function(params)
  local cmd = params.args or vim.g.run_cmd or ''
  -- if cmd not set show popup to assign it, otherwise run the command
  if string.len(cmd) == 0 then
    _get_run_cmd(function(run_cmd)
      if run_cmd ~= nil then
        vim.api.nvim_set_var('run_cmd', run_cmd)
        _exec_run_cmd(run_cmd)
      end
    end)
  else
    _exec_run_cmd(cmd)
  end
end

return run_cmd
