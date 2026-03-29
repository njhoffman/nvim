--- Working directory component.
--- Shows current working directory, truncated to a maximum length.
---@module "bars.components.workdir"


local M = {}

---@type integer
local default_max_len = 20

--- Returns the truncated working directory for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  ---|fS

  local cwd = vim.fn.getcwd()
  local home = os.getenv("HOME") or ""

  if home ~= "" then
    cwd = string.gsub(cwd, "^" .. vim.pesc(home), "~")
  end

  if vim.fn.strchars(cwd) > default_max_len then
    cwd = "..." .. vim.fn.strcharpart(cwd, vim.fn.strchars(cwd) - default_max_len + 3)
  end

  return cwd

  ---|fE
end

--- Creates a value function with a custom max length.
---@param max_len integer
---@return fun(buffer: integer, window: integer): string
M.with_max_len = function(max_len)
  return function(buffer, window)
    ---|fS

    local cwd = vim.fn.getcwd()
    local home = os.getenv("HOME") or ""

    if home ~= "" then
      cwd = string.gsub(cwd, "^" .. vim.pesc(home), "~")
    end

    if vim.fn.strchars(cwd) > max_len then
      cwd = "..." .. vim.fn.strcharpart(cwd, vim.fn.strchars(cwd) - max_len + 3)
    end

    return cwd

    ---|fE
  end
end

return M
