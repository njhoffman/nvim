local opts = require("import.opts")

local n = 0
local simple_metrics = function(metrics)
  if metrics == nil then
    metrics = {
      start = vim.uv.hrtime(),
      finish = nil,
      duration = nil,
    }
  else
    n = n + 1
    metrics.load_n = n
    metrics.finish = vim.uv.hrtime()
    metrics.duration = metrics.finish - metrics.start
  end
  return metrics
end

local count_command = function(cmd)
  vim.cmd([[ let temp_reg = @" | redir @" ]])
  vim.cmd('silent! execute "' .. cmd .. '"')
  vim.cmd([[
    redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]])
  return vim.api.nvim_eval("w:output_len")
end

local get_command = function(cmd)
  vim.cmd([[ let temp_reg = @" | redir @" ]])
  vim.cmd('silent! execute "' .. cmd .. '"')
  vim.cmd([[
    redir END
    let output = copy(@") | let @" = temp_reg | let w:output=split(output, "\n")
  ]])
  return vim.api.nvim_eval("w:output")
end

local detailed_metrics = function(metrics)
  local cmd = get_command
  metrics.report = {
    -- autocommands = 0,
    -- autogroups = 0,
    -- global_variables = cmd("let g:"),
    -- buffer_variables = cmd("let b:"),
    -- global_options = cmd(":set"),
    -- buffer_options = cmd(":setlocal"),
    -- functions = cmd(":function"),
    -- syntax_items = cmd(":syntax"),
    -- commands = cmd(":command"),
    -- highlights = cmd(":highlight"),
  }
  return metrics
end

local calc_metrics = function(prev)
  local metrics = simple_metrics(prev)
  if opts.user_opts.detailed_metrics then
    return detailed_metrics(metrics)
  end
  return metrics
end

return {
  calc_metrics = calc_metrics,
}
