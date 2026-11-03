-- jsonls (JSON Language Server) Configuration

return {
  filetypes = { "json", "jsonc" },
  root_markers = {
    "package.json",
    "courseleaf.cfg",
    ".project",
    ".git",
    "CLAUDE.md",
  },
  init_options = {
    provideFormatter = true,
  },
  single_file_support = true,
  settings = {
    json = {
      format = { enable = true },
      schemas = {
        {
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json",
        },
        {
          fileMatch = { "tsconfig.json", "tsconfig.*.json" },
          url = "http://json.schemastore.org/tsconfig",
        },
        {
          fileMatch = { "*.json" },
          schemas = require("schemastore").json.schemas(),
        },
      },
      validate = { enable = false },
    },
  },
}
