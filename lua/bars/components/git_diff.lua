--- Git diff component.
--- Shows git diff counts for added, changed, and removed lines.
---@module "bars.components.git_diff"


local M = {}

--- Returns the diff count for a given type.
---@param buffer integer
---@param diff_type string
---@param icon string
---@return string
local function get_diff(buffer, diff_type, icon)
  ---|fS

  local gsd = vim.b[buffer].gitsigns_status_dict

  if not gsd or not gsd[diff_type] or gsd[diff_type] == 0 then
    return ""
  end

  return icon .. tostring(gsd[diff_type])

  ---|fE
end

--- Returns the added lines count for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.added = function(buffer, window)
  return get_diff(buffer, "added", " ")
end

--- Returns the changed lines count for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.changed = function(buffer, window)
  return get_diff(buffer, "changed", " ")
end

--- Returns the removed lines count for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.removed = function(buffer, window)
  return get_diff(buffer, "removed", " ")
end

return M
