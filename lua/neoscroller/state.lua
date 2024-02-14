local initial_values = {
  relative_line = 0,
  target_line = 0,
  cursor_win_line = nil,
  lines_to_scroll = nil,
  time_step = nil,
  line_start = nil,
  continuous_scroll = false,
  scrolling = false,
  performance_mode = false,
  steps = {},
  history = {},
  scroll_timer = vim.loop.new_timer(),
}

local state = vim.tbl_deep_extend('force', {}, initial_values)

state._reset = function()
  -- state.scroll_timer:stop()
  -- for _, k in ipairs({
  --   'scroll_start',
  --   -- 'cursor_win_line',
  --   -- 'lines_to_scroll',
  --   -- 'relative_line',
  --   -- 'target_line',
  --   -- 'time_step',
  --   'line_start',
  --   'line_end',
  -- }) do
  --   state[k] = nil
  -- end
  --
  -- for _, k in pairs({
  --   'continuous_scroll',
  --   -- 'performance_mode',
  --   'scrolling',
  -- }) do
  --   state[k] = false
  -- end
  -- state.relative_line = 0
  -- state.target_line = 0
  -- state.steps = {}
end
return state
