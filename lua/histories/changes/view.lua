local utils = require('histories.utils')
local state = require('histories.state')
local notify = require('notify')

local default_highlights = {
  header = 'Title',
  body = 'Normal',
  curr = 'CursorLine',
  icon = 'Special',
  number = 'Number',
  string = 'String',
}

local get_dimensions = function(lines, wid)
  local msg_width = 0
  for i, msg in ipairs(lines) do
    msg_width = math.max(msg_width, #msg)
  end
  return {
    from = {
      width = vim.api.nvim_win_get_width(wid),
      height = vim.api.nvim_win_get_height(wid),
    },
    to = {
      width = msg_width + 2,
      height = #lines,
    },
  }
end

local function resize_window(wid, sizes)
  local from = sizes.from
  local to = sizes.to
  vim.defer_fn(function()
    local inc = {
      w = to.width > from.width and 1 or to.width < from.width and -1 or 0,
      h = to.height > from.height and 1 or to.height < from.height and -1 or 0,
    }
    from.width = from.width + inc.w
    from.height = from.height + inc.h
    vim.api.nvim_win_set_width(wid, from.width)
    vim.api.nvim_win_set_height(wid, from.height)
    if from.width ~= to.width or from.height ~= to.height and vim.api.nvim_win_is_valid(wid) then
      resize_window(wid, sizes)
    end
  end, 5)
end

local notify_handler = function(changes)
  local hls = default_highlights
  local rows = {}

  for i, change in ipairs(changes) do
    local line = vim.api.nvim_buf_get_lines(0, change.lnum - 1, change.lnum, false)[1]
    local text = line and line:sub(change.col + 1, change.col + 20) or ''
    table.insert(rows, {
      { change.curr and '' or ' ', hls.icon },
      { tostring(change.idx), hls.number },
      { tostring(change.lnum), hls.number },
      { tostring(change.col), hls.number },
      { text, hls.string },
    })
  end

  local lines, highlights = utils.build_highlight_table(vim.fn.reverse(rows), {
    headers = { '', 'change', 'line', 'col', 'text' },
    align = { 'center', 'center', 'center', 'center', nil },
  })

  if state.notify_wid and vim.api.nvim_win_is_valid(state.notify_wid) then
    local sizes = get_dimensions(lines, state.notify_wid)
    resize_window(state.notify_wid, sizes)
  end
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

local load = function(changes)
  notify_handler(changes)
end

return { load = load }
