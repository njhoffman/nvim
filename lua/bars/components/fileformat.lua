--- File format component.
--- Shows file format (unix/dos/mac) with optional icons.
---@module "bars.components.fileformat"


local M = {}

---@type table<string, string>
local icons = {
  unix = "",
  dos = "",
  mac = "",
}

--- Returns the file format for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  local format = vim.bo[buffer].fileformat
  local icon = icons[format]

  if icon then
    return icon .. " " .. format
  end

  return format
end

return M
