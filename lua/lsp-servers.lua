local mason_settings = {
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
    keymaps = {
      -- Keymap to apply language filter
      apply_language_filter = "<leader>ff",
    },
  },
}

local servers = {
  "ansiblels",
  "awk_ls",
  "bashls",
  "clangd",
  "cmake",
  "cssls",
  "dockerls",
  "eslint",
  "golangci_lint_ls",
  "gopls",
  "graphql",
  "html",
  "intelephense",
  "jsonls",
  "ltex",
  "pyright",
  "solargraph",
  "sqls",
  "stylelint_lsp",
  "sumneko_lua",
  "svelte",
  "tailwindcss",
  "terraformls",
  "tflint",
  "texlab",
  "tsserver",
  "vimls",
  "volar",
  "yamlls",
  -- "zk",
}

local lspconfig = require("lspconfig")

local lspconfig_settings = {
  ensure_installed = servers,
  automatic_installation = false,
}

local tool_packages = require("plugins.config.mason-nvim-tools")
local tool_settings = { ensure_installed = tool_packages }

require("mason").setup(mason_settings)
require("mason-lspconfig").setup(lspconfig_settings)
require("mason-tool-installer").setup(tool_settings)

local capabilities = require("lsp-capabilities")

local on_attach = function(client, bufnr)
  -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "")

  if client.name == "sumneko_lua" then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
  capabilities.resolve(client, bufnr)
  -- if lsp_name == "tsserver" then
  --   map_buf(bufnr, "cxo", tsserver_organize_imports)
  -- elseif lsp_name == "pyright" then
  --   map_buf(bufnr, "cxo", function()
  --     vim.cmd("silent PyrightOrganizeImports")
  --   end)
end

local util = require("lspconfig.util")
util.default_config = vim.tbl_extend("force", util.default_config, {
  on_attach = on_attach,
  capabilities = capabilities.make(),
})

require("mason-lspconfig").setup_handlers({
  function(server_name) -- default handler (optional)
    -- vim.notify("setting up lsp: " .. server_name, 1)
    -- local opts = vim.tbl_deep_extend("force", opts, lspconfig[server_name] or {})
    -- local config = get_config(server_name)
    lspconfig[server_name].setup(lspconfig[server_name])
  end,
  -- ["tsserver"] = function()
  --   -- local opts = vim.tbl_deep_extend("force", server_options, servers["tsserver"] or {})
  --   require("typescript").setup({
  --     disable_commands = false,
  --     debug = false,
  --     -- server = opts,
  --   })
  -- end,
  ["bashls"] = function()
    lspconfig.bashls.setup({
      root_dir = util.root_pattern(".project", ".git"),
    })
  end,

  ["sumneko_lua"] = function()
    local neodev_config = {
      debug = false,
      library = {
        -- for your Neovim config directory, the config.library settings will be used as is
        -- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
        -- for any other directory, config.library.enabled will be set to false
        enabled = true, -- when not enabled, lua-dev will not change any settings to the LSP server
        runtime = true, -- runtime path
        types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
        -- plugins = true,
        plugins = {
          "barbar.nvim",
          "debugprint.nvim",
          "feline.nvim",
          "fidget.nvim",
          "lspconfig",
          "mason",
          "mason-lspconfig",
          "nvim-cmp",
          "nvim-dap",
          "nvim-dap-ui",
          "nvim-notify",
          "nvim-treesitter",
          "octo.nvim",
          "plenary.nvim",
          "telescope.nvim",
          "trouble.nvim",
          "vimade",
          "which-key.nvim",
        },
      },
      -- override = function(root_dir, options)
      --   -- options.plugins = { "plenary.nvim" }
      --   vim.notify({ "Neodev with root dir " .. root_dir, options }, vim.log.levels.DEBUG)
      -- end,
      -- setup_jsonls = false,
      pathStrict = true,
      -- override = function(root_dir, library)
      --   vim.dbglog({ "OR", root_dir, vim.fn.isdirectory(root_dir .. "/lua") })
      --   if vim.fn.isdirectory(root_dir .. "/lua") then
      --     library.enabled = true
      --     library.types = true
      --     library.runtime = true
      --   end
      -- end,
    }
    require("neodev").setup(neodev_config)
    lspconfig.sumneko_lua.setup({
      -- log_level = vim.lsp.protocol.MessageType.Warn,
      -- single_file_support = true,
      cmd = {
        -- vim.fn.stdpath("data") .. "/mason/packages/lua-language-server/lua-language-server",
        "lua-language-server",
        "--logpath",
        vim.fn.stdpath("data"),
        "--loglevel",
        "warn",
      },
      settings = {
        Lua = {
          format = {
            enable = false,
            defaultConfig = {
              indent_style = "space",
              indent_size = "2",
            },
          },
          hint = {
            enable = true,
            arrayIndex = "Disable", -- "Enable", "Auto", "Disable"
            await = true,
            paramName = "Disable", -- "All", "Literal", "Disable"
            paramType = false,
            semicolon = "Disable", -- "All", "SameLine", "Disable"
            setType = true,
          },
          diagnostics = {
            globals = { "vim", "string", "table", "require", "ipairs", "pairs", "print" },
          },
          completion = {
            callSnippet = "Replace",
          },
          workspace = {
            checkThirdParty = false,
            --   library = vim.api.nvim_get_runtime_file("", true),
          },
          telemetry = {
            enable = false,
          },
        },
      },
      root_dir = function(fname)
        local git_root = util.find_git_ancestor(fname)
        local root_files = {
          ".luarc.json",
          ".luarc.jsonc",
          ".luacheckrc",
          ".stylua.toml",
          "stylua.toml",
          "selene.toml",
          "selene.yml",
          ".project",
        }
        local pattern_root = util.root_pattern(unpack(root_files))(fname)
        if pattern_root == vim.env.HOME then
          pattern_root = nil
        end

        local lua_root = util.root_pattern("lua/")(fname)
        if lua_root then
          lua_root = lua_root .. "/lua/"
        end

        -- vim.dbglog({ fname, pattern_root })
        return pattern_root
      end,
      -- filetypes = { "lua" },
      -- root_dir = require("null-ls.utils").root_pattern(
      --   ".luarc.json",
      --   ".luarc.jsonc",
      --   ".luacheckrc",
      --   "selene.toml",
      --   "stylua.toml",
      --   ".project",
      --   ".git"
      -- ),
    })
  end,
})
