--- Selection count component.
--- Shows visual selection character/line count.
---@module "bars.components.selection_count"


local M = {}

--- Returns the visual selection count for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  ---|fS

  local mode = vim.fn.mode()

  if mode == "v" then
    local wc = vim.fn.wordcount()
    local chars = wc.visual_chars or 0
    local bytes = wc.visual_bytes or 0
    local lines = math.abs(vim.fn.line("v") - vim.fn.line(".")) + 1

    local byte_suffix = ""
    if chars ~= bytes then
      byte_suffix = string.format("-%d", bytes)
    end

    local line_suffix = ""
    if lines > 1 then
      line_suffix = string.format(" / %d", lines)
    end

    return string.format("[%d%s%s]", chars, byte_suffix, line_suffix)
  elseif mode == "V" then
    local lines = math.abs(vim.fn.line("v") - vim.fn.line(".")) + 1
    return string.format("[%d]", lines)
  elseif mode == "\22" then
    local lines = math.abs(vim.fn.line("v") - vim.fn.line(".")) + 1
    local cols = math.abs(vim.fn.virtcol(".") - vim.fn.virtcol("v"))

    local line = cols >= 0 and vim.fn.getline("v") or vim.fn.getline(".")
    local col = cols >= 0 and (vim.fn.charcol("v") - 1) or (vim.fn.charcol(".") - 1)
    local char1width = vim.fn.strwidth(vim.fn.strcharpart(line, col, 1))

    return string.format("[%dx%d]", lines, math.abs(cols) + char1width)
  end

  return ""

  ---|fE
end

return M
