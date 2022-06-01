local M = {}
-- local runtime_path = vim.split(package.path, ";")
-- table.insert(runtime_path, "lua/?.lua")
-- table.insert(runtime_path, "lua/?/init.lua")

local settings = {
  Lua = {
    --   completion = {keywordSnippet = "Disable"},
    format = {
      enable = true,
      -- NOTE: the value should be STRING!!
      defaultConfig = {
        indent_style = "space",
        indent_size = "2",
        max_line_width = "120"
      }
    },
    runtime = {
      -- version = "LuaJIT", path = runtime_path
      version = "LuaJIT"
    },
    -- diagnostics = {globals = {"vim", "use"}, disable = {"lowercase-global"}},
    diagnostics = {
      neededFileStatus = {
        ["codestyle-check"] = "Any"
      },
      globals = {
        "vim",
        "use",
        "describe",
        "it",
        "assert",
        "before_each",
        "after_each"
      },
      disable = {
        "lowercase-global",
        "undefined-global",
        -- "unused-local",
        -- "unused-function",
        "missing-parameter",
        "unused-vararg",
        "trailing-space"
      }
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
    root_dir = lspconfig.util.root_pattern(".git", ".project"),
    single_file_support = true,
    on_attach = on_attach,
    cmd = { path .. "/lsp_servers/sumneko_lua/extension/server/bin/lua-language-server" },
    settings = settings,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities
  }

  local luadev =
  require("lua-dev").setup(
    {
      library = {
        vimruntime = false, -- runtime path
        types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
        plugins = true -- installed opt or start plugins in packpath
        -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
      },
      runtime_path = false,
      lspconfig = lua_settings
    }
  )
  lspconfig.sumneko_lua.setup(luadev)
  -- lspconfig.sumneko_lua.setup(lua_settings)
end

return M
