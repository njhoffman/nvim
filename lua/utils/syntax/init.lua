local hl_captures = require("utils.syntax.hl-captures")

local ts_node = require("utils.syntax.ts-node")
local output = require("utils.syntax.output")

return {
  get_node = ts_node.get_node,
  get_highlights = hl_captures.get_highlights,
  get_hl_lines = output.get_hl_lines,
  get_node_lines = output.get_node_lines,
  output = output.output,
}
