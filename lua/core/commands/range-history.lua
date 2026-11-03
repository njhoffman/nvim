-- Range History: Track visual selections and paste operations with navigation
-- gv: jump to previous recorded range
-- gV: jump to next recorded range

local M = {}

-- Configuration
local MAX_HISTORY = 10

-- State
local history = {} -- List of {bufnr, start_line, start_col, end_line, end_col, type}
local current_index = 0 -- 0 means not navigating, 1 = most recent, etc.

-- Helper: Get buffer-local history (filter by current buffer)
local function get_buffer_history(bufnr)
  local buf_history = {}
  for i, entry in ipairs(history) do
    if entry.bufnr == bufnr and vim.api.nvim_buf_is_valid(entry.bufnr) then
      buf_history[#buf_history + 1] = { index = i, entry = entry }
    end
  end
  return buf_history
end

-- Helper: Add a range to history
local function add_to_history(bufnr, start_line, start_col, end_line, end_col, range_type)
  -- Don't add if identical to the most recent entry
  if #history > 0 then
    local last = history[1]
    if
      last.bufnr == bufnr
      and last.start_line == start_line
      and last.start_col == start_col
      and last.end_line == end_line
      and last.end_col == end_col
    then
      return
    end
  end

  -- Add to front of history
  table.insert(history, 1, {
    bufnr = bufnr,
    start_line = start_line,
    start_col = start_col,
    end_line = end_line,
    end_col = end_col,
    type = range_type,
  })

  -- Trim history to max size
  while #history > MAX_HISTORY do
    table.remove(history)
  end

  -- Reset navigation index when new entry is added
  current_index = 0
end

-- Record visual selection when leaving visual mode
local function record_visual_selection()
  local bufnr = vim.api.nvim_get_current_buf()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  -- getpos returns {bufnr, line, col, off}
  local start_line, start_col = start_pos[2], start_pos[3]
  local end_line, end_col = end_pos[2], end_pos[3]

  -- Validate positions
  if start_line > 0 and end_line > 0 then
    add_to_history(bufnr, start_line, start_col, end_line, end_col, "visual")
  end
end

-- Record paste operation using '[ and '] marks
local function record_paste_range()
  local bufnr = vim.api.nvim_get_current_buf()
  local start_pos = vim.fn.getpos("'[")
  local end_pos = vim.fn.getpos("']")

  local start_line, start_col = start_pos[2], start_pos[3]
  local end_line, end_col = end_pos[2], end_pos[3]

  -- Validate positions
  if start_line > 0 and end_line > 0 then
    add_to_history(bufnr, start_line, start_col, end_line, end_col, "paste")
  end
end

-- Select a range from history
local function select_range(entry)
  if not vim.api.nvim_buf_is_valid(entry.bufnr) then
    return false
  end

  -- Switch to buffer if needed
  if vim.api.nvim_get_current_buf() ~= entry.bufnr then
    vim.api.nvim_set_current_buf(entry.bufnr)
  end

  -- Get line count to validate
  local line_count = vim.api.nvim_buf_line_count(entry.bufnr)
  local start_line = math.min(entry.start_line, line_count)
  local end_line = math.min(entry.end_line, line_count)

  -- Get line lengths to validate columns
  local start_line_text = vim.api.nvim_buf_get_lines(entry.bufnr, start_line - 1, start_line, false)[1]
    or ""
  local end_line_text = vim.api.nvim_buf_get_lines(entry.bufnr, end_line - 1, end_line, false)[1]
    or ""
  local start_col = math.min(entry.start_col, #start_line_text + 1)
  local end_col = math.min(entry.end_col, #end_line_text + 1)

  -- Set the '< and '> marks
  vim.fn.setpos("'<", { entry.bufnr, start_line, start_col, 0 })
  vim.fn.setpos("'>", { entry.bufnr, end_line, end_col, 0 })

  -- Enter visual mode and select the range
  vim.cmd("normal! `<v`>")

  return true
end

-- Navigate to previous range (older in history)
function M.prev_range()
  if #history == 0 then
    vim.notify("No range history", vim.log.levels.INFO)
    return
  end

  -- Move to next older entry
  current_index = current_index + 1
  if current_index > #history then
    current_index = #history
    vim.notify("At oldest range", vim.log.levels.INFO)
  end

  local entry = history[current_index]
  if entry then
    if not select_range(entry) then
      -- Entry invalid, try next
      table.remove(history, current_index)
      current_index = current_index - 1
      M.prev_range()
      return
    end
    vim.notify(
      string.format("Range %d/%d (%s)", current_index, #history, entry.type),
      vim.log.levels.INFO
    )
  end
end

-- Navigate to next range (newer in history)
function M.next_range()
  if #history == 0 then
    vim.notify("No range history", vim.log.levels.INFO)
    return
  end

  if current_index <= 1 then
    current_index = 0
    vim.notify("At newest range", vim.log.levels.INFO)
    return
  end

  -- Move to next newer entry
  current_index = current_index - 1

  local entry = history[current_index]
  if entry then
    if not select_range(entry) then
      -- Entry invalid, remove and try again
      table.remove(history, current_index)
      M.next_range()
      return
    end
    vim.notify(
      string.format("Range %d/%d (%s)", current_index, #history, entry.type),
      vim.log.levels.INFO
    )
  end
end

-- Show history for debugging
function M.show_history()
  if #history == 0 then
    vim.notify("No range history", vim.log.levels.INFO)
    return
  end

  local lines = { "Range History:" }
  for i, entry in ipairs(history) do
    local marker = (i == current_index) and " -> " or "    "
    local bufname = vim.api.nvim_buf_is_valid(entry.bufnr)
        and vim.fn.fnamemodify(vim.api.nvim_buf_get_name(entry.bufnr), ":t")
      or "[invalid]"
    lines[#lines + 1] = string.format(
      "%s%d. %s L%d:%d-L%d:%d (%s)",
      marker,
      i,
      bufname,
      entry.start_line,
      entry.start_col,
      entry.end_line,
      entry.end_col,
      entry.type
    )
  end
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

-- Clear history
function M.clear_history()
  history = {}
  current_index = 0
  vim.notify("Range history cleared", vim.log.levels.INFO)
end

-- Setup function
function M.setup(opts)
  opts = opts or {}
  MAX_HISTORY = opts.max_history or MAX_HISTORY

  local group = vim.api.nvim_create_augroup("RangeHistory", { clear = true })

  -- Track visual selections when leaving visual mode
  vim.api.nvim_create_autocmd("ModeChanged", {
    group = group,
    pattern = "[vV\x16]*:*", -- From any visual mode to any other mode
    callback = function()
      -- Defer to ensure '< and '> marks are set
      vim.schedule(record_visual_selection)
    end,
  })

  -- Create wrapper for paste commands to record paste ranges
  -- local paste_keys = { "p", "P", "]p", "[p", "]P", "[P" }
  -- for _, key in ipairs(paste_keys) do
  --   vim.keymap.set("n", key, function()
  --     -- Execute the paste
  --     local count = vim.v.count1
  --     vim.cmd("normal! " .. count .. key)
  --     -- Record the paste range after a small delay
  --     vim.schedule(record_paste_range)
  --   end, { desc = "Paste and record range" })
  -- end

  -- -- Setup keymaps
  -- vim.keymap.set({ "n", "x" }, "gv", function()
  --   -- If not currently navigating, record current visual selection first
  --   if current_index == 0 and vim.fn.mode():match("[vV\x16]") then
  --     record_visual_selection()
  --   end
  --   M.prev_range()
  -- end, { desc = "Previous range in history" })

  -- vim.keymap.set({ "n", "x" }, "gV", function()
  --   M.next_range()
  -- end, { desc = "Next range in history" })

  -- Commands
  vim.api.nvim_create_user_command("RangeHistory", M.show_history, { desc = "Show range history" })
  vim.api.nvim_create_user_command(
    "RangeHistoryClear",
    M.clear_history,
    { desc = "Clear range history" }
  )
end

return M
