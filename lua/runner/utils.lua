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
  local nvr_cmd = 'nvr --servername "' .. addr .. '"'

  for _, cmd in pairs(cmds) do
    nvr_cmd = nvr_cmd .. '\t' .. ' -c "' .. cmd .. '"'
  end

  local cmd_txt = table.concat(string.split(nvr_cmd, '\t'), '\n')
  vim.notify('nvr send: ' .. addr .. '\n' .. cmd_txt, 2)
  local res = vim.fn.system(nvr_cmd)
  -- TODO: ignore_error only if expected EOF error returned
  if string.len(res) > 0 and not ignore_error then
    output_error(res)
  end
end

return {
  remote_commands = remote_commands,
  path_home = path_home,
  path_nvim = path_nvim,
}
