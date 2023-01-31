local lsp_handlers = require("devbox.handlers.lsp")

local lsp_method = function(method, start_time, line_idx, done)
  local params = vim.lsp.util.make_position_params()
  local handler = lsp_handlers[method[2]] or lsp_handlers.default
  local buf_request = function(err, result, ctx, _)
    local load_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
    if err then
      vim.dbglog({ Error = err, Result = result })
    end
    local contents = handler.get_contents(result, ctx)
    if not contents then
      done({ summary = "  -------- " .. method[1], idx = line_idx, hl = "DebugMsg" })
    else
      local summary = handler.get_summary(contents, load_time)
      done({ summary = summary, idx = line_idx, hl = "Keyword" })
    end
  end

  if method[2] == "textDocument/references" then
    params.context = { includeDeclaration = vim.F.if_nil(nil, true) }
    vim.lsp.buf_request(0, "textDocument/references", params, buf_request)
  elseif method[2] == "textDocument/codeAction" then
    params.context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
    vim.lsp.buf_request_all(0, "textDocument/codeAction", params, buf_request)
  else
    vim.lsp.buf_request(0, method[2], params, buf_request)
  end
end

local lsp_enabled = function(name)
  for _, client in pairs(vim.lsp.get_active_clients()) do
    if client and client.supports_method(name) then
      vim.dbglog(name)
      return true
    end
  end
  return false
end

return {
  method = lsp_method,
  enabled = lsp_enabled,
}
