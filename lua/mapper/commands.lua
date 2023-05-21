local records = require('mapper.records')
local wkutils = require('mapper.whichkey')
local wk = require('which-key')

-- opts: remap, category, plugin
local keymods = { 'buffer', 'nowait', 'silent', 'script', 'expr', 'unique' }

local vmap = function(modes, lhs, opts)
  opts = opts or {}
  modes = type(modes) == 'string' and { modes } or modes
  local meta = vim.fn.deepcopy(opts)
  local key_opts = {
    desc = opts.desc or opts.label,
  }
  for _, mod in ipairs(keymods) do
    key_opts[mod] = opts[mod]
    meta[mod] = nil
  end
  -- TODO: add description to existing keymaps
  for _, mode in ipairs(modes) do
    records.add(true, mode, lhs, nil, key_opts, meta)
    wkutils.map(mode, lhs, opts.label or opts.desc)
  end
end

local map = function(modes, lhs, rhs, opts)
  opts = opts or {}
  modes = type(modes) == 'string' and { modes } or modes
  local meta = vim.fn.deepcopy(opts)
  local key_opts = {
    desc = opts.desc or opts.label,
  }
  for _, mod in ipairs(keymods) do
    key_opts[mod] = opts[mod]
    meta[mod] = nil
  end

  vim.keymap.set(modes, lhs, rhs, key_opts)

  for _, mode in ipairs(modes) do
    records.add(false, mode, lhs, rhs, key_opts, meta)
    wkutils.map(mode, lhs, opts.label or opts.desc)
  end
end

local prefix = function(modes, prefix, name)
  modes = type(modes) ~= 'table' and { modes } or modes
  for _, mode in ipairs(modes) do
    wk.register({ [prefix] = { name = '+' .. name }, { mode = mode } })
  end
end

return {
  prefix = prefix,
  map = map,
  vmap = vmap,
}
