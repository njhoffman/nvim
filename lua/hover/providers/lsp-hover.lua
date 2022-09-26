local async = require("hover.async")

local enabled = function(done)
  for _, client in pairs(vim.lsp.buf_get_clients()) do
    if client and client.supports_method("textDocument/hover") then
      vim.lsp.buf_request(0, "textDocument/hover", params, function(_, result, _, _)
        if not result or not result.contents then
          done(false)
        else
          done(true)
        end
      end)
    end
  end
  done(false)
end

local execute = function(done)
  local util = require("vim.lsp.util")
  local params = util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/hover", params, function(_, result, _, _)
    if not result or not result.contents then
      done()
      return
    end
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
