-- #!/usr/bin/env lua

-- for cat in pairs(fn_map.lodash) do
--   fn_map.underscore[cat] = {}
--   for _, fn in pairs(fn_map.lodash[cat]) do
--     -- for _, fn in ipairs(vim.tbl_keys(underscore)) do
--     if vim.tbl_contains(vim.tbl_keys(underscore), fn) then
--       table.insert(fn_map.underscore[cat], fn)
--     end
--   end
-- end

-- for cat in pairs(fn_map.lodash) do
--   fn_map.lodash_extras[cat] = {}
--   for _, fn in pairs(fn_map.lodash[cat]) do
--     if not vim.tbl_contains(fn_map.underscore[cat], fn) then
--       table.insert(fn_map.lodash_extras[cat], fn)
--     end
--   end
-- end

local lodash = require("lodash.lodash")
local underscore = require("lodash.underscore")

local fn_map = require("lodash.map")

local utils = vim.deepcopy(underscore)

for u_cat, u_fns in pairs(fn_map.underscore) do
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
    else
      table.insert(utils._extras, l_fn)
    end
  end
end

-- TODO: merge descriptions and examples with lookups into table

return utils
