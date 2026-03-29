--- Highlight group definitions for the bars.nvim statusline.
--- Replicates the feline.nvim color scheme and adds
--- theme-specific highlight groups.

local M = {}

--- Base colors from feline config.
M.colors = {
  bg = "#282c34",
  fg = "#abb2bf",
  cyan = "#56b6f2",
  green = "#48a3a9",
  violet = "#6961c1",
  orange = "#d19a66",
  magenta = "#c678dd",
  blue = "#61afef",
  red = "#e86671",
  ruby = "#a026a6",
  yellow = "#e0af68",
  darkblue = "#081633",
  skyblue = "#68a9e0",
  oceanblue = "#2a52be",
  black = "#1e2127",
}

--- Define all highlight groups for the statusline.
function M.setup()
  ---|fS

  local c = M.colors
  local set = vim.api.nvim_set_hl

  ---------------------------------------------------------------------------
  -- Mode highlights
  ---------------------------------------------------------------------------

  set(0, "BarsSL_ModeNormal", { fg = c.cyan, bold = true })
  set(0, "BarsSL_ModeInsert", { fg = c.green, bold = true })
  set(0, "BarsSL_ModeVisual", { fg = c.violet, bold = true })
  set(0, "BarsSL_ModeReplace", { fg = c.red, bold = true })
  set(0, "BarsSL_ModeCommand", { fg = c.yellow, bold = true })
  set(0, "BarsSL_ModeSelect", { fg = c.magenta, bold = true })
  set(0, "BarsSL_ModeOp", { fg = c.ruby, bold = true })
  set(0, "BarsSL_ModeTerminal", { fg = c.yellow, bold = true })

  ---------------------------------------------------------------------------
  -- Component highlights (slashed / shared)
  ---------------------------------------------------------------------------

  set(0, "BarsSL_Project", { fg = "#ffffff", bg = "#3311bb" })
  set(0, "BarsSL_ProjectInactive", { fg = "#8899bb", bg = "#223355" })
  set(0, "BarsSL_ProjectLeftSep", { fg = "#ffffff", bg = "#224488", bold = true })
  set(0, "BarsSL_ProjectLeftSepInactive", { fg = "#ffffff", bg = "#333333", bold = true })
  set(0, "BarsSL_ProjectRightSep", { fg = "#3311bb", bg = c.oceanblue })

  set(0, "BarsSL_FileInfo", { fg = "#ffffff", bg = c.oceanblue, bold = true })
  set(0, "BarsSL_FileInfoLeftSep", { fg = c.oceanblue, bg = c.oceanblue })
  set(0, "BarsSL_FileInfoRightSep", { fg = c.oceanblue, bg = c.bg })

  set(0, "BarsSL_FileSize", { fg = c.fg, bg = c.bg })
  set(0, "BarsSL_Position", { fg = c.fg, bg = c.bg })
  set(0, "BarsSL_Ascii", { fg = "#486088", bg = c.bg })

  set(0, "BarsSL_LineCount", { fg = "#1177a2", bg = c.bg })
  set(0, "BarsSL_LineCountVisual", { fg = "#7187f2", bg = c.bg })

  set(0, "BarsSL_MiscStats", { fg = "#4488ff", bg = c.bg })
  set(0, "BarsSL_Filetype", { fg = "#988088", bg = c.bg })

  set(0, "BarsSL_GitBranch", { fg = "#3696c2", bg = c.bg, bold = true })
  set(0, "BarsSL_GitDiffAdd", { fg = "#129A77", bg = c.black })
  set(0, "BarsSL_GitDiffChange", { fg = "#6191f1", bg = c.black })
  set(0, "BarsSL_GitDiffRemove", { fg = "#8F313A", bg = c.black })

  set(0, "BarsSL_SearchCount", { fg = c.cyan, bg = c.black })
  set(0, "BarsSL_LinePct", { fg = "#4477aa", bg = c.bg })
  set(0, "BarsSL_ScrollBar", { fg = c.skyblue, bold = true })

  set(0, "BarsSL_ThinSep", { fg = "#3b4048", bg = c.bg })

  ---------------------------------------------------------------------------
  -- Bubble theme highlights
  ---------------------------------------------------------------------------

  local bubble_bg = "#32363e"
  set(0, "BarsSL_BubbleModeSepL", { fg = bubble_bg, bg = c.bg })
  set(0, "BarsSL_BubbleModeSepR", { fg = bubble_bg, bg = c.bg })
  set(0, "BarsSL_BubbleBuf", { fg = c.fg, bg = bubble_bg })
  set(0, "BarsSL_BubbleBufSepL", { fg = bubble_bg, bg = c.bg })
  set(0, "BarsSL_BubbleBufSepR", { fg = bubble_bg, bg = c.bg })
  set(0, "BarsSL_BubbleGit", { fg = "#3696c2", bg = bubble_bg, bold = true })
  set(0, "BarsSL_BubbleGitSepL", { fg = bubble_bg, bg = c.bg })
  set(0, "BarsSL_BubbleGitSepR", { fg = bubble_bg, bg = c.bg })
  set(0, "BarsSL_BubbleRuler", { fg = c.fg, bg = bubble_bg })
  set(0, "BarsSL_BubbleRulerSepL", { fg = bubble_bg, bg = c.bg })
  set(0, "BarsSL_BubbleRulerSepR", { fg = bubble_bg, bg = c.bg })

  ---------------------------------------------------------------------------
  -- Rainbow theme highlights
  ---------------------------------------------------------------------------

  set(0, "BarsSL_RainbowMode", { fg = "#ff6188", bg = c.bg, bold = true })
  set(0, "BarsSL_RainbowInsert", { fg = "#a9dc76", bg = c.bg, bold = true })
  set(0, "BarsSL_RainbowVisual", { fg = "#ab9df2", bg = c.bg, bold = true })
  set(0, "BarsSL_RainbowCommand", { fg = "#ffd866", bg = c.bg, bold = true })
  set(0, "BarsSL_RainbowFt", { fg = "#78dce8", bg = c.bg })
  set(0, "BarsSL_RainbowGit", { fg = "#fc9867", bg = c.bg, bold = true })
  set(0, "BarsSL_RainbowPos", { fg = "#a9dc76", bg = c.bg })

  ---------------------------------------------------------------------------
  -- Pure theme highlights
  ---------------------------------------------------------------------------

  set(0, "BarsSL_PureMode", { fg = c.fg, bg = c.bg, bold = true })
  set(0, "BarsSL_PurePath", { fg = c.fg, bg = c.bg, bold = true })
  set(0, "BarsSL_PureFt", { fg = "#777777", bg = c.bg })
  set(0, "BarsSL_PureGit", { fg = "#888888", bg = c.bg })
  set(0, "BarsSL_PurePos", { fg = "#666666", bg = c.bg })

  ---|fE
end

return M
