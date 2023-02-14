local virtual_text_config = {
  source = false, -- "if_ { severity = {min=vim.diagnostic.severity.WARN} })
  prefix = "",
  spacing = 2,
  -- severity = 0. -- ERROR, WARN, INFO, HINT
  severity = { min = vim.diagnostic.severity.WARN },
}

local diagnostic_config = {
  virtual_text = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
    format = function(diag)
      -- See null-ls.nvim#632, neovim#17222 for how to pick up `code`
      local user_data
      user_data = diag.user_data or {}
      user_data = user_data.lsp or user_data.null_ls or user_data
      -- TODO: symbol is specific to pylint (will be removed)
      local code = (diag.symbol or diag.code or user_data.symbol or user_data.code)
      if code then
        return string.format("%s (%s)", diag.message, code)
      else
        return diag.message
      end
    end,
  },
  signs = true,
  -- underline = false,
  underline = {
    severity = { min = vim.diagnostic.severity.ERROR },
  },
  update_in_insert = false,
  severity_sort = true,
}

vim.diagnostic.config(diagnostic_config)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", max_width = 80 })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- local icons = require("nvim-nonicons")

-- ✘  i 
vim.fn.sign_define("DiagnosticSignError", {
  text = "", -- icons.get("x-circle"),
  texthl = "LspDiagnosticsSignError",
})

vim.fn.sign_define("DiagnosticSignWarn", {
  text = "", -- icons.get("alert"),
  texthl = "LspDiagnosticsSignWarn",
})

vim.fn.sign_define("DiagnosticSignInfo", {
  text = "", -- icons.get("info"),
  texthl = "LspDiagnosticsSignInfo",
})
-- 
vim.fn.sign_define("DiagnosticSignHint", {
  text = "", -- icons.get("comment"),
  texthl = "LspDiagnosticsSignHint",
})

local keymap_opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<Leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", keymap_opts)
vim.api.nvim_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", keymap_opts)
vim.api.nvim_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", keymap_opts)
vim.api.nvim_set_keymap("n", "<Leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", keymap_opts)

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function(args)
    local diagnostics = args.data.diagnostics
    vim.notify(diagnostics, 0, { title = "LspConfig" })
  end,
})
