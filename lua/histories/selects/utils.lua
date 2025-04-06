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

-- local pos_are_equal = function(pos1, pos2)
--   local get_line = function(pos)
--     return vim.api.nvim_buf_get_lines(pos.buffer, pos[2] - 1, pos[2], false)[1]
--   end
--   if pos1.from and pos2.from then
--     local lengths = {
--       pos1 = { #get_line(pos1.from), #get_line(pos1.to) },
--       pos2 = { #get_line(pos2.from), #get_line(pos2.to) },
--     }
--     pos1.from[2] == pos2.from[2] and pos1.to[3] == pos2.to[3]
--   else
--     local lengths = { pos1 = #get_line(pos1), pos2 = #get_line(pos2) }
--   end
-- end

local get_change_pos = function(buf, mode)
  local pos = { op = get_pos("'[", "']"), select = get_pos("'<", "'>"), change = get_pos("'.") }
  local type = "change"
  if tostring(pos.op) == tostring(pos.select) then
    type = "yank"
  elseif tostring(pos.change) == tostring(pos.op.from) then
    type = "paste"
  end
  local curr = {
    buffer = buf,
    mode = mode,
    type = type,
    pos = pos.op,
  }
  local hash = get_hash(curr.pos)
  return curr, hash
end

local get_select_pos = function(buf, mode)
  local curr = {
    buffer = buf,
    mode = mode,
    type = "v-" .. (mode == "\22" and "block" or mode == "V" and "line" or "char"),
    select = get_pos("'<", "'>"),
    op = get_pos("'[", "']"),
    change = get_pos("'."),
  }
  -- curr.pos.to[3] = curr.pos.to[3] == vim.v.maxcol and -1 or curr.pos.to[3]
  local hash = get_hash(curr.pos)
  return curr, hash
end

local has_valid_range = function(vis)
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local from_line = vis.from[2]
  local to_line = vis.to[2]
  local buf = vim.api.nvim_buf_get_lines(bufnr, from_line - 1, to_line, true)
  return #buf > 0 and vis.name == bufname
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
  -- local extmarks = vim.api.nvim_buf_get_extmarks(buf, ns, 0, -1, {
  --   -- type = 'highlight', -- highlight, sign, virt_text, virt_lines
  --   details = true,
  --   hl_name = true,
  -- })
end

return {
  log = log,
  has_valid_range = has_valid_range,
  get_select_pos = get_select_pos,
  get_change_pos = get_change_pos,
}
