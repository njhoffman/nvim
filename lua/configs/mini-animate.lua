local animate = require('mini.animate')

local is_many_wins = function(sizes_from, sizes_to)
  return vim.tbl_count(sizes_from) >= 3
end

---@diagnostic disable-next-line: unused-local
local opts = {
  scroll = { enable = false },
  cursor = { enable = false },
  resize = {
    -- Animate for 200 milliseconds with linear easing
    timing = animate.gen_timing.linear({ duration = 200, unit = 'total' }),
    -- Animate only if there are at least 3 windows
    subresize = animate.gen_subscroll.equal({ predicate = is_many_wins }),
  },
  open = {
    enable = true,
    -- Animate for 400 milliseconds with linear easing
    timing = animate.gen_timing.linear({ duration = 400, unit = 'total' }),
    -- Animate with wiping from nearest edge instead of default static one
    winconfig = animate.gen_winconfig.wipe({ direction = 'from_edge' }),
    -- Make bigger windows more transparent
    winblend = animate.gen_winblend.linear({ from = 80, to = 100 }),
  },
  close = {
    -- Animate for 400 milliseconds with linear easing
    timing = animate.gen_timing.linear({ duration = 400, unit = 'total' }),
    -- Animate with wiping to nearest edge instead of default static one
    winconfig = animate.gen_winconfig.wipe({ direction = 'to_edge' }),
    -- Make bigger windows more transparent
    winblend = animate.gen_winblend.linear({ from = 100, to = 80 }),
  },
}

-- don't use animate when scrolling with the mouse
local mouse_scrolled = false
for _, scroll in ipairs({ 'Up', 'Down' }) do
  local key = '<ScrollWheel' .. scroll .. '>'
  vim.keymap.set({ '', 'i' }, key, function()
    mouse_scrolled = true
    return key
  end, { expr = true })
end

local cfg = {
  resize = { timing = animate.gen_timing.linear({ duration = 100, unit = 'total' }) },
  scroll = { enable = false },
  -- scroll = {
  --   timing = animate.gen_timing.linear({ duration = 150, unit = 'total' }),
  --   subscroll = animate.gen_subscroll.equal({
  --     predicate = function(total_scroll)
  --       if mouse_scrolled then
  --         mouse_scrolled = false
  --         return false
  --       end
  --       return total_scroll > 1
  --     end,
  --   }),
  -- },
  open = {
    enable = true,
    timing = animate.gen_timing.linear({ duration = 500, unit = 'total' }),
    -- winconfig = animate.gen_winconfig.wipe({ direction = "from_edge" }),
    winblend = animate.gen_winblend.linear({ from = 70, to = 100 }),
  },
  close = {
    enable = true,
    -- Animate for 400 milliseconds with linear easing
    timing = animate.gen_timing.linear({ duration = 300, unit = 'total' }),
    -- Animate with wiping to nearest edge instead of default static one
    -- winconfig = animate.gen_winconfig.wipe({ direction = "to_edge" }),
    -- Make bigger windows more transparent
    winblend = animate.gen_winblend.linear({ from = 100, to = 70 }),
  },
}
require('mini.animate').setup(cfg)
