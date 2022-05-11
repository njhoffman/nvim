local M = {}

local settings = {
  Lua = {
    format = { enable = true },
    runtime = {
      version = "LuaJIT",
    },
    diagnostics = {
      globals = {
        "vim",
        "use",
        "describe",
        "it",
        "assert",
        "before_each",
        "after_each",
      },
    },
    disable = {
      "lowercase-global",
      "undefined-global",
      "unused-local",
      "unused-function",
      "unused-vararg",
      "trailing-space",
    },
  },
}

-- local sumneko_binary_path = vim.fn.exepath("lua-language-server")
M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath('data')

  lspconfig.sumneko_lua.setup {
    root_dir = lspconfig.util.root_pattern(".project", ".git"),
    --   root_dir = util.root_pattern(".project", ".git"),
    --   -- root_dir = util.root_pattern('.project', '.git') or bufdir,
    --   -- cmd = { sumneko_binary_path, "-E", sumneko_root_path .. "/main.lua" },
    --   single_file_support = true,
    on_attach = function(client, bufnr)
      client.server_capabilities.document_formatting = false
      client.server_capabilities.document_range_formatting = false
      on_attach(client, bufnr)
    end,
    cmd = { path .. "/lsp_servers/sumneko_lua/extension/server/bin/lua-language-server" },
    settings = settings,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }
end

-- local sumneko_config = {
--   settings = {
--     Lua = {
--       format = {enable = false},
--       -- completion = {keywordSnippet = "Disable"},
--       -- runtime = {version = "LuaJIT", path = runtime_path},
--       diagnostics = {globals = {"vim", "use"}, disable = {"lowercase-global"}},
--       -- workspace = {
--       --   -- Make the server aware of Neovim runtime files
--       --   library = vim.api.nvim_get_runtime_file("", true)
--       --   -- library = {[vim.fn.expand("$VIMRUNTIME/lua")] = true, [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true}
--       -- },
--       -- Do not send telemetry data containing a randomized but unique identifier
--       telemetry = {enable = false}
--     }
--   }
-- }
-- lspservers["sumneko_lua"] = lua_dev
-- local lua_dev = require("lua-dev").setup({runtime_path = false, lspconfig = sumneko_config})

return M
