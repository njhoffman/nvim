local util = vim.lsp.util

local enabled = function(done)
  local clients = vim.lsp.get_active_clients()
  if #clients == 0 then
    return done(false)
  end
  for _, client in pairs(clients) do
    if client and client.supports_method("textDocument/typeDefinition") then
      local params = util.make_position_params(0)
      vim.lsp.buf_request(0, "textDocument/typeDefinition", params, function(_, result, _, _)
        if result and #result > 0 then
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
  vim.lsp.buf_request(0, "textDocument/typeDefinition", params, function(_, result, _, _)
    if not result or #result == 0 then
      return done()
    end
    -- [1] = { originSelectionRange = {
    --         ["end"] = { character = 66, line = 0 },
    --         start = { character = 25, line = 0 }
    --     }, targetRange = {
    --         ["end"] = { character = 0, line = 0 },
    --         start = { character = 0, line = 0 }
    --     },
    --     targetSelectionRange = {
    --         ["end"] = { character = 0, line = 0 },
    --         start = { character = 0, line = 0 }
    --     },
    --     targetUri = "file:///home/nicholas/.config/nvim/lua/telescope/_extensions/devhints/hintsbox.lua"
    -- }
    local lines = result[1].targetUri
    lines = util.trim_empty_lines(lines)
    if vim.tbl_isempty(lines) then
      return done()
    end
    done({ lines = lines, filetype = "markdown" })
  end)
end

require("hover").register({
  name = "type_definition",
  menu = "TypeDef",
  desc = "LSP Type Definitions",
  priority = 1000,
  enabled = enabled,
  execute = execute,
})
