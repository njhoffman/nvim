-- scroll.lua: Navigation commands with MiniAnimate scroll integration
local M = {}

---Check if MiniAnimate is available and enabled
---@return boolean
local function has_mini_animate()
  return type(MiniAnimate) == "table" and MiniAnimate.config and MiniAnimate.config.scroll
end

---Execute callback after scroll animation completes (or immediately if no MiniAnimate)
---@param callback function
local function after_scroll(callback)
  if has_mini_animate() then
    MiniAnimate.execute_after("scroll", function()
      vim.schedule(callback)
    end)
  else
    vim.schedule(callback)
  end
end

---Temporarily disable MiniAnimate scroll, run action, then re-enable
---@param action function
local function with_scroll_disabled(action)
  if has_mini_animate() then
    MiniAnimate.config.scroll.enable = false
    action()
    vim.schedule(function()
      MiniAnimate.config.scroll.enable = true
    end)
  else
    action()
  end
end

---Scroll to diagnostic with optional severity filter
---@param direction "next"|"prev"
---@param severity? string Severity name (e.g., "ERROR", "WARN")
function M.diag_scroll(direction, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  vim.diagnostic.jump({ count = (direction == "prev" and -1 or 1), severity = severity })
  after_scroll(function()
    vim.defer_fn(vim.diagnostic.open_float, 100)
  end)
end

---MiniJump2d with scroll animation temporarily disabled
function M.minijump_scroll()
  if type(MiniJump2d) ~= "table" then
    vim.notify("MiniJump2d not available", vim.log.levels.WARN)
    return
  end
  with_scroll_disabled(function()
    MiniJump2d.start()
  end)
end

---Scroll to search match
---@param direction "next"|"prev"
function M.search_scroll(direction)
  local ok, err = pcall(function()
    if direction == "prev" then
      vim.cmd("normal! N")
    else
      vim.cmd("normal! n")
    end
  end)

  if not ok then
    vim.notify(tostring(err), vim.log.levels.WARN)
    return
  end

  after_scroll(function()
    if require("hlslens") and require("hlslens").isEnabled() then
      vim.opt.hlsearch = true
    end
    -- Briefly highlight the match
    if vim.v.hlsearch == 1 then
      require("hlslens").start()
      vim.cmd("redraw")
    end
  end)
end

---Scroll through jumplist
---@param direction "next"|"prev"
function M.jump_scroll(direction)
  local ok, err = pcall(function()
    if direction == "prev" then
      vim.cmd("normal! 1\x0f") -- <C-o>
    else
      vim.cmd("normal! 1\x09") -- <C-i>
    end
  end)

  if not ok then
    vim.notify(tostring(err), vim.log.levels.WARN)
  end
end

---Scroll through changelist
---@param direction "next"|"prev"
function M.changes_scroll(direction)
  local ok, err = pcall(function()
    if direction == "prev" then
      vim.cmd("normal! g;")
    else
      vim.cmd("normal! g,")
    end
  end)

  if not ok then
    vim.notify(tostring(err), vim.log.levels.WARN)
  end
end

---Scroll to next/prev tag
---@param direction "next"|"prev"
function M.tag_scroll(direction)
  local ok, err = pcall(function()
    if direction == "prev" then
      vim.cmd("tprev")
    else
      vim.cmd("tnext")
    end
  end)

  if not ok then
    vim.notify(tostring(err), vim.log.levels.WARN)
  end
end

---Scroll to a specific position in a file or buffer
---@param opts {row: number, col?: number, file?: string, buf?: number}
function M.file_scroll(opts)
  if not opts or not opts.row then
    vim.notify("file_scroll requires at least a row", vim.log.levels.ERROR)
    return
  end

  local row = opts.row
  local col = opts.col or 0
  local target_buf = nil

  -- Determine target buffer
  if opts.file then
    -- Open the file if not already open
    local filepath = vim.fn.expand(opts.file)
    if vim.fn.filereadable(filepath) == 0 then
      vim.notify("File not found: " .. filepath, vim.log.levels.ERROR)
      return
    end

    -- Check if file is already in a buffer
    target_buf = vim.fn.bufnr(filepath)
    if target_buf == -1 then
      -- Open the file
      vim.cmd("edit " .. vim.fn.fnameescape(filepath))
      target_buf = vim.api.nvim_get_current_buf()
    else
      -- Switch to the buffer
      vim.api.nvim_set_current_buf(target_buf)
    end
  elseif opts.buf then
    if not vim.api.nvim_buf_is_valid(opts.buf) then
      vim.notify("Invalid buffer: " .. opts.buf, vim.log.levels.ERROR)
      return
    end
    vim.api.nvim_set_current_buf(opts.buf)
    target_buf = opts.buf
  else
    target_buf = vim.api.nvim_get_current_buf()
  end

  -- Validate row is within buffer bounds
  local line_count = vim.api.nvim_buf_line_count(target_buf)
  if row < 1 then
    row = 1
  elseif row > line_count then
    row = line_count
  end

  -- Validate col is within line bounds
  local line = vim.api.nvim_buf_get_lines(target_buf, row - 1, row, false)[1] or ""
  local max_col = #line
  if col < 0 then
    col = 0
  elseif col > max_col then
    col = max_col
  end

  -- Set cursor position
  vim.api.nvim_win_set_cursor(0, { row, col })

  -- Center the view
  vim.cmd("normal! zz")
end

---Scroll within a floating window
---@param move_step number Positive for down, negative for up
function M.float_scroll(move_step)
  local windows = vim.api.nvim_list_wins()
  for _, winid in ipairs(windows) do
    -- Float windows have relative set to something other than ''
    local win_config = vim.api.nvim_win_get_config(winid)
    local noice_cmdline_win = package.loaded["noice.ui.cmdline"]
      and require("noice.ui.cmdline").win()

    if win_config.relative ~= "" and winid ~= noice_cmdline_win then
      local bufid = vim.api.nvim_win_get_buf(winid)
      local max_line_num = vim.api.nvim_buf_line_count(bufid)
      local col_idx = vim.api.nvim_win_get_cursor(winid)[2]

      vim.dbglog(winid, win_config, vim.api.nvim_buf_get_name(bufid))
      if move_step < 0 then
        -- Upward moving
        local row_idx = vim.fn.getwininfo(winid)[1].topline
        if row_idx + move_step <= 0 then
          break
        end
        vim.api.nvim_win_set_cursor(winid, { row_idx + move_step, col_idx })
        break
      else
        -- Downward moving
        local row_idx = vim.fn.getwininfo(winid)[1].botline
        if row_idx + move_step > max_line_num then
          break
        end
        vim.dbglog("row_idx: " .. row_idx .. " max_line_num: " .. max_line_num, "bufid: " .. bufid)
        vim.api.nvim_win_set_cursor(winid, { row_idx + move_step, col_idx })
        break
      end
    end
  end
end

-- User Commands

local scroll_types = { "diag", "jump", "change", "tag", "search" }

vim.api.nvim_create_user_command("ScrollNext", function(opts)
  local scroll_type = opts.fargs[1]
  if not scroll_type then
    vim.notify(
      "ScrollNext requires a type: " .. table.concat(scroll_types, ", "),
      vim.log.levels.ERROR
    )
    return
  end

  if scroll_type == "diag" then
    M.diag_scroll("next", opts.fargs[2])
  elseif scroll_type == "jump" then
    M.jump_scroll("next")
  elseif scroll_type == "change" then
    M.changes_scroll("next")
  elseif scroll_type == "tag" then
    M.tag_scroll("next")
  elseif scroll_type == "search" then
    M.search_scroll("next")
  else
    vim.notify("Unknown scroll type: " .. scroll_type, vim.log.levels.ERROR)
  end
end, {
  nargs = "+",
  complete = function(arg_lead, cmd_line, cursor_pos)
    local args = vim.split(cmd_line, "%s+")
    if #args == 2 then
      return vim.tbl_filter(function(t)
        return t:find(arg_lead, 1, true) == 1
      end, scroll_types)
    elseif #args == 3 and args[2] == "diag" then
      local severities = { "ERROR", "WARN", "INFO", "HINT" }
      return vim.tbl_filter(function(s)
        return s:find(arg_lead, 1, true) == 1
      end, severities)
    end
    return {}
  end,
  desc = "Scroll to next item (diag, jump, change, tag, search)",
})

vim.api.nvim_create_user_command("ScrollPrev", function(opts)
  local scroll_type = opts.fargs[1]
  if not scroll_type then
    vim.notify(
      "ScrollPrev requires a type: " .. table.concat(scroll_types, ", "),
      vim.log.levels.ERROR
    )
    return
  end

  if scroll_type == "diag" then
    M.diag_scroll("prev", opts.fargs[2])
  elseif scroll_type == "jump" then
    M.jump_scroll("prev")
  elseif scroll_type == "change" then
    M.changes_scroll("prev")
  elseif scroll_type == "tag" then
    M.tag_scroll("prev")
  elseif scroll_type == "search" then
    M.search_scroll("prev")
  else
    vim.notify("Unknown scroll type: " .. scroll_type, vim.log.levels.ERROR)
  end
end, {
  nargs = "+",
  complete = function(arg_lead, cmd_line, cursor_pos)
    local args = vim.split(cmd_line, "%s+")
    if #args == 2 then
      return vim.tbl_filter(function(t)
        return t:find(arg_lead, 1, true) == 1
      end, scroll_types)
    elseif #args == 3 and args[2] == "diag" then
      local severities = { "ERROR", "WARN", "INFO", "HINT" }
      return vim.tbl_filter(function(s)
        return s:find(arg_lead, 1, true) == 1
      end, severities)
    end
    return {}
  end,
  desc = "Scroll to previous item (diag, jump, change, tag, search)",
})

vim.api.nvim_create_user_command("ScrollFile", function(opts)
  local row = tonumber(opts.fargs[1])
  if not row then
    vim.notify("ScrollFile requires at least a row number", vim.log.levels.ERROR)
    return
  end

  M.file_scroll({
    row = row,
    col = tonumber(opts.fargs[2]) or 0,
    file = opts.fargs[3],
  })
end, {
  nargs = "+",
  complete = "file",
  desc = "Scroll to position in file (row [col] [file])",
})

vim.api.nvim_create_user_command("ScrollFloat", function(opts)
  local step = tonumber(opts.fargs[1]) or 5
  M.float_scroll(step)
end, {
  nargs = "?",
  desc = "Scroll floating window by step (default: 5, negative for up)",
})

-- Keymaps

-- Changelist: g, (next) and g; (prev)
vim.keymap.set("n", "g,", "<Cmd>ScrollNext change<CR>", { desc = "Next change" })
vim.keymap.set("n", "g;", "<Cmd>ScrollPrev change<CR>", { desc = "Prev change" })

-- Jumplist: <C-i> (next) and <C-o> (prev)
vim.keymap.set("n", "<c-i>", "<c-i>", { desc = "Next jump" })
vim.keymap.set("n", "<C-i>", "<Cmd>ScrollNext jump<CR>", { desc = "Next jump" })
vim.keymap.set("n", "<C-o>", "<Cmd>ScrollPrev jump<CR>", { desc = "Prev jump" })

-- Search: n (next) and N (prev)
vim.keymap.set("n", "n", "<Cmd>ScrollNext search<CR>", { desc = "Next search match" })
vim.keymap.set("n", "N", "<Cmd>ScrollPrev search<CR>", { desc = "Prev search match" })

return M
