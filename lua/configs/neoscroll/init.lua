-- /home/nicholas/.local/share/nvim/lazy/cmp-plugins/lua/cmp-plugins/list.lua
-- /home/nicholas/.local/share/nvim/lazy/tailiscope.nvim/lua/tailiscope/docs/all.lua
-- nvim --headless -c "PlenaryBustedDirectory lua/tests {minimal_init = 'lua/tests/minimal_init.vim'}"
local stats = require('neoscroll.stats')

local cfg = {
  -- All these keys will be mapped to their corresponding default scrolling animation
  -- mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
  mappings = {},
  hide_cursor = false, -- Hide cursor while scrolling
  stop_eof = true, -- Stop at <EOF> when scrolling downwards
  time_scale = 1.0,
  respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
  cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
  easing_function = 'sine', -- Default easing function
  use_local_scrolloff = true,
  -- quadratic, cubic, quartic, quintic, circular, sine
  performance_mode = false, -- Disable "Performance Mode" on all buffers.
  pre_hook = stats.hooks.pre_hook,
  post_hook = stats.hooks.post_hook,
  steps_hook = stats.hooks.steps_hook,
}

require('neoscroll').setup(cfg)

local t = {}
t['<PageUp>'] = {
  'scroll',
  {
    '-vim.api.nvim_win_get_height(0)',
    'true',
    '300',
    [['sine']],
    [['centercursor']],
  },
}
t['<PageDown>'] = {
  'scroll',
  {
    'vim.api.nvim_win_get_height(0)',
    'true',
    '300',
    [['sine']],
    [['centercursor']],
  },
}
-- im.keymap.set({'n', 'v'}, '<c-b>', '<cmd>lua vim.api.nvim_command("normal " .. vim.api.nvim_win_get_height(0)-5 .. "k"); require("neoscroll").zz(220)<cr>')
-- vim.keymap.set({'n', 'v'}, '<c-f>', '<cmd>lua vim.api.nvim_command("normal " .. vim.api.nvim_win_get_height(0)-5 .. "j"); require("neoscroll").zz(220)<cr>')
-- t[',gg'] = { 'scroll', { '-2*vim.api.nvim_buf_line_count(0)', 'true', '1', '5', e } }
-- t[',G'] = { 'scroll', { '2*vim.api.nvim_buf_line_count(0)', 'true', '1', '5', e } }

require('neoscroll.config').set_mappings(t)

-- Math.sqrt(1 - math.pow(x - 1, 2))
-- The easing functions in easings.net (and in pretty much any other place) give you t(x) where t is the relative time and x is the relative position (i.e., both are defined from 0 to 1). The math is done in the compute_time_step function. To pass a relative position it's easy: number of lines scrolled / number of lines to scroll. Then you get a relative time from 1 to 0. In the case of Neoscroll (and this is what I'm planning to change) the relative time is interpreted as the relative time-step instead, where 0 is the initial time-step and 1 is the final time-step. The maths of this final mapping from relative time-step to real time-step is done in the last line of the function (ignore the math.floor() and the + 0.5 as these are just there to make sure we get an
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
