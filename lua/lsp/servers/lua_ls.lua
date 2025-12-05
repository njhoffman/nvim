local default_workspace = {
  ignoreDir = {
    ".direnv",
    ".git",
    "build",
    "dist",
    "flake.lock",
    "flake.nix",
    "node_modules",
  },
  library = {
    vim.fn.expand("$VIMRUNTIME"),
    vim.fn.stdpath("config"),
    "${3rd}/busted/library",
    "${3rd}/luassert/library",
    "${3rd}/luv/library",
  },
  maxPreload = 5000,
  preloadFileSize = 10000,
}

local root_patterns = {
  ".editorconfig",
  ".luacheckrc",
  ".luarc.json",
  ".luarc.jsonc",
  ".project",
  ".stylua.toml",
  "selene.toml",
  "selene.yml",
  "stylua.toml",
  "vim.toml",
  "lua/",
  ".git",
  "CLAUDE.md",
}

local lua_ls = function()
  -- require('lsp.servers.neodev')
  -- table_insert(default_workspace.library, require("neodev.config").types()),

  vim.lsp.config("lua_ls", {
    -- log_level = vim.lsp.protocol.MessageType.Warn,
    -- before_init = require("neodev.lsp").before_init,
    cmd = {
      "lua-language-server", -- "--logpath", vim.fn.stdpath("data"), "--loglevel", "warn",
    },
    root_markers = root_patterns,

    on_attach = function(client, bufnr)
      client.server_capabilities.colorProvider = false
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
        workspace = default_workspace,
        telemetry = {
          enable = false,
        },
        runtime = {
          path = { "?.lua", "?/init.lua" },
          pathStrict = true,
          version = "LuaJIT",
        },
      },
    },
  })
end

return lua_ls

-- Custom Commands:
-- ---@diagnostic disable-next-line: rulename
--   lua: -- LuaFormatter off,
--   stylua: ignore
--   js:  -- organize imports

-- textDocument/codeAction: implement this on the server-side to compute a list of commands that represent the quickfixes.
-- workspace/executeCommand: implement this in the server-side to execute the commands. It can make use of workspace/applyEdit to send a request to the client to perform changes to the documents in the workspace.
-- client/registerCapability: The server can call this with a ExecuteCommandRegistrationOptions object. This registers your server-side command(s) with the client, so that it knows to execute them via the workspace/executeCommand handler implemented in the previous step.
-- initialize: Alternatively to using client/registerCapability you can also register server-side commands by returning a WorkspaceCapabilities object with an appropriate setting for its executeCommandProvider attribute. This method is slightly less complex (but can only be used if you don't require registering/unregistering of commands dynamically).
