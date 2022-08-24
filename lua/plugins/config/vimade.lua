-- vim.cmd(
--   [[
--   let g:vimade = {
--   \ "normalid": '',
--   \ "normalncid": '',
--   \ "basefg": '',
--   \ "basebg": '',
--   \ "fadelevel": 0.4,
--   }]]
-- )
--  vim.g.vimade = {
--    enabletreesitter = 1,
--    basegroups = {
--      "VirtualText",
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
-- vim.cmd([[let g:vimade  = {}]])
-- vim.cmd([[let g:vimade.fadelevel = 0.6]])
-- vim.cmd([[let g:vimade.enabletreesitter = 1]])
-- vim.cmd([[let g:vimade.fadepriority = 50]])
-- vim.cmd([[let g:vimade.colbufsize = 15]])
-- vim.cmd([[let g:vimade.rowbufsize = 15]])
-- vim.cmd([[let g:vimade.signsretentionperiod = 1]])
-- vim.cmd([[let g:vimade.enablefocusfading = 1]])
vim.g.vimade = {
  -- running = 0,
  basebg = "#001133",
  basegroups = {
    "CursorLine",
    "CursorLineNr",
    "DiffAdd",
    "DiffChange",
    "DiffDelete",
    "DiffText",
    "FoldColumn",
    "Folded",
    "LineNr",
    "Search",
    "SignColumn",
    "Whitespace",
    -- "VirtualText",
    -- "v2hexokinase",
  },
  rowbufsize = 25,
  colbufsize = 25,
  fadelevel = 0.70,
  signsretentionperiod = 4000,
  fadepriority = 500,
  enablesigns = 1,
  signspriority = 31,
  enabletreesitter = 1,
  enablebasegroups = 1,
  enablefocusfading = 1,
  checkinterval = 100,
  groupdiff = 0,
  groupscrollbind = 1,
  detecttermcolors = 0,
  usecursorhold = 0,
}

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
