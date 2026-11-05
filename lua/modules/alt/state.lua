-- Shared state for the alt module: pairs, patterns and the last closed buffer.

local state = {
  alts = {},
  patterns = {},
  augroup_id = vim.api.nvim_create_augroup("alt-alt", { clear = true }),
  lastClosedBuffer = nil,
}

return state
