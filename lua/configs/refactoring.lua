
local map = require("lib.mapper").map
map({ "n", "x" }, "<leader>re", function()
  return require("refactoring").extract_func()
end, { desc = "Extract Function", expr = true })
-- `_` is the default textobject for "current line"
map("n", "<leader>ree", function()
  return require("refactoring").extract_func() .. "_"
end, { desc = "Extract Function (line)", expr = true })

map({ "n", "x" }, "<leader>rE", function()
  return require("refactoring").extract_func_to_file()
end, { desc = "Extract Function To File", expr = true })

map({ "n", "x" }, "<leader>rv", function()
  return require("refactoring").extract_var()
end, { desc = "Extract Variable", expr = true })

-- `_` is the default textobject for "current line"
map("n", "<leader>rvv", function()
  return require("refactoring").extract_var() .. "_"
end, { desc = "Extract Variable (line)", expr = true })

map({ "n", "x" }, "<leader>ri", function()
  return require("refactoring").inline_var()
end, { desc = "Inline Variable", expr = true })

map({ "n", "x" }, "<leader>rI", function()
  return require("refactoring").inline_func()
end, { desc = "Inline function", expr = true })

map({ "n", "x" }, "<leader>rs", function()
  return require("refactoring").select_refactor()
end, { desc = "Select refactor" })

-- You can also use below = true here to to change the position of the printf
-- statement (or set two remaps for either one). This remap must be made in normal mode.
map("n", "gor", ":lua require('refactoring').debug.printf({below = false})<CR>")

-- Print var
-- Remap in normal mode and passing { normal = true } will automatically find the variable under the cursor and print it
-- map("n", "<leader>rv", ":lua require('refactoring').debug.print_var({ normal = true })<CR>")
-- -- Remap in visual mode will print whatever is in the visual selection
-- map("v", "<leader>rv", ":lua require('refactoring').debug.print_var({})<CR>")
-- -- Cleanup function: this remap should be made in normal mode
-- map("n", "<leader>rc", ":lua require('refactoring').debug.cleanup({})<CR>")

-- -- load refactoring Telescope extension
-- require('telescope').load_extension('refactoring')

-- remap to open the Telescope refactoring menu in visual mode
map("v", "<leader>rr", "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>")
