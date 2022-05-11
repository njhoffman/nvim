local M = {}

-- local runtime_path = vim.split(package.path, ";")
-- table.insert(runtime_path, "lua/?.lua")
-- table.insert(runtime_path, "lua/?/init.lua")

local settings = {
  Lua = {
    --   completion = {keywordSnippet = "Disable"},
    format = {enable = true},
    runtime = {
      -- version = "LuaJIT", path = runtime_path
      version = "LuaJIT"
    },
    -- diagnostics = {globals = {"vim", "use"}, disable = {"lowercase-global"}},
    diagnostics = {
      globals = {
        "vim",
        "use",
        "describe",
        "it",
        "assert",
        "before_each",
        "after_each"
      }
    },
    disable = {
      "lowercase-global",
      "undefined-global",
      "unused-local",
      "unused-function",
      "unused-vararg",
      "trailing-space"
    }
    -- workspace = {
    --   -- Make the server aware of Neovim runtime files
    --   library = vim.api.nvim_get_runtime_file("", true)
    --   -- library = {[vim.fn.expand("$VIMRUNTIME/lua")] = true, [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true}
    -- },
  }
}

M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath("data")

  local lua_settings = {
    root_dir = lspconfig.util.root_pattern(".project", ".git"),
    --   root_dir = util.root_pattern(".project", ".git"),
    --   -- root_dir = util.root_pattern('.project', '.git') or bufdir,
    single_file_support = true,
    on_attach = function(client, bufnr)
      -- client.resolved_capabilities.document_formatting = false
      -- client.resolved_capabilities.range_formatting = false
      on_attach(client, bufnr)
    end,
    cmd = {path .. "/lsp_servers/sumneko_lua/extension/server/bin/lua-language-server"},
    settings = settings,
    flags = {
      debounce_text_changes = 150
    },
    capabilities = capabilities
  }

  local luadev =
    require("lua-dev").setup(
    {
      library = {
        vimruntime = false, -- runtime path
        types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
        plugins = true -- installed opt or start plugins in packpath
        -- you can also specify the list of plugins to make available as a workspace library
        -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
      },
      runtime_path = false,
      lspconfig = lua_settings
    }
  )
  lspconfig.sumneko_lua.setup(luadev)
  -- lspconfig.sumneko_lua.setup(lua_settings)
end

-- local sumneko_config = {

return M
