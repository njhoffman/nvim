local state = require("histories.state")
local utils = require("histories.utils")

local ns = vim.api.nvim_create_namespace("selects")

local get_hash = function(vis)
  return vim.fn.sha256(vim.fn.json_encode(vis))
end

local get_pos = function(from, to)
  -- '< '>  	select: To the first line or character of the last selected Visual area in the current buffer.
  -- '[ ']  	operator: To the first/last character of the previously changed or yanked text.
  -- ''  ``		jump: To the position before the latest jump, or where the last "m'" or "m`" command was given
  -- '^ `^		insert: To the position where the cursor was the last time when Insert mode was stopped.
  -- '" `"		restore: To the cursor position when last exiting the current buffer
  -- '. `.		change: To the position where the last change was made.
  -- bufnum, lnum, coln, offset (if virtualedit is used)
  local get_pos_line = function(mark)
    local pos = vim.fn.getpos(mark)
    local line_length = string.len(vim.api.nvim_buf_get_lines(pos[1], pos[2] - 1, pos[2], false)[1])
    table.insert(pos, line_length)
    return pos
  end
  return to == nil and get_pos_line(from) or { from = get_pos_line(from), to = get_pos_line(to) }
end

local get_select_pos = function(buf, mode)
  local pos = get_pos("'<", "'>")
  local curr = {
    buffer = buf,
    mode = mode,
    type = "v-" .. (mode == "\22" and "block" or mode == "V" and "line" or "char"),
    pos = pos,
  }
  -- curr.pos.to[3] = curr.pos.to[3] == vim.v.maxcol and -1 or curr.pos.to[3]
  local hash = get_hash(curr.pos)
  return curr, hash
end

local log = function()
  for i, vis in ipairs(state.selects) do
    -- local timeago = vim.fn.strftime('%c', vis.time)
    local time_ago = os.difftime(os.time(), vis.time) + 1 .. "s"
    if vis.to[3] == 2147483647 then
      vis.to[3] = "end"
    end
    vim.dbglog(
      utils.align_text(#state.selects - i + 1, 3, "right"),
      utils.align_text(time_ago, 4, "right"),
      vis.type,
      utils.align_text(vis.from[2], 3, "right")
        .. ":"
        .. utils.align_text(vis.from[3], 3, "left")
        .. " "
        .. utils.align_text(vis.to[2], 3, "right")
        .. ":"
        .. utils.align_text(vis.to[3], 10, "left"),
      vim.fn.substitute(vis.name, vim.fn.getcwd() .. "/", "", "g")
    )
  end
end

local select_range = function(range, mode)
  local bufnr, start_row, start_col, end_row, end_col = table.unpack(range)
  start_row = start_row + 1
  start_col = start_col + 1
  end_row = end_row + 1
  end_col = end_col + 1
  mode = mode or "v"
  vim.fn.setpos(".", { bufnr, start_row, start_col, 0 })
  vim.cmd("normal! " .. mode, true, true, true)
  vim.fn.setpos(".", { bufnr, end_row, end_col - 1, 0 })
end

local create_mark = function(pos)
  -- let g:mark_id = nvim_buf_set_extmark(0, g:mark_ns, 0, 2, {})
  local end_line_length =
    vim.api.nvim_buf_get_lines(pos.to[1], pos.to[2] - 1, pos.to[2], false)[1]:len()
  local end_col = pos.to[3] == vim.v.maxcol and end_line_length or pos.to[3]

  local mark = vim.api.nvim_buf_set_extmark(pos.from[1], ns, pos.from[2] - 1, pos.from[3], {
    -- hl_group = "VisualRed",
    end_row = pos.to[2] - 1,
    end_col = end_col,
  })
  return mark
end

local get_mark_range = function(mark_id, buf)
  local mark = vim.api.nvim_buf_get_extmark_by_id(buf or 0, ns, mark_id, { details = true })
  return { buf, mark[1], mark[2], mark[3].end_row, mark[3].end_col }
end

return {
  log = log,
  create_mark = create_mark,
  get_mark_range = get_mark_range,
  select_range = select_range,
  get_select_pos = get_select_pos,
}
