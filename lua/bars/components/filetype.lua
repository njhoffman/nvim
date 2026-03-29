--- Filetype component.
--- Shows lowercase filetype name.
---@module "bars.components.filetype"


local M = {}

--- Returns the filetype for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  return vim.bo[buffer].filetype:lower()
end

return M
