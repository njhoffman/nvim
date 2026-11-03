local wk_mapper, wk

local function ensure_loaded()
  if not wk then
    local ok1, m = pcall(require, "what-key.mapper")
    local ok2, w = pcall(require, "what-key")
    if ok1 and ok2 then
      wk_mapper = m
      wk = w
    end
  end
  return wk ~= nil
end

local map = function(mode, lhs, opts)
  if not ensure_loaded() then
    return
  end
  local label = opts.label or opts.desc or ""
  opts.buffer = opts.buffer == true and 0 or opts.buffer
  wk.register({ [lhs] = { label } }, vim.tbl_deep_extend("force", opts, { mode = mode }))
end

local prefix = function(mode, prefix, name)
  if not ensure_loaded() then
    return
  end
  local desc = "+" .. name
  wk.register({ [prefix] = { name = desc } }, { mode = mode })
end

local dump = function(...)
  if not ensure_loaded() then
    return
  end
  return wk_mapper.dump(...)
end

return { map = map, prefix = prefix, dump = dump }
