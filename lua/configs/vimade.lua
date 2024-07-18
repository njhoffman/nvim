--  vim.g.vimade = {
--    enabletreesitter = 1,
--    basegroups = {
--      "Search",
--      "SignColumn",
--      "v2hexokinase", "LineNr",
--      "CursorLine",
--      "CursorLineNr",
--      "DiffAdd",
--      "DiffChange",
--      "DiffDelete",
--      "DiffText",
--      "FoldColumn",
--      "Whitespace"
--    },
--    rowbufsize = 15,
--    colbufsize = 15,
--    fadelevel = 0.7,
--    signsretentionperiod = 1000,
--    fadepriority = 50,
--    enablesigns = 1,
--    enablefocusfading = 1
-- --  }

-- TODO: have separate fade level for focus events

vim.g.vimade = {
  -- running = 0,
  basebg = "#041026",
  basegroups = {
    "Conceal",
    -- "ColorColumn",
    "CursorLine",
    "CursorLineNr",
    "CursorColumn",
    "LineNr",
    "DiffAdd",
    "DiffChange",
    "DiffDelete",
    "DiffText",
    "EndOfBuffer",
    "FoldColumn",
    "Folded",
    "NonText",
    -- 'MiniIndentscopeSymbol',
    -- 'IblScope',
    -- 'IblIndent',
    -- 'IblWhitespace',
    -- '@ibl.scope.char.1',
    -- '@ibl.indent.char.1',
    -- '@ibl.whitespace.char.1',
    -- 'Search',
    "SignColumn",
    -- 'Scrollbar',
    -- 'ScrollView',
    "SpecialKey",
    -- 'StatusLine',
    "WinBar",
    "WinSeparator",
    "Whitespace",
    "VirtualText",
    "barbecue_basename",
    "barbecue_normal",
    "barbecue_context",
  },
  checkinterval = 100,
  detecttermcolors = 1,
  enablebasegroups = 1,
  enablefocusfading = 1,
  enablesigns = 0,
  enabletreesitter = 1,
  fadelevel = 0.5,
  fadepriority = 100,
  groupdiff = 1,
  groupscrollbind = 1,
  signspriority = 31,
  signsretentionperiod = 4000,
  usecursorhold = 0,
}

vim.api.nvim_create_augroup("VimadeEvents", { clear = true })
vim.api.nvim_create_autocmd({ "FocusLost", "WinLeave" }, {
  group = "VimadeEvents",
  callback = function(ev)
    local winid = vim.fn.bufwinid(ev.buf)
    vim.api.nvim_set_option_value("colorcolumn", "0", { win = winid })
  end,
})

-- vim.cmd('VimadeFadeActive')
vim.api.nvim_create_autocmd({ "FocusGained", "WinEnter" }, {
  group = "VimadeEvents",
  callback = function(ev)
    local winid = vim.fn.bufwinid(ev.buf)
    vim.api.nvim_set_option_value("colorcolumn", "+1", { win = winid })
  end,
})
-- vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufWinLeave' }, {
--   group = 'VimadeEvents',
--   callback = function(ev)
--     local state = {
--       bufnr = ev.buf,
--       winnr = vim.fn.bufwinnr(ev.buf),
--       ft = vim.api.nvim_buf_get_option(ev.buf, 'filetype'),
--       buftype = vim.api.nvim_buf_get_option(ev.buf, 'buftype'),
--       bufname = vim.api.nvim_buf_get_name(ev.buf),
--     }
--     local wininfo = vim.fn.getwininfo(state.winnr)
--     vim.dbglog(ev.event .. ':' .. state.bufnr .. ' ' .. state.buftype .. ' ' .. state.ft)
--   end,
-- })

-- vim.cmd([[
--  " window instead of bufer fading
--  augroup SemiDimPerWin
--  au!
--  au WinLeave * call OnWinLeave()
--  au WinEnter * call OnWinEnter()
--  au! TextChangedI,TextChanged * call UpdateBufferAsync()
--  augroup END

--   function! OnWinEnter ()
--       VimadeFadeActive
--       VimadeWinDisable
--   endfunction
--   function! OnWinLeave ()
--       VimadeWinEnable
--   endfunction

--  function! UpdateBufferAsync ()
--      if exists('g:update_vimade')
--          return
--      endif
--      let g:update_vimade = timer_start(1, 'DoUpdateBuffer') "change the timer value from 1 to whatever to help with performance
--  endfunction

--  function! DoUpdateBuffer (w)
--      unlet g:update_vimade
--      call vimade#BufDisable()
--      call vimade#BufEnable()
--  endfunction

-- ]])
-- print(vim.inspect(vim.g.vimade.fadelevel))
