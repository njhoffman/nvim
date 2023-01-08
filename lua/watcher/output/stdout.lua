local cmd = vim.cmd

local stdout_msg = function(modl, message)
  if modl ~= nil then
    cmd('echo "[' .. modl .. "]: " .. message .. '"')
  else
    cmd('echo "' .. message .. '"')
  end
end

local stdout = {}
stdout.error = function(modl, message)
  cmd([[echohl ErrorMsg]])
  stdout_msg(modl, message)
  cmd([[echohl Normal]])
end

stdout.warn = function(modl, message)
  cmd([[echohl WarningMsg]])
  stdout_msg(modl, message)
  cmd([[echohl Normal]])
end

stdout.info = function(modl, message)
  cmd([[echohl ModeMsg]])
  stdout_msg(modl, message)
  cmd([[echohl Normal]])
end

stdout.debug = function(modl, message)
  cmd([[echohl DebugMsg]])
  stdout_msg(modl, message)
  cmd([[echohl Normal]])
end

stdout.trace = function(modl, message)
  stdout_msg(modl, message)
end

return {
  handle_log = stdout,
}
