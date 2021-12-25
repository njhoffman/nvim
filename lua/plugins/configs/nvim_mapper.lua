local H = require "helpers"
local M = {}

--  default keymap : <leader>MM, :Telescope mapper.

local Mapper = require("nvim-mapper")

-- Mapper.map("n", "<leader>mp", ":MarkdownPreview<CR>", { silent = true, noremap = true }, "Markdown", "md_preview",
--            "display markdown preview")

-- virtual keymaps to document other/default keymaps
-- function M.treesitter_text_objects()
--   require("nvim-treesitter.configs").setup {
--     textobjects = {
--       select = {
--         enable = true,
--         lookahead = true,
--         -- The keymaps are defined in the configuration table, no way to get our Mapper in there !
--         keymaps = {
--           ["af"] = "@function.outer",
--           ["if"] = "@function.inner",
--           ["ac"] = "@class.outer",
--           ["ic"] = "@class.inner",
--         },
--       },
--     },
--   }
--   -- Hopefully we can still document them
--   Mapper.map_virtual("o", "af", "", {}, "Navigation", "treesitter_function_outer", "Function outer motion")
--   Mapper.map_virtual("o", "if", "", {}, "Navigation", "treesitter_function_inner", "Function inner motion")
--   Mapper.map_virtual("o", "ac", "", {}, "Navigation", "treesitter_class_outer", "Class outer motion")
--   Mapper.map_virtual("o", "ic", "", {}, "Navigation", "treesitter_class_inner", "Class inner motion")
-- end

return Mapper
