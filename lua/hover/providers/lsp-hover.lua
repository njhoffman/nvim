local util = vim.lsp.util

local enabled = function(done)
  for _, client in pairs(vim.lsp.buf_get_active_clients()) do
    if client and client.supports_method("textDocument/hover") then
      local params = util.make_position_params(0)
      vim.lsp.buf_request(0, "textDocument/hover", params, function(_, result, _, _)
        if result and result.contents then
          done(true)
        end
      end)
    end
  end
  done(false)
end

local execute = function(done)
  local params = util.make_position_params(0)
  vim.lsp.buf_request(0, "textDocument/hover", params, function(_, result, _, _)
    local lines = util.convert_input_to_markdown_lines(result.contents)
    lines = util.trim_empty_lines(lines)
    if vim.tbl_isempty(lines) then
      done()
      return
    end

    done({ lines = lines, filetype = "markdown" })
  end)
end

require("hover").register({
  name = "Hover",
  priority = 1000,
  enabled = enabled,
  execute = execute,
})
