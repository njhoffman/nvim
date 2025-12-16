local jsonls = function()
  vim.lsp.config("jsonls", {
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
      -- customCapabilities = { rangeFormatting = { editLimit = 50 } }
      -- handleSchemaProtocols = true,
    },
    single_file_support = true,
    settings = {
      json = {
        format = {
          enable = true,
        },
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
            schemas = require("schemastore").json.schemas(), -- ignore = { '.eslintrc', 'package.json', },
          },
        },
        -- diagnostics
        validate = { enable = false },
      },
    },
    -- Note: commands setup moved to LspAttach autocmd if needed
  })
end

return jsonls
