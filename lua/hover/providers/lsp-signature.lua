local enabled = function(done)
  for _, client in pairs(vim.lsp.buf_get_active_clients()) do
    if client and client.supports_method("textDocument/signatureHelp") then
      local params = util.make_position_params(0)
      vim.lsp.buf_request(0, "textDocument/signatureHelp", params, function(_, result, _, _)
        if result and result.signatures then
          done(true)
        end
      end)
    end
  end
  done(false)
end

local execute = function(done)
  local params = util.make_position_params(0)
  vim.lsp.buf_request(0, "textDocument/signatureHelp", params, function(_, result, _, _)
    local content = result.signatures[0].label
    if result.signatures[0].documentation then
      content = result.signatures[0].documentation.value
    end

    local lines = util.convert_input_to_markdown_lines(content)
    lines = util.trim_empty_lines(lines)
    if vim.tbl_isempty(lines) then
      done()
      return
    end

    done({ lines = lines, filetype = "markdown" })
  end)
end

require("hover").register({
  name = "Signature",
  priority = 1000,
  enabled = enabled,
  execute = execute,
})
