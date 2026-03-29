--- Hostname component.
--- Shows system hostname.
---@module "bars.components.hostname"


local M = {}

--- Returns the system hostname for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  return vim.uv.os_gethostname() or ""
end

return M
