vim.g.skip_ts_context_commentstring_module = true
require("ts_context_commentstring").setup({
  enable = true,
  -- enable_autocmd = false,
  config = {
    javascript = {
      __default = "// %s",
      jsx_element = "{/* %s */}",
      jsx_fragment = "{/* %s */}",
      jsx_attribute = "// %s",
      comment = "// %s",
    },
    typescript = { __default = "// %s", __multiline = "/* %s */" },
  },
})

-- use bash parser for zsh files
-- vim.treesitter.language.register("bash", "zsh")

vim.filetype.add({
  extension = { rasi = "rasi" },
  pattern = {
    [".*/waybar/config"] = "jsonc",
    [".*/mako/config"] = "dosini",
    [".*/kitty/*.conf"] = "bash",
  },
})

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  desc = "User: Highlights for the Treesitter `comments` parser",
  callback = function()
    -- FIX lua todo-comments https://github.com/stsewd/tree-sitter-comment/issues/22
    -- https://github.com/LuaLS/lua-language-server/issues/1809
    vim.api.nvim_set_hl(0, "@lsp.type.comment.lua", {})

    -- Define `@comment.bold` for `queries/comment/highlights.scm`
    vim.api.nvim_set_hl(0, "@comment.bold", { bold = true })
  end,
})

-- local parsers = require("nvim-treesitter.parsers")
-- local parser_config = parsers.get_parser_configs()
-- parser_config.org = {
--   install_info = {
--     url = "https://github.com/milisims/tree-sitter-org",
--     revision = "f110024d539e676f25b72b7c80b0fd43c34264ef",
--     files = { "src/parser.c", "src/scanner.cc" },
--   },
--   filetype = "org",
-- }
--
-- parser_config.norg = {
--   install_info = {
--     url = "https://github.com/nvim-neorg/tree-sitter-norg",
--     files = { "src/parser.c", "src/scanner.cc" },
--     branch = "main",
--   },
-- }
--
-- parser_config.sql = {
--   install_info = {
--     url = "https://github.com/m-novikov/tree-sitter-sql",
--     files = { "src/parser.c" },
--     branch = "main",
--   },
--   filetype = { "sql", "psql" },
-- }
--
-- textobj-unit
local textobj_unit = "treesitter._textobjects.unit"
require(textobj_unit).setup()

local map = require("mapper").map
map(
  "x",
  "iu",
  ':lua require("' .. textobj_unit .. '").select()<CR>',
  { noremap = true, silent = true }
)
map(
  "x",
  "au",
  ':lua require("' .. textobj_unit .. '").select(true)<CR>',
  { noremap = true, silent = true }
)
map(
  "o",
  "iu",
  ':<c-u>lua require("' .. textobj_unit .. '").select()<CR>',
  { noremap = true, silent = true }
)
map(
  "o",
  "au",
  ':<c-u>lua require("' .. textobj_unit .. '").select(true)<CR>',
  { noremap = true, silent = true }
)
map(
  "x",
  "u",
  ':lua require("' .. textobj_unit .. '").select()<CR>',
  { noremap = true, silent = true }
)
map(
  "o",
  "u",
  ':<c-u>lua require("' .. textobj_unit .. '").select()<CR>',
  { noremap = true, silent = true }
)

map(
  "n",
  "ghu",
  '<cmd>lua require("' .. textobj_unit .. '").toggle_highlighting("VisualAlt")<CR>',
  { noremap = true, silent = true }
)

vim.api.nvim_create_user_command( -- :TSUnitHighlight
  "TSUnitHighlight",
  'lua require("' .. textobj_unit .. '").toggle_highlighting("VisualAlt")',
  { nargs = 0 }
)
