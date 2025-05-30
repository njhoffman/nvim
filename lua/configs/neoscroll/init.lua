-- /home/nicholas/.local/share/nvim/lazy/cmp-plugins/lua/cmp-plugins/list.lua
-- /home/nicholas/.local/share/nvim/lazy/tailiscope.nvim/lua/tailiscope/docs/all.lua
-- nvim --headless -c "PlenaryBustedDirectory lua/tests {minimal_init = 'lua/tests/minimal_init.vim'}"
local hooks = require("configs.neoscroll.hooks")
--   mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
--   hide_cursor = true,
--   stop_eof = true,
--   respect_scrolloff = false,
--   cursor_scrolls_alone = true,
--   duration_multiplier = 1.0,
--   performance_mode = false,
--   easing = "linear",
--   ignored_events = {'WinScrolled', 'CursorMoved'},
--   telescope_scroll_opts = { duration = 250 },
local cfg = {
  -- All these keys will be mapped to their corresponding default scrolling animation
  -- mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
  mappings = {},
  hide_cursor = false, -- Hide cursor while scrolling
  stop_eof = true, -- Stop at <EOF> when scrolling downwards
  respect_scrolloff = true, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
  cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
  easing_function = "sine", -- Default easing function
  use_local_scrolloff = true,
  -- quadratic, cubic, quartic, quintic, circular, sine
  performance_mode = false, -- Disable "Performance Mode" on all buffers.
  pre_hook = hooks.pre_hook,
  post_hook = hooks.post_hook,
  steps_hook = hooks.steps_hook,
}
require("neoscroll").setup(cfg)

--[[ defaults['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '250' } }
  defaults['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '250' } }
  defaults['<C-b>'] = { 'scroll', { '-vim.fn.winheight(0)', 'true', '450' } }
  defaults['<C-f>'] = { 'scroll', { 'vim.fn.winheight(0)', 'true', '450' } }
  defaults['<C-y>'] = { 'scroll', { '-0.10', 'false', '100' } }
  defaults['<C-e>'] = { 'scroll', { '0.10', 'false', '100' } }
  defaults['zt'] = { 'zt', { '250' } }
  defaults['zz'] = { 'zz', { '250' } }
  defaults['zb'] = { 'zb', { '250' } }
  defaults['G'] = { 'G', { '100' } }
  defaults['gg'] = { 'gg', { '100' } } ]]
-- function next_paragraph_line_count(search_direction)
--    local current_line = vim.api.nvim_win_get_cursor(0)[1]
--    local next_paragraph = vim.fn.search("\\(^$\\)\\(\\n^$\\)\\@!", search_direction)
--    local distance_to_scroll = next_paragraph - current_line
--    return distance_to_scroll
-- end
--
-- require('neoscroll.config').set_mappings({
--    ['J'] = {'scroll', { 'next_paragraph_line_count("n")', 'false', '50'}},
--    ['K'] = {'scroll', { 'next_paragraph_line_count("b")', 'false', '50'}},
-- })
-- require('neoscroll').setup({
--   post_hook = function(info) if info == 'centercursor' then vim.cmd('normal! zz') end end,
-- })
-- local t = {}
-- t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '350', 'sine', [['centercursor']] } }

-- Calculate the delay length.
-- if config.max_length ~= -1 then
--   if math.abs(distance) * delay_length > config.max_length then
--     delay_length = math.floor((config.max_length / math.abs(distance)) + 0.5)
--   end
-- end

-- I just tried it, but I felt nothing but faster with the easing function. I didn't feel the easing.
-- If you want to "feel" the easing you'll need to change the default time-step range instead
-- of the easing function.
-- That is what I was trying to explain here:
-- There isn't, mainly because you need to also specify the first and last time-step of the scrolling animation
-- as additional arguments and you probably never want to set those to the same value for all the commands as some
-- movements are very long (c-f/c-b) and some are very short (c-e/c-y).
-- So for instance if you change the c-d/c-u easing mappings from the README to:
--
-- t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '7', '35', easing1}}
-- t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '7', '35', easing1}}
-- You'll now "feel" the easing more because it goes from a time-step of 7 ms to a time-step of 35 ms instead of 15 ms.
-- The easing function only determines how the time-step goes from 7 ms to 35 ms.
-- Of course, the higher the value of the last time-step the slower the animation will "feel" towards the end of the scrolling animation.
-- I don't particularly like it that high because you can notice the line-by-line scrolling and it doesn't look as smooth to me but everyone has their own preferences.
--
-- So for example with function(x) return x end the time-step will decrease from 7 ms to 35 ms linearly whereas with
-- function(x) return math.pow(x, 2) end the time-step will decrease from 7 ms to 35 ms quadratically, i.e. slow at
-- the beginning and quickly at the end.
-- The function function(x) return 0.5 end returns a constant so in that case the time-step will be constant throughout the whole scrolling animation.
--  This obviously is totally unnecessary because you don't need an easing function to obtain this scrolling animation.
-- BTW, IDK if the information "Scrolling with easing function" was used for debugging, but it's noisy and useless in real use.
--
-- You will need to elaborate on what do you mean by "noisy". I am using the defaults and they work just fine for me.
-- Math.sqrt(1 - math.pow(x - 1, 2))
-- The easing functions in easings.net (and in pretty much any other place) give you t(x) where t is the relative time and x is the relative position (i.e., both are defined from 0 to 1).
-- The math is done in the compute_time_step function. To pass a relative position it's easy: number of lines scrolled / number of lines to scroll.
-- Then you get a relative time from 1 to 0. In the case of Neoscroll (and this is what I'm planning to change) the relative time is interpreted as the relative time-step instead,
-- where 0 is the initial time-step and 1 is the final time-step.
-- The maths of this final mapping from relative time-step to real time-step is done in the last line of the function (ignore the math.floor() and the + 0.5 as these are just there to make sure we get an
-- integer value for the time-step). In this last line time_step1 is the initial time-step, time_step2 is the final time-step and fraction is the relative time-step obtained from the easing function (t(x)).

-- :lua require('neoscroll').scroll(0.1, true, 200)
-- " Scroll only the screen 10% of the window height downwards
-- :lua require('neoscroll').scroll(0.1, false, 200)
-- " Scroll 20 lines upwards using the "sine" easing function.
-- :lua require('neoscroll').scroll(-20, true, 400, "sine")
-- Key     Function
-- <C-u>    scroll(-vim.wo.scroll, true, 350)
-- <C-d>    scroll( vim.wo.scroll, true, 350)
-- <C-b>    scroll(-vim.api.nvim_win_get_height(0), true, 550)
-- <C-f>    scroll( vim.api.nvim_win_get_height(0), true, 550)
-- <C-y>    scroll(-0.10, false, 100)
-- <C-e>    scroll( 0.10, false, 100)
-- zt      zt(200)
-- zz      zz(200)
-- zb      zb(200)
