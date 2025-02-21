local state = {
  alts = {},
  patterns = {},
  augroup_id = vim.api.nvim_create_augroup("alt-alt", { clear = true }),
  lastClosedBuffer = nil,
}

return state
