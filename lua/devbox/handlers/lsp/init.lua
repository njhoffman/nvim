local lsp_handlers = require('devbox.handlers.lsp.methods')
local state = require('devbox.state')

local log_items = false
local log_results = function(name, results)
  if type(results) == 'table' and log_items then
    results = { unpack(results, 1, 3) }
    vim.dbglog(name, results)
  end
end

local defaults = {
  request = function(lsp_name, params, cb)
    vim.lsp.buf_request(0, lsp_name, params, cb)
  end,
  request_all = function(lsp_name, params, cb)
    local params = vim.lsp.util.make_range_params()
    params.context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
    vim.lsp.buf_request_all(0, lsp_name, params, cb)
  end,
  request_cb = function(done, get_contents, get_summary, params)
    return function(err, result, _, _)
      if err then
        vim.dbglog({ Error = err, Result = result })
      end
      local contents = get_contents(result)
      log_results(method[1], contents)
      if not contents then
        done({ summary = '  -------- ' .. method[1], idx = line_idx, hl = 'DebugMsg' })
      else
        local summary = get_summary(contents, load_time)
        done({ summary = summary, idx = line_idx, hl = 'Keyword' })
      end
    end
  end,
  request_all_cb = function(done, get_contents, get_summary, params)
    return function(client_returns)
      local clients = vim.lsp.get_active_clients()
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

      local contents = get_contents({ results = results, context = params.context })
      log_results(method[1], contents)
      if not contents then
        done({ summary = '  -------- ' .. method[1], idx = line_idx, hl = 'DebugMsg' })
      else
        local summary = get_summary(contents, load_time)
        done({ summary = summary, idx = line_idx, hl = 'Keyword' })
      end
    end
  end,
  get_contents = function(result)
    if result and result.contents and result.contents.value then
      return result.contents.value
    end
    return nil
  end,
  get_summary = function(name, content, load_time)
    return load_time .. ' ' .. name .. '    ' .. #get_lines(content) .. ' lines'
  end,
}

local lsp_method = function(method, done)
  local name, lsp_name = method[1], method[2]
  local handler = lsp_handlers[name] or lsp_handlers.default
  local defaults = lsp_handlers.default
  local request = handler.request or defaults.request
  local get_contents = handler.get_contents or defaults.get_contents
  local get_summary = handler.get_summary or defaults.get_summary
  local params = {}

  local request_cb = (handler.request_cb or defaults.request_cb)(done, method, params, get_contents, get_summary)
  local req_state = { name = name, idx = state.current }
  local curr = state.current

  if type(request) == 'function' then
    request(lsp_name, params, request_cb)
  else
    defaults.request(lsp_name, params, request_cb)
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
