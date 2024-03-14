-- let l:subline_step_size = s:subline_position + (g:smoothie_update_interval/1000.0 * s:compute_velocity())
-- let l:step_size = float2nr(trunc(l:subline_step_size))

-- if abs(l:step_size) > abs(s:target_displacement)
--   " clamp step size to prevent overshooting the target
--   let l:step_size = s:target_displacement
-- end

-- if s:step_many(l:step_size)
--   " we've collided with either buffer end
--   call s:stop_moving()
-- else
--   let s:target_displacement -= l:step_size
--   let s:subline_position = l:subline_step_size - l:step_size
-- endif

local get_arg = function(action, arg)
  if type(arg) == 'function' then
    return arg(action, arg)
  elseif type(arg) == 'string' then
    return vim.fn.execute(arg)
  elseif type(arg) == 'number' then
    return arg
  end
end

local defaults = {
  page_up = { '-vim.wo.scroll', true, 600, 'sine' },
  page_down = { 'vim.wo.scroll', true, 600, 'sine' },
  page_forward = { '3 * tonumber(vim.wo.scroll)', true, 250, 'sine' },
}

local scroll_page = function(action, user_args)
  if action and defaults[action] then
    local args = vim.tbl_deep_extend('force', defaults[action], user_args)
    args.lines = get_arg(action, args.lines)
    args.time = get_arg(action, args.time)
    -- (lines, move_cursor, time, easing_function, info)
    require('neoscroll').scroll(unpack(args))
  end
end

require('neoscroll').scroll(lines, move_cursor, time, easing_function, info)
-- end

-- function neoscroll.scroll(lines, move_cursor, time, easing_function, info)
-- function neoscroll.zt(half_screen_time, easing, info)
-- defaults['<C-u>'] = { 'scroll', {  }
-- defaults['<C-d>'] = { 'scroll', { }
-- defaults['<C-b>'] = { 'scroll', { '-vim.fn.winheight(0)', 'true', '450' } }
-- defaults['<C-f>'] = { 'scroll', { 'vim.fn.winheight(0)', 'true', '450' } }
-- defaults['<C-y>'] = { 'scroll', { '-0.10', 'false', '100' } }
-- defaults['<C-e>'] = { 'scroll', { '0.10', 'false', '100' } }
-- defaults['zt'] = { 'zt', { '250' } }
-- defaults['zz'] = { 'zz', { '250' } }
-- defaults['zb'] = { 'zb', { '250' } }
-- defaults['G'] = { 'G', { '100' } }
-- defaults['gg'] = { 'gg', { '100' } }

-- local function map_key(action, func, args)
--   local opts = { silent = true, noremap = false }
--   vim.api.nvim_set_keymap('n', key, func(action, args), opts)
--   vim.api.nvim_set_keymap('x', key, func(action, args), opts)
-- end

-- map_key('<C-f>', 'page_down', scroll_page, { time = 600  } )

local t = {}
-- t['<PageUp>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '300', [['sine']], [['centercursor']] } }
-- t['<PageDown>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '300', [['sine']], [['centercursor']] } }

t['<C-b>'] =
  { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '300', [['sine']], [['centercursor']] } }
t['<C-f>'] =
  { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '300', [['sine']], [['centercursor']] } }

-- t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '7', '35', easing1}}
-- t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '7', '35', easing1}}

t[',gg'] = { 'scroll', { '-2*vim.api.nvim_buf_line_count(0)', 'true', '1', '5', e } }
t[',G'] = { 'scroll', { '2*vim.api.nvim_buf_line_count(0)', 'true', '1', '5', e } }
require('neoscroll.config').set_mappings(t)
