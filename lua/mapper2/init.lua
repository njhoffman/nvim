local wk = require("which-key")
local mapper_records = {}

-- Set a mapping
local function map_record(virtual, mode, lhs, rhs, options)
  local buffer_only = false
  if options.buffer ~= nil then
    buffer_only = true
  end

  local keymap_opts = {
    remap = options.remap or (options.noremap == false),
    silent = options.silent,
  }

  local unique_id = lhs .. "_" .. mode

  local record = {
    mode = mode,
    lhs = lhs,
    rhs = rhs,
    options = keymap_opts,
    category = options.category,
    unique_identifier = unique_id,
    virtual = virtual,
    description = options.description,
    label = options.label,
    buffer_only = buffer_only,
    n = 1,
  }
  mapper_records[unique_id] = record
  -- local existing_record = mapper_records[unique_id]
  -- if existing_record then
  --   record.n = existing_record.n + 1
  --   unique_id = unique_id .. "_" .. record.n
  -- end
end

local map_whichkey = function(mode, lhs, label)
  wk.register({ [lhs] = { label }, { mode = mode } })
end

local vmap = function(modes, lhs, opts)
  opts = opts or {}
  modes = type(modes) == "string" and { modes } or modes
  for _, mode in ipairs(modes) do
    map_record(true, mode, lhs, _, opts)
    map_whichkey(mode, lhs, opts.label or opts.desc)
  end
end

-- opts: remap, category, plugin
local map = function(modes, lhs, rhs, opts)
  opts = opts or {}
  modes = type(modes) == "string" and { modes } or modes
  local keymap_opts = {
    remap = opts.remap or (opts.noremap == false),
    nowait = opts.nowait,
    silent = opts.silent,
    desc = opts.desc or opts.label,
  }

  vim.keymap.set(modes, lhs, rhs, keymap_opts)
  for _, mode in ipairs(modes) do
    map_record(false, mode, lhs, rhs, opts)
    map_whichkey(mode, lhs, opts.label or opts.desc)
  end
end

local prefix = function(mode, prefix, name)
  wk.register({ [prefix] = { name = "+" .. name }, { mode = mode } })
end

return {
  map = map,
  prefix = prefix,
  vmap = vmap,
  records = mapper_records,
}
