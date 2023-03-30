local animate = require("mini.animate")

local is_many_wins = function(sizes_from, sizes_to)
  return vim.tbl_count(sizes_from) >= 3
end
local opts = {
  scroll = { enable = false },
  cursor = { enable = false },
  resize = {
    -- Animate for 200 milliseconds with linear easing
    timing = animate.gen_timing.linear({ duration = 200, unit = "total" }),
    -- Animate only if there are at least 3 windows
    subresize = animate.gen_subscroll.equal({ predicate = is_many_wins }),
  },
  open = {
    enable = true,
    -- Animate for 400 milliseconds with linear easing
    timing = animate.gen_timing.linear({ duration = 400, unit = "total" }),
    -- Animate with wiping from nearest edge instead of default static one
    winconfig = animate.gen_winconfig.wipe({ direction = "from_edge" }),
    -- Make bigger windows more transparent
    winblend = animate.gen_winblend.linear({ from = 80, to = 100 }),
  },
  close = {
    -- Animate for 400 milliseconds with linear easing
    timing = animate.gen_timing.linear({ duration = 400, unit = "total" }),
    -- Animate with wiping to nearest edge instead of default static one
    winconfig = animate.gen_winconfig.wipe({ direction = "to_edge" }),
    -- Make bigger windows more transparent
    winblend = animate.gen_winblend.linear({ from = 100, to = 80 }),
  },
}
local cfg = {
  scroll = { enable = false },
  cursor = { enable = false },
  open = {
    enable = true,
    timing = animate.gen_timing.linear({ duration = 500, unit = "total" }),
    -- winconfig = animate.gen_winconfig.wipe({ direction = "from_edge" }),
    winblend = animate.gen_winblend.linear({ from = 70, to = 100 }),
  },
  close = {
    enable = true,
    -- Animate for 400 milliseconds with linear easing
    timing = animate.gen_timing.linear({ duration = 300, unit = "total" }),
    -- Animate with wiping to nearest edge instead of default static one
    -- winconfig = animate.gen_winconfig.wipe({ direction = "to_edge" }),
    -- Make bigger windows more transparent
    winblend = animate.gen_winblend.linear({ from = 100, to = 70 }),
  },
  resize = { enable = false },
}
require("mini.animate").setup(cfg)
