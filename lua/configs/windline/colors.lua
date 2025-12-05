-- Migrated from configs.feline.colors
--stylua: ignore
local colors = {
  default = "282c34",
  bg              = "#282c34",
  fg              = "#abb2bf",
  yellow          = "#e0af68",
  cyan            = "#56b6f2",
  darkblue        = "#081633",
  green           = "#48a3a9",
  orange          = "#d19a66",
  violet          = "#6961c1",
  magenta         = "#c678dd",
  blue            = "#61afef",
  red             = "#e86671",
  ruby            = "#a026a6",
  white           = "#ffffff",
  black           = "#000000",
  skyblue         = "#87ceeb",
  gray            = "#808080",
  base            = "#282c34",
  oceanblue       = "#224488",
}

--stylua: ignore
local vi_mode_colors = {
  NORMAL        = colors.cyan,
  INSERT        = colors.green,
  VISUAL        = colors.violet,
  LINES         = colors.violet,
  BLOCK         = colors.violet,
  OP            = colors.ruby,
  REPLACE       = colors.red,
  ["V-REPLACE"] = colors.red,
  ENTER         = colors.cyan,
  MORE          = colors.cyan,
  SELECT        = colors.magenta,
  COMMAND       = colors.yellow,
  SHELL         = colors.yellow,
  TERM          = colors.yellow,
  NONE          = colors.yellow,
}

return { vi_mode = vi_mode_colors, main = colors }
