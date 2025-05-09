local state = require("histories.state")
local track = require("histories.track")
local view = require("histories.selects.view")

local config = { max = 5 }

local get_items = function()
  return state.selects, state.select_idx
end

local start = function()
  local selects, select_idx = get_items()
  view.load(selects, select_idx)
end

local init = function(opts)
  config = vim.tbl_extend("force", config, opts or {})
  track.watch(config.max)
end

return {
  disabled = true,
  init = init,
  start = start,
}
