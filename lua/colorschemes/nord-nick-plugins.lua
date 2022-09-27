---@diagnostic disable undefined-global
--luacheck: ignore

local tokyoColors = {}

tokyoColors = {
  none = "NONE",
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
  purple = "#9d7cd8",
  orange = "#ff9e64",
  yellow = "#e0af68",
  green = "#9ece6a",
  green1 = "#73daca",
  green2 = "#41a6b5",
  teal = "#1abc9c",
  red = "#f7768e",
  red1 = "#db4b4b",
  git = { change = "#6183bb", add = "#449dab", delete = "#914c54", conflict = "#bb7a61" },
  gitSigns = { add = "#164846", change = "#394b70", delete = "#823c41" },
}

return function()
  local colors = {
    fg = "#C8D0E0",
    fg_light = "#E5E9F0",
    bg_dark = "#1c1f24",
    bg = "#2E3440",
    gray = "#646A76",
    light_gray = "#6C7A96",
    cyan = "#88C0D0",
    blue = "#81A1C1",
    dark_blue = "#5E81AC",
    green = "#A3BE8C",
    light_green = "#8FBCBB",
    dark_red = "#BF616A",
    red = "#D57780",
    light_red = "#DE878F",
    pink = "#E85B7A",
    dark_pink = "#E44675",
    orange = "#D08F70",
    yellow = "#EBCB8B",
    purple = "#B988B0",
    light_purple = "#B48EAD",
    none = "NONE",
  }

  local clr_over = {
    -- select ion = "#2F3243",
    -- -selection = "#0f2a56",
    selection = "#122244",
    orange = "#cc8877",
    yellow = "#bdb994",
    yellow_faded = "#7B6B3B",
    purple_faded = "#6A6CAB",
    red_faded = "#7F212A",
    green_faded = "#128A67",
    blue_faded = "#5171A1",
  }
  return {

    TaskFloat({ fg = "#9abcfb", gui = "bold" }),
    TaskFloatBorder({ fg = "#2151a1" }),

    -- +--- GitSigns ---+
    GitSignsAddFaded({ fg = clr_over.green_faded }),
    GitSignsAddNrFaded({ fg = clr_over.green_faded }),
    GitSignsAddLnFaded({ fg = clr_over.green_faded }),
    GitSignsChangeFaded({ fg = clr_over.yellow_faded }),
    GitSignsChangeNrFaded({ fg = clr_over.yellow_faded }),
    GitSignsChangeLnFaded({ fg = clr_over.yellow_faded }),
    GitSignsChangeDeleteFaded({ fg = clr_over.purple_faded }),
    GitSignsChangeDeleteNrFaded({ fg = clr_over.purple_faded }),
    GitSignsChangeDeleteLnFaded({ fg = clr_over.purple_faded }),
    GitSignsDeleteFaded({ fg = clr_over.red_faded }),
    GitSignsDeleteNrFaded({ fg = clr_over.red_faded }),
    GitSignsDeleteLnFaded({ fg = clr_over.red_faded }),

    -- +--- DAP ---+
    DAPLogPointSign({ fg = "#00f1f5" }),
    DAPBreakpointSign({ fg = "#4790ff" }),
    DAPStopSign({ fg = "#07ffc0" }),
    DAPStopSignText({ bg = "#280000" }),
    DapUIScope({ fg = "#00F1F5" }),
    DapUIType({ fg = "#74b4cF" }),
    DapUIDecoration({ fg = "#00F1F5" }),
    DapUIThread({ fg = "#A9FF68" }),
    DapUIStoppedThread({ fg = "#00f1f5" }),
    DapUISource({ fg = "#8484FF" }),
    DapUILineNumber({ fg = "#00f1f5" }),
    DapUIFloatBorder({ fg = "#00F1F5" }),
    DapUIWatchesHeader({ fg = "#00F1F5" }),
    DapUIWatchesEmpty({ fg = "#F70067" }),
    DapUIWatchesValue({ fg = "#A9FF68" }),
    DapUIWatchesError({ fg = "#F70067" }),
    DapUIBreakpointsPath({ fg = "#00F1F5" }),
    DapUIBreakpointsInfo({ fg = "#A9FF68" }),
    DapUIBreakpointsCurrentLine({ fg = "#A9FF68", gui = "bold" }),
    DapUIVariable({ fg = "#6484cF" }),
    -- DapUIFrameName { Normal },
    -- DapUIBreakpointsLive { DapUILineNumber },
    -- DapVariableTreeType { Comment },
    -- DapVariableTreeOperator { Operator },
    -- DapVariableTreeString { String },
    -- DapVariableTreeNumber { Number },

    -- +--- PackageInfo ---+
    PackageInfoOutdatedVersion({ fg = "#d19a66" }),
    PackageInfoUpToDateVersion({ fg = "#3C4048" }),
    SpecsCursor({ bg = "#274087" }),

    -- +--- Telescope ---+
    TelescopeNormal({ fg = "#6D779a", bg = "none" }),
    TelescopeBorder({ bg = "none" }),
    TelescopePrompt({ bg = "none" }),
    TelescopePromptNormal({ fg = "#2299cc", bg = "none" }),
    TelescopePromptBorder({ fg = "#2299cc", bg = "none" }),
    TelescopePromptPrefix({ fg = "#2977FF", bg = "none" }),
    -- fg_bg("TelescopePromptPrefix", red, black2)
    -- fg_bg("TelescopePromptTitle", black, red)
    TelescopeMultiIcon({ fg = "#0066ff" }),
    TelescopePreviewBorder({ fg = "#416191", bg = "none" }),
    TelescopeResults({ bg = "none" }),
    TelescopeResultsBorder({ fg = "#476F9F", bg = "none" }),
    TelescopeSelectionCaret({ fg = "#44c9fc" }),
    TelescopeSelection({ fg = "#28ddff", gui = "bold", bg = "#0f1a20" }), -- bg = "#202324"
    TelescopeMatching({ fg = "#7997FF", bg = "none" }),
    TelescopeFrecencyScores({ fg = "#34799c" }),
    TelescopeBufferLoaded({ fg = "#47a0f0" }),
    TelescopeMultiSelection({ fg = "#4060ff", gui = "italic" }),
    TelescopeTitle({ fg = "#2299ff", gui = "bold " }),
    TelescopePromptTitle({ bg = "none" }),
    TelescopePreviewTitle({ fg = "#47a0f0", bg = "none" }),
    TelescopeResultsTitle({ fg = "#64a9ec", bg = "none" }),
    -- TelescopePromptCounter { NonText },
    -- TelescopePathSeparator { fg = '#667788' },
    -- TelescopeQueryFilter { fg = '#4466FF'},
    -- TelescopeResultsIdentifier = {},
    -- TelescopeResultsComment = {},
    -- TelescopeMultiSelection guifg=#928374          " Multisections

    -- Folding Highlights
    -- UfoPreviewSbar({ PmenuSbar }),
    -- UfoPreviewThumb({ PmenuThumb }),
    -- UfoFoldedEllipsis({ Comment }),
    --- nvim-hlslens
    HlSearchLensCur({ fg = "#ff2266", bg = "#003333" }),
    HlSearchLens({ fg = "#00ddff", bg = "none" }),
    HlSearchCur({ fg = "#00ffdd", bg = "none" }),

    -- +--- CMP ---+

    --   " gray
    --   " {✅Class, ✅Module, ✅Interface, Struct, ✅Function, ✅Method, ✅Constructor,
    --   "  ✅Variable, ✅Property, Field, ✅Unit, Value, Enum, EnumMember, Event,
    --   "  ✅Keyword, Color, File, Reference, Folder, Constant, Operator, TypeParameter,
    --   "  ✅Snippet, ✅Text}
    CmpPmenu({ bg = "#242a30" }),
    CmpPmenuBorder({ bg = "#242a30" }),
    CmpItemAbbr({ fg = colors.fg }),
    CmpItemAbbrDeprecated({ fg = colors.fg, gui = "strikethrough" }),
    CmpItemAbbrMatch({ fg = colors.blue, gui = "bold" }),
    CmpItemAbbrMatchFuzzy({ fg = colors.blue, underline = true }),
    CmpItemMenu({ fg = colors.light_gray }),
    CmpItemKindText({ fg = colors.orange }),
    CmpItemKindMethod({ fg = colors.purple }),
    CmpItemKindFunction({ fg = colors.purple }),
    CmpItemKindConstructor({ fg = colors.yellow }),
    CmpItemKindField({ fg = colors.blue }),
    CmpItemKindClass({ fg = colors.yellow }),
    CmpItemKindInterface({ fg = colors.yellow }),
    CmpItemKindModule({ fg = colors.blue }),
    CmpItemKindProperty({ fg = colors.blue }),
    CmpItemKindValue({ fg = colors.orange }),
    CmpItemKindEnum({ fg = colors.yellow }),
    CmpItemKindKeyword({ fg = colors.purple }),
    CmpItemKindSnippet({ fg = colors.green }),
    CmpItemKindFile({ fg = colors.blue }),
    CmpItemKindEnumMember({ fg = colors.cyan }),
    CmpItemKindConstant({ fg = colors.orange }),
    CmpItemKindUnit({ fg = colors.orange }),
    CmpItemKindStruct({ fg = colors.yellow }),
    CmpItemKindTypeParameter({ fg = colors.yellow }),
    -- +--- Notify ---+
    NotifyTASKBorder({ fg = "#6a3246", bg = "none" }),
    NotifyTASKTitle({ fg = "#6a3246" }),
    NotifyTASKIcon({ fg = "#7a7697" }),
    NotifySTATUSBorder({ fg = "#3a3286", bg = "none" }),
    NotifySTATUSTitle({ fg = "#3a3286" }),
    NotifySTATUSIcon({ fg = "#2a76b7" }),
    NotifyINSPECTBorder({ fg = "#2A70fF", bg = "none" }),
    NotifyINSPECTIcon({ fg = "#67b0f7" }),
    NotifyINSPECTTitle({ fg = "#2760f7" }),
    NotifyINFOIcon({ fg = "#29cFa8" }),
    NotifyINFOTitle({ fg = "#29cFa8" }),
    NotifyINFOBorder({ fg = "#4Fa792", bg = "none" }),
    NotifyDEBUGBorder({ fg = "#4B4BBB" }),
    NotifyDEBUGIcon({ fg = "#6B6BFF" }),
    NotifyDEBUGTitle({ fg = "#6B6BFF" }),
    NotifyTRACEBorder({ fg = "#637699", bg = "none" }),
    -- NotifyTRACEBorder { fg = "#7B7BCC" },
    -- NotifyTRACEBorder { Normal },
    NotifyTRACEIcon({ fg = "#637699" }),
    NotifyTRACEBody({ fg = "#637699" }),
    -- NotifyTRACEIcon { fg = "#7BABFF" },
    NotifyTRACETitle({ fg = "#7BABFF" }),
    NotifyERRORBorder({ fg = "#8A1F1F", bg = "none" }),
    NotifyERRORIcon({ fg = "#F74047" }),
    NotifyERRORTitle({ fg = "#F74047" }),
    NotifyWARNBorder({ fg = "#79491D", bg = "none" }),
    NotifyWARNIcon({ fg = "#F79000" }),
    NotifyWARNTitle({ fg = "#F79000" }),
    -- NotifyINSPECTMsgArea{ Normal},
    -- NotifyERRORMsgArea { Normal },
    -- NotifyWARNMsgArea { Normal },
    -- NotifyINFOMsgArea { Normal },
    -- NotifyDEBUGMsgArea { Normal },
    -- NotifyTRACEMsgArea { Normal },
    -- NotifyERRORBorder = { fg = colors.error },
    -- NotifyWARNBorder = { fg = colors.warn },
    -- NotifyINFOBorder = { fg = colors.info },
    -- NotifyDEBUGBorder = { fg = colors.light_gray },
    -- NotifyTRACEBorder = { fg = colors.hint },
    -- NotifyERRORIcon = { fg = colors.error },
    -- NotifyWARNIcon = { fg = colors.warn },
    -- NotifyINFOIcon = { fg = colors.info },
    -- NotifyDEBUGIcon = { fg = colors.light_gray },
    -- NotifyTRACEIcon = { fg = colors.hint },
    -- NotifyERRORTitle = { fg = colors.error },
    -- NotifyWARNTitle = { fg = colors.warn },
    -- NotifyINFOTitle = { fg = colors.info },
    -- NotifyDEBUGTitle = { fg = colors.light_gray },
    -- NotifyTRACETitle = { fg = colors.hint },

    -- -- LspSaga
    -- LspFloatWinNormal = { fg = colors.fg, bg = colors.bg },
    -- LspFloatWinBorder = { fg = colors.purple },
    -- LspSagaDiagnosticBorder = { fg = colors.gray },
    -- LspSagaDiagnosticHeader = { fg = colors.blue },
    -- LspSagaDiagnosticTruncateLine = { fg = colors.highlight },
    -- LspSagaShTruncateLine = { fg = colors.highlight },
    -- LspSagaDocTruncateLine = { fg = colors.highlight },
    -- LspSagaBorderTitle = { fg = colors.cyan },
    -- LspSagaHoverBorder = { fg = colors.blue },
    -- LspSagaRenameBorder = { fg = colors.green },
    -- LspSagaDefPreviewBorder = { fg = colors.green },
    -- LspSagaCodeActionTitle = { fg = colors.blue },
    -- LspSagaCodeActionContent = { fg = colors.purple },
    -- LspSagaCodeActionBorder = { fg = colors.blue },
    -- LspSagaCodeActionTruncateLine = { fg = colors.highlight },
    -- LspSagaSignatureHelpBorder = { fg = colors.light_red },
    -- LspSagaFinderSelection = { fg = colors.green },
    -- LspSagaAutoPreview = { fg = colors.red },

    -- -- Trouble
    -- TroubleCount = { fg = colors.purple },
    -- TroubleNormal = { fg = colors.fg },
    -- TroubleText = { fg = colors.fg },

    -- -- Diff
    -- diffAdded = { fg = colors.diff_add },
    -- diffRemoved = { fg = colors.diff_remove },
    -- diffChanged = { fg = colors.diff_change },
    -- diffOldFile = { fg = colors.yellow },
    -- diffNewFile = { fg = colors.orange },
    -- diffFile = { fg = colors.blue },
    -- diffLine = { fg = colors.light_gray },
    -- diffIndexLine = { fg = colors.purple },

    -- -- Neogit
    -- NeogitBranch = { fg = colors.purple },
    -- NeogitRemote = { fg = colors.orange },
    -- NeogitHunkHeader = { fg = colors.fg, bg = colors.highlight },
    -- NeogitHunkHeaderHighlight = { fg = colors.yellow, bg = colors.highlight },
    -- NeogitDiffContextHighlight = { bg = colors.active },
    -- NeogitDiffDeleteHighlight = { fg = colors.diff_remove, bg = colors.diff_remove_bg },
    -- NeogitDiffAddHighlight = { fg = colors.diff_add, bg = colors.diff_add_bg },

    -- NeogitNotificationInfo = { fg = colors.info },
    -- NeogitNotificationWarning = { fg = colors.warn },
    -- NeogitNotificationError = { fg = colors.error },

    -- -- GitGutter
    -- GitGutterAdd = { fg = colors.diff_add }, -- diff mode: Added line |diff.txt|
    -- GitGutterChange = { fg = colors.diff_change }, -- diff mode: Changed line |diff.txt|
    -- GitGutterDelete = { fg = colors.diff_remove }, -- diff mode: Deleted line |diff.txt|

    -- -- GitSigns
    -- GitSignsAdd = { fg = colors.diff_add }, -- diff mode: Added line |diff.txt|
    -- GitSignsAddNr = { fg = colors.diff_add }, -- diff mode: Added line |diff.txt|
    -- GitSignsAddLn = { fg = colors.diff_add }, -- diff mode: Added line |diff.txt|
    -- GitSignsChange = { fg = colors.diff_change }, -- diff mode: Changed line |diff.txt|
    -- GitSignsChangeNr = { fg = colors.diff_change }, -- diff mode: Changed line |diff.txt|
    -- GitSignsChangeLn = { fg = colors.diff_change }, -- diff mode: Changed line |diff.txt|
    -- GitSignsDelete = { fg = colors.diff_remove }, -- diff mode: Deleted line |diff.txt|
    -- GitSignsDeleteNr = { fg = colors.diff_remove }, -- diff mode: Deleted line |diff.txt|
    -- GitSignsDeleteLn = { fg = colors.diff_remove }, -- diff mode: Deleted line |diff.txt|

    -- -- Telescope
    -- TelescopeNormal = { fg = colors.fg, bg = colors.bg },
    -- TelescopePromptPrefix = { fg = colors.purple },
    -- TelescopePromptBorder = { fg = colors.blue },
    -- TelescopeResultsBorder = { fg = colors.blue },
    -- TelescopePreviewBorder = { fg = colors.blue },
    -- TelescopeSelectionCaret = { fg = colors.cyan },
    -- TelescopeSelection = { fg = colors.cyan },
    -- TelescopeMatching = { fg = colors.yellow, gui = "bold" },

    -- -- NvimTree
    -- NvimTreeSymlink = { fg = colors.cyan, gui = "bold" },
    -- NvimTreeRootFolder = { fg = colors.green, gui = "bold" },
    -- NvimTreeFolderName = { fg = colors.blue },
    -- NvimTreeFolderIcon = { fg = colors.dark_blue },
    -- NvimTreeEmptyFolderName = { fg = colors.light_gray },
    -- NvimTreeOpenedFolderName = { fg = colors.yellow, gui = "italic" },
    -- NvimTreeIndentMarker = { fg = colors.blue },
    -- NvimTreeGitDirty = { fg = colors.yellow },
    -- NvimTreeGitNew = { fg = colors.diff_add },
    -- NvimTreeGitStaged = { fg = colors.purple },
    -- NvimTreeGitDeleted = { fg = colors.diff_remove },
    -- NvimTreeExecFile = { fg = colors.green, gui = "bold" },
    -- NvimTreeOpenedFile = { fg = colors.none },
    -- NvimTreeSpecialFile = { fg = colors.orange, gui = "underline" },
    -- NvimTreeImageFile = { fg = colors.purple, gui = "bold" },
    -- NvimTreeNormal = { fg = colors.fg, bg = colors.active },
    -- NvimTreeCursorLine = { bg = colors.float },
    -- NvimTreeVertSplit = { fg = colors.active, bg = colors.active },

    -- -- WhichKey
    --     WhichKey = { fg = clrs.accent, gui = "bold" },
    --     WhichKeyGroup = { fg = clrs.text },
    --     WhichKeyDesc = { fg = clrs.nord7, gui = "italic" },
    --     WhichKeySeperator = { fg = clrs.fg },
    --     WhichKeyFloating = { bg = clrs.float },
    --     WhichKeyFloat = { bg = clrs.float },
    WhichKey({ fg = "#f78077", gui = "bold" }), --Function
    WhichKeyGroup({ fg = "#619cf4" }), -- Keyword
    -- WhichKeyDesc  { fg = clrs.nord7, gui = "italic" }, -- Identifier
    -- WhichKeySeperator  { fg = clrs.fg }, -- DiffAdded
    WhichKeyFloat({ bg = NormalFloat.bg }), -- NormalFloat
    -- WhichKeyValue { bg = clrs.float }, -- Comment
    -- WhichKey = { fg = colors.purple, gui = "bold" },
    -- WhichKeyGroup = { fg = colors.cyan },
    -- WhichKeyDesc = { fg = colors.blue, gui = "italic" },
    -- WhichKeySeperator = { fg = colors.green },
    -- WhichKeyFloat = { bg = colors.active },

    -- -- BufferLine
    -- BufferLineIndicatorSelected = { fg = colors.yellow },
    -- BufferLineFill = { bg = colors.bg },

    -- -- barbar
    BufferCurrent({ fg = colors.fg, bg = "NONE" }),
    BufferCurrentIndex({ fg = colors.fg, bg = "NONE" }),
    BufferCurrentMod({ fg = colors.yellow, bg = "NONE", gui = "bold" }),
    BufferCurrentSign({ fg = colors.cyan, bg = "NONE" }),
    BufferCurrentTarget({ fg = colors.red, bg = "NONE", gui = "bold" }),
    BufferVisible({ fg = colors.fg, bg = "none" }),
    BufferVisibleIndex({ fg = colors.fg, bg = "none" }),
    BufferVisibleMod({ fg = colors.yellow, bg = "none", gui = "bold" }),
    BufferVisibleSign({ fg = colors.light_gray, bg = "none" }),
    BufferVisibleTarget({ fg = colors.red, bg = "none", gui = "bold" }),
    BufferInactive({ fg = colors.light_gray, bg = "#1C1F24" }),
    BufferInactiveIndex({ fg = colors.light_gray, bg = "#1C1F24" }),
    BufferInactiveMod({ fg = colors.yellow, bg = "#1C1F24" }),
    BufferInactiveSign({ fg = colors.light_gray, bg = "#1C1F24" }),
    BufferInactiveTarget({ fg = colors.red, bg = "#1C1F24", gui = "bold" }),
    TabLineFill({ fg = "NONE", bg = colors.bg }),
    -- TabLine({ fg = colors.bg, bg = colors.bg_dark }),
    -- TabLineSel({ fg = colors.bg, bg = colors.bg_dark }),

    -- -- Sneak
    -- Sneak = { fg = colors.bg, bg = colors.fg },
    -- SneakScope = { bg = colors.selection },

    -- -- Indent Blankline
    -- IndentBlanklineChar = { fg = colors.selection, gui = "nocombine" },
    -- IndentBlanklineContextChar = { fg = colors.purple, gui = "nocombine" },

    -- -- Nvim dap
    -- DapBreakpoint = { fg = colors.red },
    -- DapStopped = { fg = colors.green },

    -- -- Illuminate
    -- illuminatedWord = { bg = colors.highlight },
    -- illuminatedCurWord = { bg = colors.highlight },

    -- -- Hop
    -- HopNextKey = { fg = colors.fg_light, gui = "bold" },
    -- HopNextKey1 = { fg = colors.cyan, gui = "bold" },
    -- HopNextKey2 = { fg = colors.purple },
    -- HopUnmatched = { fg = colors.light_gray },

    -- -- Fern
    -- FernBranchText = { fg = colors.blue },

    -- -- Lightspeed
    -- LightspeedLabel = { fg = colors.pink, gui = "bold,underline" },
    -- LightspeedLabelOverlapped = { fg = colors.dark_pink, gui = "underline" },
    -- LightspeedLabelDistant = { fg = colors.cyan, gui = "bold,underline" },
    -- LightspeedLabelDistantOverlapped = { fg = colors.blue, gui = "underline" },
    -- LightspeedShortcut = { fg = "#E5E9F0", bg = colors.pink, gui = "bold,underline" },
    -- LightspeedMaskedChar = { fg = colors.light_purple },
    -- LightspeedGreyWash = { fg = colors.gray },
    -- LightspeedUnlabeledMatch = { fg = colors.fg_light, gui = "bold" },
    -- LightspeedOneCharMatch = { fg = colors.yellow, gui = "bold,reverse" },
  }

  --   OctoDirty	ErrorMsg
  --   OctoIssueTitle	PreProc
  --   OctoIssueId	Question
  --   OctoEmpty	Comment
  --   OctoFloat	NormalNC
  --   OctoDate	Comment
  --   OctoSymbol	Comment
  --   OctoTimelineItemHeading	Comment
  --   OctoDetailsLabel	Title
  --   OctoMissingDetails	Comment
  --   OctoDetailsValue	Identifier
  --   OctoDiffHunkPosition	NormalFloat
  --   OctoCommentLine	TabLineSel
  --   OctoEditable	NormalFloat
  --   OctoViewer	GitHub color
  --   OctoBubble	NormalFloat
  --   OctoBubbleGreen	GitHub color
  --   OctoBubbleRed	GitHub color
  --   OctoUser	OctoBubble
  --   OctoUserViewer	OctoViewer
  --   OctoReaction	OctoBubble
  --   OctoReactionViewer	OctoViewer
  --   OctoPassingTest	GitHub color
  --   OctoFailingTest	GitHub color
  --   OctoPullAdditions	GitHub color
  --   OctoPullDeletions	GitHub color
  --   OctoPullModifications	GitHub color
  --   OctoStateOpen	GitHub color
  --   OctoStateClosed	GitHub color
  --   OctoStateMerge	GitHub color
  --   OctoStatePending	GitHub color
  --   OctoStateApproved	OctoStateOpen
  --   OctoStateChangesRequested	OctoStateClosed
  --   OctoStateCommented	Normal
  --   OctoStateDismissed	OctoStateClosed

  -- DiffAdd {
  --   fg = clrs.nord14,
  --   bg = cfg.nord_uniform_diff_background == 0 and clrs.nord0 or clrs.nord1,
  --   gui = spec.inverse,
  -- },
  -- DiffChange {
  --   fg = clrs.nord13,
  --   bg = cfg.nord_uniform_diff_background == 0 and clrs.nord0 or clrs.nord1,
  --   gui = spec.inverse,
  -- },
  -- DiffDelete {
  --   fg = clrs.nord11,
  --   bg = cfg.nord_uniform_diff_background == 0 and clrs.nord0 or clrs.nord1,
  --   gui = spec.inverse,
  -- },
  -- DiffText {
  --   fg = clrs.nord9,
  --   bg = cfg.nord_uniform_diff_background == 0 and clrs.nord0 or clrs.nord1,
  --   gui = spec.inverse,
  -- },

  -- gitDiff, gitcommitDiff, gitDiffMerge, gitDiffRemoved
  -- DiffAdd        xxx ctermbg=4 guibg=#00361f
  -- DiffviewDiffAddAsDelete xxx guibg=#3E0009
  --
  -- DiffviewDim1   xxx guifg=#495a74
  -- DiffviewPrimary xxx guifg=#6e99c6
  -- DiffviewNormal xxx links to Normal
  -- DiffviewSecondary xxx guifg=#5679b3
  -- DiffviewNonText xxx links to NonText
  -- DiffviewSignColumn xxx links to Normal
  -- DiffviewDiffDelete xxx links to Comment
  -- DiffviewFolderSign xxx links to PreProc
  -- DiffviewVertSplit xxx links to VertSplit
  -- DiffviewDiffAddAsDelete xxx guibg=#3E0009
  -- DiffviewFolderName xxx links to Directory
  -- DiffviewCursorLine xxx links to CursorLine
  -- DiffviewStatusLine xxx links to StatusLine
  -- DiffviewStatusAdded xxx links to diffAdded
  -- DiffviewFilePanelPath xxx links to Comment
  -- DiffviewStatusIgnored xxx links to Comment
  -- DiffviewFilePanelFileName xxx guifg=#8396B9
  -- DiffviewEndOfBuffer xxx links to EndOfBuffer
  -- DiffviewStatusCopied xxx links to diffChanged
  -- DiffviewStatusBroken xxx links to diffRemoved
  -- DiffviewStatusRenamed xxx links to diffChanged
  -- DiffviewStatusLineNC xxx links to StatusLineNC
  -- DiffviewStatusUntracked xxx links to diffAdded
  -- DiffviewStatusDeleted xxx links to diffRemoved
  -- DiffviewStatusUnknown xxx links to diffRemoved
  -- DiffviewStatusModified xxx links to diffChanged
  -- DiffviewStatusUnmerged xxx links to diffChanged
  -- DiffviewFilePanelTitle xxx gui=bold guifg=#187298
  -- DiffviewStatusTypeChange xxx links to diffChanged
  -- DiffviewFilePanelInsertions xxx links to diffAdded
  -- DiffviewFilePanelCounter xxx gui=bold guifg=#6e99c6
  -- DiffviewFilePanelDeletions xxx links to diffRemoved
  -- DiffviewFilePanelRootPath xxx links to
  -- DiffviewFilePanelTitle
  -- DiffviewDim1   xxx guifg=#495a74 DiffviewPrimary xxx guifg=#6e99c6 DiffviewNormal xxx links to Normal DiffviewSecondary xxx guifg=#5679b3 DiffviewNonText xxx links to NonText DiffviewSignColumn xxx links to Normal DiffviewDiffDelete xxx links to Comment DiffviewFolderSign xxx links to PreProc DiffviewVertSplit xxx links to VertSplit DiffviewDiffAddAsDelete xxx guibg=#3E0009 DiffviewFolderName xxx links to Directory DiffviewCursorLine xxx links to CursorLine DiffviewStatusLine xxx links to StatusLine DiffviewStatusAdded xxx links to diffAdded DiffviewFilePanelPath xxx links to Comment DiffviewStatusIgnored xxx links to Comment DiffviewFilePanelFileName xxx guifg=#8396B9 DiffviewEndOfBuffer xxx links to EndOfBuffer gitDiff        xxx cleared gitDiffMerge   xxx cleared gitcommitDiff  xxx cleared

  -- -- Neogit
  -- NeogitBranch = { fg = clrs.nord10 },
  -- NeogitRemote = { fg = clrs.nord9 },
  -- NeogitHunkHeader = { fg = clrs.fg, bg = clrs.highlight },
  -- NeogitHunkHeaderHighlight = { fg = clrs.nord7, bg = clrs.contrast },
  -- NeogitDiffContextHighlight = { fg = clrs.bg_alt, bg = clrs.contrast },
  -- NeogitDiffDeleteHighlight = { fg = clrs.nord11 },
  -- NeogitDiffAddHighlight = { fg = clrs.nord14 },
  -- -- GitGutter
  -- GitGutterAdd = { fg = clrs.nord14 }, -- diff mode: Added line |diff.txt|
  -- GitGutterChange = { fg = clrs.nord15 }, -- diff mode: Changed line |diff.txt|
  -- GitGutterDelete = { fg = clrs.nord11 }, -- diff mode: Deleted line |diff.txt|
  -- -- GitSigns
  -- GitSignsAdd = { fg = clrs.nord14 }, -- diff mode: Added line |diff.txt|
  -- GitSignsAddNr = { fg = clrs.nord14 }, -- diff mode: Added line |diff.txt|
  -- GitSignsAddLn = { fg = clrs.nord14 }, -- diff mode: Added line |diff.txt|
  -- GitSignsChange = { fg = clrs.nord15 }, -- diff mode: Changed line |diff.txt|
  -- GitSignsChangeNr = { fg = clrs.nord15 }, -- diff mode: Changed line |diff.txt|
  -- GitSignsChangeLn = { fg = clrs.nord15 }, -- diff mode: Changed line |diff.txt|
  -- GitSignsDelete = { fg = clrs.nord11 }, -- diff mode: Deleted line |diff.txt|
  -- GitSignsDeleteNr = { fg = clrs.nord11 }, -- diff mode: Deleted line |diff.txt|
  -- GitSignsDeleteLn = { fg = clrs.nord11 }, -- diff mode: Deleted line |diff.txt|
  -- -- Telescope
  -- TelescopePromptBorder = { fg = clrs.nord8 },
  -- TelescopeResultsBorder = { fg = clrs.nord9 },
  -- TelescopePreviewBorder = { fg = clrs.nord14 },
  -- TelescopeSelectionCaret = { fg = clrs.nord9 },
  -- TelescopeSelection = { fg = clrs.nord9 },
  -- TelescopeMatching = { fg = clrs.nord8 },
  -- TelescopeNormal = { fg = clrs.fg, bg = clrs.float },
  -- -- NvimTree
  -- NvimTreeRootFolder = { fg = clrs.nord7, gui = "bold" },
  -- NvimTreeGitDirty = { fg = clrs.nord15 },
  -- NvimTreeGitNew = { fg = clrs.nord14 },
  -- NvimTreeImageFile = { fg = clrs.nord15 },
  -- NvimTreeExecFile = { fg = clrs.nord14 },
  -- NvimTreeSpecialFile = { fg = clrs.nord9, gui = spec.underline },
  -- NvimTreeFolderName = { fg = clrs.nord10 },
  -- NvimTreeEmptyFolderName = { fg = clrs.disabled },
  -- NvimTreeFolderIcon = { fg = clrs.accent },
  -- NvimTreeIndentMarker = { fg = clrs.disabled },
  -- -- WhichKey
  -- WhichKey = { fg = clrs.accent, gui = "bold" },
  -- WhichKeyGroup = { fg = clrs.text },
  -- WhichKeyDesc = { fg = clrs.nord7, gui = "italic" },
  -- WhichKeySeperator = { fg = clrs.fg },
  -- WhichKeyFloating = { bg = clrs.float },
  -- WhichKeyFloat = { bg = clrs.float },
end

--   colors.bg = "#1a1b26"
--   colors.bg_dark = "#16161e"
-- colors.diff = {
--   add = util.darken(colors.green2, 0.15),
--   delete = util.darken(colors.red1, 0.15),
--   change = util.darken(colors.blue7, 0.15),
--   text = colors.blue7,
-- }
-- colors.git.ignore = colors.dark3
-- colors.black = util.darken(colors.bg, 0.8, "#000000")
-- colors.border_highlight = colors.blue0
-- colors.border = colors.black
-- -- Popups and statusline always get a dark background
-- colors.bg_popup = colors.bg_dark
-- colors.bg_statusline = colors.bg_dark
-- -- Sidebar and Floats are configurable
-- colors.bg_sidebar = (config.transparentSidebar and colors.none) or config.darkSidebar and colors.bg_dark or colors.bg
-- colors.bg_float = config.darkFloat and colors.bg_dark or colors.bg
-- colors.bg_visual = util.darken(colors.blue0, 0.7)
-- colors.bg_search = colors.blue0
-- colors.fg_sidebar = colors.fg_dark
-- colors.error = colors.red1
-- colors.warning = colors.yellow
-- colors.info = colors.blue2
-- colors.hint = colors.teal
-- util.color_overrides(colors, config)

-- local function remove_background(group)
--   group["bg"] = colors.none
-- end

-- local function load_syntax()
--   -- Syntax highlight groups

--   local syntax = {
--     -- int, long, char, etc.
--     Type = { fg = colors.yellow },
--     -- static, register, volatile, etc.
--     StorageClass = { fg = colors.purple },
--     -- struct, union, enum, etc.
--     Structure = { fg = colors.purple },
--     -- any constant
--     Constant = { fg = colors.blue },
--     -- any character constant: 'c', '\n'
--     Character = { fg = colors.green },
--     -- a number constant: 5
--     Number = { fg = colors.orange },
--     -- a boolean constant: TRUE, false
--     Boolean = { fg = colors.orange },
--     -- a floating point constant: 2.3e10
--     Float = { fg = colors.orange },
--     -- any statement
--     Statement = { fg = colors.purple },
--     -- case, default, etc.
--     Label = { fg = colors.purple },
--     -- sizeof", "+", "*", etc.
--     Operator = { fg = colors.purple },
--     -- try, catch, throw
--     Exception = { fg = colors.purple },
--     -- generic Preprocessor
--     PreProc = { fg = colors.purple },
--     -- preprocessor #include
--     Include = { fg = colors.blue },
--     -- preprocessor #define
--     Define = { fg = colors.red },
--     -- same as Define
--     Macro = { fg = colors.red },
--     -- A typedef
--     Typedef = { fg = colors.purple },
--     -- preprocessor #if, #else, #endif, etc.
--     PreCondit = { fg = colors.purple },
--     -- any special symbol
--     Special = { fg = colors.light_red },
--     -- special character in a constant
--     SpecialChar = { fg = colors.light_red },
--     -- you can use CTRL-] on this
--     Tag = { fg = colors.green },
--     -- character that needs attention like , or .
--     Delimiter = { fg = colors.dark_blue },
--     -- special things inside a comment
--     SpecialComment = { fg = colors.light_gray },
--     -- debugging statements
--     Debug = { fg = colors.yellow },
--     -- text that stands out, HTML links
--     Underlined = { fg = colors.green, gui = "underline" },
--     -- left blank, hidden
--     Ignore = { fg = colors.cyan, bg = colors.bg, gui = "bold" },
--     -- any erroneous construct
--     Error = { fg = colors.error, bg = colors.none, gui = "bold,underline" },
--     -- anything that needs extra attention; mostly the keywords TODO FIXME and XXX
--     Todo = { fg = colors.yellow, bg = colors.none, gui = "bold,italic" },
--     Comment = { fg = colors.light_gray, gui = config.styles.comments }, -- normal comments
--     -- normal if, then, else, endif, switch, etc.
--     Conditional = { fg = colors.purple, gui = config.styles.keywords },
--     -- normal for, do, while, etc.
--     Keyword = { fg = colors.purple, gui = config.styles.keywords },
--     -- normal any other keyword
--     Repeat = { fg = colors.purple, gui = config.styles.keywords },
--     -- normal function names
--     Function = { fg = colors.blue, gui = config.styles.functions },
--     -- any variable name
--     Identifier = { fg = colors.fg, gui = config.styles.variables },
--     -- any string
--     String = { fg = colors.green, config.styles.strings },

--     htmlLink = { fg = colors.green, gui = "underline" },
--     htmlH1 = { fg = colors.cyan, gui = "bold" },
--     htmlH2 = { fg = colors.red, gui = "bold" },
--     htmlH3 = { fg = colors.green, gui = "bold" },
--     htmlH4 = { fg = colors.yellow, gui = "bold" },
--     htmlH5 = { fg = colors.purple, gui = "bold" },

--     markdownBlockquote = { fg = colors.light_gray },
--     markdownBold = { fg = colors.purple, gui = "bold" },
--     markdownCode = { fg = colors.green },
--     markdownCodeBlock = { fg = colors.green },
--     markdownCodeDelimiter = { fg = colors.green },
--     markdownH1 = { fg = colors.dark_blue, gui = "bold" },
--     markdownH2 = { fg = colors.blue, gui = "bold" },
--     markdownH3 = { fg = colors.cyan, gui = "bold" },
--     markdownH4 = { fg = colors.light_green },
--     markdownH5 = { fg = colors.light_green },
--     markdownH6 = { fg = colors.light_green },
--     markdownH1Delimiter = { fg = colors.dark_blue },
--     markdownH2Delimiter = { fg = colors.blue },
--     markdownH3Delimiter = { fg = colors.cyan },
--     markdownH4Delimiter = { fg = colors.light_green },
--     markdownH5Delimiter = { fg = colors.light_green },
--     markdownH6Delimiter = { fg = colors.light_green },
--     markdownId = { fg = colors.yellow },
--     markdownIdDeclaration = { fg = colors.purple },
--     markdownIdDelimiter = { fg = colors.light_gray },
--     markdownLinkDelimiter = { fg = colors.light_gray },
--     markdownItalic = { fg = colors.yellow, gui = "italic" },
--     markdownLinkText = { fg = colors.purple },
--     markdownListMarker = { fg = colors.red },
--     markdownOrderedListMarker = { fg = colors.red },
--     markdownRule = { fg = colors.purple },
--     markdownUrl = { fg = colors.cyan, gui = "underline" },
--   }

--   return syntax
-- end

-- local function load_editor()
--   -- Editor highlight groups

--   local editor = {
--     -- normal text and background color for floating windows
--     NormalFloat = { fg = colors.fg, bg = colors.active },
--     -- floating window border
--     FloatBorder = { fg = colors.blue, bg = colors.active },
--     -- used for the columns set with 'colorcolumn'
--     ColorColumn = { fg = colors.none, bg = colors.float },
--     -- placeholder characters substituted for concealed text (see 'conceallevel')
--     Conceal = { bg = colors.bg },
--     -- the character under the cursor
--     Cursor = { fg = colors.fg, bg = colors.none, gui = "reverse" },
--     -- like Cursor, but used when in IME mode
--     CursorIM = { fg = colors.fg, bg = colors.none, gui = "reverse" },
--     -- directory names (and other special names in listings)
--     Directory = { fg = colors.blue, bg = colors.none },
--     -- diff mode: Added line
--     DiffAdd = { fg = colors.none, bg = colors.diff_add_bg },
--     -- diff mode: Changed line
--     DiffChange = { fg = colors.none, bg = colors.diff_change_bg },
--     -- diff mode: Deleted line
--     DiffDelete = { fg = colors.none, bg = colors.diff_remove_bg },
--     -- diff mode: Changed text within a changed line
--     DiffText = { fg = colors.none, bg = colors.diff_text_bg },
--     -- error messages
--     ErrorMsg = { fg = colors.error },
--     -- line used for closed folds
--     Folded = { fg = colors.dark_blue, bg = colors.none, gui = "italic" },
--     -- 'foldcolumn'
--     FoldColumn = { fg = colors.light_gray },
--     -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
--     IncSearch = { fg = colors.yellow, bg = colors.selection, gui = "bold,underline" },
--     -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
--     LineNr = { fg = colors.light_gray },
--     -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
--     CursorLineNr = { fg = colors.fg },
--     -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
--     MatchParen = { fg = colors.yellow, bg = colors.none, gui = "bold" },
--     -- 'showmode' message (e.g., "-- INSERT -- ")
--     ModeMsg = { fg = colors.blue, gui = "bold" },
--     -- |more-prompt|
--     MoreMsg = { fg = colors.blue, gui = "bold" },
--     -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist
--     -- in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line).
--     -- See also |hl-EndOfBuffer|.
--     NonText = { fg = colors.gray },
--     -- normal item |hl-Pmenu|
--     Pmenu = { fg = colors.fg, bg = colors.float },
--     -- selected item |hl-PmenuSel|
--     PmenuSel = { bg = colors.selection },
--     -- scrollbar |hl-PmenuSbar|
--     PmenuSbar = { bg = colors.float },
--     -- thumb of the scrollbar  |hl-PmenuThumb|
--     PmenuThumb = { bg = colors.fg },
--     -- |hit-enter| prompt and yes/no questions
--     Question = { fg = colors.green },
--     -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
--     QuickFixLine = { bg = colors.float, gui = "bold,italic" },
--     -- Line numbers for quickfix lists
--     qfLineNr = { fg = colors.purple },
--     -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
--     Search = { fg = colors.blue, bg = colors.selection, gui = "bold" },
--     -- Unprintable characters: text displayed differently from what it really is.
--     -- But not 'listchars' whitespace. |hl-Whitespace|
--     SpecialKey = { fg = colors.dark_blue },
--     -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
--     SpellBad = { fg = colors.red, bg = colors.none, gui = "italic,underline", sp = colors.red },
--     -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
--     SpellCap = { fg = colors.yellow, bg = colors.none, gui = "italic,underline", sp = colors.yellow },
--     -- Word that is recognized by the spellchecker as one that is used in another region.
--     -- |spell| Combined with the highlighting used otherwise.
--     SpellLocal = { fg = colors.cyan, bg = colors.none, gui = "italic,underline", sp = colors.cyan },
--     -- Word that is recognized by the spellchecker as one that is hardly ever used.
--     -- |spell| Combined with the highlighting used otherwise.
--     SpellRare = { fg = colors.purple, bg = colors.none, gui = "italic,underline", sp = colors.purple },
--     -- status line of current window
--     StatusLine = { fg = colors.fg, bg = colors.active },
--     -- status lines of not-current windows Note: if this is equal to "StatusLine"
--     -- Vim will use "^^^" in the status line of the current window.
--     StatusLineNC = { fg = colors.light_gray, bg = colors.active },
--     -- status line of current terminal window
--     StatusLineTerm = { fg = colors.fg, bg = colors.active },
--     -- status lines of not-current terminal windows Note: if this is equal to "StatusLine"
--     -- Vim will use "^^^" in the status line of the current window.
--     StatusLineTermNC = { fg = colors.light_gray, bg = colors.active },
--     -- tab pages line, where there are no labels
--     TabLineFill = { fg = colors.light_gray, bg = colors.active },
--     -- tab pages line, active tab page label
--     TablineSel = { fg = colors.cyan, bg = colors.bg },
--     Tabline = { fg = colors.light_gray, bg = colors.active },
--     -- titles for output from ":set all", ":autocmd" etc.
--     Title = { fg = colors.green, bg = colors.none, gui = "bold" },
--     -- Visual mode selection
--     Visual = { fg = colors.none, bg = colors.highlight },
--     -- Visual mode selection when vim is "Not Owning the Selection".
--     VisualNOS = { fg = colors.none, bg = colors.highlight },
--     -- warning messages
--     WarningMsg = { fg = colors.warn },
--     -- "nbsp", "space", "tab" and "trail" in 'listchars'
--     Whitespace = { fg = colors.gray },
--     -- current match in 'wildmenu' completion
--     WildMenu = { fg = colors.yellow, bg = colors.none, gui = "bold" },
--     -- Screen-column at the cursor, when 'cursorcolumn' is set.
--     CursorColumn = { fg = colors.none, bg = colors.float },
--     -- Screen-line at the cursor, when 'cursorline' is set. Low-priority if foreground (ctermfg OR guifg) is not set.
--     CursorLine = { fg = colors.none, bg = colors.active },
--     -- Normal mode message in the cmdline
--     NormalMode = { fg = colors.cyan, bg = colors.none, gui = "reverse" },
--     -- Insert mode message in the cmdline
--     InsertMode = { fg = colors.green, bg = colors.none, gui = "reverse" },
--     -- Replace mode message in the cmdline
--     ReplacelMode = { fg = colors.red, bg = colors.none, gui = "reverse" },
--     -- Visual mode message in the cmdline
--     VisualMode = { fg = colors.purple, bg = colors.none, gui = "reverse" },
--     -- Command mode message in the cmdline
--     CommandMode = { fg = colors.yellow, bg = colors.none, gui = "reverse" },
--     Warnings = { fg = colors.warn },

--     healthError = { fg = colors.error },
--     healthSuccess = { fg = colors.green },
--     healthWarning = { fg = colors.warn },

--     -- Dashboard
--     DashboardShortCut = { fg = colors.cyan },
--     DashboardHeader = { fg = colors.blue },
--     DashboardCenter = { fg = colors.purple },
--     DashboardFooter = { fg = colors.green, gui = "italic" },

--     -- normal text and background color
--     Normal = { fg = colors.fg, bg = colors.bg },
--     NormalNC = { bg = colors.bg },
--     SignColumn = { fg = colors.fg, bg = colors.none },

--     -- the column separating vertically split windows
--     VertSplit = { fg = colors.bg },

--     EndOfBuffer = { fg = colors.gray },
--   }

--   -- Options:

--   -- Set non-current background
--   if config.fade_nc then
--     editor.NormalNC["bg"] = colors.active
--     editor.NormalFloat["bg"] = colors.bg
--     editor.FloatBorder["bg"] = colors.bg
--   end

--   -- Set transparent background
--   if config.disable.background then
--     remove_background(editor.Normal)
--     remove_background(editor.NormalNC)
--     remove_background(editor.SignColumn)
--   end

--   -- Set transparent cursorline
--   if config.disable.cursorline then
--     remove_background(editor.CursorLine)
--   end

--   -- Set transparent eob lines
--   if config.disable.eob_lines then
--     editor.EndOfBuffer["fg"] = colors.bg
--   end

--   -- Add window split borders
--   if config.borders then
--     editor.VertSplit["fg"] = colors.selection
--   end

--   return editor
-- end

-- local function load_treesitter()
--   -- TreeSitter highlight groups

--   local treesitter = {
--     -- Annotations that can be attached to the code to denote some kind of meta information. e.g. C++/Dart attributes.
--     TSAttribute = { fg = colors.purple },
--     -- Boolean literals: `True` and `False` in Python.
--     TSBoolean = { fg = colors.orange },
--     -- Character literals: `'a'` in C.
--     TSCharacter = { fg = colors.green },
--     -- Line comments and block comments.
--     TSComment = { fg = colors.light_gray, gui = config.styles.comments },
--     -- Keywords related to conditionals: `if`, `when`, `cond`, etc.
--     TSConditional = { fg = colors.purple, gui = config.styles.keywords },
--     -- Constants identifiers. These might not be semantically constant. E.g. uppercase variables in Python.
--     TSConstant = { fg = colors.cyan },
--     -- Built-in constant values: `nil` in Lua.
--     TSConstBuiltin = { fg = colors.orange },
--     -- Constants defined by macros: `NULL` in C.
--     TSConstMacro = { fg = colors.red },
--     -- Constructor calls and definitions: `{}` in Lua, and Java constructors.
--     TSConstructor = { fg = colors.yellow },
--     -- Syntax/parser errors. This might highlight large sections of code while the user is typing
--     -- still incomplete code, use a sensible highlight.
--     TSError = { fg = colors.error },
--     -- Exception related keywords: `try`, `except`, `finally` in Python.
--     TSException = { fg = colors.purple },
--     -- Object and struct fields.
--     TSField = { fg = colors.blue },
--     -- Floating-point number literals.
--     TSFloat = { fg = colors.orange },
--     -- Function calls and definitions.
--     TSFunction = { fg = colors.blue, gui = config.styles.functions },
--     -- Built-in functions: `print` in Lua.
--     TSFuncBuiltin = { fg = colors.cyan, gui = config.styles.functions },
--     -- Macro defined functions (calls and definitions): each `macro_rules` in Rust.
--     TSFuncMacro = { fg = colors.blue },
--     -- File or module inclusion keywords: `#include` in C, `use` or `extern crate` in Rust.
--     TSInclude = { fg = colors.blue },
--     -- Keywords that don't fit into other categories.
--     TSKeyword = { fg = colors.purple, gui = config.styles.keywords },
--     -- Keywords used to define a function: `function` in Lua, `def` and `lambda` in Python.
--     TSKeywordFunction = { fg = colors.purple, gui = config.styles.keywords },
--     -- Unary and binary operators that are English words: `and`, `or` in Python; `sizeof` in C.
--     TSKeywordOperator = { fg = colors.purple },
--     -- Keywords like `return` and `yield`.
--     TSKeywordReturn = { fg = colors.purple },
--     -- GOTO labels: `label:` in C, and `::label::` in Lua.
--     TSLabel = { fg = colors.purple },
--     -- Method calls and definitions.
--     TSMethod = { fg = colors.blue, gui = config.styles.functions },
--     -- Identifiers referring to modules and namespaces.
--     TSNamespace = { fg = colors.yellow },
--     -- Numeric literals that don't fit into other categories.
--     TSNumber = { fg = colors.orange },
--     -- Binary or unary operators: `+`, and also `->` and `*` in C.
--     TSOperator = { fg = colors.purple },
--     -- Parameters of a function.
--     TSParameter = { fg = colors.red },
--     -- References to parameters of a function.
--     TSParameterReference = { fg = colors.red },
--     -- Same as `TSField`.
--     TSProperty = { fg = colors.blue },
--     -- Punctuation delimiters: Periods, commas, semicolons, etc.
--     TSPunctDelimiter = { fg = colors.dark_blue },
--     -- Brackets, braces, parentheses, etc.
--     TSPunctBracket = { fg = colors.dark_blue },
--     -- Special punctuation that doesn't fit into the previous categories.
--     TSPunctSpecial = { fg = colors.dark_blue },
--     -- Keywords related to loops: `for`, `while`, etc.
--     TSRepeat = { fg = colors.purple, gui = config.styles.keywords },
--     -- String literals.
--     TSString = { fg = colors.green, gui = config.styles.strings },
--     -- Regular expression literals.
--     TSStringRegex = { fg = colors.orange },
--     -- Escape characters within a string: `\n`, `\t`, etc.
--     TSStringEscape = { fg = colors.orange },
--     -- Identifiers referring to symbols or atoms.
--     TSSymbol = { fg = colors.cyan },
--     -- Tags like HTML tag names.
--     TSTag = { fg = colors.yellow },
--     -- HTML tag attributes.
--     TSTagAttribute = { fg = colors.blue },
--     -- Tag delimiters like `<` `>` `/`.
--     TSTagDelimiter = { fg = colors.dark_blue },
--     -- Non-structured text. Like text in a markup language.
--     TSText = { fg = colors.fg },
--     -- Text to be represented in bold.
--     TSStrong = { fg = colors.purple, gui = "bold" },
--     -- Text to be represented with emphasis.
--     TSEmphasis = { fg = colors.yellow, gui = "italic" },
--     -- Text to be represented with an underline.
--     TSUnderline = { gui = "underline" },
--     -- Text that is part of a title.
--     TSTitle = { fg = colors.blue, gui = "bold" },
--     -- Literal or verbatim text.
--     TSLiteral = { fg = colors.green },
--     -- URIs like hyperlinks or email addresses.
--     TSURI = { fg = colors.cyan, gui = "underline" },
--     -- Math environments like LaTeX's `$ ... $`
--     TSMath = { fg = colors.fg },
--     -- Footnotes, text references, citations, etc.
--     TSTextReference = { fg = colors.purple },
--     -- Text environments of markup languages.
--     TSEnvironment = { fg = colors.fg },
--     -- Text/string indicating the type of text environment. Like the name of a `\begin` block in LaTeX.
--     TSEnvironmentName = { fg = colors.fg },
--     -- Text representation of an informational note.
--     TSNote = { fg = colors.info, gui = "bold" },
--     -- Text representation of a warning note.
--     TSWarning = { fg = colors.warn, gui = "bold" },
--     -- Text representation of a danger note.
--     TSDanger = { fg = colors.error, gui = "bold" },
--     -- Type (and class) definitions and annotations.
--     TSType = { fg = colors.yellow },
--     -- Built-in types: `i32` in Rust.
--     TSTypeBuiltin = { fg = colors.orange },
--     -- Variable names that don't fit into other categories.
--     TSVariable = { fg = colors.fg, gui = config.styles.variables },
--     -- Variable names defined by the language: `this` or `self` in Javascript.
--     TSVariableBuiltin = { fg = colors.red, gui = config.styles.variables },
--   }

--   return treesitter
-- end

-- local function load_lsp()
--   -- Lsp highlight groups

--   local lsp = {
--     -- used for "Error" diagnostic virtual text
--     LspDiagnosticsDefaultError = { fg = colors.error },
--     -- used for "Error" diagnostic signs in sign column
--     LspDiagnosticsSignError = { fg = colors.error },
--     -- used for "Error" diagnostic messages in the diagnostics float
--     LspDiagnosticsFloatingError = { fg = colors.error },
--     -- Virtual text "Error"
--     LspDiagnosticsVirtualTextError = { fg = colors.error },
--     -- used to underline "Error" diagnostics.
--     LspDiagnosticsUnderlineError = { gui = config.styles.diagnostics, sp = colors.error },
--     -- used for "Warning" diagnostic signs in sign column
--     LspDiagnosticsDefaultWarning = { fg = colors.warn },
--     -- used for "Warning" diagnostic signs in sign column
--     LspDiagnosticsSignWarning = { fg = colors.warn },
--     -- used for "Warning" diagnostic messages in the diagnostics float
--     LspDiagnosticsFloatingWarning = { fg = colors.warn },
--     -- Virtual text "Warning"
--     LspDiagnosticsVirtualTextWarning = { fg = colors.warn },
--     -- used to underline "Warning" diagnostics.
--     LspDiagnosticsUnderlineWarning = { gui = config.styles.diagnostics, sp = colors.warn },
--     -- used for "Information" diagnostic virtual text
--     LspDiagnosticsDefaultInformation = { fg = colors.info },
--     -- used for "Information" diagnostic signs in sign column
--     LspDiagnosticsSignInformation = { fg = colors.info },
--     -- used for "Information" diagnostic messages in the diagnostics float
--     LspDiagnosticsFloatingInformation = { fg = colors.info },
--     -- Virtual text "Information"
--     LspDiagnosticsVirtualTextInformation = { fg = colors.info },
--     -- used to underline "Information" diagnostics.
--     LspDiagnosticsUnderlineInformation = { gui = config.styles.diagnostics, sp = colors.info },
--     -- used for "Hint" diagnostic virtual text
--     LspDiagnosticsDefaultHint = { fg = colors.hint },
--     -- used for "Hint" diagnostic signs in sign column
--     LspDiagnosticsSignHint = { fg = colors.hint },
--     -- used for "Hint" diagnostic messages in the diagnostics float
--     LspDiagnosticsFloatingHint = { fg = colors.hint },
--     -- Virtual text "Hint"
--     LspDiagnosticsVirtualTextHint = { fg = colors.hint },
--     -- used to underline "Hint" diagnostics.
--     LspDiagnosticsUnderlineHint = { gui = config.styles.diagnostics, sp = colors.hint },
--     -- used for highlighting "text" references
--     LspReferenceText = { gui = "underline", sp = colors.yellow },
--     -- used for highlighting "read" references
--     LspReferenceRead = { gui = "underline", sp = colors.yellow },
--     -- used for highlighting "write" references
--     LspReferenceWrite = { gui = "underline", sp = colors.yellow },

--     LspSignatureActiveParameter = { fg = colors.none, bg = colors.highlight_dark, gui = "bold" },
--     LspCodeLens = { fg = colors.light_gray },

--     DiagnosticError = { link = "LspDiagnosticsDefaultError" },
--     DiagnosticWarn = { link = "LspDiagnosticsDefaultWarning" },
--     DiagnosticInfo = { link = "LspDiagnosticsDefaultInformation" },
--     DiagnosticHint = { link = "LspDiagnosticsDefaultHint" },
--     DiagnosticVirtualTextWarn = { link = "LspDiagnosticsVirtualTextWarning" },
--     DiagnosticUnderlineWarn = { link = "LspDiagnosticsUnderlineWarning" },
--     DiagnosticFloatingWarn = { link = "LspDiagnosticsFloatingWarning" },
--     DiagnosticSignWarn = { link = "LspDiagnosticsSignWarning" },
--     DiagnosticVirtualTextError = { link = "LspDiagnosticsVirtualTextError" },
--     DiagnosticUnderlineError = { link = "LspDiagnosticsUnderlineError" },
--     DiagnosticFloatingError = { link = "LspDiagnosticsFloatingError" },
--     DiagnosticSignError = { link = "LspDiagnosticsSignError" },
--     DiagnosticVirtualTextInfo = { link = "LspDiagnosticsVirtualTextInformation" },
--     DiagnosticUnderlineInfo = { link = "LspDiagnosticsUnderlineInformation" },
--     DiagnosticFloatingInfo = { link = "LspDiagnosticsFloatingInformation" },
--     DiagnosticSignInfo = { link = "LspDiagnosticsSignInformation" },
--     DiagnosticVirtualTextHint = { link = "LspDiagnosticsVirtualTextHint" },
--     DiagnosticUnderlineHint = { link = "LspDiagnosticsUnderlineHint" },
--     DiagnosticFloatingHint = { link = "LspDiagnosticsFloatingHint" },
--     DiagnosticSignHint = { link = "LspDiagnosticsSignHint" },
--   }
--   return lsp
-- end
