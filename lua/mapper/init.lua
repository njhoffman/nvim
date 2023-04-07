local wkutils = require("mapper.whichkey")
local records = require("mapper.records")

local vmap = function(modes, lhs, opts)
  opts = opts or {}
  modes = type(modes) == "string" and { modes } or modes
  for _, mode in ipairs(modes) do
    records.add(true, mode, lhs, _, opts)
    wkutils.map(mode, lhs, opts.label or opts.desc)
  end
end

-- opts: remap, category, plugin
local map = function(modes, lhs, rhs, opts)
  opts = opts or {}
  modes = type(modes) == "string" and { modes } or modes
  local keymap_opts = {
    remap = opts.remap or (opts.noremap == false),
    expr = opts.expr,
    unique = opts.unique,
    desc = opts.desc or opts.label,
  }
  if type(opts.nowait) ~= "nil" then
    keymap_opts.nowait = opts.nowait
  end
  if type(opts.silent) ~= "nil" then
    keymap_opts.silent = opts.nowait
  end

  vim.keymap.set(modes, lhs, rhs, keymap_opts)
  for _, mode in ipairs(modes) do
    records.add(false, mode, lhs, rhs, opts)
    wkutils.map(mode, lhs, opts.label or opts.desc)
  end
end

return {
  map = map,
  vmap = vmap,
  prefix = wkutils.prefix,
  records = records.values,
}
