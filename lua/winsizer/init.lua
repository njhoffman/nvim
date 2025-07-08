local utils = require("winsizer.utils")

local winmap = {
  default_split = { w = 0.5 },
  default_float = { w = 0.3, h = 0.9 },
}

local default_winprops = {}

local apply_updates = function(updates)
  vim.dbglog("applying updates", updates)
end

local get_default = function(action, existing_props)
  return winmap.default(action, existing_props)
end

local match_mapdef = function(action, id, winprops)
  if type(winmap[id]) == "table" then
    return winmap[id]
  elseif type(winmap[id]) == "function" then
    return winmap[id](action, winprops)
  else
    return get_default(action, winprops)
  end
end

local setup = function(opts)
  local add_window = function(id, winopts)
    local winprops = type(opts) == "string" and { wintype = opts } or {}
    winopts = vim.tbl_extend("force", default_winprops, winprops)

    local matchdef = match_mapdef("add", id, opts)
    vim.dbglog("MATCHDEF", matchdef)

    -- local updates = window.calc_updatess(action, opts, matchdef, existing_props)
    -- local results = window.apply_updates(updates)

    --   vim.dbglog(results)
    -- sizers.remove_window = function(id, winprops) end
    -- sizers.resize_windows = function() end
  end

  return { add_window = add_window }
end

local TEST_FLAG = true
local test_sizers = function()
  local sizers = setup()
  sizers.add()
end

return TEST_FLAG and test_zizers or setup
