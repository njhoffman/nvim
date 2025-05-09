-- https://github.com/artemave/workspace-diagnostics.nvim
-- https://github.com/Danisaski/neodafer/blob/main/lua/daniel/diagnostics.lua

local lsp_icons = require("lsp.icons")

local sources = {
  "todo_comments",
  "Lua Diagnostics.",
  "editorconfig_checker",
  "shellcheck",
}
-- wrap open_float to inspect diagnostics and use the severity color for border
-- bufnr = 10, col = 35, end_col = 0, end_lnum = 4, lnum = 3, message = "INFO, HINT", namespace = 93, row = 4, severity = 4, source = "todo_comments"
--     bufnr = 8, code = "missing-fields", col = 15, end_col = 61, end_lnum = 186, lnum = 186,
--     message = "Missing required fields in type `cmp.MatchingConfig`: `disallow_fuzzy_matching`, `disallow_fullfuzzy_matching`, `disallow_partial_fuzzy_matching`, `disallow_partial_matching`, `disallow_prefix_unmatching`",
--     namespace = 90, severity = 2, source = "Lua Diagnostics.",
--     user_data = { lsp = { code = "missing-fields" } }
-- }

local severity_name = function(severity_level)
  local lvl = type(severity_level) == "number" and severity_level or tonumber(severity_level)
  return string.lower(vim.diagnostic.severity[lvl])
end

-- local filter_by_severity = function(severity, diagnostics)
--   if not severity then
--     return diagnostics
--   end
--
--   if type(severity) ~= 'table' then
--     severity = to_severity(severity)
--       return t.severity == severity
--     end, diagnostics)
--   end
--
--   local min_severity = to_severity(severity.min) or vim.diagnostic.severity.HINT
--   local max_severity = to_severity(severity.max) or vim.diagnostic.severity.ERROR
--
--   return vim.tbl_filter(function(t)
--     return t.severity <= min_severity and t.severity >= max_severity
--   end, diagnostics)
-- end

local get_max_severity = function(diagnostics)
  local max_severity = vim.diagnostic.severity.HINT
  for _, d in ipairs(diagnostics) do
    -- Equality is "less than" based on how the severities are encoded
    if d.severity < max_severity then
      max_severity = d.severity
    end
  end
  return max_severity
end

local generate_border = function(max_severity)
  local border_color = ({
    [vim.diagnostic.severity.HINT] = "DiagnosticFloatingHintBorder",
    [vim.diagnostic.severity.INFO] = "DiagnosticFloatingInfoBorder",
    [vim.diagnostic.severity.WARN] = "DiagnosticFloatingWarnBorder",
    [vim.diagnostic.severity.ERROR] = "DiagnosticFloatingErrorBorder",
  })[max_severity]

  return {
    { "╭", border_color },
    { "─", border_color },
    { "╮", border_color },
    { "│", border_color },
    { "╯", border_color },
    { "─", border_color },
    { "╰", border_color },
    { "│", border_color },
  }
end

local float_options = function(maxwidth)
  local win_opts = {
    header = "",
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    focusable = false,
    style = "minimal",
    scope = "cursor",
    source = "always",
    width = maxwidth,
    format = function(diag)
      -- See null-ls.nvim#632, neovim#17222 for how to pick up `code`
      local user_data
      user_data = diag.user_data or {}
      user_data = user_data.lsp or user_data.null_ls or user_data
      -- local code = (diag.symbol or diag.code or user_data.symbol or user_data.code)
      diag.source = vim.fn.substitute(diag.source, "\\.$", "", "g")
      diag.message = vim.fn.substitute(diag.message, "\\.$", "", "g")
      return string.format("%s", diag.message)
    end,
    prefix = function(diag, i, total)
      local icons = lsp_icons.get_icons("diagnostics")
      -- local num_prefix = string.format('%d. ', i)
      local icon_prefix = string.format("%s ", icons[severity_name(diag.severity)])
      local hl_group = ({
        [vim.diagnostic.severity.HINT] = "DiagnosticFloatingHint",
        [vim.diagnostic.severity.INFO] = "DiagnosticFloatingInfo",
        [vim.diagnostic.severity.WARN] = "DiagnosticFloatingWarn",
        [vim.diagnostic.severity.ERROR] = "DiagnosticFloatingError",
      })[diag.severity]
      return icon_prefix, hl_group
    end,
  }
  return win_opts
end

vim.diagnostic.open_float = (function(orig_open_float)
  return function(_opts, ...)
    if _opts == nil or type(_opts) == "number" then
      local bufnr = _opts
      _opts = ... or {} --- @type vim.diagnostic.Opts.Float
      _opts.bufnr = bufnr
    end

    local opts = vim.tbl_deep_extend("force", float_options(), _opts or {})
    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diagnostics = vim.diagnostic.get(opts.bufnr or 0, { namespace = nil, lnum = lnum })
    if vim.tbl_isempty(diagnostics) then
      return
    end
    -- local maxwidth = 0
    -- diagnostics = vim.tbl_map(function(d)
    --   --  Lua Syntax Check.: Unexpected <exp> . [exp-in-action]
    --   d.source = vim.fn.substitute(d.source, "%.", "", "g")
    --   d.message = vim.fn.substitute(d.message, "%.", "", "g")
    --   local w = {
    --     icon = 1,
    --     code = vim.fn.strlen(d.code) + 3,
    --     message = vim.fn.strlen(d.message) + 1,
    --     source = vim.fn.strlen(d.source) + 2,
    --   }
    --   maxwidth = math.max(w.icon + w.code + w.message + w.source, maxwidth)
    --   return d
    -- end, diagnostics)

    local max_severity = get_max_severity(diagnostics)
    opts.border = generate_border(max_severity)
    local bufnr, winnr = orig_open_float(opts)
    -- local max_level = severity_name(max_severity) or "info"

    if winnr and vim.api.nvim_win_is_valid(winnr) then
      -- use the same transparency effect from cmp
      vim.api.nvim_set_option_value(
        "winhighlight",
        "Normal:Normal,FloatBorder:Comment,CursorLine:Visual,Search:None",
        { scope = "local", win = winnr }
      )
      -- vim.api.nvim_win_set_option(winnr, 'winblend', 10)
    end
    return bufnr, winnr
  end
end)(vim.diagnostic.open_float)

-- vim.api.nvim_create_autocmd('DiagnosticChanged', {
--   callback = function(args)
--     local diagnostics = args.data.diagnostics
--     vim.print(diagnostics)
--   end,
-- })

---            - bufnr: (number) Buffer number to show diagnostics from.
---                     Defaults to the current buffer.
---            - namespace: (number) Limit diagnostics to the given namespace
---            - scope: (string, default "line") Show diagnostics from the whole buffer ("buffer"),
---                     the current cursor line ("line"), or the current cursor position ("cursor").
---                     Shorthand versions are also accepted ("c" for "cursor", "l" for "line", "b"
---                     for "buffer").
---            - pos: (number or table) If {scope} is "line" or "cursor", use this position rather
---                   than the cursor position. If a number, interpreted as a line number;
---                   otherwise, a (row, col) tuple.
---            - severity_sort: (default false) Sort diagnostics by severity. Overrides the setting
---                             from |vim.diagnostic.config()|.
---            - severity: See |diagnostic-severity|. Overrides the setting
---                        from |vim.diagnostic.config()|.
---            - header: (string or table) String to use as the header for the floating window. If a
---                      table, it is interpreted as a [text, hl_group] tuple. Overrides the setting
---                      from |vim.diagnostic.config()|.
---            - source: (boolean or string) Include the diagnostic source in the message.
---                      Use "if_many" to only show sources if there is more than one source of
---                      diagnostics in the buffer. Otherwise, any truthy value means to always show
---                      the diagnostic source. Overrides the setting from |vim.diagnostic.config()|.
---            - format: (function) A function that takes a diagnostic as input and returns a
---                      string. The return value is the text used to display the diagnostic.
---                      Overrides the setting from |vim.diagnostic.config()|.
---            - prefix: (function, string, or table) Prefix each diagnostic in the floating
---                      window. If a function, it must have the signature (diagnostic, i,
---                      total) -> (string, string), where {i} is the index of the diagnostic
---                      being evaluated and {total} is the total number of diagnostics
---                      displayed in the window. The function should return a string which
---                      is prepended to each diagnostic in the window as well as an
---                      (optional) highlight group which will be used to highlight the
---                      prefix. If {prefix} is a table, it is interpreted as a [text,
---                      hl_group] tuple as in |nvim_echo()|; otherwise, if {prefix} is a
---                      string, it is prepended to each diagnostic in the window with no
---                      highlight.
---                      Overrides the setting from |vim.diagnostic.config()|.
---            - suffix: Same as {prefix}, but appends the text to the diagnostic instead of
---                      prepending it. Overrides the setting from |vim.diagnostic.config()|.

-- function M.open_float(opts, ...)
--   -- Support old (bufnr, opts) signature
--   local bufnr
--   if opts == nil or type(opts) == 'number' then
--     bufnr = opts
--     opts = ...
--   else
--     vim.validate({
--       opts = { opts, 't', true },
--     })
--   end
--
--   opts = opts or {}
--   bufnr = get_bufnr(bufnr or opts.bufnr)
--
--   do
--     -- Resolve options with user settings from vim.diagnostic.config
--     -- Unlike the other decoration functions (e.g. set_virtual_text, set_signs, etc.) `open_float`
--     -- does not have a dedicated table for configuration options; instead, the options are mixed in
--     -- with its `opts` table which also includes "keyword" parameters. So we create a dedicated
--     -- options table that inherits missing keys from the global configuration before resolving.
--     local t = global_diagnostic_options.float
--     local float_opts = vim.tbl_extend('keep', opts, type(t) == 'table' and t or {})
--     opts = get_resolved_options({ float = float_opts }, nil, bufnr).float
--   end
--
--   local scope = ({ l = 'line', c = 'cursor', b = 'buffer' })[opts.scope] or opts.scope or 'line'
--   local lnum, col
--   if scope == 'line' or scope == 'cursor' then
--     if not opts.pos then
--       local pos = api.nvim_win_get_cursor(0)
--       lnum = pos[1] - 1
--       col = pos[2]
--     elseif type(opts.pos) == 'number' then
--       lnum = opts.pos
--     elseif type(opts.pos) == 'table' then
--       lnum, col = unpack(opts.pos)
--     else
--       error("Invalid value for option 'pos'")
--     end
--   elseif scope ~= 'buffer' then
--     error("Invalid value for option 'scope'")
--   end
--
--   local diagnostics = get_diagnostics(bufnr, opts, true)
--
--   if scope == 'line' then
--     diagnostics = vim.tbl_filter(function(d)
--       return d.lnum == lnum
--     end, diagnostics)
--   elseif scope == 'cursor' then
--     -- LSP servers can send diagnostics with `end_col` past the length of the line
--     local line_length = #api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, true)[1]
--     diagnostics = vim.tbl_filter(function(d)
--       return d.lnum == lnum
--         and math.min(d.col, line_length - 1) <= col
--         and (d.end_col >= col or d.end_lnum > lnum)
--     end, diagnostics)
--   end
--
--   if vim.tbl_isempty(diagnostics) then
--     return
--   end
--
--   local severity_sort = vim.F.if_nil(opts.severity_sort, global_diagnostic_options.severity_sort)
--   if severity_sort then
--     if type(severity_sort) == 'table' and severity_sort.reverse then
--       table.sort(diagnostics, function(a, b)
--         return a.severity > b.severity
--       end)
--     else
--       table.sort(diagnostics, function(a, b)
--         return a.severity < b.severity
--       end)
--     end
--   end
--
--   local lines = {}
--   local highlights = {}
--   local header = if_nil(opts.header, 'Diagnostics:')
--   if header then
--     vim.validate({
--       header = {
--         header,
--         { 'string', 'table' },
--         "'string' or 'table'",
--       },
--     })
--     if type(header) == 'table' then
--       -- Don't insert any lines for an empty string
--       if string.len(if_nil(header[1], '')) > 0 then
--         table.insert(lines, header[1])
--         table.insert(highlights, { hlname = header[2] or 'Bold' })
--       end
--     elseif #header > 0 then
--       table.insert(lines, header)
--       table.insert(highlights, { hlname = 'Bold' })
--     end
--   end
--
--   if opts.format then
--     diagnostics = reformat_diagnostics(opts.format, diagnostics)
--   end
--
--   if opts.source and (opts.source ~= 'if_many' or count_sources(bufnr) > 1) then
--     diagnostics = prefix_source(diagnostics)
--   end
--
--   local prefix_opt =
--     if_nil(opts.prefix, (scope == 'cursor' and #diagnostics <= 1) and '' or function(_, i)
--       return string.format('%d. ', i)
--     end)
--
--   local prefix, prefix_hl_group
--   if prefix_opt then
--     vim.validate({
--       prefix = {
--         prefix_opt,
--         { 'string', 'table', 'function' },
--         "'string' or 'table' or 'function'",
--       },
--     })
--     if type(prefix_opt) == 'string' then
--       prefix, prefix_hl_group = prefix_opt, 'NormalFloat'
--     elseif type(prefix_opt) == 'table' then
--       prefix, prefix_hl_group = prefix_opt[1] or '', prefix_opt[2] or 'NormalFloat'
--     end
--   end
--
--   local suffix_opt = if_nil(opts.suffix, function(diagnostic)
--     return diagnostic.code and string.format(' [%s]', diagnostic.code) or ''
--   end)
--
--   local suffix, suffix_hl_group
--   if suffix_opt then
--     vim.validate({
--       suffix = {
--         suffix_opt,
--         { 'string', 'table', 'function' },
--         "'string' or 'table' or 'function'",
--       },
--
--                                                       *vim.diagnostic.match()*
-- match({str}, {pat}, {groups}, {severity_map}, {defaults})
--     Parse a diagnostic from a string.
--
--     For example, consider a line of output from a linter: >
--         WARNING filename:27:3: Variable 'foo' does not exist
-- <
--
--     This can be parsed into a diagnostic |diagnostic-structure| with: >lua
--         local s = "WARNING filename:27:3: Variable 'foo' does not exist"
--         local pattern = "^(%w+) %w+:(%d+):(%d+): (.+)$"
--         local groups = { "severity", "lnum", "col", "message" }
--         vim.diagnostic.match(s, pattern, groups, { WARNING = vim.diagnostic.WARN })
-- <
--
--     Parameters: ~
--       • {str}           (string) String to parse diagnostics from.
--       • {pat}           (string) Lua pattern with capture groups.
--       • {groups}        (table) List of fields in a |diagnostic-structure| to
--                         associate with captures from {pat}.
--       • {severity_map}  (table) A table mapping the severity field from
--                         {groups} with an item from |vim.diagnostic.severity|.
--       • {defaults}      (table|nil) Table of default values for any fields not
--                         listed in {groups}. When omitted, numeric values
--                         default to 0 and "severity" defaults to ERROR.
