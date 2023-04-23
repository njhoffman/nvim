local lspconfig = require("lspconfig")
local util = lspconfig.util

local lua_ls = function()
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
        -- "barbar.nvim",
        -- "debugprint.nvim",
        -- "feline.nvim",
        -- "fidget.nvim",
        -- "lspconfig",
        -- "mason",
        -- "mason-lspconfig",
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
    -- setup_jsonls = false,
    pathStrict = true,
  }
  require("neodev").setup(neodev_config)

  lspconfig["lua_ls"].setup({
    -- log_level = vim.lsp.protocol.MessageType.Warn,
    before_init = require("neodev.lsp").before_init,
    cmd = {
      "lua-language-server",
      -- "--logpath",
      -- vim.fn.stdpath("data"),
      -- "--loglevel",
      -- "warn",
    },
    root_dir = function(fname)
      local root_files = {
        ".editorconfig",
        ".stylua.toml",
        "stylua.toml",
        "selene.toml",
        "selene.yml",
        ".project",
        ".luarc.json",
        ".luarc.jsonc",
        ".luacheckrc",
        "vim.toml",
      }

      local pattern_root = nil
      local lua_root = nil
      for _, root_file in ipairs(root_files) do
        pattern_root = pattern_root or util.root_pattern(root_file)(fname)
        if pattern_root ~= nil then
          pattern_root = pattern_root ~= vim.env.HOME and pattern_root or nil
          if pattern_root ~= nil then
            local pattern_parts = vim.fn.split(pattern_root, "/")
            if pattern_parts[#pattern_parts] == "lua" then
              lua_root = pattern_root
              pattern_root = nil
            end
          end
        end
      end

      local git_root = util.find_git_ancestor(fname)
      local final = pattern_root or git_root or lua_root
      return final
    end,

    settings = {
      Lua = {
        format = {
          enable = false,
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
            align_call_args = true,
            align_function_params = true,
            continuation_indent = 4,
            quote_style = "double",
            trailing_table_separator = "smart",
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
        semantic = {
          enable = false,
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
  })
end

return lua_ls

-- Custom Commands:
--   lua: -- LuaFormatter off, -- stylua: ignore
--   js:  -- organize imports
-- textDocument/codeAction: implement this on the server-side to compute a list of commands that represent the quickfixes.
-- workspace/executeCommand: implement this in the server-side to execute the commands. It can make use of workspace/applyEdit to send a request to the client to perform changes to the documents in the workspace.
-- client/registerCapability: The server can call this with a ExecuteCommandRegistrationOptions object. This registers your server-side command(s) with the client, so that it knows to execute them via the workspace/executeCommand handler implemented in the previous step.
-- initialize: Alternatively to using client/registerCapability you can also register server-side commands by returning a WorkspaceCapabilities object with an appropriate setting for its executeCommandProvider attribute. This method is slightly less complex (but can only be used if you don't require registering/unregistering of commands dynamically).
