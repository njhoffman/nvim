" ============================================================================
" Fake - Random dummy/filler text generator
" ============================================================================

if exists('g:loaded_fake')
  finish
endif

"" Choose a random element from a list
" call fake#define('sex', 'fake#choice(["male", "female"])')

"" Get a name of male or female
"" fake#int(1) returns 0 or 1

" call fake#define('name', 'fake#int(1) ? fake#gen("male_name")'
"       \ . ' : fake#gen("female_name")')
"" Get a full name
" call fake#define('fullname', 'fake#gen("name") . " " . fake#gen("surname")')

"" Get a nonsense text like Lorem ipsum
" call fake#define('sentense', 'fake#capitalize('
"       \ . 'join(map(range(fake#int(3,15)),"fake#gen(\"nonsense\")"))'
"       \ . ' . fake#chars(1,"..............!?"))')

" call fake#define('paragraph', 'join(map(range(fake#int(3,10)),"fake#gen(\"sentense\")"))')

"" Alias
" call fake#define('lipsum', 'fake#gen("paragraph")')

" You can add your favorite dictionaries. g:fake_src_paths is a list of directory that contains dictionaries, which will be used in fake#load() or fake#gen() as its search path.
let g:fake_src_paths = ['/home/nicholas/.config/nvim/plugin/fake-data']


let s:save_cpo = &cpo
set cpo&vim

augroup AutoCmdFake
  autocmd!
augroup END

autocmd! AutoCmdFake BufHidden * call fake#free_cache()


function! s:FakeSubstitute(...) range
  let firstline = get(a:000, 0)
  let lastline = get(a:000, 1)
  let pat = 'FAKE__\([[:alnum:]\/_-]\{-}\)__'
  let sub = '\=fake#has_keyname(submatch(1))?fake#gen(submatch(1)):submatch(0)'

  silent execute printf(':%s,%ss/%s/%s/ge', firstline, lastline, pat, sub)
endfunction

command! -range=% FakeSubstitute :call <SID>FakeSubstitute(<line1>, <line2>)


let &cpo = s:save_cpo
let g:loaded_fake = 1

unlet s:save_cpo

" vim: ft=vim fenc=utf-8 ff=unix foldmethod=marker:
