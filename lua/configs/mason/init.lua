-- https://raw.githubusercontent.com/williamboman/mason.nvim/main/README.md
-- https://raw.githubusercontent.com/williamboman/mason-lspconfig.nvim/main/README.md

local tool_packages = require("configs.mason.tools")
local tool_settings = { ensure_installed = tool_packages }

local lspconfig_settings = {
  ensure_installed = {
    "awk_ls",
    "bashls",
    "clangd",
    "copilot-language-server",
    "cssls",
    "dockerls",
    -- "efm",
    "golangci_lint_ls",
    "gopls",
    "graphql",
    "html",
    "jq-lsp",
    "jsonls",
    "pylsp",
    "sqls",
    "lua_ls",
    "terraformls",
    "ts_ls",
    "vimls",
    "yamlls",
    -- "null-ls",
  },
  automatic_installation = true,
}

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

-- ORDER IS IMPORTANT HERE
-- require("mason").setup(mason_settings)
-- require("mason-lspconfig").setup(lspconfig_settings)
-- require("mason-tool-installer").setup(tool_settings)
--
-- -- local default_lsp_on_attach = function(client, bufnr)
-- --   -- require("mappings").keys_lsp()
-- --   -- client.server_capabilities.document_formatting = false
-- --   -- client.server_capabilities.document_range_formatting = false
-- --   -- vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
-- --   -- vim.opt_local.tagfunc = "v:lua.vim.lsp.tagfunc"
-- --
-- --   if type(client.server_capabilities.signatureHelpProvider) == "table" then
-- --     local lsp_sig = require("lsp.signature")
-- --     require("lsp_signature").on_attach(lsp_sig.cfg, bufnr)
-- --   end
-- --
-- --   local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
-- --   if client.server_capabilities.documentFormattingProvider == true or
-- --     ft == 'sh' or
-- --     ft == 'bash'  then
-- --     local augroup = vim.api.nvim_create_augroup("Formatting", {})
-- --     vim.api.nvim_create_autocmd("BufWritePre", {
-- --       group = augroup,
-- --       buffer = bufnr,
-- --       command = "Format",
-- --     })
-- --   end
-- -- end
-- --
-- -- local default_lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
-- -- -- require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- --
-- -- local lspconfig = require("lspconfig")
-- -- lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
-- --   on_attach = default_lsp_on_attach,
-- --   capabilities = default_lsp_capabilities,
-- -- })
-- --
-- -- require("mason-lspconfig").setup_handlers({
-- --   -- The first entry (without a key) will be the default handler
-- --   -- and will be called for each installed server that doesn't have
-- --   -- a dedicated handler.
-- --   function(server_name) -- default handler (optional)
-- --     vim.notify("setting up lsp: " .. server_name, "trace")
-- --     -- local opts = vim.tbl_deep_extend("force", server_options, servers[server_name] or {})
-- --     -- lspconfig[server_name].setup(opts)
-- --     lspconfig[server_name].setup({})
-- --   end,
-- --   -- ["tsserver"] = function()
-- --   --   -- local opts = vim.tbl_deep_extend("force", server_options, servers["tsserver"] or {})
-- --   --   require("typescript").setup {
-- --   --     disable_commands = false,
-- --   --     debug = false,
-- --   --     -- server = opts,
-- --   --   }
-- --   -- end,
-- --   ["sumneko_lua"] = function()
-- --     lspconfig.sumneko_lua.setup(require("lua-dev").setup({
-- --       library = {
-- --         vimruntime = true, -- runtime path
-- --         types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
-- --         plugins = false, -- installed opt or start plugins in packpath
-- --         -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
-- --       },
-- --       runtime_path = false,
-- --       settings = {
-- --         Lua = {
-- --           format = {
-- --             enable = false,
-- --           },
-- --           hint = {
-- --             enable = true,
-- --             arrayIndex = "Disable", -- "Enable", "Auto", "Disable"
-- --             await = true,
-- --             paramName = "Disable", -- "All", "Literal", "Disable"
-- --             paramType = false,
-- --             semicolon = "Disable", -- "All", "SameLine", "Disable"
-- --             setType = true,
-- --           },
-- --           diagnostics = {
-- --             globals = { "vim" },
-- --           },
-- --         },
-- --       },
-- --     }))
-- --   end,
-- -- })
--
-- -- -- Capability-based keymaps.
-- -- if client.server_capabilities.declarationProvider then
-- --   vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts("Go to declaration"))
-- -- end
-- -- if client.server_capabilities.definitionProvider then
-- --   vim.api.nvim_buf_set_option(bufnr, 'tagfunc', 'v:lua.vim.lsp.tagfunc')
-- --   vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts("Go to definition"))
-- -- end
-- -- if client.server_capabilities.typeDefinitionProvider then
-- --   vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts("Go to type definition"))
-- -- end
-- -- if client.server_capabilities.hoverProvider then
-- --   vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts("LSP hover"))
-- -- end
-- -- if client.server_capabilities.implementationProvider then
-- --   vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts("Go to implementation"))
-- -- end
-- -- if client.server_capabilities.signatureHelpProvider then
-- --   vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts("Show signature help"))
-- -- end
-- -- if client.server_capabilities.referencesProvider then
-- --   vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts("Go to references"))
-- -- end
-- -- if client.server_capabilities.documentFormattingProvider then
-- --   vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts("Format buffer"))
-- -- end
-- -- if client.server_capabilities.documentRangeFormattingProvider then
-- --   vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
-- --   vim.keymap.set('v', '<leader>f', vim.lsp.buf.range_formatting, opts("Format range"))
-- -- end
