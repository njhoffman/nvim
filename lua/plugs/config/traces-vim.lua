vim.cmd [[
  let g:traces_preview_window = 'bot 10vnew'
  " let g:traces_preview_window = 'vertical botright new'
  " let g:traces_preview_window = 'topleft 15new'
]]

-- If window width is greater than 160 columns, open vertical
-- window or else open horizontal window
-- let g:traces_preview_window =
--       \ "winwidth('%') > 160 ? 'bot vnew' : 'bot 10new'"
