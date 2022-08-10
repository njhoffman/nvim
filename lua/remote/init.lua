local output_error = function(err)
  vim.notify(err, 'error')
end

local next_server = string.gsub(vim.v.servername, 'nvim', 'nvim_linked')

local assign_target = function()
  return next_server
end

local run_script = function()
  vim.notify('running script')
end

local view_watched = function()
  vim.notify('view watched')
end

local watch_file = function()
  vim.notify('watch_file')
end

local run_commands = function(cmds, ignore_error)
  local addr = next_server
  local nvr_cmd = 'nvr --servername "' .. addr .. '"'
  for _, cmd in pairs(cmds) do
    nvr_cmd = nvr_cmd .. "\t" .. ' -c "' .. cmd .. '"'
  end
  local cmd_txt = table.concat(string.split(nvr_cmd, '\t'), '\n')
  vim.notify('nvr send: ' .. addr .. '\n' .. cmd_txt, 'debug')
  local res = vim.fn.system(nvr_cmd)
  -- TODO: ignore_error only if expected EOF error returned
  if string.len(res) > 0 and not ignore_error then output_error(res) end
end

local run_command = function(props)
  run_commands(props.fargs)()
end

return {
  run_command   = run_command,
  run_commands  = run_commands,
  run_script    = run_script,
  assign_target = assign_target,
  watch_file    = watch_file,
  view_watched  = view_watched,
}
