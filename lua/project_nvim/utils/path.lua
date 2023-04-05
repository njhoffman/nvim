local config = require("project_nvim.config")
local uv = vim.loop
local M = {}

M.datapath = vim.fn.stdpath("data") -- directory
M.projectpath = M.datapath .. "/project_nvim" -- directory
M.historyfile = M.projectpath .. "/project_history" -- file

function M.init()
  M.datapath = require("project_nvim.config").options.datapath
  M.projectpath = M.datapath .. "/project_nvim" -- directory
  M.historyfile = M.projectpath .. "/project_history" -- file
end

function M.is_file()
  local buf_type = vim.api.nvim_buf_get_option(0, "buftype")

  local whitelisted_buf_type = { "", "acwrite" }
  local is_in_whitelist = false
  for _, wtype in ipairs(whitelisted_buf_type) do
    if buf_type == wtype then
      is_in_whitelist = true
      break
    end
  end
  if not is_in_whitelist then
    return false
  end

  return true
end

function M.create_scaffolding(callback)
  if callback ~= nil then -- async
    uv.fs_mkdir(M.projectpath, 448, callback)
  else -- sync
    uv.fs_mkdir(M.projectpath, 448)
  end
end

function M.is_excluded(dir)
  for _, dir_pattern in ipairs(config.options.exclude_dirs) do
    if dir:match(dir_pattern) ~= nil then
      return true
    end
  end

  return false
end

return M
