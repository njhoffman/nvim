local expand = function(name)
  local start_time = vim.fn.reltime()
  local res = vim.fn.expand("<" .. name .. ">")
  local load_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
  -- load_time = string.sub(string.gsub(load_time, " ", ""), 1, 5)
  local line = name .. ": " .. load_time .. "  - " .. res
  return line
end

local lsp_enabled = function(name)
  for _, client in pairs(vim.lsp.get_active_clients()) do
    if client and client.supports_method(name) then
      return true
    end
  end
  return false
end

local lsp_method = function(name, done)
  local util = require("vim.lsp.util")
  local params = util.make_position_params()
  local buf_request = function(_, result, _, _)
    if not result or not result.contents then
      done()
      return
    end
    -- local lines = util.convert_input_to_markdown_lines(result.contents)
    local lines = util.trim_empty_lines(vim.split(result.contents.value, "\n"))
    if vim.tbl_isempty(lines) then
      done()
      return
    end
    done({ lines = lines })
  end
  vim.lsp.buf_request(0, name, params, buf_request)
end

local update_preview = function(bufnr)
  local terms = { "cfile", "cword", "cWORD", "cexpr" }
  local lsp_methods = { "textDocument/hover" }

  local lines = {}
  for _, term in pairs(terms) do
    table.insert(lines, expand(term))
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, #lines, false, lines)

  for _, method in pairs(lsp_methods) do
    local lsp_cb = function(lsp_ret)
      if lsp_ret ~= nil and lsp_ret.lines ~= nil then
        local line = method .. ":  " .. tostring(#lsp_ret.lines)
        vim.dbglog("line", line)
        table.insert(lines, line)
        vim.api.nvim_buf_set_lines(bufnr, #lines - 1, #lines, false, { line })
      end
    end

    if lsp_enabled(method) then
      lsp_method(method, lsp_cb)
    else
      lsp_cb({ "------" })
    end
  end
end

return {
  update_preview = update_preview,
  lsp_method = lsp_method,
  lsp_enabled = lsp_enabled,
  expand = expand,
}
