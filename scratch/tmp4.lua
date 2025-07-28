-- local gradient = require("utils/gradient")
-- local my_gradient = gradient.from_stops(10, "#0000FF", "#00FF00")

-- -- Iterate over the gradient colors and apply them to the CursorLine highlight group
-- for i, color in ipairs(my_gradient) do
--   -- Apply the gradient color as the background of the CursorLine highlight group
--   vim.api.nvim_set_hl(0, "CursorLine", { bg = color })
-- gnd
--
local utils = require("utils.gradient_utils")
local css = require("utils.css")

local gradient = function(args)
  local hex_string_1
  local hex_string_2
  if css.get_color_value(args.fargs[2]) ~= "" then
    hex_string_1 = css.get_color_value(args.fargs[2])
  else
    local color = get_color(args.fargs[2])
    hex_string_1 = "#"
      .. utils.hex(color.rgb_values[1])
      .. utils.hex(color.rgb_values[2])
      .. utils.hex(color.rgb_values[3])
  end
  if css.get_color_value(args.fargs[3]) ~= "" then
    hex_string_2 = css.get_color_value(args.fargs[3])
  else
    local color = get_color(args.fargs[3])
    hex_string_2 = "#"
      .. utils.hex(color.rgb_values[2])
      .. utils.hex(color.rgb_values[2])
      .. utils.hex(color.rgb_values[3])
  end
  require("colortils.tools.gradients.colors")(hex_string_1, hex_string_2)
end
