if exists('g:loaded_dashboard') || &cp
  finish
endif

let g:loaded_dashboard = 1

if !get(g:, 'dashboard_disable_at_vimenter') && (!has('nvim') || has('nvim-0.3.5'))
  set shortmess+=I
endif

let s:home_dir = getenv('HOME')

" Options
let g:dashboard_version = '1.0.0'
let g:dashboard_executive = get(g:,'dashboard_default_executive','telescope')
let g:dashboard_command = get(g:,'dashboard_preview_command','')
let g:preview_file_path = get(g:,'dashboard_preview_file','')
let g:preview_file_height = get(g:,'dashboard_preview_file_height',0)
let g:preview_file_width = get(g:,'dashboard_preview_file_width',0)
let g:preview_pipeline_command = get(g:,'dashboard_preview_pipeline','')
let s:disable_statusline = get(g:,'dashboard_disable_statusline',0)

augroup dashboard
  autocmd!
  autocmd VimEnter * nested call s:loaded_dashboard()
  if s:disable_statusline
    autocmd FileType dashboard set laststatus=0 | autocmd WinLeave <buffer> set laststatus=2
  endif
  autocmd BufReadPost * call dashboard#change_to_dir(expand("%:p"))
  autocmd WinLeave * call dashboard#close_preview()
  autocmd User TelescopeFindPre call dashboard#close_preview()

  autocmd VimResized * if &filetype ==# 'dashboard' | call dashboard#instance(0) | endif
augroup END

function! s:loaded_dashboard() abort
  if !argc() && line2byte('$') == -1
    if !get(g:, 'dashboard_disable_at_vimenter')
      " NOTE: added this for telescope start fix
        if stridx(join(get(v:, 'argv'), ' '), 'Telescope') == -1
          call dashboard#instance(1)
        endif
      endif
  endif
  autocmd! dashboard VimEnter
endfunction

command! -nargs=0 -bar Dashboard call dashboard#instance(0)

command! -nargs=0 -bar DashboardNewFile           call dashboard#handler#new_file()
command! -nargs=0 -bar DashboardFindFile          call dashboard#handler#find_file()
command! -nargs=0 -bar DashboardFindHistory       call dashboard#handler#find_history()
command! -nargs=0 -bar DashboardChangeColorscheme call dashboard#handler#change_colorscheme()
command! -nargs=0 -bar DashboardFindWord          call dashboard#handler#find_word()
command! -nargs=0 -bar DashboardJumpMarks         call dashboard#handler#book_marks()

" vim: et sw=2 sts=2
