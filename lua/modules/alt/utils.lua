local M = {}

---@param msg string
---@param level? "info"|"trace"|"debug"|"warn"|"error"
function M.notify(msg, level)
  if not level then
    level = "info"
  end
  local pluginName = "alt-alt"
  vim.notify(msg, vim.log.levels[level:upper()], { title = pluginName })
end

function M.set_alternate_buffe(buffer_a, buffer_b)
  vim.api.nvim_set_current_buf(buffer_a)
  vim.api.nvim_set_current_buf(buffer_b)
end

--------------------------------------------------------------------------------

---count number of windows, excluding various special windows (scrollbars,
---notification windows, etc)
---@nodiscard
---@return number
function M.numberOfWins()
  local count = 0
  local wins = vim.api.nvim_list_wins()
  for _, win in pairs(wins) do
    local winConf = vim.api.nvim_win_get_config(win)
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))

    if
      bufname
      and bufname ~= ""
      and not winConf.external
      and winConf.focusable
      and vim.api.nvim_win_is_valid(win)
    then
      count = count + 1
    end
  end
  return count
end

---get the alternate oldfile, accounting for non-existing files etc.
---@nodiscard
---@return string|nil path of oldfile, nil if none exists in all oldfiles
function M.altOldfile()
  local oldfile
  local i = 0
  repeat
    i = i + 1
    if i > #vim.v.oldfiles then
      return nil
    end
    oldfile = vim.v.oldfiles[i]
    local fileExists = vim.uv.fs_stat(oldfile) ~= nil
    local isCurrentFile = oldfile == vim.fn.expand("%:p")
    local commitMsg = oldfile:find("COMMIT_EDITMSG$")
  until fileExists and not commitMsg and not isCurrentFile
  return oldfile
end

function M.formatPath(path)
  return path:gsub("^" .. vim.env.HOME, "~")
end

return M
