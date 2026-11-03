-- lua_ls (Lua Language Server) Configuration

local root_markers = {
  ".editorconfig",
  ".luacheckrc",
  ".luarc.json",
  ".luarc.jsonc",
  ".stylua.toml",
  "selene.toml",
  "selene.yml",
  "stylua.toml",
  "vim.toml",
  ".project",
  "courseleaf.cfg",
  ".git",
  "CLAUDE.md",
  "lua/",
}

return {
  cmd = { "lua-language-server" },
  root_markers = root_markers,
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
        arrayIndex = "Disable",
        await = true,
        paramName = "Disable",
        paramType = false,
        semicolon = "Disable",
        setType = true,
      },
      semantic = { enable = false },
      diagnostics = {
        globals = { "vim", "string", "table", "require", "ipairs", "pairs", "print" },
      },
      completion = { callSnippet = "Replace" },
      workspace = {
        didChangeWatchedFiles = { dynamicRegistration = false },
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
      },
      telemetry = { enable = false },
      runtime = {
        path = { "?.lua", "?/init.lua" },
        pathStrict = true,
        version = "LuaJIT",
      },
    },
  },
}
