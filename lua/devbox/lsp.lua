local lsp_handlers = require("devbox.handlers.lsp")

local log_items = false
local log_results = function(name, results)
  if type(results) == "table" and log_items then
    results = { unpack(results, 1, 3) }
    vim.dbglog(name, results)
  end
end

local lsp_method = function(method, start_time, line_idx, done)
  local params = vim.lsp.util.make_position_params()
  local handler = lsp_handlers[method[2]] or lsp_handlers.default
  local buf_request = function(err, result, ctx, _)
    local load_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
    if err then
      vim.dbglog({ Error = err, Result = result })
    end
    local contents = handler.get_contents(result, ctx)
    log_results(method[1], contents)
    if not contents then
      done({ summary = "  -------- " .. method[1], idx = line_idx, hl = "DebugMsg" })
    else
      local summary = handler.get_summary(contents, load_time)
      done({ summary = summary, idx = line_idx, hl = "Keyword" })
    end
  end

  local buf_request_all = function(client_returns)
    local clients = vim.lsp.get_active_clients()
    local load_time = vim.fn.reltimestr(vim.fn.reltime(start_time))

    local results = {}
    for i, client_return in ipairs(client_returns) do
      if type(client_return.error) == "table" then
        vim.dbglog({ Error = client_return.error, Result = client_return.result })
      else
        local client_name = clients[i]
        for _, result in ipairs(client_return.result or {}) do
          result.client_name = client_name
          table.insert(results, result)
        end
      end
    end
    local contents = handler.get_contents(results)
    log_results(method[1], contents)
    if not contents then
      done({ summary = "  -------- " .. method[1], idx = line_idx, hl = "DebugMsg" })
    else
      local summary = handler.get_summary(contents, load_time)
      done({ summary = summary, idx = line_idx, hl = "Keyword" })
    end
  end

  if method[1] == "references" then
    params.context = { includeDeclaration = vim.F.if_nil(nil, true) }
    vim.lsp.buf_request(0, method[2], params, buf_request)
  elseif method[1] == "codeaction" then
    params = vim.lsp.util.make_range_params()
    params.context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
    vim.lsp.buf_request_all(0, method[2], params, buf_request_all)
  else
    vim.lsp.buf_request(0, method[2], params, buf_request)
  end
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
