-- TODO: add option for truncating, banner, timm format

-- 0:trace 1:debug 2:info 3:warn 4:error -1:none
-- stylua: ignore
local scopes = {
  ['*']                   = { main = 2 },
  alt                     = { main = 1, module = 0 },
  buffers                 = { main = 2 },
  cmdline                 = { main = 0 },
  convey                  = { main = 0 },
  -- hover                = { main = 0 },
  -- ['early-retirement'] = { main = -1 },
  events                  = { main = 2 },
  fasd                    = { main = 0 },
  -- git                  = { main = 0 },
  -- hover                = { main = 2 },
  lazy                    = { main = 2 },
  ['lazy:help']                = { main = 1 },
  ['lazy:docs']                = { main = 1 },
  -- lsp                  = { main = 2 },
  -- mapper               = { main = -1, module = -1 },
  modeman                 = { main = 3, module = 0 },
  neoscroll               = { main = -1, module = 1 },
  -- mru                  = { main = -1 },
  notifier                = { main = 1, module = 0 },
  notify                  = { main = 0 },
  registers               = { main = 2 },
  -- project              = { main = 0 },
  lab                     = { main = 2 },
  root                    = { main = 0 },
  reactive                = { main = -1, module = 1 },
  tail                    = { main = 0 },
  telescope               = { main = 3, module = 1 },
  whichkey                = { main = 1 },
}

local patterns = {
  notify = { "^%[devdocs%]", 2 },
}
-- `DEBUG_CODEIUM` environment variable: `trace`, `debug`, `info`, `warn`, `error`

-- require('cmp.utils.debug').enable()/disable()
return { patterns = patterns, scopes = scopes }
