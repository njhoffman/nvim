local state = {
  listeners_initialized = nil,
  from = nil,
  to = vim.fn.mode(true),
  last = {
    mode = vim.fn.mode(true),
    op = nil,
    opfunc = nil,
  },
  opfuncs = {
    current = nil,
    matched = {},
    missed = {},
  },
  cache = {
    applied_hl = {},
    transformed_winhl = {},
  },
}
-- local reset_state = function()
--   state.last_mode =
--   state.last_op = nil
--   state.last_opfunc = nil
-- end

return state
