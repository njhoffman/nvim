-- QuickClose command - Smart buffer/window closing logic
local M = {}

-- Special splits configuration
local special_splits = {
  { buftype = "quickfix" },
  { buftype = "help" },
  { filetype = "neo-tree" },
  { filetype = "noice" },
  { filetype = "CodeCompanion" },
  { filetype = "Avante.*" }, -- Regex pattern
}

-- Check if a window matches any special split criteria
local function is_special_split(winid)
  local bufnr = vim.api.nvim_win_get_buf(winid)
  local buftype = vim.bo[bufnr].buftype
  local filetype = vim.bo[bufnr].filetype

  for _, criteria in ipairs(special_splits) do
    -- Check buftype match
    if criteria.buftype and buftype == criteria.buftype then
      return true
    end

    -- Check filetype match (with regex support)
    if criteria.filetype then
      if filetype:match("^" .. criteria.filetype .. "$") then
        return true
      end
    end
  end

  return false
end

-- Get number of windows in current tab (excluding floating windows)
local function get_split_count()
  local count = 0
  for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local config = vim.api.nvim_win_get_config(winid)
    if config.relative == "" then -- Not floating
      count = count + 1
    end
  end
  return count
end

-- Check if current window is floating
local function is_floating_window()
  local config = vim.api.nvim_win_get_config(0)
  return config.relative ~= ""
end

-- Get all window IDs in current tab (excluding floating)
local function get_all_windows()
  local wins = {}
  for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local config = vim.api.nvim_win_get_config(winid)
    if config.relative == "" then -- Not floating
      table.insert(wins, winid)
    end
  end
  return wins
end

-- Find special split window (if any)
local function find_special_split_window()
  local windows = get_all_windows()
  local current_win = vim.api.nvim_get_current_win()

  for _, winid in ipairs(windows) do
    if winid ~= current_win and is_special_split(winid) then
      return winid
    end
  end

  return nil
end

-- Count total number of listed buffers
local function count_listed_buffers()
  local count = 0
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[bufnr].buflisted then
      count = count + 1
    end
  end
  return count
end

-- Main QuickClose logic
function M.quick_close()
  local current_win = vim.api.nvim_get_current_win()

  -- Case 1: If current window is floating, just close it
  if is_floating_window() then
    vim.api.nvim_win_close(current_win, false)
    return
  end

  local split_count = get_split_count()

  -- Case 2: Window has splits
  if split_count > 1 then
    -- Check if current window is a special split
    if is_special_split(current_win) then
      vim.api.nvim_win_close(current_win, false)
      return
    end

    -- Check if any other window is a special split
    local special_win = find_special_split_window()
    if special_win then
      vim.api.nvim_win_close(special_win, false)
      return
    end

    -- No special splits found, close current window
    vim.api.nvim_win_close(current_win, false)
    return
  end

  -- Case 3: Last window - delete buffer instead of closing window
  local buf_count = count_listed_buffers()

  if buf_count > 1 then
    -- Delete the buffer but keep the window
    vim.cmd("bdelete")
  else
    -- Last buffer and last window - show Alpha startup screen
    local alpha_ok, _ = pcall(vim.cmd, "Alpha")
    if not alpha_ok then
      -- Fallback if Alpha is not available
      vim.cmd("enew")
    end
  end
end

-- Setup command
function M.setup()
  vim.api.nvim_create_user_command("QuickClose", function()
    M.quick_close()
  end, {
    desc = "Smart close: close window, special split, or delete buffer",
  })
end

return M
