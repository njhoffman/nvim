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

return state
