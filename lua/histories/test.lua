local state = require("histories.state")

local align_text = function(text, width, type)
  local left, right = 0, 0
  local len = vim.fn.strwidth(text)
  if type == "right" then
    left = width - len
  elseif type == "center" then
    left = math.floor((width - len) / 2)
    right = math.ceil((width - len) / 2)
  else
    right = width - len
  end
  return string.rep(" ", left) .. text .. string.rep(" ", right), { left, len }
end

local build_highlight_table = function(rows, opts)
  opts = opts or {}
  opts.padding = opts.padding or 2
  if opts.headers then
    local header_row = {}
    for i, header in ipairs(opts.headers) do
      table.insert(header_row, { header, "Title" })
    end
    table.insert(rows, 1, header_row)
  end

  local colwidths = {}
  for _, row in ipairs(rows) do
    for i, item in ipairs(row) do
      local width = colwidths[i] or 0
      colwidths[i] = math.max(width, vim.fn.strwidth(item[1] or ""))
    end
  end

  local lines, highlights = {}, {}
  for _, row in ipairs(rows) do
    local line = ""
    for i, item in ipairs(row) do
      local text, pos = align_text(item[1], colwidths[i] + opts.padding, opts.align[i])
      local start = #line + pos[1]
      local finish = start + pos[2]
      table.insert(highlights, { item[2], #lines, start, finish })
      line = line .. text
    end
    table.insert(lines, line)
  end
  return lines, highlights
end

local notify_handler = function(changes, curr_idx, opts)
  opts = opts or {}
  local lines_before = opts.notify and opts.notify.lines_before or 6
  local lines_after = opts.notify and opts.notify.lines_after or 2

  local default_highlights = {
    header = "Title",
    body = "Normal",
    curr = "CursorLine",
    icon = "Special",
    number = "Number",
    string = "String",
  }

  local hls = default_highlights
  local rows = {}

  for _, change in ipairs(changes) do
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

  local lines, highlights = build_highlight_table(vim.fn.reverse(rows), {
    headers = { "", "change", "line", "col", "text" },
    align = { "center", "center", "center", "center", nil },
  })

  local notif = require("notify")(lines, 3, {
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

local changes = {
  [1] = { col = 0, coladd = 0, idx = 1, lnum = 30 },
  [2] = { col = 0, coladd = 0, idx = 2, lnum = 21 },
  [3] = { col = 0, coladd = 0, idx = 3, lnum = 20 },
  [4] = { col = 21, coladd = 0, idx = 4, lnum = 81 },
  [5] = { col = 6, coladd = 0, idx = 5, lnum = 88, curr = true },
  [6] = { col = 27, coladd = 0, idx = 6, lnum = 87 },
  [7] = { col = 0, coladd = 0, idx = 7, lnum = 62 },
  [8] = { col = 6, coladd = 0, idx = 8, lnum = 61 },
  [9] = { col = 0, coladd = 0, idx = 9, lnum = 49 },
  [10] = { col = 0, coladd = 0, idx = 10, lnum = 63 },
  [11] = { col = 0, coladd = 0, idx = 11, lnum = 49 },
  [12] = { col = 0, coladd = 0, idx = 12, lnum = 69 },
}

notify_handler(changes, 5)
