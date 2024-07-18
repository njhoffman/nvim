local neodev_config = {
  debug = false,
  library = {
    -- for your Neovim config directory, the config.library settings will be used as is
    -- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
    -- for any other directory, config.library.enabled will be set to false
    enabled = true, -- when not enabled, lua-dev will not change any settings to the LSP server
    runtime = true, -- runtime path
    types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
    -- plugins = false,
    -- plugins = true,
    plugins = {
      "barbar.nvim",
      -- "debugprint.nvim",
      -- "feline.nvim",
      -- "fidget.nvim",
      "lspconfig",
      -- "mason",
      "mason-lspconfig",
      -- "neo-tree.nvim",
      "nvim-cmp",
      -- "nvim-dap",
      -- "nvim-dap-ui",
      "nvim-notify",
      "nvim-treesitter",
      -- "octo.nvim",
      "plenary.nvim",
      "telescope.nvim",
      -- "trouble.nvim",
      -- "vimade",
      "which-key.nvim",
    },
  },
  setup_jsonls = true,
  pathStrict = true,
}

require("neodev").setup(neodev_config)
