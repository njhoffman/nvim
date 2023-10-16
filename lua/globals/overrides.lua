--
local function keymap(modes, lhs, rhs, opts)
  opts = opts or {}
  opts.unique = true
  vim.keymap.set(modes, lhs, rhs, opts)
end
