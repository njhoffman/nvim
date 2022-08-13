
-- https://www.reddit.com/r/neovim/comments/wc0kzl/i_didnt_know_before_that_having_multiple_neovim/

-- neovim
local neovim_config = function()
  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  return {
    runtime_path = runtime_path,
    workspace_library = vim.api.nvim_get_runtime_file("", true),
    -- workspace_library = {
    --   [vim.fn.expand("$VIMRUNTIME/lua")] = true,
    --   [vim.fn.stdpath("config") .. "/lua"] = true
    -- }
    -- workspace_library = {
    --   [vim.fn.expand('$VIMRUNTIME/lua')] = true,
    --   [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
    -- }

  }
end

-- luarocks scripts
local luarocks_config = function()
  return {
    workspace_library = {
      vim.fn.expand('~/.luarocks/share/lua/5.3'),
      '/usr/share/lua/5.3'
    },
    runtime_path = {
      '?.lua',
      '?/init.lua',
      '~/.luarocks/share/lua/5.3/?.lua',
      '~/.luarocks/share/lua/5.3/?/init.lua',
      '/usr/share/5.3/?.lua',
      '/usr/share/lua/5.3/?/init.lua'
    }
  }
end

local util = require 'lspconfig.util'

local settings = {
  Lua = {
    --   completion = {keywordSnippet = "Disable"},
    format = {
      enable = true,
      -- NOTE: the value should be STRING!!
      defaultConfig = {
        indent_style = "space",
        indent_size = "2",
        max_line_width = "120",
        quote_style = 'AutoPreferDouble'
        -- line_endings	Unix
        -- call_parentheses	Always
      }
    },
    runtime = {
      path = neovim_config().runtime_path,
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
        "trailing-space",
        "missing-parameter",
        -- "undefined-global",
        -- "unused-local",
        -- "unused-function",
        -- "unused-vararg",
      }
    },
    workspace = {
      library = neovim_config().workspace_library
    },
    telemetry = {
      enable = false,
    },
  }
}

local lspconfig = require "lspconfig"
local M = {}
M.setup = function(on_attach, capabilities)

  local path = vim.fn.stdpath("data")

  local root_files = {
    '.luarc.json',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
  }

  local lua_settings = {
    root_dir = function(fname)
      -- local fname = vim.api.nvim_buf_get_name(0)
      -- local root_dir = get_root_dir(fname, vim.api.nvim_get_current_buf())
      --     or util.find_git_ancestor(fname)
      -- if not root_dir and util.path.dirname(fname) ~= vim.loop.os_homedir() then
      --   root_dir = util.path.dirname(fname)
      -- end
      return util.find_git_ancestor(fname) or util.path.dirname(fname)
      -- return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
    end,
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
    runtime_path = false,
    lspconfig = lua_settings
  })

  lspconfig.sumneko_lua.setup(luadev)
  -- lspconfig.sumneko_lua.setup(lua_settings)
end

return M
