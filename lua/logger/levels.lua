-- stylua: ignore
local log_levels = {
  ['*']                = { main = 1 },
  hover                = { main = 0 },
  ['early-retirement'] = { main = -1 },
  fasd                 = { main = 0 },
  -- git               = { main = 0 },
  -- hover                = { main = 2 },
  lazy                 = { main = 2 },
  lsp                  = { main = 2 },
  ['lsp-root']         = { main = 0 },
  -- mapper            = { main = -1, module = -1 },
  -- mru               = { main = -1 },
  notify               = { main = 0 },
  project              = { main = 1 },
  root                 = { main = -1 },
  -- telescope            = { main = -1 },
}

-- `DEBUG_CODEIUM` environment variable: `trace`, `debug`, `info`, `warn`, `error`

return log_levels
