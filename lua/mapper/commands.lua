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
  for _, mode in ipairs(modes) do
    opts.buffer = opts.buffer == true and 0 or opts.buffer
    local key_opts = { desc = opts.desc }
    local maps = vim.iter(vim.api.nvim_get_keymap(mode))
    if opts.buffer then
      maps = vim.iter(vim.api.nvim_buf_get_keymap(opts.buffer, mode))
      key_opts.buffer = opts.buffer
    end

    local existing = maps:find(function(k)
      return k.lhs == lhs and (not opts.buffer or k.buffer == opts.buffer)
    end)
    if existing then
      for _, mod in ipairs({ "remap", "nowait", "script", "expr", "unique" }) do
        key_opts[mod] = existing[mod]
      end
      if opts.buffer then
        vim.api.nvim_buf_set_keymap(opts.buffer, mode, lhs, existing.rhs or "", key_opts)
      else
        vim.api.nvim_set_keymap(mode, lhs, existing.rhs or "", key_opts)
      end
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

local prefix = function(modes, pfx, name)
  modes = type(modes) ~= "table" and { modes } or modes
  for _, mode in ipairs(modes) do
    -- local desc = "+" .. name
    -- records.add(true, mode, prefix, nil, { desc = desc })
    whichkey_utils.prefix(mode, pfx, name)
    whatkey_utils.prefix(mode, pfx, name)
  end
end

return {
  prefix = prefix,
  map = map,
  vmap = vmap,
}
