local animate = require("mini.animate")
local is_many_wins = function(sizes_from, sizes_to)
  return vim.tbl_count(sizes_from) >= 3
end

-- don't use animate when scrolling with the mouse
local mouse_scrolled = false
for _, scroll in ipairs({ "Up", "Down" }) do
  local key = "<ScrollWheel" .. scroll .. ">"
  vim.keymap.set({ "", "i" }, key, function()
    mouse_scrolled = true
    return key
  end, { expr = true })
end

vim.api.nvim_create_autocmd("User", {
  pattern = { "ScrollStart", "ScrollStop" },
  callback = function(ev)
    if ev.match == "ScrollStart" then
      vim.b.minianimate_disable = true
    else
      vim.b.minianimate_disable = false
    end
  end,
})

local cfg = {
  cursor = {
    enable = true,
    -- gen_path.line(), gen_path.angle(), gen_path.walls(), gen_path.spiral()
    timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
    -- path = animate.gen_path.line(),
    path = animate.gen_path.angle(),
    -- timing = animate.gen_timing.linear({ duration = 50, unit = "total" }),
  },
  scroll = {
    enable = true,
    -- Animate for 200 milliseconds with linear easing
    -- timing = animate.gen_timing.linear({ duration = 150, unit = 'total' }),
    timing = animate.gen_timing.quadratic({ duration = 200, unit = "total" }),
    subscroll = animate.gen_subscroll.equal({
      -- max_output_steps = 60,
      -- Animate equally but with at most 120 steps instead of default 60
      max_output_steps = 120,
      predicate = function(total_scroll)
        if mouse_scrolled then
          mouse_scrolled = false
          return false
        end
        return total_scroll > 1
      end,
    }),
  },
  resize = {
    enable = true,
    timing = animate.gen_timing.linear({ duration = 200, unit = "total" }),
    -- subresize = animate.gen_subscroll.equal({ predicate = is_many_wins }),
  },
  open = {
    enable = true,
    -- Animate for 400 milliseconds with linear easing
    timing = animate.gen_timing.linear({ duration = 400, unit = "total" }),
    -- Animate with wiping from nearest edge instead of default static one
    winconfig = animate.gen_winconfig.wipe({ direction = "from_edge" }),
    -- Make bigger windows more transparent
    -- winblend = animate.gen_winblend.linear({ from = 50, to = 100 }),

    -- -- Animate for 400 milliseconds with linear easing
    -- timing = animate.gen_timing.linear({ duration = 400, unit = "total" }),
    -- -- Animate with wiping from nearest edge instead of default static one
    -- winconfig = animate.gen_winconfig.wipe({ direction = "from_edge" }),
    -- -- Make bigger windows more transparent
    -- winblend = animate.gen_winblend.linear({ from = 80, to = 100 }),
  },

  close = {
    enable = true,
    -- Animate for 400 milliseconds with linear easing
    timing = animate.gen_timing.linear({ duration = 300, unit = "total" }),
    -- Animate with wiping to nearest edge instead of default static one
    winconfig = animate.gen_winconfig.wipe({ direction = "to_edge" }),
    -- Make bigger windows more transparent
    -- winblend = animate.gen_winblend.linear({ from = 100, to = 50 }),

    -- -- Animate for 400 milliseconds with linear easing
    -- timing = animate.gen_timing.linear({ duration = 400, unit = "total" }),
    -- -- Animate with wiping to nearest edge instead of default static one
    -- winconfig = animate.gen_winconfig.wipe({ direction = "to_edge" }),
    -- -- Make bigger windows more transparent
    -- winblend = animate.gen_winblend.linear({ from = 100, to = 80 }),
  },
}

require("mini.animate").setup(cfg)

-- require('mini.animate').execute_after('scroll', 'normal! n nzvzz')

---@diagnostic disable-next-line: unused-local
local default_cfg = {
  -- Cursor path
  cursor = {
    -- Whether to enable this animation
    enable = true,
    -- Timing of animation (how steps will progress in time)
    -- timing = --<function: implements linear total 250ms animation duration>,
    -- Path generator for visualized cursor movement
    -- path = --<function: implements shortest line path>,
  },
  -- Vertical scroll
  scroll = {
    -- Whether to enable this animation
    enable = true,
    -- Timing of animation (how steps will progress in time)
    -- timing = --<function: implements linear total 250ms animation duration>,
    -- Subscroll generator based on total scroll
    -- subscroll = --<function: implements equal scroll with at most 60 steps>,
  },
  -- Window resize
  resize = {
    -- Whether to enable this animation
    enable = true,
    -- Timing of animation (how steps will progress in time)
    -- timing = --<function: implements linear total 250ms animation duration>,
    -- Subresize generator for all steps of resize animations
    -- subresize = --<function: implements equal linear steps>,
  },
  -- Window open
  open = {
    -- Whether to enable this animation
    enable = true,
    -- Timing of animation (how steps will progress in time)
    -- timing = --<function: implements linear total 250ms animation duration>,
    -- Floating window config generator visualizing specific window
    -- winconfig = --<function: implements static window for 25 steps>,
    -- 'winblend' (window transparency) generator for floating window
    -- winblend = --<function: implements equal linear steps from 80 to 100>,
  },
  -- Window close
  close = {
    -- Whether to enable this animation
    enable = true,
    -- Timing of animation (how steps will progress in time)
    -- timing = --<function: implements linear total 250ms animation duration>,
    -- Floating window config generator visualizing specific window
    -- winconfig = --<function: implements static window for 25 steps>,
    -- 'winblend' (window transparency) generator for floating window
    -- winblend = --<function: implements equal linear steps from 80 to 100>,
  },
}
