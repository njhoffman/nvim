local lsp_icons = require("lsp.icons")
local default_opts = {
  scope = "buffer",
  severity = vim.diagnostic.severity.HINT,
}

local get_line_diagnostics = function(opts)
  -- MiniAnimateDoneCursor
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})

  local line_diagnostics = vim.diagnostic.get(0, { severity = opts.severity })
  -- local line = vim.api.nvim_get_current_line()
  local line_nr = vim.api.nvim_win_get_cursor(0)[1]
  local filtered_diagnostics = vim.tbl_filter(function(d)
    local range = vim.tbl_get(d, "user_data", "lsp", "range")
    if opts.scope == "line" then
      return range.start.line == line_nr
    end
    return true
  end, line_diagnostics)

  if #filtered_diagnostics == 0 then
    return
  end

  local poop = ""

  local diagnostic = filtered_diagnostics[1]

  local message = vim.diagnostic.format({
    severity = opts.severity,
    message = diagnostic.message,
    source = diagnostic.source,
  })
  vim.dbglog(message)
  -- local severity = string.lower(vim.diagnostic.severity[diagnostic.severity])
  -- local icon = lsp_icons.get_icons({ "diagnostics", severity })[1]
  -- local msg = string.format("%s %s %s", diagnostic.code, message, diagnostic.source)
  -- vim.dbglog("🪚 msg: ", filtered_diagnostics, msg, icon, severity)
  -- vim.notify(msg, 2, { title = icon .. " " .. severity, timeout = 5000 })
end

get_line_diagnostics()
