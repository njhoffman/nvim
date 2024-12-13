local records = require("mapper.records")
local wkutils = require("mapper.whichkey")
local wk = require("which-key")

local force_unique = false

-- opts: remap, category, plugin
local keymods = {
  "buffer",
  "nowait",
  "script",
  "expr",
  "unique",
}

local update_keys = {
  "buffer",
  "category",
  "desc",
  "expr",
  "label",
  "nowait",
  "plugin",
  "remap",
  "silent",
  "unique",
}

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
      local new_opts = {}
      for _, name in ipairs(update_keys) do
        new_opts[name] = opts[name] and opts[name] or existing[name]
      end
      if new_opts.remap then
        vim.dbglog(lhs, new_opts)
      end
      -- vim.api.nvim_set_keymap(mode, lhs, existing.rhs, { noremap = true, silent = true })
      vim.keymap.set(
        existing.mode,
        existing.lhs,
        existing.rhs or existing.callback,
        { desc = new_opts.desc }
      )
      wkutils.map(mode, lhs, new_opts)
    else
      wkutils.map(mode, lhs, opts)
    end
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
  if key_opts.remap then
    vim.dbglog(lhs, opts)
  end
  if force_unique then
    key_opts.unique = true
  end
  for _, mod in ipairs(keymods) do
    key_opts[mod] = opts[mod]
    meta[mod] = nil
  end

  vim.keymap.set(modes, lhs, rhs, key_opts)
  for _, mode in ipairs(modes) do
    wkutils.map(mode, lhs, key_opts)
  end
end

local prefix = function(modes, prefix, name)
  modes = type(modes) ~= "table" and { modes } or modes
  for _, mode in ipairs(modes) do
    local desc = "+" .. name
    -- vim.dbglog(mode, prefix, desc)
    -- records.add(true, mode, prefix, nil, { desc = desc })
    wk.register({ [prefix] = { name = desc } }, { mode = mode })
  end
end

return {
  prefix = prefix,
  map = map,
  vmap = vmap,
}
