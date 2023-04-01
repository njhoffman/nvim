local hsl = require("lush").hsl

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
    highlight = hsl("#101c39"),
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
    TelescopeResultsIdentifier({ fg = "#6476ce" }),
    TelescopeResultsSpecialComment({ fg = "#4488cc" }),
    -- { entry.value.event, "vimAutoEvent" },
    -- { entry.value.group_name, "vimAugroup" },
    -- { entry.value.pattern, "vimAutoCmdSfxList" },
    -- "TelescopeResultsDiffAdd" },
    -- "TelescopeResultsDiffAdd" },
    -- "TelescopeResultsDiffChange" },
    -- "TelescopeResultsDiffChange" },
    -- "TelescopeResultsDiffChange" },
    -- "TelescopeResultsDiffDelete" },
    -- = "TelescopeResultsDiffUntracked" },
    --
    -- ["Class"] = "TelescopeResultsClass",
    -- ["Constant"] = "TelescopeResultsConstant",
    -- ["Field"] = "TelescopeResultsField",
    -- ["Function"] = "TelescopeResultsFunction",
    -- ["Method"] = "TelescopeResultsMethod",
    -- ["Property"] = "TelescopeResultsOperator",
    -- ["Struct"] = "TelescopeResultsStruct",
    -- ["Variable"] = "TelescopeResultsVariable",
    --     WhichKeyGroup = { fg = clrs.text },
    --     WhichKeyDesc = { fg = clrs.nord7, gui = "italic" },
    --     WhichKeySeperator = { fg = clrs.fg },

    -- TelescopePromptCounter { NonText },
    -- TelescopePathSeparator { fg = '#667788' },
    -- TelescopeQueryFilter { fg = '#4466FF'},
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
    -- +--- Notify ---+
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

    -- -- NeoTree
    NeoTreeIndentMarker({ fg = "#222222" }),
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
    TabLineFill({ fg = "NONE", bg = colors.bg_dark }),
    -- Illuminate
    IlluminatedWordRead({ bg = colors.highlight, gui = "italic" }),
    IlluminatedWordText({ bg = colors.highlight, gui = "none" }),
    IlluminatedWordWrite({ bg = colors.highlight, gui = "none", fg = "none" }),
    -- illuminatedCurWord = { bg = colors.highlight },

    -- TabLine({ fg = colors.bg, bg = colors.bg_dark }),
    -- TabLineSel({ fg = colors.bg, bg = colors.bg_dark }),

    -- -- Sneak
    -- Sneak = { fg = colors.bg, bg = colors.fg },
    -- SneakScope = { bg = colors.selection },

    -- -- Nvim dap
    -- DapBreakpoint = { fg = colors.red },
    -- DapStopped = { fg = colors.green },

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
end

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
