-- keys = {
--   { "<leader>cn", "<cmd>ConvertFindNext<CR>", desc = "Find next convertable unit" },
--   { "<leader>cc", "<cmd>ConvertFindCurrent<CR>", desc = "Find convertable unit in current line" },
--   -- Add "v" to enable converting a selected region
--   { "<leader>ca", "<cmd>ConvertAll<CR>", mode = {"n", "v"}, desc = "Convert all of a specified unit" },
-- },
-- Size Units: 📏 px	Pixels          rem	Relative to root element
--                cm	Centimeters     in	Inches
--                mm	Millimeters     pt	Points
--                pc	Picas
-- Color Formats: 🎨 rgb	Red-Green-Blue
--                   hex	Hexadecimal color code
--                   hsl	Hue-Saturation-Lightness
--
-- Number Systems 🔢 bin	Binary
--                   hexadecimal	Hexadecimal
--                   octal	Octal
--                 * Defined with respective prefix: 0b, 0x, 0o
-- :ConvertFindNext	Finds the next convertible unit
-- :ConvertFindCurrent	Finds the convertible unit in the current line (starting from cursor)
-- :ConvertAll	Converts all instances in a buffer or visual mode selection of one unit to another of the same type (size, color)
local convert = require("convert")
convert.setup({
  keymaps = {
    focus_next = { "j", "<Down>", "<Tab>" },
    focus_prev = { "k", "<Up>", "<S-Tab>" },
    close = { "<Esc>", "<C-c>", "qq" },
    submit = { "<CR>", "<Space>" },
  },
  modes = { "color", "size", "numbers" }, -- available conversion modes
})
