local M = {}
local lsp_severity = vim.diagnostic.severity
local diagnostic = vim.diagnostic

function M.is_lsp_attached()
  return next(vim.lsp.get_clients({ bufnr = 0 })) ~= nil
end

-- function M.get_diagnostics_count(severity)
--   return vim.tbl_count(vim.diagnostic.get(0, severity and { severity = severity }))
-- end

function M.get_diagnostics_count(severity)
  local opts = severity and { severity = severity }
  return (diagnostic.count and severity) and diagnostic.count(0, opts)[severity]
    or vim.tbl_count(diagnostic.get(0, opts))
end

function M.diagnostics_exist(severity)
  return M.get_diagnostics_count(severity) > 0
end

-- Common function used by the diagnostics providers
local function diagnostics(severity)
  local count = M.get_diagnostics_count(severity)
  return count ~= 0 and tostring(count) or ""
end

function M.lsp_client_names()
  local clients = {}

  for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
    clients[#clients + 1] = client.name
  end

  return table.concat(clients, " "), " "
end

function M.diagnostic_errors()
  return diagnostics(lsp_severity.ERROR), "  "
end

function M.diagnostic_warnings()
  return diagnostics(lsp_severity.WARN), "  "
end

function M.diagnostic_info()
  return diagnostics(lsp_severity.INFO), "  "
end

function M.diagnostic_hints()
  return diagnostics(lsp_severity.HINT), "  "
end

return M
