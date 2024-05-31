--  vim.g.vimade = {
-- TODO: have separate fade level for focus events

vim.g.vimade = {
  -- running = 0,
  basebg = '#041026',
  basegroups = {
    'Conceal',
    'CursorLine',
    'CursorLineNr',
    -- 'ColorColumn',
    'LineNr',
    'DiffAdd',
    'DiffChange',
    'DiffDelete',
    'DiffText',
    'EndOfBuffer',
    'FoldColumn',
    'Folded',
    'NonText',
    -- 'MiniIndentscopeSymbol',
    -- 'IblScope',
    -- 'IblIndent',
    -- 'IblWhitespace',
    -- '@ibl.scope.char.1',
    -- '@ibl.indent.char.1',
    -- '@ibl.whitespace.char.1',
    'Search',
    'SignColumn',
    -- 'Scrollbar',
    -- 'ScrollView',
    'SpecialKey',
    -- 'StatusLine',
    'WinBar',
    'WinSeparator',
    'Whitespace',
    'VirtualText',
    'barbecue_basename',
    'barbecue_normal',
    'barbecue_context',
  },
  checkinterval = 100,
  detecttermcolors = 1,
  enablebasegroups = 1,
  enablefocusfading = 1,
  enablesigns = 0,
  enabletreesitter = 1,
  fadelevel = '0.50',
  fadepriority = 100,
  groupdiff = 1,
  groupscrollbind = 1,
  signspriority = 31,
  signsretentionperiod = 4000,
  usecursorhold = 0,
}

vim.api.nvim_create_augroup('VimadeEvents', { clear = true })
vim.api.nvim_create_autocmd({ 'FocusLost' }, {
  group = 'VimadeEvents',
  callback = function(ev)
    local winid = vim.fn.bufwinid(ev.buf)
    vim.api.nvim_set_option_value('colorcolumn', '', { win = winid })
  end,
})
vim.api.nvim_create_autocmd({ 'FocusGained' }, {
  group = 'VimadeEvents',
  callback = function(ev)
    local winid = vim.fn.bufwinid(ev.buf)
    vim.api.nvim_set_option_value('colorcolumn', '+1', { win = winid })
  end,
})
-- window instead of bufer fading
-- augroup SemiDimPerWin
-- au!
-- au WinLeave * call OnWinLeave()
-- au WinEnter * call OnWinEnter()
-- au! TextChangedI,TextChanged * call UpdateBufferAsync()
-- augroup END

-- function! OnWinEnter ()
--     VimadeFadeActive
--     VimadeWinDisable
-- endfunction
-- function! OnWinLeave ()
--     VimadeWinEnable
-- endfunction

-- function! UpdateBufferAsync ()
--     if exists('g:update_vimade')
--         return
--     endif
--     let g:update_vimade = timer_start(1, 'DoUpdateBuffer') "change the timer value from 1 to whatever to help with performance
-- endfunction

-- function! DoUpdateBuffer (w)
--     unlet g:update_vimade
--     call vimade#BufDisable()
--     call vimade#BufEnable()
-- endfunction

-- print(vim.inspect(vim.g.vimade.fadelevel))
