-- https://www.reddit.com/r/neovim/comments/wc0kzl/i_didnt_know_before_that_having_multiple_neovim/
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
    },
    workspace = {
      -- library = vim.api.nvim_get_runtime_file("", true),
      library = {
        -- [vim.fn.expand("$VIMRUNTIME/lua")] = true,
        [vim.fn.stdpath("config") .. "/lua"] = true
      }
    },
  }
}

local M = {}
M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath("data")

  local lua_settings = {
    -- root_dir = lspconfig.util.root_pattern(".git", ".project"),
    settings = settings,
    single_file_support = true,
    on_attach = on_attach,
    cmd = { path .. "/lsp_servers/sumneko_lua/extension/server/bin/lua-language-server" },
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities
  }

  local luadev = require("lua-dev").setup({
    library = {
      vimruntime = true, -- runtime path
      types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
      plugins = true -- installed opt or start plugins in packpath
      -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
    },
    -- runtime_path = false,
    lspconfig = lua_settings
  })
  lspconfig.sumneko_lua.setup(luadev)
  -- lspconfig.sumneko_lua.setup(lua_settings)
end

return M
