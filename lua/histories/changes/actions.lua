local state = require("histories.state")
local change_pos = function(item)
  vim.fn.setpos(".", { 0, item.lnum, item.col, item.coladd })
  vim.fn.setpos(".", { 0, item.lnum, item.col, item.coladd })
end

local next = function()
  local new_idx = (state.curr_idx or 0) + 1
  if state.changes[new_idx] then
    change_pos(state.changes[new_idx])
  end
end

local prev = function()
  local new_idx = (state.curr_idx or 0) - 1
  if state.changes[new_idx] then
    change_pos(state.changes[new_idx])
  end
end

return { next = next, prev = prev }
