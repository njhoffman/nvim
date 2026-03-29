--- File size component.
--- Shows human-readable file size (b, k, M, G).
---@module "bars.components.file_size"


local M = {}

---@type string[]
local suffixes = { "b", "k", "M", "G" }

--- Returns the human-readable file size for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  ---|fS

  local name = vim.api.nvim_buf_get_name(buffer)

  if name == "" then
    return ""
  end

  local size = vim.fn.getfsize(name)

  if size <= 0 then
    return ""
  end

  local i = 1

  while size >= 1024 and i < #suffixes do
    size = size / 1024
    i = i + 1
  end

  if size >= 10 then
    return string.format("%.0f%s", size, suffixes[i])
  else
    return string.format("%.2f%s", size, suffixes[i])
  end

  ---|fE
end

return M
