local cfg = {
  highlight = {
    -- keyword = "fg", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
    multiline = false, -- enable multine todo comments
    multiline_pattern = '^.', -- lua pattern to match the next multiline from the start of the matched keyword
    multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
    before = 'fg', -- "fg" or "bg" or empty
    keyword = 'fg', -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
    after = 'fg', -- "fg" or "bg" or empty
    pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
    comments_only = true, -- uses treesitter to match keywords in comments only
    max_line_len = 400, -- ignore lines longer than this
    exclude = {}, -- list of file types to exclude highlighting
  },
  keywords = {
    FIX = {
      icon = ' ', -- icon used for the sign, and in search results
      color = 'error', -- can be a hex color, or a named color (see below)
      alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' }, -- a set of other keywords that all map to this FIX keywords
      -- signs = false, -- configure signs for some keywords individually
    },
    TODO = { icon = ' ', color = 'info' },
    HACK = { icon = ' ', color = 'warning' },
    WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
    PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
    NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
    TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
  },
  colors = {
    -- warning = { 'Warning' },
    info = { 'TodoMsg', 'DiagnosticInfo', '#2563EB' },
    -- hint = { '#10B981' },
    -- default = { 'TodoMsg' },
    test = { '#794789' },
    error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
    warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
    hint = { 'DiagnosticHint', '#10B981' },
    default = { 'Identifier', '#7C3AED' },
    -- test = { 'Identifier', '#FF00FF' },
  },
}

require('todo-comments').setup(cfg)

-- TODO: testing
-- HACK: hack
-- FIX: a fix
-- WARN: this is a warning
-- PERF: this is for perf
-- NOTE: this is a note
-- TEST: this is a test
