local lsp_status = require("lsp-status")

local status = {}
status.select_symbol = function(cursor_pos, symbol)
  if symbol.valueRange then
    local value_range = {
      ["start"] = { character = 0, line = vim.fn.byte2line(symbol.valueRange[1]) },
      ["end"] = { character = 0, line = vim.fn.byte2line(symbol.valueRange[2]) },
    }

    return require("lsp-status.util").in_range(cursor_pos, value_range)
  end
end

lsp_status.config {
  select_symbol = status.select_symbol,
  status_symbol = "🇻 ",
  current_function = true,
  diagnostics = false,
  indicator_separator = " ",
  component_separator = " ",
  -- indicator_ok = '',
  -- indicator_errors = '',
  -- indicator_warnings = '',
  -- indicator_info = '🛈',
  -- indicator_hint = '❗'
}


lsp_status.register_progress()
