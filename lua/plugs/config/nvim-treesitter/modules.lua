local configs = require("nvim-treesitter.configs")

local custom_modules = {
  incremental_custom = {
    enable = true,
    disable = { "markdown" },
    keymaps = {
      {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        scope_incremental = "<Tab>",
        node_decremental = "<S-Tab>",
      },
      {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        node_decremental = "<BS>",
      },
      {
        init_selection = "vv",
        node_incremental = "v",
        node_decremental = "V",
      },
      {
        -- init_selection = "<TAB>", -- interferes with Ctrl+O/Ctrl+I
        node_incremental = "+",
        node_decremental = "-",
      },
      -- defaults --
      -- init_selection = "gnn",
      -- node_incremental = "grn", -- visual
      -- scope_incremental = "grc", -- visual
      -- node_decremental = "grm", -- visual
    },
    attach = function(bufnr)
      local config = configs.get_module("incremental_custom")
      for _, keymaps in ipairs(config.keymaps) do
        for funcname, mapping in pairs(keymaps) do
          local mode
          if funcname == "init_selection" then
            mode = "n"
          else
            mode = "x"
          end
          local cmd = string.format(":lua require'nvim-treesitter.incremental_selection'.%s()<CR>", funcname)
          vim.api.nvim_buf_set_keymap(bufnr, mode, mapping, cmd, { silent = true, noremap = true })
        end
      end
    end,
    detach = function(bufnr)
      local config = configs.get_module("incremental_custom")
      for _, keymaps in ipairs(config.keymaps) do
        for f, mapping in pairs(keymaps) do
          if f == "init_selection" then
            vim.api.nvim_buf_del_keymap(bufnr, "n", mapping)
          else
            vim.api.nvim_buf_del_keymap(bufnr, "x", mapping)
          end
        end
      end
    end,
  },
}

return custom_modules
