--
local function keymap(modes, lhs, rhs, opts)
  opts = opts or {}
  opts.unique = true
  require("mapper").map(modes, lhs, rhs, opts)
end
