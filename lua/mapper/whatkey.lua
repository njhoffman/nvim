local wk_mapper = require("what-key.mapper")
local wk = require("what-key")

-- wk.register({ ["<leader>f"] = { name = "+file" }, ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", "Find File" }}, opts)
local map = function(mode, lhs, opts)
  local label = opts.label or opts.desc or ""
  opts.buffer = opts.buffer == true and 0 or opts.buffer
  -- if mode == "" then
  --   whatkey.register({ [lhs] = { label } }, vim.tbl_deep_extend("force", opts, { mode = "n" }))
  -- elseif mode == "v" then
  --   whatkey.register({ [lhs] = { label } }, vim.tbl_deep_extend("force", opts, { mode = "x" }))
  --   whatkey.register({ [lhs] = { label } }, vim.tbl_deep_extend("force", opts, { mode = "s" }))
  -- else
  wk.register({ [lhs] = { label } }, vim.tbl_deep_extend("force", opts, { mode = mode }))
  -- end
end

local prefix = function(mode, prefix, name)
  local desc = "+" .. name
  wk.register({ [prefix] = { name = desc } }, { mode = mode })
end

return { map = map, prefix = prefix, dump = wk_mapper.dump }
