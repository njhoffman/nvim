-- LSP Keymaps
-- Buffer-local keymaps set when LSP attaches

local log = require("logger").init("lsp.keymaps")

local M = {}

local map = require("mapper").map

-- Setup keymaps for a buffer when LSP attaches
function M.setup(client, bufnr)
  local opts = { buffer = bufnr }

  log:debug("Setting up keymaps for " .. client.name .. " on buffer " .. bufnr)

  -- Diagnostics
  map("n", "<C-t>", function()
    require("telescope.builtin").diagnostics({ bufnr = 0 })
  end, vim.tbl_extend("force", opts, { desc = "Buffer diagnostics" }))

  map("n", "<M-T>", function()
    require("telescope.builtin").diagnostics()
  end, vim.tbl_extend("force", opts, { desc = "Workspace diagnostics" }))

  map("n", "<Leader>e", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Open diagnostic float" }))

  map("n", "[d", function()
    require("commands.scroll").diag_scroll("prev")
  end, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))

  map("n", "]d", function()
    require("commands.scroll").diag_scroll("next")
  end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))

  map("n", "[e", function()
    require("commands.scroll").diag_scroll("prev", "ERROR")
  end, vim.tbl_extend("force", opts, { desc = "Previous error" }))

  map("n", "]e", function()
    require("commands.scroll").diag_scroll("next", "ERROR")
  end, vim.tbl_extend("force", opts, { desc = "Next error" }))

  map("n", "gqd", function()
    vim.diagnostic.setqflist({ open = true })
  end, vim.tbl_extend("force", opts, { desc = "Diagnostics to quickfix" }))

  -- Hover and signature
  if client.server_capabilities.hoverProvider and vim.bo.ft ~= "vim" then
    pcall(vim.keymap.del, "n", "K", { buffer = bufnr })
    map("n", "K", "<cmd>Hover<cr>", vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
    map("n", "glh", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP hover" }))
  end

  if client.server_capabilities.signatureHelpProvider then
    map("n", "gK", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
    map("n", "glH", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "LSP signature help" }))
  end

  -- Navigation
  if client.server_capabilities.definitionProvider then
    map("n", "gld", function()
      require("telescope.builtin").lsp_definitions()
    end, vim.tbl_extend("force", opts, { desc = "LSP definitions (telescope)" }))
    map("n", "glD", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "LSP definition" }))
    map("n", "gpd", function()
      require("goto-preview").goto_preview_definition()
    end, vim.tbl_extend("force", opts, { desc = "Preview definition" }))
  end

  if client.server_capabilities.declarationProvider then
    map("n", "gly", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "LSP declaration" }))
  end

  if client.server_capabilities.referencesProvider then
    map("n", "glr", function()
      require("telescope.builtin").lsp_references()
    end, vim.tbl_extend("force", opts, { desc = "LSP references (telescope)" }))
    map("n", "glR", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "LSP references (quickfix)" }))
    map("n", "gpr", function()
      require("goto-preview").goto_preview_references()
    end, vim.tbl_extend("force", opts, { desc = "Preview references" }))
  end

  if client.server_capabilities.implementationProvider then
    map("n", "gli", function()
      require("telescope.builtin").lsp_implementations()
    end, vim.tbl_extend("force", opts, { desc = "LSP implementations (telescope)" }))
    map("n", "glI", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "LSP implementation" }))
    map("n", "gpi", function()
      require("goto-preview").goto_preview_implementation()
    end, vim.tbl_extend("force", opts, { desc = "Preview implementation" }))
  end

  if client.server_capabilities.typeDefinitionProvider then
    map("n", "glt", function()
      require("telescope.builtin").lsp_type_definitions()
    end, vim.tbl_extend("force", opts, { desc = "LSP type definitions (telescope)" }))
    map("n", "glT", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "LSP type definition" }))
    map("n", "gpt", function()
      require("goto-preview").goto_preview_type_definition()
    end, vim.tbl_extend("force", opts, { desc = "Preview type definition" }))
  end

  -- Code actions
  if client.server_capabilities.codeActionProvider then
    map("n", "glc", "<cmd>CodeActionMenu<cr>", vim.tbl_extend("force", opts, { desc = "Code action menu" }))
    map("n", "gla", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
    map("n", "glA", function()
      require("actions-preview").code_actions()
    end, vim.tbl_extend("force", opts, { desc = "Code actions preview" }))
  end

  -- Formatting (using new API)
  if client.server_capabilities.documentFormattingProvider then
    map("n", "<Leader>ff", function()
      vim.lsp.buf.format({ async = true })
    end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
  end

  if client.server_capabilities.documentRangeFormattingProvider then
    map("v", "<Leader>ff", function()
      vim.lsp.buf.format({ async = true })
    end, vim.tbl_extend("force", opts, { desc = "Format selection" }))
  end

  log:debug("Keymaps setup complete for " .. client.name)
end

return M
