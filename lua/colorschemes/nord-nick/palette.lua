local M = {}

-- Nord base palette (HSL pre-computed to hex)
M.nord0 = "#2F3541"
M.nord1 = "#3C4353"
M.nord2 = "#444D5F"
M.nord3 = "#4D576A"
M.nord3_bright = "#616F89"
M.nord4 = "#D8DEE9"
M.nord5 = "#E5E9F0"
M.nord6 = "#ECEFF4"
M.nord7 = "#6f9cbb"
M.nord8 = "#87BFCF"
M.nord9 = "#81A1C1"
M.nord10 = "#5D81AC"
M.nord11 = "#BE6069"
M.nord12 = "#D18771"
M.nord13 = "#EBCA89"
M.nord14 = "#22BB99"
M.nord15 = "#646EAD"
M.nord16 = "#3698b3"
M.none = "NONE"
M.highlight = "#1F2233"
M.disabled = "#464B5D"
M.accent = "#84FFFF"
M.error = "#aa3049"

-- Main theme colors
M.fg = "#A8C0E0"
M.fg_light = "#E5E9F0"
M.bg_dark = "#1c1f24"
M.bg = "#2E3440"
M.gray = "#646A76"
M.light_gray = "#6C7A96"
M.cyan = "#88C0D0"
M.blue = "#81A1C1"
M.dark_blue = "#5E81AC"
M.green = "#A3BE8C"
M.light_green = "#8FBCBB"
M.dark_red = "#BF616A"
M.red = "#D57780"
M.light_red = "#DE878F"
M.pink = "#E85B7A"
M.dark_pink = "#E44675"
M.orange = "#D08F70"
M.yellow = "#EBCB8B"
M.purple = "#B988B0"
M.light_purple = "#B48EAD"

-- Color overrides (main.lua)
M.selection = "#101840"
M.orange_faded = "#80788a"
M.orange_over = "#cc8877"
M.yellow_over = "#bdb994"
M.yellow_faded = "#7B6B3B"
M.purple_faded = "#6A6CAB"
M.red_faded = "#430000"
M.green_faded = "#004a47"
M.blue_faded = "#173787"

-- Color overrides (plugins.lua)
M.selection_plug = "#122244"
M.orange_plug = "#cc8877"
M.yellow_plug = "#bdb994"
M.yellow_faded_plug = "#7B6B3B"
M.purple_faded_plug = "#6A6CAB"
M.red_faded_plug = "#7F212A"
M.green_faded_plug = "#128A67"
M.blue_faded_plug = "#5171A1"

-- Tokyo Night accent colors (used by CmpItemKind, NavicIcons, etc.)
M.tokyo = {
  bg_dark = "#1c1f24",
  bg = "#24283b",
  bg_highlight = "#292e42",
  terminal_black = "#414868",
  fg = "#c0caf5",
  fg_dark = "#a9b1d6",
  fg_gutter = "#3b4261",
  dark3 = "#545c7e",
  comment = "#565f89",
  dark5 = "#737aa2",
  blue0 = "#3d59a1",
  blue = "#7aa2f7",
  cyan = "#7dcfff",
  blue1 = "#2ac3de",
  blue2 = "#0db9d7",
  blue5 = "#89ddff",
  blue6 = "#B4F9F8",
  blue7 = "#394b70",
  magenta = "#bb9af7",
  magenta2 = "#ff007c",
  purple = "#7d7cf8",
  orange = "#ff9e64",
  yellow = "#e0af68",
  green = "#9ece6a",
  green1 = "#73daca",
  green2 = "#41a6b5",
  teal = "#1abc9c",
  red = "#f7768e",
  red1 = "#db4b4b",
}

-- TSRainbow (shade_color -30, pre-computed)
M.rainbow_red = "#8e1914"
M.rainbow_yellow = "#966b17"
M.rainbow_blue = "#305d5f"
M.rainbow_orange = "#954109"
M.rainbow_green = "#486d4a"
M.rainbow_violet = "#7b445d"
M.rainbow_cyan = "#756b5c"

-- Nord3 brightened range (from nord-nvim.lua, pre-computed HSL)
M.nord3_brightened = {
  "#4D576A", -- nord3
  "#4E586E",
  "#505C71",
  "#535E74",
  "#566176",
  "#586279",
  "#5A657C",
  "#5B6780",
  "#5D6983",
  "#5F6D86",
  "#616F89",
  "#63728C",
  "#67738E",
  "#697691",
  "#6A7895",
  "#6E7B96",
  "#707E99",
  "#73819C",
  "#77839C",
  "#7A879F",
  "#7C89A2",
}

return M
