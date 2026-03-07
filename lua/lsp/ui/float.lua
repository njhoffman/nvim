-- LSP Floating Window Utilities
-- Custom diagnostic float styling with severity-based borders

local lsp_icons = require("lsp.icons")

local M = {}

-- Get severity name from level
local function severity_name(severity_level)
  local lvl = type(severity_level) == "number" and severity_level or tonumber(severity_level)
  return string.lower(vim.diagnostic.severity[lvl])
end

-- Get maximum severity from diagnostics list
local function get_max_severity(diagnostics)
  local max_severity = vim.diagnostic.severity.HINT
  for _, d in ipairs(diagnostics) do
    if d.severity < max_severity then
      max_severity = d.severity
    end
  end
  return max_severity
end

-- Generate border with severity-based coloring
local function generate_border(max_severity)
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

-- Float window options
local function float_options()
  return {
    header = "",
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    focusable = false,
    style = "minimal",
    scope = "cursor",
    source = "always",
    format = function(diag)
      diag.source = vim.fn.substitute(diag.source or "", "\\.$", "", "g")
      diag.message = vim.fn.substitute(diag.message or "", "\\.$", "", "g")
      return string.format("%s", diag.message)
    end,
    prefix = function(diag, _, _)
      local icons = lsp_icons.get_icons("diagnostics")
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
end

-- Override vim.diagnostic.open_float with custom styling
vim.diagnostic.open_float = (function(orig_open_float)
  return function(_opts, ...)
    if _opts == nil or type(_opts) == "number" then
      local bufnr = _opts
      _opts = ... or {}
      _opts.bufnr = bufnr
    end

    local opts = vim.tbl_deep_extend("force", float_options(), _opts or {})
    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diagnostics = vim.diagnostic.get(opts.bufnr or 0, { namespace = nil, lnum = lnum })

    if vim.tbl_isempty(diagnostics) then
      return
    end

    local max_severity = get_max_severity(diagnostics)
    opts.border = generate_border(max_severity)

    local bufnr, winnr = orig_open_float(opts)

    if winnr and vim.api.nvim_win_is_valid(winnr) then
      vim.api.nvim_set_option_value(
        "winhighlight",
        "Normal:Normal,FloatBorder:Comment,CursorLine:Visual,Search:None",
        { scope = "local", win = winnr }
      )
    end

    return bufnr, winnr
  end
end)(vim.diagnostic.open_float)

return M
