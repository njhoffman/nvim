" handle node_module gf jumping
au FileType javascript,json,jsx,typescript,tsx call ImproveNodeEditing()

function! ImproveNodeEditing()
  setlocal isfname+=@-@ " some node_modules are namespaced with an @
  setlocal suffixesadd+=.js,.json,.jsx,.ts,.tsx
  setlocal includeexpr=LookupNodeModule(v:fname)
" 'path', 'suffixesadd', 'include'
endfunction

function! LookupNodeModule(fname)
  let modulesPath = finddir('node_modules', expand('%:p:h') . ';' . getcwd()) . '/' . a:fname
  let indexFileJs = modulesPath . '/index.js'
  let indexFileTs = modulesPath . '/index.ts'
  let packageFile = modulesPath . '/package.json'

  if filereadable(packageFile)
    let package = json_decode(join(readfile(packageFile)))

    if has_key(package, 'module')
      return modulesPath . '/' . package.module
    endif

    if has_key(package, 'main')
      return modulesPath . '/' . package.main
    endif
  endif

  if filereadable(indexFileTs)
    return indexFileTs
  endif

  if filereadable(indexFileJs)
    return indexFileJs
  endif

  return modulesPath
endfunction

" adapted from https://github.com/romainl/ctags-patterns-for-javascript
let &l:define = '\v' . (empty(&l:define) ? '' : '|')

" classes
let &l:define .= '^\s*var\s+\ze[A-Z]\i+\s*\=\s*function|' .
                  \ '^\s*let\s+\ze[A-Z]\i+\s*\=\s*function|' .
                  \ '^\s*const\s+\ze[A-Z]\i+\s*\=\s*function|' .
                  \ '^\s*class\s+\ze\i+|'

" methods
let &l:define .= '^\s*this\.\ze\i+\s*\=.*\{$|' .
      \ '^\s*\ze\i+\s*[:=]\s*\(*function\s*\(|' .
      \ '^\s*\ze\i+\s*\=\s.+\=\>|' .
      \ '^\s*static\s+\ze\i+\s*\(|' .
      \ '^\s*\ze\i+\(.*\)\s*\{|'

" generator functions
let &l:define .= '^\s*function\s*\*\s*\ze\i+|' .
      \ '^\s*var\s+\ze[a-z]\i+\s*\=\s*function\(\s*\*\)|' .
      \ '^\s*let\s+\ze[a-z]\i+\s*\=\s*function\(\s*\*\)|' .
      \ '^\s*const\s+\ze[a-z]\i+\s*\=\s*function\(\s*\*\)|' .
      \ '^\s*\(\*\s\)\ze\i+\s*.*\s*\{|'

" free-form functions
let &l:define .= '^\s*function\s*\ze\i+[[:space:](]|' .
                  \ '^\s*\(function\s*\ze\i+[[:space:](]|' .
                  \ '^\s*var\s+\ze[a-z]\i+\s*\=\s*function[^\*][^\*]|' .
                  \ '^\s*let\s+\ze[a-z]\i+\s*\=\s*function[^\*][^\*]|' .
                  \ '^\s*const\s+\ze[a-z]\i+\s*\=\s*function[^\*][^\*]|' .
                  \ '^\s*var\s+\ze[a-z]\i+\s*\=\s*\([^\*]|' .
                  \ '^\s*let\s+\ze[a-z]\i+\s*\=\s*\([^\*]|' .
                  \ '^\s*const\s+\ze[a-z]\i+\s*\=\s*\([^\*]|'
" exports
let &l:define .= '^\s*export\s+function\s+\ze\i+|' .
                  \ '^\s*export\s+default\s+function\s+\ze\i+'
