local M = require("mapper")
M.map(
  { "n", "o", "x" },
  "w",
  "<cmd>lua require('spider').motion('w')<CR>",
  { desc = "Spider-w motion", plugin = "nvim-spider", category = "Motion" }
)
M.map(
  { "n", "o", "x" },
  "e",
  "<cmd>lua require('spider').motion('e')<CR>",
  { desc = "Spider-e motion", plugin = "nvim-spider", category = "Motion" }
)
M.map(
  { "n", "o", "x" },
  "b",
  "<cmd>lua require('spider').motion('b')<CR>",
  { desc = "Spider-b motion", plugin = "nvim-spider", category = "Motion" }
)
M.map(
  { "n", "o", "x" },
  "ge",
  "<cmd>lua require('spider').motion('ge')<CR>",
  { desc = "Spider-ge motion", plugin = "nvim-spider", category = "Motion" }
)
require("spider").setup({
  skipInsignificantPunctuation = false,
})
