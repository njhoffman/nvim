--- Spell component.
--- Shows spell check status icon when enabled.
---@module "bars.components.spell"


local M = {}

---@type string
local icon = " SPELL"

--- Returns the spell status icon for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  if vim.wo[window].spell == true then
    return icon
  end

  return ""
end

return M
