--- Encoding component.
--- Shows file encoding only when non-UTF-8.
---@module "bars.components.encoding"


local M = {}

--- Returns the file encoding for the statusline, empty when UTF-8.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  local enc = vim.bo[buffer].fileencoding

  if enc == "" then
    enc = vim.o.encoding
  end

  if enc == "" or enc == "utf-8" then
    return ""
  end

  return enc
end

return M
