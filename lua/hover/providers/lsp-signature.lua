local util = vim.lsp.util

local enabled = function(done)
  local clients = vim.lsp.get_active_clients()
  if #clients == 0 then
    return done(false)
  end
  for _, client in pairs(clients) do
    if client and client.supports_method('textDocument/signatureHelp') then
      local params = util.make_position_params(0)
      vim.lsp.buf_request(0, 'textDocument/signatureHelp', params, function(_, result, _, _)
        if result and result.signatures and #result.signatures > 0 then
          return done(true)
        end
      end)
    end
    return done(false)
  end
end

local execute = function(done)
  local params = util.make_position_params(0)
  vim.lsp.buf_request(0, 'textDocument/signatureHelp', params, function(_, result, _, _)
    if not result then
      return done()
    end
    local content = result.signatures[1].label
    if result.signatures[1].documentation then
      content = result.signatures[1].documentation.value
    end

    local lines = util.convert_input_to_markdown_lines(content)
    lines = util.trim_empty_lines(lines)
    if vim.tbl_isempty(lines) then
      return done()
    end
    done({ lines = lines, filetype = 'markdown' })
  end)
end

require('hover').register({
  name = 'signature',
  menu = 'Signature',
  desc = 'LSP Signature',
  priority = 200,
  enabled = enabled,
  execute = execute,
})
