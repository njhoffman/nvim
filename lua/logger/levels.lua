-- stylua: ignore
local scopes = {
  ['*']                   = { main = 2 },
  buffers                 = { main = 2 },
  -- hover                = { main = 0 },
  -- ['early-retirement'] = { main = -1 },
  -- fasd                 = { main = 0 },
  -- git                  = { main = 0 },
  -- hover                = { main = 2 },
  -- lazy                 = { main = 2 },
  -- lsp                  = { main = 2 },
  -- ['lsp-root']         = { main = 0 },
  -- mapper               = { main = -1, module = -1 },
  neoscroll               = { main = -1, module = 1 },
  -- mru                  = { main = -1 },
  notify                  = { main = 1 },
  -- project              = { main = 1 },
  lab                     = { main = 2 },
  root                    = { main = -1 },
  -- telescope            = { main = -1 },
  reactive                = { main = -1, module = 1 },
  tail                    = { main = 0 },
  whichkey                = { main = 1 },
}

local patterns = {
  notify = { '^%[devdocs%]', 2 },
}
-- `DEBUG_CODEIUM` environment variable: `trace`, `debug`, `info`, `warn`, `error`

-- require('cmp.utils.debug').enable()/disable()
return { patterns = patterns, scopes = scopes }
