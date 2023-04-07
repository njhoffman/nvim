local state = require("devbox.state")
local syn_utils = require("devbox.handlers.syntax.utils")
local res = { summary = "  -------- syn   ", hl = "DebugMsg" }

local enabled = function()
  local captures = syn_utils.get_captures()
  return #captures.treesitter > 0 or #captures.syntax > 0
end

local syntax_handler = function(done, provider)
  local captures = syn_utils.get_captures({ bufnr = state.base_bufnr })
  local node = syn_utils.get_node({ bufnr = state.base_bufnr })
  node = node and node[1] or nil

  if #captures.treesitter > 0 or #captures.syntax > 0 then
    ---@diagnostic disable-next-line: missing-parameter
    local msg = " syn   " .. #captures.treesitter .. " ts "
    msg = msg .. #captures.syntax .. " vim"
    if node ~= nil then
      msg = msg .. " [" .. node.path .. "]"
    end
    done(provider, {
      summary = msg,
      hl = "MoreMsg",
      content = captures,
      name = provider.name,
    })
  end
end

return {
  enabled = enabled,
  handler = syntax_handler,
}
