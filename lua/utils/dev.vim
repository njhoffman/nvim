" FOR DEVELOPMENT
" nvim --cmd "set rtp+=$(pwd)" -u lua/telescope/_extensions/plugin/dev.vim
set rtp+=.

function! ReloadPlugin()
lua << EOF
  for k in pairs(package.loaded) do
     if k:match("env") then
       print('resetting ' .. k)
       package.loaded[k] = nil
    end
  end
EOF
  LuaCacheClear
  let l:filepath = stdpath('config') . '/lua/telescope/_extensions/env.lua'
  exe "luafile " . l:filepath
  echo "Reloaded " . l:filepath
lua <<EOF
  require('telescope').load_extension('env')
EOF
endfunction

" Reload the plugin
nnoremap <Leader>rp :call ReloadPlugin()<CR>
" Test the plugin
nnoremap <Leader>rP :Telescope env<CR>

" Inital load
lua <<EOF
require('telescope').load_extension('env')
EOF
