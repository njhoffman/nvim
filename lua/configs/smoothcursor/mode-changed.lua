  --         ﲵ       嶺 淪 ▷   輪 ﯖ  
  -- 濾      礪 閭 驪 麗 ﱵ 隷   •   ● ●  
-- stylua: ignore
local icons = {
  ['n']  = '▷', --    ◆ ﮜ ▷
  ['o']  = '', --    ◆ ﮜ ▷
  ['no'] = '', --    ◆ ﮜ ▷
  ['v']  = '',
  ['V']  = '',
  [''] = '礪',
  ['R']  = ' ',
  ['i']  = '',
  ['s']  = '',
  ['S']  = '',
  ['c']  = '',
  ['C']  = '',
  ['*']  = '',
}

local colors = {
  -- ['n'] = { fg = '#fa4842', bold = true },
  ['n'] = { fg = '#0081ca', bold = true },
  ['no'] = { fg = '#0081ca', bold = true },
  ['o'] = { fg = '#0081ca', bold = true },
  ['v'] = { fg = '#8f41fa', bold = true },
  ['V'] = { fg = '#8f41fa', bold = true },
  [''] = { fg = '#8f41fa', bold = true },
  ['R'] = { fg = '#fa4842', bold = true },
  ['s'] = { fg = '#0f61ba', bold = true },
  ['S'] = { fg = '#0f61ba', bold = true },
  ['c'] = { fg = '#8f216a', bold = true },
  ['C'] = { fg = '#8f216a', bold = true },
  ['i'] = { fg = '#00afaf', bold = true },
  ['*'] = { fg = '#fa4842', bold = true },
  -- ! C C R S V c i n r s t v
}

-- vim.api.nvim_create_autocmd({ 'ModeChanged' }, {
--   callback = function(ev)
--     local set_mode = function(icon, opts)
--       vim.dbglog('set mode', icon)
--       vim.api.nvim_set_hl(0, 'SmoothCursor', {
--         fg = opts.fg or nil,
--         bg = opts.bg or nil,
--         sp = opts.sp or nil,
--         bold = opts.bold or nil,
--         italic = opts.italic or nil,
--         style = opts.style or nil,
--         link = opts.link or nil,
--       })
--       vim.fn.sign_define('smoothcursor', { text = icon })
--       vim.cmd('redraw')
--     end

--     local from, to = unpack(vim.split(ev.match, ':'))
--     if type(icons[to]) ~= 'nil' then
--       set_mode(icons[to], colors[to])
--     else
--       vim.dbglog('mode no icon: ' .. to, from)
--       set_mode(icons['*'], colors['*'])
--     end
--   end,
-- })
