local H = require "helpers"
local M = {}

if H.is_module_available("nvim-mapper") then
  local Mapper = require("nvim-mapper")

  Mapper.map("n", "<leader>P", ":MarkdownPreview<CR>", { silent = true, noremap = true }, "Markdown", "md_preview",
             "Display Markdown preview in Qutebrowser")

  -- virtual keymaps to document other/default keymaps
  function M.treesitter_text_objects()
    require("nvim-treesitter.configs").setup {
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          -- The keymaps are defined in the configuration table, no way to get our Mapper in there !
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
      },
    }
    -- Hopefully we can still document them
    Mapper.map_virtual("o", "af", "", {}, "Navigation", "treesitter_function_outer", "Function outer motion")
    Mapper.map_virtual("o", "if", "", {}, "Navigation", "treesitter_function_inner", "Function inner motion")
    Mapper.map_virtual("o", "ac", "", {}, "Navigation", "treesitter_class_outer", "Class outer motion")
    Mapper.map_virtual("o", "ic", "", {}, "Navigation", "treesitter_class_inner", "Class inner motion")
  end
  H.map = function(mode, keys, cmd, options, category, unique_identifier, description)
    mapper.map(mode, keys, cmd, options, category, unique_identifier, description)
  end
  H.map_buf = function(bufnr, mode, keys, cmd, options, category, unique_identifier, description)
    mapper.map_buf(bufnr, mode, keys, cmd, options, category, unique_identifier, description)
  end
  H.map_virtual = function(mode, keys, cmd, options, category, unique_identifier, description)
    mapper.map_virtual(mode, keys, cmd, options, category, unique_identifier, description)
  end
  H.map_buf_virtual = function(mode, keys, cmd, options, category, unique_identifier, description)
    mapper.map_buf_virtual(mode, keys, cmd, options, category, unique_identifier, description)
  end
else
  H.map = function(mode, keys, cmd, options, _, _, _) vim.api.nvim_set_keymap(mode, keys, cmd, options) end
  H.map_buf = function(mode, keys, cmd, options, _, _, _) vim.api.nvim_buf_set_keymap(mode, keys, cmd, options) end
  H.map_virtual = function(_, _, _, _, _, _, _) return end
  H.map_buf_virtual = function(_, _, _, _, _, _, _) return end
end

return M
