local records = require("mapper.records")
local whatkey_utils = require("mapper.whatkey")
local whichkey_utils = require("mapper.whichkey")

local force_unique = false

-- opts: remap, category, plugin
local keymods = { "buffer", "nowait", "script", "expr", "unique" }

local update_keys =
  { "buffer", "category", "desc", "expr", "label", "nowait", "plugin", "remap", "silent", "unique" }

local vmap = function(modes, lhs, opts)
  opts = opts or {}
  modes = type(modes) == "string" and { modes } or modes
  opts.remap = opts.remap == true or opts.noremap == false
  -- opts.noremap = (opts.remap == 1 or opts.noremap == 0) and 0 or opts.noremap == 1 and 1 or nil
  opts.silent = opts.silent ~= false
  local meta = vim.fn.deepcopy(opts)
  for _, mod in ipairs(keymods) do
    meta[mod] = nil
  end
  -- TODO: add description to existing keymaps
  for _, mode in ipairs(modes) do
    local maps = vim.iter(vim.api.nvim_get_keymap(mode))
    local existing = maps:find(function(k)
      return k.lhs == lhs
    end)
    if existing then
      for _, name in ipairs(update_keys) do
        opts[name] = opts[name] or existing[name]
      end
      vim.keymap.set(
        existing.mode,
        existing.lhs,
        existing.rhs or existing.callback,
        { desc = opts.desc }
      )
    end
    whatkey_utils.map(mode, lhs, opts)
    whichkey_utils.map(mode, lhs, opts)
  end
end

local map = function(modes, lhs, rhs, opts)
  opts = opts or {}
  modes = type(modes) == "string" and { modes } or modes
  local meta = vim.fn.deepcopy(opts)
  local key_opts = {
    desc = opts.desc or opts.label,
    remap = opts.remap == true or opts.noremap == false,
    silent = opts.silent ~= false,
  }
  if force_unique then
    key_opts.unique = true
  end
  for _, mod in ipairs(keymods) do
    key_opts[mod] = opts[mod]
    meta[mod] = nil
  end

  vim.keymap.set(modes, lhs, rhs, key_opts)
  for _, mode in ipairs(modes) do
    whichkey_utils.map(mode, lhs, key_opts)
    whatkey_utils.map(mode, lhs, key_opts)
  end
end

local prefix = function(modes, prefix, name)
  modes = type(modes) ~= "table" and { modes } or modes
  for _, mode in ipairs(modes) do
    -- local desc = "+" .. name
    -- records.add(true, mode, prefix, nil, { desc = desc })
    whichkey_utils.prefix(mode, prefix, name)
    whatkey_utils.prefix(mode, prefix, name)
  end
end

return {
  prefix = prefix,
  map = map,
  vmap = vmap,
}
