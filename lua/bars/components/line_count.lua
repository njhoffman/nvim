--- Line count component.
--- Shows total lines in normal mode, or visual selection info in visual mode.
---@module "bars.components.line_count"


local M = {}

---@type table<string, boolean>
local visual_modes = {
  ["v"] = true,
  ["vs"] = true,
  ["V"] = true,
  ["Vs"] = true,
  ["\22"] = true,
  ["\22s"] = true,
}

--- Returns the line count or visual selection info for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  ---|fS

  local mode = vim.fn.mode()

  if visual_modes[mode] then
    local ln_beg = vim.fn.line("v")
    local ln_end = vim.fn.line(".")
    local lines = math.abs(ln_end - ln_beg) + 1
    local wc = vim.fn.wordcount()
    local chars = wc.visual_chars or 0

    return string.format("%d %d", lines, chars)
  end

  return "%L"

  ---|fE
end

return M
