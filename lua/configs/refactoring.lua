-- local default_config = {
--   refactor = {
--     extract_func = { code_generation = extract_func_code_generation },
--     inline_func = { code_generation = inline_func_code_generation },
--     extract_var = { code_generation = extract_var_code_generation },
--     inline_var = { code_generation = inline_var_code_generation },
--   },
--   debug = {
--     markers = {
--       print_var = { start = "__PRINT_VAR_START", ["end"] = "__PRINT_VAR_END" },
--       print_exp = { start = "__PRINT_EXP_START", ["end"] = "__PRINT_EXP_END" },
--       print_loc = { start = "__PRINT_LOC_START", ["end"] = "__PRINT_LOC_END" },
--     },
--     print_var = {
--       output_location = "below",
--       code_generation = print_var_code_generation,
--     },
--     cleanup = {
--       types = { "print_var", "print_loc", "print_exp" },
--       restore_view = true,
--     },
--     print_loc = {
--       output_location = "below",
--       code_generation = print_loc_code_generation,
--     },
--     print_exp = {
--       output_location = "below",
--       code_generation = print_exp_code_generation,
--     },
--   },
-- }

local map = require("mapper").map
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

--
-- -- `iw` is the builtin textobject for "in word". You can use any other textobject or even create the keymap without any textobject if you prefer to provide one yourself each time that you use the keymap
-- keymap.set({ "x", "n" }, "<leader>pv", function()
--   return require("refactoring.debug").print_var { output_location = "below" } .. "iw"
-- end, { desc = "Debug print var below", expr = true })
--
-- -- `iw` is the builtin textobject for "in word". You can use any other textobject or even create the keymap without any textobject if you prefer to provide one yourself each time that you use the keymap
-- keymap.set({ "x", "n" }, "<leader>pV", function()
--   return require("refactoring.debug").print_var { output_location = "above" } .. "iw"
-- end, { desc = "Debug print var above", expr = true })
--
-- keymap.set({ "x", "n" }, "<leader>pe", function()
--   return require("refactoring.debug").print_exp { output_location = "below" }
-- end, { desc = "Debug print exp below", expr = true })
-- -- `_` is the default textobject for "current line"
-- keymap.set("n", "<leader>pee", function()
--   return require("refactoring.debug").print_exp { output_location = "below" } .. "_"
-- end, { desc = "Debug print exp below", expr = true })
--
-- keymap.set({ "x", "n" }, "<leader>pE", function()
--   return require("refactoring.debug").print_exp { output_location = "above" }
-- end, { desc = "Debug print exp above", expr = true })
-- -- `_` is the default textobject for "current line"
-- keymap.set("n", "<leader>pEE", function()
--   return require("refactoring.debug").print_exp { output_location = "above" } .. "_"
-- end, { desc = "Debug print exp above", expr = true })
--
-- keymap.set("n", "<leader>pP", function()
--   return require("refactoring.debug").print_loc { output_location = "above" }
-- end, { desc = "Debug print location", expr = true })
-- keymap.set("n", "<leader>pp", function()
--   return require("refactoring.debug").print_loc { output_location = "below" }
-- end, { desc = "Debug print location", expr = true })
--
-- keymap.set({ "x", "n" }, "<leader>pc", function()
--   -- `ag` is a custom textobject that selects the whole buffer. It's provided by plugins like `mini.ai` (requires manual configuration using `MiniExtra.gen_ai_spec.buffer()`).
--   -- return require("refactoring.debug").cleanup { restore_view = true } .. "ag"
--
--   -- this keymap doesn't select any textobject by default, so you need to provide one each time you use it.
--   return require("refactoring.debug").cleanup { restore_view = true }
-- end, { desc = "Debug print clean", expr = true, remap = true })

-- -- load refactoring Telescope extension
-- require('telescope').load_extension('refactoring')

-- remap to open the Telescope refactoring menu in visual mode
map("v", "<leader>rr", "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>")
