local i = {
  [" "] = "  inside whitespace",
  ['"'] = '  inside quote "',
  ["'"] = "  inside s-quote '",
  ["`"] = "  inside apostrophe `",
  ["("] = "  inside (",
  [")"] = "  inside ) including white-space",
  [">"] = "  inside > including white-space",
  ["<lt>"] = "  inside <",
  ["]"] = "  inside ] including white-space",
  ["["] = "  inside [",
  ["}"] = "  inside } including white-space",
  ["{"] = "  inside {",
  ["?"] = "  inside user prompt",
  [";"] = "  inside argument",
  _ = "  inside underscore",
  A = "  inside attribute",
  b = "  inside balanced: ), ], }",
  c = "  inside conditional",
  C = "  inside class",
  g = "  inside entire buffer",
  f = "  inside function",
  l = "  inside line",
  L = "  inside loop",
  o = "  inside block, conditional, loop",
  q = "  inside quote: `, \", '",
  t = "  inside tag",
  x = "  inside comment",
}

local a = vim.deepcopy(i)
for k, v in pairs(a) do
  a[k] = v:gsub("inside", "around"):gsub(" including.*", "")
end

-- local ic = vim.deepcopy(i)
-- local ac = vim.deepcopy(a)
-- for key, name in pairs({ n = 'Next', l = 'Last' }) do
--   i[key] = vim.tbl_extend('force', { name = '  inside ' .. name .. ' textobject' }, ic)
--   a[key] = vim.tbl_extend('force', { name = '  around ' .. name .. ' textobject' }, ac)
-- end

for k, v in pairs(i) do
  vim.dbglog("i" .. k, v)
  require("mapper").vmap({ "v", "o" }, "i" .. k, { desc = v })
end

for k, v in pairs(a) do
  vim.dbglog("a" .. k, v)
  require("mapper").vmap({ "v", "o" }, "a" .. k, { desc = v })
end
