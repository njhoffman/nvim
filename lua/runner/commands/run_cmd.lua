local task_error = require('notify.task_error')
local task_success = require('notify.task_success')

local _parse_output = function(msg, cmd)
  if task_error.is_match(msg) then
    task_error.notify(msg, cmd)
  else
    task_success.notify(msg, cmd)
  end
end

local _exec_run_cmd = function(run_cmd)
  vim.cmd [[
    let temp_reg = @" 
    redir @" 
  ]]
  run_cmd = "luafile ~/.config/nvim/testtemp2.lua"
  vim.cmd('silent! execute ":' .. run_cmd .. '"')
  vim.cmd([[
    redir END
    let output = copy(@") 
    let @" = temp_reg
    let w:command_output=split(output, "\n")
  ]])

  local output = vim.api.nvim_eval("w:command_output")
  _parse_output(output, run_cmd)
end

local _get_run_cmd = function(callback)
  local default_cmd = 'luafile ' .. string.gsub(
    vim.fn.expand('%:p'),
    vim.fn.stdpath('config') .. '/',
    '')

  require("dressing").setup({
    input = {
      relative     = 'win',
      prompt_align = 'center',
      override     = function(conf)
        return conf
        -- anchor = "SW", border = "rounded", col = 28, height = 1, noautocmd = true,
        -- relative = "win", row = 21, style = "minimal", width = 40
      end
    }
  })
  vim.ui.input({
    prompt  = 'luarun',
    default = default_cmd,
  }, callback)
end

local run_cmd = function(params)
  local cmd = params.args or vim.g.run_cmd or ''
  if string.len(cmd) == 0 then
    _get_run_cmd(function(run_cmd)
      vim.api.nvim_set_var('run_cmd', run_cmd)
      _exec_run_cmd(run_cmd)
    end)
  else
    _exec_run_cmd(cmd)
  end
end

return run_cmd
