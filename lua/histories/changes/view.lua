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
  if curr_idx > lines_before then
    local start = curr_idx - lines_before
    local finish = curr_idx + lines_after
    local new_changes = {}
    for i = start, finish do
      table.insert(new_changes, changes[i])
    end
    return new_changes
  end
  return changes
end

local notify_handler = function(changes, curr_idx, opts)
  changes = truncate_changes(changes, curr_idx, opts)

  local hls = default_highlights
  local rows = {}

  for i, change in ipairs(changes) do
    local line = vim.api.nvim_buf_get_lines(0, change.lnum - 1, change.lnum, false)[1]
    local text = line and line:sub(change.col + 1, change.col + 20) or ""
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
    timeout = false,
    on_close = function()
      state.notify_id = nil
      state.notify_wid = nil
    end,
    on_open = function(wid)
      state.notify_wid = wid
    end,
    replace = state.notify_id,
    highlights = { body = highlights },
  })
  state.notify_id = notif.id
end

return { notify_handler = notify_handler }
