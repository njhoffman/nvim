local M = {}

local get_buf_var = function(name)
  local ok, val = pcall(vim.api.nvim_buf_get_var, 0, name)
  if ok then
    return val
  end
  return nil
end

function M.git_branch()
  return get_buf_var('gitsigns_head') or '', ' '
end

-- Common function used by the git providers
local function git_diff(type)
  local gsd = get_buf_var('gitsigns_status_dict')
  if gsd and gsd[type] and gsd[type] > 0 then
    return tostring(gsd[type])
  end
  return ''
end

--     󰐗 
function M.git_diff_added()
  return git_diff('added'), '  '
end

-- 󰛲  󰍵  󰍵
function M.git_diff_removed()
  return git_diff('removed'), '  '
end

-- 󰝤󰏬 󰎃 󰏭 
function M.git_diff_changed()
  return git_diff('changed'), '  '
end

-- Utility function to check if git provider information is available
function M.git_info_exists()
  return get_buf_var('gitsigns_head') or get_buf_var('gitsigns_status_dict')
end

return M
