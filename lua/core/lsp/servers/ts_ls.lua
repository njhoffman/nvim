-- ts_ls (TypeScript Language Server) Configuration

local root_markers = {
  "courseleaf.cfg",
  ".project",
  "tsconfig.json",
  "jsconfig.json",
  "package.json",
  ".git",
  "CLAUDE.md",
}

return {
  init_options = {
    hostInfo = "neovim",
    preferences = {
      disableSuggestions = true,
    },
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = root_markers,
  single_file_support = true,
  settings = {
    typescript = {
      suggestionActions = { enabled = false },
      format = false,
    },
    javascript = {
      suggestionActions = { enabled = false },
      format = false,
    },
    diagnostics = {
      ignoredCodes = {
        80001, -- File is a CommonJS module
        7006,  -- parameter implicitly has any type
        2571,  -- object is of type 'unknown'
      },
    },
    completions = {
      completeFunctionCalls = true,
    },
  },
}
