local utils = require("histories.utils")
local state = require("histories.state")
local notify = require("notify")

local default_highlights = {
  header = "Title",
  body = "Normal",
  curr = "CursorLine",
  icon = "Special",
  number = "Number",
  string = "String",
}

local truncate_changes = function(changes, curr_idx, opts)
  local lines_before = opts.notify and opts.notify.lines_before or 8
  local lines_after = opts.notify and opts.notify.lines_after or 3
  local start = curr_idx - lines_before + 1
  local finish = curr_idx + lines_after
  start = start > 0 and start or 1
  finish = finish < #changes and finish or #changes
  local new_changes = {}
  for i = start, finish do
    table.insert(new_changes, changes[i])
  end
  return new_changes
end

local notify_handler = function(changes, curr_idx, opts)
  local timeout = false
  if curr_idx < 1 then
    if type(state.notify_wid) == "number" and vim.api.nvim_win_is_valid(state.notify_wid) then
      -- timeout = 1
      vim.api.nvim_win_close(state.notify_wid, true)
    end
    return
  end

  changes = truncate_changes(changes, curr_idx, opts)

  local hls = default_highlights
  local rows = {}

  for i, change in ipairs(changes) do
    local line = vim.api.nvim_buf_get_lines(0, change.lnum - 1, change.lnum, false)[1]
    local text = vim.trim(line and line:sub(change.col + 1, change.col + 20) or "")
    table.insert(rows, {
      { change.curr and "" or " ", hls.icon },
      { tostring(change.idx), hls.number },
      { tostring(change.lnum), hls.number },
      { tostring(change.col), hls.number },
      { text, hls.string },
    })
  end

  local lines, highlights = utils.build_highlight_table(vim.fn.reverse(rows), {
    headers = { "", "change", "line", "col", "text" },
    align = { "center", "center", "center", "center", nil },
  })

  local notif = notify(lines, 3, {
    timeout = timeout,
    on_close = function()
      state.notify_id = nil
      state.notify_wid = nil
    end,
    on_open = function(wid)
      state.notify_wid = wid
    end,
    on_replace = function(wid)
      -- TODO: create notify event for animation completing
      vim.defer_fn(function()
        if vim.api.nvim_win_is_valid(wid) then
          local bufnr = vim.api.nvim_win_get_buf(wid)
          local total_lines = vim.api.nvim_buf_line_count(bufnr)
          local win_height = vim.api.nvim_win_get_height(wid)
          if total_lines > win_height then
            vim.dbglog("scroll", total_lines)
            vim.api.nvim_win_set_cursor(wid, { total_lines, 0 })
          end
        end
      end, 200)
    end,
    replace = state.notify_id,
    highlights = { body = highlights },
  })
  state.notify_id = notif.id
end

local load = function(changes, curr_idx, opts)
  if curr_idx >= 0 then
    notify_handler(changes, curr_idx, opts)
  end
end

return { load = load }
