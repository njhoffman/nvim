-- https://raw.githubusercontent.com/smjonas/live-command.nvim/main/README.md

local commands = {
  Norm = { cmd = "norm", hl_range = { kind = "visible" } },
  G = { cmd = "g", hl_range = { 1, -1, kind = "absolute" } },
  D = { cmd = "d", hl_range = { 1, -1, kind = "absolute" } },
  -- :5Reg a (preview macros) -> :norm 5@a
  Reg = {
    cmd = "norm",
    -- args = function(opts)
    --   return (opts.count == -1 and '' or opts.count) .. '@' .. opts.args
    -- end,
    -- range = '',
  },
  LSubvert = { cmd = "Subvert" },
  -- :S/txt/repl/g
  -- Sub = { cmd = '%s', hl_range = { kind = 'visible' } },
  S = { cmd = "s", hl_range = { kind = "visible" } },
}

require("live-command").setup({
  commands = commands,
  enable_highlighting = true,
  inline_highlighting = true,
  hl_groups = {
    insertion = "DiffAdd",
    deletion = "DiffDelete",
    change = "DiffChange",
  },
  debug = false,
})
