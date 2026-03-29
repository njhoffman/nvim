--- Tabs component.
--- Shows tab page count when more than one tab is open.
---@module "bars.components.tabs"


local M = {}

---@type string
local icon = "󰓩 "

--- Returns the tab count for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  local count = #vim.api.nvim_list_tabpages()

  if count <= 1 then
    return ""
  end

  return icon .. tostring(count)
end

return M
