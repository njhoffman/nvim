--- Search count component.
--- Shows search result position as [current/total].
---@module "bars.components.search_count"


local M = {}

--- Returns the search count for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  local ok, result = pcall(vim.fn.searchcount)

  if not ok or type(result) ~= "table" then
    return ""
  end

  local total = result.total or 0
  local current = result.current or 0

  if total == 0 then
    return ""
  end

  return string.format("[%d/%d]", current, total)
end

return M
