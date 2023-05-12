local lsp_handlers = require('devbox.handlers.lsp')
local state = require('devbox.state')

local log_items = false
local log_results = function(name, results)
  if type(results) == 'table' and log_items then
    results = { unpack(results, 1, 3) }
    vim.dbglog(name, results)
  end
end

local buf_request_all = function(client_returns)
  local clients = vim.lsp.get_active_clients()
  ---@diagnostic disable-next-line: missing-parameter
  local load_time = vim.fn.reltimestr(vim.fn.reltime(start_time))

  local results = {}
  for i, client_return in ipairs(client_returns) do
    if type(client_return) == 'table' and type(client_return.error) == 'table' then
      vim.dbglog({ Error = client_return.error, Result = client_return.result })
    else
      local client_name = clients[i]
      for _, result in ipairs(client_return.result or {}) do
        result.client_name = client_name
        table.insert(results, result)
      end
    end
  end

  local contents = lsp_handlers.get_contents({ results = results, context = params.context })
  log_results(method[1], contents)
  if not contents then
    done({ summary = '  -------- ' .. method[1], idx = line_idx, hl = 'DebugMsg' })
  else
    local summary = handler.get_summary(contents, load_time)
    done({ summary = summary, idx = line_idx, hl = 'Keyword' })
  end
end

local lsp_map = {
  references = function() end,
  codeaction = function() end,
  default = function() end,
}

local buffer_request_cb = function(err, result, _, _)
  ---@diagnostic disable-next-line: missing-parameter
  if err then
    vim.dbglog({ Error = err, Result = result })
  end
  local contents = handler.get_contents(result)
  log_results(method[1], contents)
  if not contents then
    done({ summary = '  -------- ' .. method[1], idx = line_idx, hl = 'DebugMsg' })
  else
    local summary = handler.get_summary(contents, load_time)
    done({ summary = summary, idx = line_idx, hl = 'Keyword' })
  end
end

local defaults = {
  request = function(lsp_name)
    vim.lsp.buf_request(0, lsp_name, params, buffer_request_cb)
  end,
}

local provider_map = {
  references = {
    request = function(lsp_name, params)
      params.context = { includeDeclaration = vim.F.if_nil(nil, true) }
      vim.lsp.buf_request(0, method[2], params, buffer_request_cb)
    end,
  },
  codeaction = {
    request = function()
      params = vim.lsp.util.make_range_params()
      params.context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
      vim.lsp.buf_request_all(0, method[2], params, buf_request_all)
    end,
  },
}

local lsp_method = function(method, done)
  local name, lsp_name = method[1], method[2]
  local request = provider_map[name] and provider_map[name].request or defaults.request
  -- local req_state = { name = name, idx = state.current }
  -- local curr = state.current

  if type(request) == 'function' then
    request(lsp_name)
  else
    defaults.request(lsp_name)
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
