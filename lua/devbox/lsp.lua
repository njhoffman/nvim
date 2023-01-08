local lsp_handlers = require("devbox.handlers.lsp")

local lsp_method = function(method, start_time, line_idx, done)
  local params = vim.lsp.util.make_position_params()
  local handler = lsp_handlers[method[2]] or lsp_handlers.default
  local buf_request = function(_, result, _, _)
    local load_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
    local contents = handler.get_contents(result)
    if not contents then
      done({ summary = "  -------- " .. method[1], idx = line_idx, hl = "DebugMsg" })
    else
      local summary = handler.get_summary(contents, load_time)
      done({ summary = summary, idx = line_idx, hl = "Keyword" })
    end
  end
  vim.lsp.buf_request(0, method[2], params, buf_request)
end

local lsp_enabled = function(name)
  for _, client in pairs(vim.lsp.get_active_clients()) do
    if client and client.supports_method(name) then
      return true
    end
  end
  return false
end

return {
  method = lsp_method,
  enabled = lsp_enabled,
}
