--- bars.nvim configuration entry point.
--- Supports switchable statusline backends via vim.g.statusline_backend.
---
--- Set vim.g.statusline_backend = "bars" to use bars.nvim statusline.
--- Default is "feline" (current behavior).

local backend = vim.g.statusline_backend or "feline"

local bars_config = {
  statuscolumn = false,
  statusline = backend == "bars",
  tabline = false,
  winbar = false,
}

require("bars").setup(bars_config)

-------------------------------------------------------------------------------
-- Bars backend initialization
-------------------------------------------------------------------------------

--- Performs full bars.nvim statusline initialization.
--- Safe to call multiple times (all sub-calls are idempotent).
local function init_bars()
  -- Set up highlights.
  require("configs.bars.highlights").setup()

  -- Register neocodeium autocmd for misc_stats component.
  require("bars.components.misc_stats").setup()

  -- Register the separator component kind on the upstream table.
  local slC = require("bars.components.statusline")
  slC.separator = function(_, _, config)
    if not config.char or config.char == "" then
      return ""
    end
    local hl = config.char_hl or config.hl or ""
    if hl ~= "" and vim.fn.hlexists(hl) == 1 then
      hl = "%#" .. hl .. "#"
    else
      hl = ""
    end
    return hl .. config.char
  end

  -- Load statusline configuration.
  local sl_config = require("configs.bars.statusline")
  require("bars.statusline").setup(sl_config)
end

if backend == "bars" then
  init_bars()
end

-------------------------------------------------------------------------------
-- Commands (always registered regardless of backend)
-------------------------------------------------------------------------------

-- Theme switching.
require("configs.bars.themes").setup_commands()

-- Benchmark.
require("configs.bars.benchmark").setup_commands()

-- Switch between backends at runtime.
vim.api.nvim_create_user_command("StatuslineSwitch", function(opts)
  local target = opts.args
  if target == "feline" then
    vim.g.statusline_backend = "feline"
    require("bars").setup({ statusline = false })
    vim.import("configs.feline")
    vim.notify("Switched to feline statusline", vim.log.levels.INFO)
  elseif target == "bars" then
    vim.g.statusline_backend = "bars"
    require("bars").setup({ statusline = true })
    init_bars()
    vim.cmd("redrawstatus!")
    vim.notify("Switched to bars.nvim statusline", vim.log.levels.INFO)
  else
    vim.notify("Usage: StatuslineSwitch feline|bars", vim.log.levels.WARN)
  end
end, {
  nargs = 1,
  complete = function()
    return { "feline", "bars" }
  end,
  desc = "Switch statusline backend",
})
