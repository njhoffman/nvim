-- https://github.com/sumneko/lua-language-server/issues/496
local util = require 'lspconfig.util'
local M = {}

local root_files = {
  '.luarc.json',
  '.luacheckrc',
  '.stylua.toml',
  'stylua.toml',
  'selene.toml',
}
-- require('lua-dev.sumneko').library()
M.setup = function(on_attach, capabilities)
  local luadev_config = {
    library = {
      vimruntime = true, -- runtime path
      types      = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
      plugins    = false -- installed opt or start plugins in packpath
      -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
    },
    runtime_path = false,
  }

  local lua_settings = {
    Lua = {
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
        version = 'LuaJIT', -- Lua 5.1/LuaJIT
      },
      completion = { callSnippet = "Disable" },
      workspace = { maxPreload = 8000 },
    }
  }

  local luadev = vim.tbl_deep_extend('force',
    require("lua-dev").setup(luadev_config), {

    root_dir     = function(fname)
      -- local fname = vim.api.nvim_buf_get_name(0)
      -- local root_dir = get_root_dir(fname, vim.api.nvim_get_current_buf())
      --     or util.find_git_ancestor(fname)
      -- if not root_dir and util.path.dirname(fname) ~= vim.loop.os_homedir() then
      --   root_dir = util.path.dirname(fname)
      -- end
      -- return util.find_git_ancestor(fname) or util.path.dirname(fname)
      return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
    on_attach    = on_attach,
    capabilities = capabilities,
    settings     = lua_settings
  })

  local lspconfig = require('lspconfig')
  lspconfig.sumneko_lua.setup(luadev)
end

return M
