local state = require("histories.state")
local utils = require("histories.utils")

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

return {
  log = log,
  get_select_pos = get_select_pos,
}
