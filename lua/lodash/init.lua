-- #!/usr/bin/env lua

local lodash = require("lodash.lodash")
local underscore = require("lodash.underscore")

local fn_map = require("lodash.map")

local utils = vim.deepcopy(underscore)

for u_cat, u_fns in pairs(fn_map.underscore) do
  u_cat = "_" .. u_cat
  utils[u_cat] = {}
  for _, u_fn in ipairs(u_fns) do
    local fn = type(lodash[u_fn]) == "function" and lodash[u_fn] or underscore[u_fn]
    utils[u_fn] = fn
    utils[u_cat][u_fn] = fn
    local alias = vim.tbl_get(fn_map._aliases, u_fn)
    if alias then
      utils[u_cat][alias] = fn
      utils[alias] = fn
    end
  end
end

utils._extras = {}

for l_cat, l_fns in pairs(fn_map.lodash) do
  l_cat = "_" .. l_cat
  for _, l_fn in ipairs(l_fns) do
    local fn = type(lodash[l_fn]) == "function" and lodash[l_fn]
    if fn and not vim.list_contains(vim.tbl_keys(utils), l_fn) then
      utils[l_cat] = utils[l_cat] or {}
      utils[l_cat][l_fn] = fn
      utils[l_fn] = fn
      local alias = vim.tbl_get(fn_map._aliases, l_fn)
      if alias then
        utils[l_cat][alias] = fn
        utils[alias] = fn
      end
      -- else
      --   table.insert(utils._extras, l_fn)
    end
  end
end

-- TODO: merge descriptions and examples with lookups into table

return utils
