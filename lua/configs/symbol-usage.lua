local SymbolKind = vim.lsp.protocol.SymbolKind

---@type UserOpts
local default_opts = {
  ---@type table<string, any> `nvim_set_hl`-like options for highlight virtual text
  hl = { link = 'Comment' },
  ---@type lsp.SymbolKind[] Symbol kinds what need to be count (see `lsp.SymbolKind`)
  kinds = { SymbolKind.Function, SymbolKind.Method },
  ---@type 'above'|'end_of_line'|'textwidth'
  vt_position = 'above',
  ---@type function(symbol: Symbol): string
  text_format = function(symbol)
    local fragments = {}

    if symbol.references then
      local usage = symbol.references <= 1 and 'usage' or 'usages'
      local num = symbol.references == 0 and 'no' or symbol.references
      table.insert(fragments, ('%s %s'):format(num, usage))
    end

    if symbol.definition then
      table.insert(fragments, symbol.definition .. ' defs')
    end

    if symbol.implementation then
      table.insert(fragments, symbol.implementation .. ' impls')
    end

    return table.concat(fragments, ', ')
  end,
  references = { enabled = true, include_declaration = false },
  definition = { enabled = false },
  implementation = { enabled = false },
  ---@type UserOpts[]
  filetypes = {},
}

local cfg = {
  hl = { link = 'SymbolInlay' },
  vt_position = 'end_of_line',
  -- references = { enabled = true, include_declaration = false },
  -- definition = { enabled = false },
  -- implementation = { enabled = false },
  -- filetypes = {},
}
require('symbol-usage').setup(cfg)
