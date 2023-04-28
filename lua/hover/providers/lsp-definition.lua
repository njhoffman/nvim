local util = vim.lsp.util

local enabled = function(done)
  local clients = vim.lsp.get_active_clients()
  if #clients == 0 then
    return done(false)
  end
  for _, client in pairs(clients) do
    if client and client.supports_method('textDocument/definition') then
      local params = util.make_position_params(0)
      vim.lsp.buf_request(0, 'textDocument/definition', params, function(_, result, _, _)
        if result and result.contents and #result.contents > 0 then
          return done(true)
        else
          return done(false)
        end
      end)
    end
  end
end

local execute = function(done)
  local params = util.make_position_params()
  vim.lsp.buf_request(0, 'textDocument/definition', params, function(_, result, _, _)
    if not result or not result.contents then
      return done()
    end

    local lines = util.convert_input_to_markdown_lines(result.contents)
    lines = util.trim_empty_lines(lines)

    if vim.tbl_isempty(lines) then
      return done()
    end
    done({ lines = lines, filetype = 'markdown' })
  end)
end

require('hover').register({
  name = 'definition',
  menu = 'Definition',
  desc = 'LSP Definition',
  priority = 1000,
  enabled = enabled,
  execute = execute,
})
