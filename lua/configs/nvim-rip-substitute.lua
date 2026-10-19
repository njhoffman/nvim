-- default settings
local default_settings = {
  popupWin = {
    title = " rip-substitute",
    border = "single",
    matchCountHlGroup = "Keyword",
    noMatchHlGroup = "ErrorMsg",
    hideSearchReplaceLabels = false,
    position = "bottom", -- "top"|"bottom"
  },
  prefill = {
    normal = "cursorWord", -- "cursorWord"|false
    visual = "selectionFirstLine", -- "selectionFirstLine"|false
    startInReplaceLineIfPrefill = false,
  },
  keymaps = {
    -- normal & visual mode
    confirmAndSubstituteInBuffer = "<CR>",
    abort = "q",
    prevSubst = "<Up>",
    nextSubst = "<Down>",
    openAtRegex101 = "R",
    insertModeConfirmAndSubstituteInBuffer = "<C-CR>", -- (except this one, obviously)
  },
  incrementalPreview = {
    matchHlGroup = "IncSearch",
    rangeBackdropBrightness = 50, -- 0-100, false disables the backdrop
  },
  regexOptions = {
    -- pcre2 enables lookarounds and backreferences, but performs slower
    pcre2 = true,
    ---@type "case-sensitive"|"ignore-case"|"smart-case"
    casing = "case-sensitive",
    -- disable if you use named capture groups (see README for details)
    autoBraceSimpleCaptureGroups = true,
  },
  editingBehavior = {
    -- Experimental. When typing `()` in the `search` line, automatically
    -- adds `$n` to the `replace` line.
    autoCaptureGroups = false,
  },
  notificationOnSuccess = true,
}

local cfg = default_settings

require("rip-substitute").setup(cfg)
