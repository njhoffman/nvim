local log_levels = {
  ['*'] = {
    main = 1,
  },
  hover = { main = 0 },
  ['early-retirement'] = { main = -1 },
  -- fasd = { main = -1 },
  -- git = { main = -1 },
  lazy = { main = 2 },
  lsp = { main = 2 },
  -- mapper = { main = -1, module = -1 },
  -- mru = { main = -1 },
  notify = { main = 0 },
  project = { main = 2 },
  root = { main = -1 },
}

return log_levels
