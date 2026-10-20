local state = require("telescope._extensions.frecency.state")
local uv = vim.uv

local util = {}

-- stolen from penlight

-- escape any Lua 'magic' characters in a string
util.escape = function(str)
  return (str:gsub("[%-%.%+%[%]%(%)%$%^%%%?%*]", "%%%1"))
end

util.filemask = function(mask)
  mask = util.escape(mask)
  return "^" .. mask:gsub("%%%*", ".*"):gsub("%%%?", ".") .. "$"
end

util.filename_match = function(filename, pattern)
  return filename:find(util.filemask(pattern)) ~= nil
end

--

util.string_isempty = function(str)
  return str == nil or str == ""
end

util.split = function(str, delimiter)
  local result = {}
  for match in str:gmatch("[^" .. delimiter .. "]+") do
    table.insert(result, match)
  end
  return result
end

util.fs_stat = function(path)
  local stat = uv.fs_stat(path)
  local res = {}
  res.exists = stat and true or false -- TODO: this is silly
  res.isdirectory = (stat and stat.type == "directory") and true or false

  return res
end

-- returns `true` if workspaces exist
---@param bufnr number
---@param force? boolean
---@return boolean workspaces_exist
util.fetch_lsp_workspaces = function(bufnr, force)
  if not vim.tbl_isempty(state.lsp_workspaces) and not force then
    return true
  end

  local lsp_workspaces = vim.api.nvim_buf_call(bufnr, vim.lsp.buf.list_workspace_folders)
  if not vim.tbl_isempty(lsp_workspaces) then
    state.lsp_workspaces = lsp_workspaces
    return true
  end

  state.lsp_workspaces = {}
  return false
end

util.get_workspace_tags = function()
  -- Add user config workspaces. TODO: validate that workspaces are existing directories
  local tags = {}
  for k, _ in pairs(state.user_workspaces) do
    table.insert(tags, k)
  end

  -- Add CWD filter
  table.insert(tags, "CWD")

  -- Add LSP workpace(s)
  if util.fetch_lsp_workspaces(state.previous_buffer, true) then
    table.insert(tags, "LSP")
  end

  -- print(vim.inspect(tags))
  -- TODO: sort tags - by collective frecency?
  return tags
end

return util
