local lspconfig = require("lspconfig")
local util = lspconfig.util

local jsonls = function()
  lspconfig.jsonls.setup({
    filetypes = { "json", "jsonc" },
    root_dir = function(fname)
      return util.root_pattern("package.json")(fname) or util.find_git_ancestor(fname)
    end,
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
    setup = {
      commands = {
        Format = {
          function(arg)
            local bufnr = arg.fargs[1] and tonumber(arg.fargs[1]) or 0
            local lsp_name = arg.fargs[2] or ""
            if vim.b.format_on_write == 0 then
              vim.notify("Skipping format on write: " .. lsp_name, 1)
              return
            end
            vim.lsp.buf.format({
              --   filter = function(client) return client.name ~= "tsserver" end
              -- async = true,
              bufnr = bufnr,
              timeout = 3000,
            })
          end,
        },
      },
    },
  })
end

return jsonls
