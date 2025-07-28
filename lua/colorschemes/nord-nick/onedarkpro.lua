local vaporwave_colors = {
  bg = "#222435",
  fg = "#B4B7CF",
  red = "#E16765",
  orange = "#EAA041",
  yellow = "#EAE852",
  green = "#75BE78",
  cyan = "#46A3AF",
  blue = "#25ABE4",
  purple = "#c678dd",
  white = "#B4B7CF",
  black = "#222435",
  gray = "#585B89",
  highlight = "#e2be7d",
  comment = "#7679A7",
  none = "NONE",

  -- codeblock = "require('onedarkpro.helpers').lighten('bg', 2, 'vaporwave')",
  -- statusline_bg = "require('onedarkpro.helpers').lighten('bg', 4, 'vaporwave')", -- gray
  -- statuscolumn_border = "require('onedarkpro.helpers').lighten('bg', 4, 'vaporwave')", -- gray
  -- ellipsis = "require('onedarkpro.helpers').lighten('bg', 4, 'vaporwave')", -- gray
  -- picker_results = "require('onedarkpro.helpers').darken('bg', 4, 'vaporwave')",
  -- picker_selection = "require('onedarkpro.helpers').darken('bg', 8, 'vaporwave')",
  -- copilot = "require('onedarkpro.helpers').darken('gray', 8, 'vaporwave')",
  -- breadcrumbs = "require('onedarkpro.helpers').darken('gray', 10, 'vaporwave')",
  -- light_gray = "require('onedarkpro.helpers').darken('gray', 7, 'vaporwave')",

  --  cursorline = colors.cursorline or color.lighten(colors.bg, 4),
  --  color_column = colors.color_column or color.lighten(colors.bg, 4),
  --  fold = colors.fold or color.lighten(colors.bg, 4),
  --  line_number = colors.line_number or color.lighten(colors.bg, 25),
  --  indentline = colors.indentline or color.lighten(colors.bg, 7),
  --  selection = colors.selection or color.lighten(colors.bg, 6),
  --  float_bg = colors.float_bg or color.darken(colors.bg, 3),
  --  inlay_hint = colors.inlay_hint or color.darken(colors.gray, 7),
  --
  --  -- Git colors
  --  git_add = colors.git_add or "#109868",
  --  git_change = colors.git_change or "#948B60",
  --  git_delete = colors.git_delete or "#9a353d",
  --
  --  git_hunk_add = colors.git_hunk_add or "#43554d",
  --  git_hunk_delete = colors.git_hunk_delete or "#502d30",
  --  git_hunk_add_inline = colors.git_hunk_add_inline or "#3f534f",
  --  git_hunk_change_inline = colors.git_hunk_change_inline or "#41483d",
  --  git_hunk_delete_inline = colors.git_hunk_delete_inline or "#6f2e2d",
  --
  --  -- Git diff
  --  diff_add = colors.diff_add or "#003e4a",
  --  diff_delete = colors.diff_delete or "#501b20",
  --  diff_text = colors.diff_text or "#005869",
  --
  --  -- Lualine colors
  --  bg_statusline = colors.bg_statusline or color.darken(colors.bg, 2.5),
  --  fg_gutter = colors.fg_gutter or color.lighten(colors.bg, 9.6),
  --  fg_gutter_inactive = colors.fg_gutter_inactive or colors.fg,
  --
  --  -- Virtual text
  --  virtual_text_error = colors.virtual_text_error or color.lighten(colors.red, 9.3),
  --  virtual_text_warning = colors.virtual_text_warning or color.lighten(colors.yellow, 9),
  --  virtual_text_information = colors.virtual_text_information or color.lighten(colors.blue, 10.2),
  --  virtual_text_hint = colors.virtual_text_hint or color.lighten(colors.cyan, 10.8),
}

local highlights = {
  CodeCompanionChatIcon = { fg = "${green}" },
  CodeCompanionChatToolFailure = { fg = "${gray}", italic = true },
  CodeCompanionChatToolSuccess = { fg = "${gray}", bg = "NONE", italic = true },
  CodeCompanionTokens = { fg = "${gray}", italic = true },
  CodeCompanionVirtualText = { fg = "${gray}", italic = true },

  ["@markup.raw.block.markdown"] = { bg = "${codeblock}" },
  ["@markup.quote.markdown"] = { italic = true, extend = true },

  EdgyNormal = { bg = "${bg}" },
  EdgyTitle = { fg = "${purple}", bold = true },

  EyelinerPrimary = { fg = "${green}" },
  EyelinerSecondary = { fg = "${blue}" },

  NormalFloat = { bg = "${bg}" }, -- Set the terminal background to be the same as the editor
  FloatBorder = { fg = "${gray}", bg = "${bg}" },

  CursorLineNr = { bg = "${bg}", fg = "${fg}", italic = true },
  MatchParen = { fg = "${cyan}" },
  ModeMsg = { fg = "${gray}" }, -- Make command line text lighter
  Search = { bg = "${selection}", fg = "${yellow}", underline = true },
  VimLogo = { fg = { dark = "#81b766", light = "#029632" } },

  -- Dashboard
  SnacksDashboardDesc = { fg = "${blue}", bold = true },
  SnacksDashboardKey = { fg = "${orange}", bold = true, italic = true },
  SnacksDashboardIcon = { fg = "${blue}" },

  -- Copilot
  CopilotSuggestion = { fg = "${copilot}", italic = true },

  -- DAP
  DebugBreakpoint = { fg = "${red}", italic = true },
  DebugHighlightLine = { fg = "${purple}", italic = true },
  NvimDapVirtualText = { fg = "${cyan}", italic = true },

  -- DAP UI
  DapUIBreakpointsCurrentLine = { fg = "${yellow}", bold = true },

  -- Heirline
  Heirline = { bg = "${statusline_bg}" },
  HeirlineStatusColumn = { fg = "${statuscolumn_border}" },
  HeirlineBufferline = { fg = { dark = "#939aa3", light = "#6a6a6a" } },
  HeirlineWinbar = { fg = "${breadcrumbs}", italic = true },
  HeirlineWinbarEmphasis = { fg = "${fg}", italic = true },

  -- Luasnip
  LuaSnipChoiceNode = { fg = "${yellow}" },
  LuaSnipInsertNode = { fg = "${yellow}" },

  -- Neotest
  NeotestAdapterName = { fg = "${purple}", bold = true },
  NeotestFocused = { bold = true },
  NeotestNamespace = { fg = "${blue}", bold = true },

  -- Nvim UFO
  UfoFoldedEllipsis = { fg = "${yellow}" },

  -- Snacks
  SnacksPicker = { bg = "${picker_results}" },
  SnacksPickerDir = { fg = "${gray}", italic = true },
  SnacksPickerBorder = { fg = "${picker_results}", bg = "${picker_results}" },
  SnacksPickerListCursorLine = { bg = "${picker_selection}" },
  SnacksPickerPrompt = { bg = "${picker_results}", fg = "${purple}", bold = true },
  SnacksPickerSelected = { bg = "${picker_results}", fg = "${orange}" },
  SnacksPickerTitle = { bg = "${purple}", fg = "${picker_results}", bold = true },
  SnacksPickerToggle = { bg = "${purple}", fg = "${picker_results}", italic = true },
  SnacksPickerTotals = { bg = "${picker_results}", fg = "${purple}", bold = true },
  SnacksPickerUnselected = { bg = "${picker_results}" },

  SnacksPickerPreview = { bg = "${bg}" },
  SnacksPickerPreviewBorder = { fg = "${bg}", bg = "${bg}" },
  SnacksPickerPreviewTitle = { bg = "${green}", fg = "${bg}", bold = true },

  -- Virt Column
  VirtColumn = { fg = "${indentline}" },
}

---Plugins
--    MCPHubNormal = { link = "Normal" },
--    MCPHubTitle = { fg = theme.palette.green },
--    MCPHubHeader = { fg = theme.palette.purple },
--    MCPHubHeaderShortcut = { fg = theme.palette.purple },
--    MCPHubHeaderBtn = { bg = theme.palette.purple, fg = theme.palette.bg, bold = true },
--    MCPHubHeaderBtnShortcut = { bg = theme.palette.purple, fg = theme.palette.bg, bold = true },
--    MCPHubMuted = { link = "Comment" },
--    MCPHubInfo = { fg = theme.palette.fg },
--    MCPHubSuccessFill = { bg = theme.palette.green, fg = theme.palette.bg },
--    MCPHubHeaderAccent = { bg = theme.palette.purple, fg = theme.palette.bg },
--
--    MCPHubSuccess = { fg = theme.palette.green },
--    MCPHubError = { fg = theme.palette.red },
--    MCPHubActiveItem = { bg = theme.palette.blue, fg = theme.palette.bg },

--    NeoTreeNormalNC = { -- Color when nvim-tree is no longer in focus
--        bg = config.options.transparency and "NONE"
--            or (config.options.highlight_inactive_windows and theme.generated.color_column or theme.palette.bg),
--    },
--    NeoTreeSymbolicLinkTarget = { fg = theme.palette.cyan },
--    NeoTreeDirectoryName = { fg = theme.palette.blue },
--    NeoTreeDirectoryIcon = { fg = theme.palette.purple },
--    NeoTreeRootName = { fg = theme.palette.purple },
--    NeoTreeFileIcon = { fg = theme.palette.blue },
--    NeoTreeFileName = { fg = theme.palette.fg },
--    NeoTreeFileNameOpened = { fg = theme.palette.purple },
--    NeoTreeIndentMarker = { fg = theme.palette.gray },
--    NeoTreeTitleBar = { fg = theme.palette.bg, bg = theme.palette.purple },
--    NeoTreeFloatTitle = { fg = theme.palette.bg, bg = theme.palette.purple },
--    NeoTreeGitAdded = { fg = theme.palette.green },
--    NeoTreeGitConflict = { fg = theme.palette.blue },
--    NeoTreeGitDeleted = { fg = theme.palette.red },
--    NeoTreeGitModified = { fg = theme.palette.yellow },
--    NeoTreeGitIgnored = { fg = theme.palette.gray },
--    NeoTreeGitUntracked = { fg = theme.palette.gray },
--    NeoTreeModified = { fg = theme.palette.red },
--    CodeCompanionChatHeader = { fg = theme.palette.purple, bold = true },
--    CodeCompanionChatSeparator = { fg = theme.palette.gray },
--    CodeCompanionChatTool = { fg = theme.palette.bg, bg = theme.palette.green },
--    CodeCompanionChatToolGroup = { fg = theme.palette.bg, bg = theme.palette.orange },
--    CodeCompanionChatVariable = { fg = theme.palette.bg, bg = theme.palette.blue },
