#!/usr/bin/env lua

-- | if &bufhidden =~ 'wipe' && &buftype =~ 'nofile' && &buftype =~ hidden | silent! wshada | silent! !~/bin/wshada.sh | endif",
-- local shadaEventsViml = { { "BufWrite", "*", [[call ShadaWrite()]] }, { "Signal", "SIGUSR1", [[call ShadaRead()]] } }
if Opts.shada_events == true then
  autocmds.ShadaEvents = {
    { 'BufRead', '*', [[call ShadaWrite()]] },
    { 'Signal', 'SIGUSR1', [[call ShadaRead()]] },
  }
end

--
-- let s:shada_script = stdpath('config') .. '/bin/wshada.sh'
--
-- function! ShadaWrite()
--   " TODO: convert to lua, whitelist filetypes
--   if(getftype(@%) == "file" && &bufhidden == '')
--     let l:buftype = &buftype || "<empty>"
--     let l:summary = 'ShadaWrite: ' . buffer_name()  . ' : ' . &ft
--     let l:summary2 = 'type: ' . l:buftype . ', listed: ' . &buflisted
--     " lua vim.notify( vim.api.nvim_eval('l:summary'), 'debug', { title = 'shada' })
--     " lua vim.notify({ vim.api.nvim_eval('l:summary'), vim.api.nvim_eval('l:summary2') }, 'debug', { title = 'shada' })
--     exec 'silent! wshada'
--     exec 'silent! !' . s:shada_script . ' ' . buffer_name()
--   endif
-- endfunction
-- command ShadaWrite call ShadaWrite()
--
-- function! ShadaRead()
--   " lua vim.notify('Received USR1 signal for ShadaRead', 'debug', { title = 'shada' })
--   exec "silent! rshada!"
-- endfunction
-- command ShadaRead call ShadaRead()
--
