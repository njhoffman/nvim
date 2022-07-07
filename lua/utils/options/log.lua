local vim = vim
local cmd = vim.cmd

local function msg(modl, message)
  if modl ~= nil then
    cmd('echo "[' .. modl .. "]: " .. message .. '"')
  else
    cmd('echo "' .. message .. '"')
  end
end

local M = {}
function M.error(modl, message)
  cmd([[echohl ErrorMsg]])
  cmd('echo "[' .. modl .. "]: " .. message .. '"')
  cmd([[echohl Normal]])
end

function M.warning(modl, message)
  cmd([[echohl WarningMsg]])
  cmd('echo "[' .. modl .. "]: " .. message .. '"')
  cmd([[echohl Normal]])
end

function M.log(modl, message)
  msg(modl, message)
end

function M.info(modl, message)
  cmd([[echohl ModeMsg]])
  msg(modl, message)
  cmd([[echohl Normal]])
end

function M.debug(modl, message)
  cmd([[echohl DebugMsg]])
  msg(modl, message)
  cmd([[echohl Normal]])
end

return M
