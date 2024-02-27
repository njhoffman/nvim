local common = require('trailblazer.trails.common')
local Motions = require('trailblazer.trails.motions')
local stacks = require('trailblazer.trails.stacks')

local notify_mark_traversal = function(mark, direction)
  if not mark then
    return
  end
  local msg = string.format(
    'TrailBlazer: Moved "%s" to trail mark %d at line %d and column %d',
    direction,
    mark.mark_id,
    mark.pos[1],
    mark.pos[2]
  )
  vim.notify(msg)
end

local M = {}

local stack_names = stacks.get_sorted_stack_names()

M.nearest_or_prev = function(buf, directive, dist_type)
  buf = buf or vim.api.nvim_get_current_buf()
  local _, current_mark = common.get_trail_mark_at_pos()
  local _, nearest_mark = common.get_nearest_trail_mark_for_pos(buf, nil, directive, dist_type)

  if Motions.move_to_nearest(buf, directive, dist_type) then
    notify_mark_traversal(nearest_mark, 'nearest')
  elseif Motions.peek_move_previous_up(buf, directive, dist_type) then
    notify_mark_traversal(current_mark, 'prev')
  elseif Motions.peek_move_next_down(buf, directive, dist_type) then
    notify_mark_traversal(current_mark, 'next')
  else
    vim.notify('TrailBlazer: No trail marks found')
  end
end

return M
