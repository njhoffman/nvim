local output_error = function(res, ret_code)
  vim.dbglog(res, ret_code)
end

local shell_command = function(cmd, ignore_error)
  local res = vim.fn.system(vim.fn.shellescape(vim.fn.expand(cmd)))
  -- TODO: ignore_error only if expected EOF error returned
  local ret_code = vim.v.shell_error
  if string.len(res) > 0 and not ignore_error then output_error(res, ret_code) end
end

shell_command('~/bin/tmpred')

-- shell_command('echo -e "\\033[38;5;89mtesting one, two, three\\033[0m"')
