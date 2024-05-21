local utils = require('histories.utils')
local state = require('histories.state')
local view = require('histories.jumps.view')

local get_items = function()
  -- bufnr col coladd filename lnum
  local jumplist = vim.fn.getjumplist(nil) or {}
  local new_list, new_idx = utils.process_list(jumplist[1] or {}, jumplist[2] or {})
  state.jumps = new_list
  state.jump_idx = new_idx
  return state.jumps, state.jumps_idx
end

local start = function()
  local jumps, jump_idx = get_items()
  view.load(jumps, jump_idx)
end

return { start = start }
