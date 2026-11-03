local path_home = function(file)
  local home = os.getenv('HOME') or ''
  if string.len(home) > 0 then
    return string.gsub(file, home, '~')
  end
  return file
end

local path_nvim = function(file)
  local nvim = vim.fn.stdpath('config') .. '/'
  if string.len(nvim) > 0 then
    return string.gsub(file, nvim, '')
  end
  return file
end

local remote_commands = function(cmds, ignore_error)
  local output_error = function(err)
    vim.notify(err, 4)
  end

  local next_server = string.gsub(vim.v.servername, 'nvim', 'nvim_linked')
  local addr = next_server

  local cmd_lines = {}
  for _, cmd in pairs(cmds) do
    cmd_lines[#cmd_lines + 1] = cmd
  end

  vim.notify('remote send: ' .. addr .. '\n' .. table.concat(cmd_lines, '\n'), 2)

  for _, cmd in ipairs(cmd_lines) do
    local escaped = cmd:gsub('"', '\\"')
    local remote_cmd = 'nvim --server "' .. addr .. '" --remote-send ":' .. escaped .. '<CR>"'
    local res = vim.fn.system(remote_cmd)
    if string.len(res) > 0 and not ignore_error then
      output_error(res)
    end
  end
end

return {
  remote_commands = remote_commands,
  path_home = path_home,
  path_nvim = path_nvim,
}
