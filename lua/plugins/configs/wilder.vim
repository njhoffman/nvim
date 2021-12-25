function! SetShortmessF(on) abort
  if a:on
    set shortmess+=F
  else
    set shortmess-=F
  endif
  return ''
endfunction

nnoremap <expr> : SetShortmessF(1) . ':'

augroup WilderShortmessFix
  autocmd!
  autocmd CmdlineLeave * call SetShortmessF(0)
augroup END

call wilder#enable_cmdline_enter()

" set wildcharm=<Tab>
set wildcharm=<C-n>
" TODO: port this to lua
cmap <expr> <C-n> wilder#in_context() ? wilder#next() : "\<C-n>"
cmap <expr> <C-p> wilder#in_context() ? wilder#previous() : "\<C-p>"

cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"

let s:highlighters = [  wilder#pcre2_highlighter(), wilder#lua_fzy_highlighter() ]

call wilder#set_option('modes', ['/', '?', ':'])
call wilder#set_option('pipeline', [  wilder#branch( wilder#python_file_finder_pipeline({ 'file_command': {_, arg -> stridx(arg, '.') != -1 ? ['fd', '-tf', '-H'] : ['fd', '-tf']}, 'dir_command': ['fd', '-td'], 'filters': ['fuzzy_filter'], 'cache_timestamp': {-> 1} }), wilder#cmdline_pipeline({ 'fuzzy': 1, 'sorter': wilder#python_difflib_sorter(), }), wilder#python_search_pipeline({ 'pattern': 'fuzzy', }),), ])
call wilder#set_option('renderer', wilder#renderer_mux({  ':': wilder#popupmenu_renderer({   'highlighter': s:highlighters,   'left': [     wilder#popupmenu_devicons(),   ],   'right': [ ' ', wilder#popupmenu_scrollbar() ] }), '/': wilder#wildmenu_renderer({    'highlighter': s:highlighters,  }),  }))


" call wilder#set_option('renderer', wilder#renderer_mux({
"       \ ':': wilder#popupmenu_renderer({
"       \ 'highlighter': wilder#basic_highlighter(),
"       \ }),
"       \ '/': wilder#wildmenu_renderer(
"       \ wilder#lightline_theme({
"       \   'highlights': {},
"       \   'highlighter': wilder#basic_highlighter(),
"       \   'separator': ' · ',
"       \ })
"       \ ),
"       \ }))

" " wilder#popupmenu_devicons() needs 'ryanoasis/vim-devicons' to be installed
" call wilder#set_option('renderer', wilder#popupmenu_renderer({
"       \ 'highlighter': wilder#basic_highlighter(),
"       \ 'left': [
"         \   wilder#popupmenu_devicons(),
"         \   wilder#popupmenu_buffer_flags(),
"         \ ],
"         \ 'right': [
"           \   ' ',
"           \   wilder#popupmenu_spinner(),
"           \  wilder#popupmenu_scrollbar(),
"           \ ],
"           \ }))
