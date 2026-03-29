--- Noice mode component.
--- Shows noice cmdline mode status with vi_mode-derived highlight.
---@module "bars.components.noice_mode"

local M = {}

local function set_hl(group)
  if type(group) ~= "string" or group == "" then
    return ""
  end
  return string.format("%%#%s#", group)
end

---@type table<string, string>
local mode_highlights = {
  ["n"] = "BarsNormal",
  ["i"] = "BarsInsert",
  ["v"] = "BarsVisual",
  ["V"] = "BarsVisualLine",
  ["\22"] = "BarsVisualBlock",
  ["c"] = "BarsCommand",
  ["R"] = "BarsInsert",
  ["t"] = "BarsNormal",
}

--- Returns the noice mode text for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  ---|fS

  if not package.loaded["noice"] then
    return ""
  end

  local status = require("noice").api.status.mode

  if not status.has() then
    return ""
  end

  local mode_text = status.get()

  if not mode_text or mode_text == "" then
    return ""
  end

  local current_mode = vim.api.nvim_get_mode().mode
  local hl = mode_highlights[current_mode] or mode_highlights["n"]

  return set_hl(hl) .. mode_text

  ---|fE
end

return M
