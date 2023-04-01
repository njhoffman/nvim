local state = require("devbox.state")
local syn_utils = require("devbox.handlers.syntax.utils")
local res = { summary = "  -------- syn   ", hl = "DebugMsg" }

local enabled = function()
  local captures = syn_utils.get_captures()
  return #captures.treesitter > 0 or #captures.syntax > 0
end

local syntax_handler = function(start_time, timing)
  local captures = syn_utils.get_captures({ bufnr = state.base_bufnr })
  local node = syn_utils.get_node({ bufnr = state.base_bufnr })
  node = node and node[1] or nil

  if #captures.treesitter > 0 or #captures.syntax > 0 then
    ---@diagnostic disable-next-line: missing-parameter
    local load_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
    timing.total = timing.total + (load_time * 100000)
    timing.n = timing.n + 1

    local msg = load_time .. " syn   " .. #captures.treesitter .. " ts "
    msg = msg .. #captures.syntax .. " vim"
    if node ~= nil then
      msg = msg .. " [" .. node.path .. "]"
    end
    res = vim.tbl_deep_extend("force", res, {
      summary = msg,
      hl = "MoreMsg",
    })
  end
  return res
end

return {
  enabled = enabled,
  handler = syntax_handler,
}
