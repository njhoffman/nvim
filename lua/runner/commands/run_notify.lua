local run_notify = function(params)
  local cmd = params.args or vim.g.run_cmd or ''
  print(cmd)
end

return run_notify
