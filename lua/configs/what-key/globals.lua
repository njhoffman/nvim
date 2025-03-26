_G._wk_timing = function()
  vim.dbg(require("what-key.logger").timing_summary())
end

local get_hooks = function()
  local all_hooks = require("what-key.keys.hooks")
  local hooks = {}
  for _, key in ipairs({ "nop", "auto", "fast" }) do
    for k, _ in pairs(all_hooks["hooked_" .. key]) do
      local mode = k:sub(1, 1)
      if type(tonumber(k:sub(2, 2))) == "number" then
        local pfx = "buf_" .. k:sub(2, 2)
        hooks[pfx] = hooks[pfx] or {}
        hooks[pfx][mode] = hooks[pfx][mode] or {}
        hooks[pfx][mode][k:sub(3)] = key
      else
        hooks[mode] = hooks[mode] or {}
        hooks[mode][k:sub(2)] = key
      end
    end
  end
  return hooks
end

_G._wk = function()
  require("what-key.logger").log_counts("_wk_keys")
end

_G._wk_counts = function()
  local counts = require("what-key.mapper").get_counts()
  local hooks = get_hooks()
  for key, val in pairs(hooks) do
    if key:match("^buf_") then
      counts["hook_" .. key] = counts["hook_" .. key] or {}
      for k, v in pairs(val) do
        counts["hook_" .. key][k] = #vim.tbl_keys(v)
      end
    else
      counts["hook_" .. key] = #vim.tbl_keys(val)
    end
  end
  vim.dbg(counts)
end

_G._wk_hooks = function()
  local hooks = get_hooks()
  vim.dbg(hooks)
end
