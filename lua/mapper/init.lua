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
    silent = vim.tbl_contains(opts, "silent") and opts.silent or true,
    nowait = vim.tbl_contains(opts, "nowait") and opts.nowait,
    expr = vim.tbl_contains(opts, "expr") and opts.expr,
    unique = vim.tbl_contains(opts, "unique") and opts.unique,
    desc = opts.desc or opts.label,
  }

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
