--- DAP component.
--- Shows debug session status when active.
---@module "bars.components.dap"


local M = {}

---@type string
local icon = " "

--- Returns the DAP session status for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  if not package.loaded["dap"] then
    return ""
  end

  local session = require("dap").session()

  if not session then
    return ""
  end

  local status = require("dap").status()

  if status and status ~= "" then
    return icon .. status
  end

  return icon .. "Active"
end

return M
