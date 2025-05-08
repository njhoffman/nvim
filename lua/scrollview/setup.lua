vim.cmd([[
  highlight default link ScrollView Visual
  highlight default link ScrollViewChangeListPrevious SpecialKey
  highlight default link ScrollViewChangeListCurrent SpecialKey
  highlight default link ScrollViewChangeListNext SpecialKey
  highlight default link ScrollViewConflictsMiddle DiffAdd
  highlight default link ScrollViewConflictsTop DiffAdd
  highlight default link ScrollViewConflictsMiddle DiffAdd
  highlight default link ScrollViewConflictsBottom DiffAdd
  highlight default link ScrollViewCursor WarningMsg
  " Set the diagnostic highlights to the corresponding Neovim sign text
  " highlight if defined, or the default otherwise.
  let s:diagnostics_highlight_data = [
    \   ['ScrollViewDiagnosticsError', 'DiagnosticError', 'DiagnosticSignError'],
    \   ['ScrollViewDiagnosticsHint', 'DiagnosticHint', 'DiagnosticSignHint'],
    \   ['ScrollViewDiagnosticsInfo', 'DiagnosticInfo', 'DiagnosticSignInfo'],
    \   ['ScrollViewDiagnosticsWarn', 'DiagnosticWarn', 'DiagnosticSignWarn'],
    \ ]
  for [s:key, s:fallback, s:sign] in s:diagnostics_highlight_data
  let s:highlight = s:sign
    execute 'highlight default link ' .. s:key .. ' ' .. s:highlight
  endfor
  highlight default link ScrollViewFolds Directory
  highlight default link ScrollViewHover CurSearch
  highlight default link ScrollViewIndentSpaces LineNr
  highlight default link ScrollViewIndentTabs LineNr
  highlight default link ScrollViewKeywordsFix ColorColumn
  highlight default link ScrollViewKeywordsHack ColorColumn
  highlight default link ScrollViewKeywordsTodo ColorColumn
  highlight default link ScrollViewKeywordsWarn ColorColumn
  highlight default link ScrollViewKeywordsXxx ColorColumn
  highlight default link ScrollViewLatestChange SpecialKey
  highlight default link ScrollViewLocList LineNr
  highlight default link ScrollViewMarks Identifier
  highlight default link ScrollViewQuickFix Constant
  highlight default link ScrollViewRestricted CurSearch
  highlight default link ScrollViewSearch NonText
  highlight default link ScrollViewSpell Statement
  highlight default link ScrollViewTextWidth Question

  " === Initialization ===

  " Initialize scrollview asynchronously. Asynchronous initialization is used to
  " prevent issues when setting configuration variables is deferred (#99). This
  " was originally used to avoid an issue that prevents diff mode from
  " functioning properly when it's launched at startup (i.e., with nvim
  " -d). The issue was reported on Jan 8, 2021, in Neovim Issue #13720. As of
  "  Neovim 0.9.0, the issue is resolved (Neovim PR #21829, Jan 16, 2023).
  " WARN: scrollview events are omitted from the output of --startuptime.
  call timer_start(0, {-> execute('call scrollview#Initialize()', '')})
]])

-- shape = { head = "▲", body = "█", tail = "▼" },
local scrollview = require("scrollview")
local state = scrollview.setup({
  excluded_filetypes = {
    "WhichKey",
    "TelescopePrompt",
    "chatgpt-input",
    "cmp_docs",
    "cmp_menu",
    "lazy",
    "neoai-input",
    "nerdtree",
    "noice",
    "notify",
    "prompt",
  },
  signs_max_per_row = 2,
  -- text = "┆", "▁", "", "", " ", ﹘‐ ‑ ‒ – — ― ‖ ‗﹉ ﹊ ﹋ ﹌ ﹍ ﹎ ﹏
  cursor_symbol = "",
  search_symbol = { vim.fn.nr2char(0x2261) }, -- { "-", "= ", vim.fn.nr2char(0x2261) },
  diagnostics_error_symbol = { "" }, -- { "-", "= " },
  diagnostics_warn_symbol = { "—" }, -- { "-", "= " },
  winblend_gui = 30,
  current_only = false,
  base = "right", -- left, right, buffer
  -- column = 80,
  -- zindex = 40,
  floating_windows = true,
  signs_on_startup = {
    -- "conflicts",
    "cursor",
    "diagnostics",
    -- 'folds',
    -- 'loclist',
    -- 'marks',
    -- 'quickfix',
    "search",
    -- 'spell',
    -- 'textwidth',
    -- 'trail',
    -- 'all'
  },
  diagnostics_severities = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.ERROR },
})
