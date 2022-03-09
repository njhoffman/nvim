local config = require("config")
local api = vim.api
local lsp = vim.lsp

vim.lsp.set_log_level(config.Logging.lsp_level)

function len(t)
  local count = 0
  for _ in pairs(t) do
    count = count + 1
  end
  return count
end

require("vim.lsp.log").set_format_func(
  function(messages)
    local inspected = vim.inspect(messages)
    local formatted = ""
    if type(messages) == "table" then
      formatted = formatted .. "Length: " .. len(messages) .. "\n"
    end
    for line in string.gmatch(inspected, "[^\n\r]+") do
      formatted = formatted .. "\n  " .. line
    end
    return formatted
  end
)

vim.g.diagnostics_active = true
function _G.toggle_diagnostics()
  if vim.g.diagnostics_active then
    vim.g.diagnostics_active = false
    vim.lsp.diagnostic.clear(0)
    vim.lsp.handlers["textDocument/publishDiagnostics"] = function()
    end
  else
    vim.g.diagnostics_active = true
    vim.lsp.handlers["textDocument/publishDiagnostics"] =
      vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics,
      {
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false
      }
    )
  end
end

vim.api.nvim_set_keymap("n", "<leader>lt", ":call v:lua.toggle_diagnostics()<CR>", {noremap = true, silent = true})

vim.fn.sign_define(
  "DiagnosticSignError",
  {texthl = "LspDiagnosticsSignError", text = "", numhl = "LspDiagnosticsSignError"}
)
vim.fn.sign_define(
  "DiagnosticSignWarn",
  {
    texthl = "LspDiagnosticsSignWarning",
    text = ""
    -- numhl = "LspDiagnosticsSignWarning",
  }
)
vim.fn.sign_define(
  "DiagnosticSignInformation",
  {
    texthl = "LspDiagnosticsSignInformation",
    text = ""
    -- numhl = "LspDiagnosticsSignInformation",
  }
)
vim.fn.sign_define(
  "DiagnosticSignHint",
  {
    texthl = "LspDiagnosticsSignHint",
    text = ""
    -- numhl = "LspDiagnosticsSignHint",
  }
)
-- end

-- global config for diagnostic
vim.diagnostic.config(
  {
    update_in_insert = false,
    underline = false,
    virtual_text = false,
    signs = true,
    severity_sort = true
  }
)

-- lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
--   underline = false,
--   virtual_text = false,
--   signs = true,
--   update_in_insert = false,
-- })

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
lsp.handlers["textDocument/hover"] =
  lsp.with(
  vim.lsp.handlers.hover,
  {
    border = "rounded"
  }
)

local M = {}

function M.show_line_diagnostics()
  local opts = {
    focusable = false,
    close_events = {"BufLeave", "CursorMoved", "InsertEnter", "FocusLost"},
    border = "rounded",
    source = "always", -- show source in diagnostic popup window
    prefix = " "
  }
  vim.diagnostic.open_float(nil, opts)
end

return M
