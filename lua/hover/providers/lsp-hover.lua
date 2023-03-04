local util = vim.lsp.util

local enabled = function(done)
  local clients = vim.lsp.get_active_clients()
  if #clients == 0 then
    return done(false)
  end
  for _, client in pairs(clients) do
    if client and client.supports_method("textDocument/hover") then
      local params = util.make_position_params(0)
      vim.lsp.buf_request(0, "textDocument/hover", params, function(_, result, _, _)
        if result and result.contents then
          return done(true)
        else
          return done(false)
        end
      end)
    end
  end
end

local execute = function(done)
  local params = util.make_position_params(0)
  vim.lsp.buf_request(0, "textDocument/hover", params, function(_, result, _, _)
    local lines
    if not result then
      return done()
    else
      lines = util.convert_input_to_markdown_lines(result.contents)
    end
    lines = util.trim_empty_lines(lines)
    if vim.tbl_isempty(lines) then
      return done()
    end
    done({ lines = lines, filetype = "help-markdown" })
  end)
end

require("hover").register({
  name = "hover",
  menu = "Hover",
  desc = "LSP Hover",
  priority = 500,
  enabled = enabled,
  execute = execute,
})
