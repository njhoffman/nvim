---@diagnostic disable undefined-global
--luacheck: ignore

local tokyoColors = {}

tokyoColors = {
  none = "NONE",
  bg_dark = "#1f2335",
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
  gitSigns = { add = "#164846", change = "#394b70", delete = "#823c41" }
}

return function()
  local colors = {
    fg = "#C8D0E0",
    fg_light = "#E5E9F0",
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
    none = "NONE"
  }
  return {
    -- Telescope
    TelescopeNormal { fg = "#6D778a", bg = "none" },
    TelescopeBorder { bg = "none" },
    TelescopePrompt { bg = "none" },
    TelescopePromptNormal { bg = "none" },
    TelescopePromptBorder { fg = "#2299cc", bg = "none" },
    TelescopePromptPrefix { fg = "#2977FF", bg = "none" },
    -- fg_bg("TelescopePromptPrefix", red, black2)
    -- fg_bg("TelescopePromptTitle", black, red)
    TelescopeMultiIcon { fg = "#0066ff" },
    TelescopePreviewTitle { fg = "#47a0f0", bg = "none" },
    TelescopePreviewBorder { fg = "#416191", bg = "none" },
    TelescopeResults { bg = "none" },
    TelescopeResultsBorder { fg = "#476F9F", bg = "none" },
    TelescopeResultsTitle { fg = "#34799c", bg = "none" },
    TelescopeSelectionCaret { fg = "#44c9fc" },
    TelescopeSelection { fg = "#28ddff", gui = "bold", bg = "#0f1a20" }, -- bg = "#202324"
    TelescopeMatching { fg = "#7997FF", bg = "none" },
    TelescopeFrecencyScores { fg = "#34799c" },
    TelescopeBufferLoaded { fg = "#47a0f0" },
    TelescopeMultiSelection { fg = "#4060ff", gui = "italic" },
    -- -- keybinds cheatsheet
    -- fg_bg("CheatsheetBorder", black, black)
    -- bg("CheatsheetSectionContent", black)
    -- fg("CheatsheetHeading", white)
    -- local section_title_colors = {
    --   white,
    --   blue,
    --   red,
    --   green,
    --   yellow,
    --   purple,
    --   orange,
    -- }
    -- for i, color in ipairs(section_title_colors) do
    --   vim.cmd(
    --     "highlight CheatsheetTitle"
    --       .. i
    --       .. " guibg = "
    --       .. color
    --       .. " guifg="
    --       .. black
    --   )
    -- end

    -- TelescopePromptCounter { NonText },
    -- TelescopePathSeparator { fg = '#667788' },
    -- TelescopeQueryFilter { fg = '#4466FF'},
    -- TelescopeResultsIdentifier = {},
    -- TelescopeResultsComment = {},
    -- TelescopeMultiSelection guifg=#928374          " Multisections

    --    " Sets the highlight for selected items within the picker.
    --    highlight default link TelescopeSelection Visual
    --    highlight default link TelescopeSelectionCaret TelescopeSelection
    --    highlight default link TelescopeMultiSelection Type
    --
    --    " "Normal" in the floating windows created by telescope.
    --    highlight default link TelescopeNormal Normal
    --    highlight default link TelescopePreviewNormal TelescopeNormal
    --    highlight default link TelescopePromptNormal TelescopeNormal
    --    highlight default link TelescopeResultsNormal TelescopeNormal
    --
    --    " Border highlight groups.
    --    "   Use TelescopeBorder to override the default.
    --    "   Otherwise set them specifically
    --    highlight default link TelescopeBorder TelescopeNormal
    --    highlight default link TelescopePromptBorder TelescopeBorder
    --    highlight default link TelescopeResultsBorder TelescopeBorder
    --    highlight default link TelescopePreviewBorder TelescopeBorder
    --
    --    " Title highlight groups.
    --    "   Use TelescopeTitle to override the default.
    --    "   Otherwise set them specifically
    --    highlight default link TelescopeTitle TelescopeBorder
    --    highlight default link TelescopePromptTitle TelescopeTitle
    --    highlight default link TelescopeResultsTitle TelescopeTitle
    --    highlight default link TelescopePreviewTitle TelescopeTitle
    --
    --    highlight default link TelescopePromptCounter NonText
    --
    --    " Used for highlighting characters that you match.
    --    highlight default link TelescopeMatching Special
    --
    --    " Used for the prompt prefix
    --    highlight default link TelescopePromptPrefix Identifier
    --
    --    " Used for highlighting the matched line inside Previewer. Works only for (vim_buffer_ previewer)
    --    highlight default link TelescopePreviewLine Visual
    --    highlight default link TelescopePreviewMatch Search
    --
    --    highlight default link TelescopePreviewPipe Constant
    --    highlight default link TelescopePreviewCharDev Constant
    --    highlight default link TelescopePreviewDirectory Directory
    --    highlight default link TelescopePreviewBlock Constant
    --    highlight default link TelescopePreviewLink Special
    --    highlight default link TelescopePreviewSocket Statement
    --    highlight default link TelescopePreviewNormal Normal
    --    highlight default link TelescopePreviewRead Constant
    --    highlight default link TelescopePreviewWrite Statement
    --    highlight default link TelescopePreviewExecute String
    --    highlight default link TelescopePreviewHyphen NonText
    --    highlight default link TelescopePreviewSticky Keyword
    --    highlight default link TelescopePreviewSize String
    --    highlight default link TelescopePreviewUser Constant
    --    highlight default link TelescopePreviewGroup Constant
    --    highlight default link TelescopePreviewDate Directory
    --    highlight default link TelescopePreviewMessage TelescopePreviewNormal
    --    highlight default link TelescopePreviewMessageFillchar TelescopePreviewMessage
    --
    --    " Used for Picker specific Results highlighting
    --    highlight default link TelescopeResultsClass Function
    --    highlight default link TelescopeResultsConstant Constant
    --    highlight default link TelescopeResultsField Function
    --    highlight default link TelescopeResultsFunction Function
    --    highlight default link TelescopeResultsMethod Method
    --    highlight default link TelescopeResultsOperator Operator
    --    highlight default link TelescopeResultsStruct Struct
    --    highlight default link TelescopeResultsVariable SpecialChar
    --
    --    highlight default link TelescopeResultsLineNr LineNr
    --    highlight default link TelescopeResultsIdentifier Identifier
    --    highlight default link TelescopeResultsNumber Number
    --    highlight default link TelescopeResultsComment Comment
    --    highlight default link TelescopeResultsSpecialComment SpecialComment
    --
    --    " Used for git status Results highlighting
    --    highlight default link TelescopeResultsDiffChange DiffChange
    --    highlight default link TelescopeResultsDiffAdd DiffAdd
    --    highlight default link TelescopeResultsDiffDelete DiffDelete
    --    highlight default link TelescopeResultsDiffUntracked NonText

    -- Cmp
    CmpItemAbbr { fg = colors.fg },
    CmpItemAbbrDeprecated { fg = colors.fg },
    CmpItemAbbrMatch { fg = colors.blue, style = "bold" },
    CmpItemAbbrMatchFuzzy { fg = colors.blue, underline = true },
    CmpItemMenu { fg = colors.light_gray },
    CmpItemKindText { fg = colors.orange },
    CmpItemKindMethod { fg = colors.blue },
    CmpItemKindFunction { fg = colors.blue },
    CmpItemKindConstructor { fg = colors.yellow },
    CmpItemKindField { fg = colors.blue },
    CmpItemKindClass { fg = colors.yellow },
    CmpItemKindInterface { fg = colors.yellow },
    CmpItemKindModule { fg = colors.blue },
    CmpItemKindProperty { fg = colors.blue },
    CmpItemKindValue { fg = colors.orange },
    CmpItemKindEnum { fg = colors.yellow },
    CmpItemKindKeyword { fg = colors.purple },
    CmpItemKindSnippet { fg = colors.green },
    CmpItemKindFile { fg = colors.blue },
    CmpItemKindEnumMember { fg = colors.cyan },
    CmpItemKindConstant { fg = colors.orange },
    CmpItemKindStruct { fg = colors.yellow },
    CmpItemKindTypeParameter { fg = colors.yellow },
    -- Notify
    NotifyTASKBorder { fg = "#6a3246" },
    NotifyTASKTitle { fg = "#6a3246" },
    NotifyTASKIcon { fg = "#7a7697" },
    NotifySTATUSBorder { fg = "#3a3286" },
    NotifySTATUSTitle { fg = "#3a3286" },
    NotifySTATUSIcon { fg = "#2a76b7" },
    NotifyINSPECTBorder { fg = "#2A70fF" },
    NotifyINSPECTIcon { fg = "#67b0f7" },
    NotifyINSPECTTitle { fg = "#2760f7" },
    NotifyINFOIcon { fg = "#29cFa8" },
    NotifyINFOTitle { fg = "#29cFa8" },
    NotifyINFOBorder { fg = "#4Fa792" },
    NotifyDEBUGBorder { fg = "#4B4BBB" },
    NotifyDEBUGIcon { fg = "#6B6BFF" },
    NotifyDEBUGTitle { fg = "#6B6BFF" },
    NotifyTRACEBorder { fg = "#637699" },
    -- NotifyTRACEBorder { fg = "#7B7BCC" },
    -- NotifyTRACEBorder { Normal },
    NotifyTRACEIcon { fg = "#637699" },
    NotifyTRACEBody { fg = "#637699" },
    -- NotifyTRACEIcon { fg = "#7BABFF" },
    NotifyTRACETitle { fg = "#7BABFF" },
    NotifyERRORBorder { fg = "#8A1F1F" },
    NotifyERRORIcon { fg = "#F74047" },
    NotifyERRORTitle { fg = "#F74047" },
    NotifyWARNBorder { fg = "#79491D" },
    NotifyWARNIcon { fg = "#F79000" },
    NotifyWARNTitle { fg = "#F79000" }
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
    -- TelescopeMatching = { fg = colors.yellow, style = "bold" },

    -- -- NvimTree
    -- NvimTreeSymlink = { fg = colors.cyan, style = "bold" },
    -- NvimTreeRootFolder = { fg = colors.green, style = "bold" },
    -- NvimTreeFolderName = { fg = colors.blue },
    -- NvimTreeFolderIcon = { fg = colors.dark_blue },
    -- NvimTreeEmptyFolderName = { fg = colors.light_gray },
    -- NvimTreeOpenedFolderName = { fg = colors.yellow, style = "italic" },
    -- NvimTreeIndentMarker = { fg = colors.blue },
    -- NvimTreeGitDirty = { fg = colors.yellow },
    -- NvimTreeGitNew = { fg = colors.diff_add },
    -- NvimTreeGitStaged = { fg = colors.purple },
    -- NvimTreeGitDeleted = { fg = colors.diff_remove },
    -- NvimTreeExecFile = { fg = colors.green, style = "bold" },
    -- NvimTreeOpenedFile = { fg = colors.none },
    -- NvimTreeSpecialFile = { fg = colors.orange, style = "underline" },
    -- NvimTreeImageFile = { fg = colors.purple, style = "bold" },
    -- NvimTreeNormal = { fg = colors.fg, bg = colors.active },
    -- NvimTreeCursorLine = { bg = colors.float },
    -- NvimTreeVertSplit = { fg = colors.active, bg = colors.active },
    -- LspDiagnosticsError = { fg = colors.error },
    -- LspDiagnosticsWarning = { fg = colors.warn },
    -- LspDiagnosticsInformation = { fg = colors.info },
    -- LspDiagnosticsHint = { fg = colors.hint },

    -- -- WhichKey
    -- WhichKey = { fg = colors.purple, style = "bold" },
    -- WhichKeyGroup = { fg = colors.cyan },
    -- WhichKeyDesc = { fg = colors.blue, style = "italic" },
    -- WhichKeySeperator = { fg = colors.green },
    -- WhichKeyFloat = { bg = colors.active },

    -- -- LspSaga
    -- LspFloatWinNormal = { fg = colors.fg, bg = colors.bg },
    -- LspFloatWinBorder = { fg = colors.purple },
    -- DiagnosticError = { fg = colors.error },
    -- DiagnosticWarning = { fg = colors.warn },
    -- DiagnosticInformation = { fg = colors.info },
    -- DiagnosticHint = { fg = colors.hint },
    -- LspSagaDiagnosticBorder = { fg = colors.gray },
    -- LspSagaDiagnosticHeader = { fg = colors.blue },
    -- LspSagaDiagnosticTruncateLine = { fg = colors.highlight },
    -- ProviderTruncateLine = { fg = colors.highlight },
    -- LspSagaShTruncateLine = { fg = colors.highlight },
    -- LspSagaDocTruncateLine = { fg = colors.highlight },
    -- LineDiagTruncateLine = { fg = colors.highlight },
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
    -- ReferencesCount = { fg = colors.purple },
    -- DefinitionCount = { fg = colors.purple },
    -- DefinitionPreviewTitle = { fg = colors.green },
    -- DefinitionIcon = { fg = colors.blue },
    -- ReferencesIcon = { fg = colors.blue },
    -- TargetWord = { fg = colors.cyan },

    -- -- BufferLine
    -- BufferLineIndicatorSelected = { fg = colors.yellow },
    -- BufferLineFill = { bg = colors.bg },

    -- -- barbar
    -- BufferCurrent = { fg = colors.fg, bg = colors.bg },
    -- BufferCurrentIndex = { fg = colors.fg, bg = colors.bg },
    -- BufferCurrentMod = { fg = colors.yellow, bg = colors.bg, style = "bold" },
    -- BufferCurrentSign = { fg = colors.cyan, bg = colors.bg },
    -- BufferCurrentTarget = { fg = colors.red, bg = colors.bg, style = "bold" },
    -- BufferVisible = { fg = colors.fg, bg = colors.bg },
    -- BufferVisibleIndex = { fg = colors.fg, bg = colors.bg },
    -- BufferVisibleMod = { fg = colors.yellow, bg = colors.bg, style = "bold" },
    -- BufferVisibleSign = { fg = colors.light_gray, bg = colors.bg },
    -- BufferVisibleTarget = { fg = colors.red, bg = colors.bg, style = "bold" },
    -- BufferInactive = { fg = colors.light_gray, bg = colors.active },
    -- BufferInactiveIndex = { fg = colors.light_gray, bg = colors.active },
    -- BufferInactiveMod = { fg = colors.yellow, bg = colors.active },
    -- BufferInactiveSign = { fg = colors.light_gray, bg = colors.active },
    -- BufferInactiveTarget = { fg = colors.red, bg = colors.active, style = "bold" },

    -- -- Sneak
    -- Sneak = { fg = colors.bg, bg = colors.fg },
    -- SneakScope = { bg = colors.selection },

    -- -- Indent Blankline
    -- IndentBlanklineChar = { fg = colors.selection, style = "nocombine" },
    -- IndentBlanklineContextChar = { fg = colors.purple, style = "nocombine" },

    -- -- Nvim dap
    -- DapBreakpoint = { fg = colors.red },
    -- DapStopped = { fg = colors.green },

    -- -- Illuminate
    -- illuminatedWord = { bg = colors.highlight },
    -- illuminatedCurWord = { bg = colors.highlight },

    -- -- Hop
    -- HopNextKey = { fg = colors.fg_light, style = "bold" },
    -- HopNextKey1 = { fg = colors.cyan, style = "bold" },
    -- HopNextKey2 = { fg = colors.purple },
    -- HopUnmatched = { fg = colors.light_gray },

    -- -- Fern
    -- FernBranchText = { fg = colors.blue },

    -- -- Lightspeed
    -- LightspeedLabel = { fg = colors.pink, style = "bold,underline" },
    -- LightspeedLabelOverlapped = { fg = colors.dark_pink, style = "underline" },
    -- LightspeedLabelDistant = { fg = colors.cyan, style = "bold,underline" },
    -- LightspeedLabelDistantOverlapped = { fg = colors.blue, style = "underline" },
    -- LightspeedShortcut = { fg = "#E5E9F0", bg = colors.pink, style = "bold,underline" },
    -- LightspeedMaskedChar = { fg = colors.light_purple },
    -- LightspeedGreyWash = { fg = colors.gray },
    -- LightspeedUnlabeledMatch = { fg = colors.fg_light, style = "bold" },
    -- LightspeedOneCharMatch = { fg = colors.yellow, style = "bold,reverse" },
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
  -- NvimTreeRootFolder = { fg = clrs.nord7, style = "bold" },
  -- NvimTreeGitDirty = { fg = clrs.nord15 },
  -- NvimTreeGitNew = { fg = clrs.nord14 },
  -- NvimTreeImageFile = { fg = clrs.nord15 },
  -- NvimTreeExecFile = { fg = clrs.nord14 },
  -- NvimTreeSpecialFile = { fg = clrs.nord9, style = spec.underline },
  -- NvimTreeFolderName = { fg = clrs.nord10 },
  -- NvimTreeEmptyFolderName = { fg = clrs.disabled },
  -- NvimTreeFolderIcon = { fg = clrs.accent },
  -- NvimTreeIndentMarker = { fg = clrs.disabled },
  -- -- WhichKey
  -- WhichKey = { fg = clrs.accent, style = "bold" },
  -- WhichKeyGroup = { fg = clrs.text },
  -- WhichKeyDesc = { fg = clrs.nord7, style = "italic" },
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
