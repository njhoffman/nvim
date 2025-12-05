
" Private Functions {{{1
function! s:SetBufferOptDefault(opt, val) "{{{2
  if !exists('b:' . a:opt)
    let b:{a:opt} = a:val
  endif
endfunction

function! s:Map(map, to, mode) "{{{2
  if !empty(a:to) && !hasmapto(a:map, a:mode)
    for l:mode in split(a:mode, '.\zs')
      execute l:mode . 'map <buffer>' a:to a:map
    endfor
  endif
endfunction

function! s:UnMap(map, mode) "{{{2
  if !empty(maparg(a:map, a:mode))
    for mode in split(a:mode, '.\zs')
      execute l:mode . 'unmap <buffer>' a:map
    endfor
  endif
endfunction

function! s:CustomMapping() "{{{2
lua << EOF
-- vim.g.table_mode_toggle_map         m
-- table_mode_corner_corner            |
-- table_mode_separator                |
-- table_mode_corner                   +
-- table_mode_delimiter                ,
-- table_mode_align_char               :
-- table_mode_fill_char                -
-- table_mode_syntax                   1
-- table_mode_update_time              500
-- table_mode_ignore_align             0
-- table_mode_insert_column_before_map <Leader>tic
-- table_mode_insert_column_after_map  <Leader>tiC
-- table_mode_add_formula_map          <Leader>tfa
-- table_mode_eval_formula_map         <Leader>tfe
-- table_mode_cell_text_object_a_map   a<Bar>
-- table_mode_cell_text_object_i_map   i<Bar>
-- [|  ]|  {|  }|                      Move to cell previous, next, above, below
-- TableAddFormula, TableEvalFormulaLine, TableSort
-- Tableize   Tableize/;
-- TableModeDisable, TableModeEnable, TableModeRealign, TableModeToggle


-- stylua: ignore start
vim.g.table_mode_disable_mappings          = false       -- false
vim.g.table_mode_disable_tableize_mappings = false       -- false
vim.g.table_mode_auto_border               = true        -- false
vim.g.table_mode_always_active             = true        -- false
vim.g.table_mode_map_verbose               = true        -- false
vim.g.table_mode_motion_up_map             = "<Bar>k"         --  {<Bar>
vim.g.table_mode_motion_down_map           = "<Bar>j"         --  }<Bar>
vim.g.table_mode_motion_left_map           = "<Bar>h"         --  [<Bar>
vim.g.table_mode_motion_right_map          = "<Bar>l"         --  ]<Bar
vim.g.table_mode_map_prefix                = "<Leader>t" --  <Leader>t
vim.g.table_mode_realign_map               = "<Leader>tr"         --  <Leader>tr |
vim.g.table_mode_delete_row_map            = "<Leader>tdd"        --  <Leader>tdd
vim.g.table_mode_delete_column_map         = "<Leader>tdj"        --  <Leader>tdc
vim.g.table_mode_sort_map                  = "<Leader>ts"         --  <Leader>ts
vim.g.table_mode_echo_cell_map             = "<Leader>t?"         --  <Leader>t?
vim.g.table_mode_tableize_map              = "<Leader>tt"         --  <Leader>tt  visual
vim.g.table_mode_tableize_d_map            = "<Leader>tT"         --  <Leader>T   visual
-- stylua: ignore end

--     g:table_mode_cell_text_object_a_map, 'ox')
--     g:table_mode_cell_text_object_i_map, 'ox')

--     g:table_mode_realign_map, 'n')
--     g:table_mode_delete_row_map, 'n')
--     g:table_mode_delete_column_map, 'n')
--     g:table_mode_insert_column_before_map, 'n')
--     g:table_mode_insert_column_after_map, 'n')
--     g:table_mode_add_formula_map, 'n')
--     g:table_mode_eval_formula_map, 'n')
--     g:table_mode_echo_cell_map, 'n')
-- Enter the first line, delimiting columns by the | symbol. The plugin reacts by inserting spaces between the text and the separator if you omit them:

-- | name | address | phone |
-- In the second line (without leaving Insert mode), enter | twice. The plugin will write a properly formatted horizontal line:

-- | name | address | phone |
-- |------+---------+-------|

-- Go on until the table is ready:

-- | name            | address                  | phone      |
-- |-----------------+--------------------------+------------|
-- | John Adams      | 1600 Pennsylvania Avenue | 0123456789 |
-- |-----------------+--------------------------+------------|
-- | Sherlock Holmes | 221B Baker Street        | 0987654321 |
-- |-----------------+--------------------------+------------|
-- Then you can return to the first line and above it enter ||:

-- |<Esc>:call tablemode#TableizeInsertMode()<CR>a

local map = vim.api.nvim_set_keymap
map('i', '<Bar>', '<Bar><Esc>:call tablemode#TableizeInsertMode()<CR>a', { noremap = true, silent = true, desc = 'TableizeInsertMode' })

map('n', '<Leader>tt',  ':Tableize<CR>',                                        { noremap = false, silent = true, desc = 'Tableize Toggle' })
map('x', '<Leader>tt',  ':Tableize<CR>',                                        { noremap = false, silent = true, desc = 'Tableize Toggle' })
map('x', '<Leader>tT',  ':<C-U>call tablemode#TableizeByDelimiter()<CR>',       { noremap = false, silent = true, desc = 'Tableize With Delimiter'})

map('n', '<Leader>tr',  ':TableModeRealign<CR>',                                { noremap = true,  silent = true, desc = 'TableMode Realign'})
map('n', '<Leader>tdd', ':<C-U>call tablemode#spreadsheet#DeleteRow()<CR>',     { noremap = true,  silent = true, desc = "TableMode Delete Row" })
map('n', '<Leader>tdj', ':<C-U>call tablemode#spreadsheet#DeleteColumn()<CR>',  { noremap = true,  silent = true, desc = "TableMode Delete Column" })
map('n', '<Leader>tic', ':<C-U>call tablemode#spreadsheet#InsertColumn(0)<CR>', { noremap = true,  silent = true, desc = "TableMode Insert Before" })
map('n', '<Leader>tiC', ':<C-U>call tablemode#spreadsheet#InsertColumn(1)<CR>', { noremap = true,  silent = true, desc = "TableMode Insert After" })
map('n', '<Leader>ts',  ':<C-U>call tablemode#spreadsheet#Sort()<CR>',          { noremap = true,  silent = true, desc = "TableMode Sort" })
map('n', '<Leader>t?',  ':<C-U>call tablemode#spreadsheet#EchoCell()<CR>',      { noremap = true,  silent = true, desc = "TableMode Echo Cell" })

map('n', '{<Bar>',      ':<C-U>call tablemode#spreadsheet#Motion("k")<CR>',     { noremap = true,  silent = true, desc = "TableMode Move Up" })
map('n', '}<Bar>',      ':<C-U>call tablemode#spreadsheet#Motion("j")<CR>',     { noremap = true,  silent = true, desc = "TableMode Move Down" })
map('n', '[<Bar>',      ':<C-U>call tablemode#spreadsheet#Motion("h")<CR>',     { noremap = true,  silent = true, desc = "TableMode Move Left" })
map('n', ']<Bar>',      ':<C-U>call tablemode#spreadsheet#Motion("l")<CR>',     { noremap = true,  silent = true, desc = "TableMode Move Right" })

map('n', '<Leader>ta',  '<Plug>(table-mode-cell-text-object-a)',                { noremap = true,  silent = true, desc = "TableMode textobj-around" })
map('n', '<Leader>ti',  '<Plug>(table-mode-cell-text-object-i)',                { noremap = true,  silent = true, desc = "TableMode textobj-inner"})
map('x', '<Leader>ta',  '<Plug>(table-mode-cell-text-object-a)',                { noremap = true,  silent = true, desc = "TableMode textobj-around" })
map('x', '<Leader>ti',  '<Plug>(table-mode-cell-text-object-i)',                { noremap = true,  silent = true, desc = "TableMode textobj-inner" })

map('n', '<Leader>tfa', ':<C-U>call tablemode#spreadsheet#formula#Add()<CR>', { noremap = true, silent = true, desc = "TableMode Add Formula"})
map('n', '<Leader>tfe', ':<C-U>call tablemode#spreadsheet#formula#EvaluateFormulaLine()<CR>', { noremap = true, silent = true, desc = "TableMode Evaluate Formula Line"})

EOF


endfunction

function! s:ToggleMapping() "{{{2
  if !g:table_mode_disable_mappings
    if tablemode#IsActive()
      call s:Map('<Plug>(table-mode-tableize)', g:table_mode_separator_map, 'i')
      call s:Map('<Plug>(table-mode-motion-up)', g:table_mode_motion_up_map, 'n')
      call s:Map('<Plug>(table-mode-motion-down)', g:table_mode_motion_down_map, 'n')
      call s:Map('<Plug>(table-mode-motion-left)', g:table_mode_motion_left_map, 'n')
      call s:Map('<Plug>(table-mode-motion-right)', g:table_mode_motion_right_map, 'n')

      call s:Map('<Plug>(table-mode-cell-text-object-a)', g:table_mode_cell_text_object_a_map, 'ox')
      call s:Map('<Plug>(table-mode-cell-text-object-i)', g:table_mode_cell_text_object_i_map, 'ox')

      call s:Map('<Plug>(table-mode-realign)', g:table_mode_realign_map, 'n')
      call s:Map('<Plug>(table-mode-delete-row)', g:table_mode_delete_row_map, 'n')
      call s:Map('<Plug>(table-mode-delete-column)', g:table_mode_delete_column_map, 'n')
      call s:Map('<Plug>(table-mode-insert-column-before)', g:table_mode_insert_column_before_map, 'n')
      call s:Map('<Plug>(table-mode-insert-column-after)', g:table_mode_insert_column_after_map, 'n')
      call s:Map('<Plug>(table-mode-add-formula)', g:table_mode_add_formula_map, 'n')
      call s:Map('<Plug>(table-mode-eval-formula)', g:table_mode_eval_formula_map, 'n')
      call s:Map('<Plug>(table-mode-echo-cell)', g:table_mode_echo_cell_map, 'n')
      call s:Map('<Plug>(table-mode-sort)', g:table_mode_sort_map, 'n')
    else
      call s:UnMap(g:table_mode_separator_map, 'i')
      call s:UnMap(g:table_mode_motion_up_map, 'n')
      call s:UnMap(g:table_mode_motion_down_map, 'n')
      call s:UnMap(g:table_mode_motion_left_map, 'n')
      call s:UnMap(g:table_mode_motion_right_map, 'n')

      call s:UnMap(g:table_mode_cell_text_object_a_map, 'ox')
      call s:UnMap(g:table_mode_cell_text_object_i_map, 'ox')

      call s:UnMap(g:table_mode_realign_map, 'n')
      call s:UnMap(g:table_mode_delete_row_map, 'n')
      call s:UnMap(g:table_mode_delete_column_map, 'n')
      call s:UnMap(g:table_mode_insert_column_before_map, 'n')
      call s:UnMap(g:table_mode_insert_column_after_map, 'n')
      call s:UnMap(g:table_mode_add_formula_map, 'n')
      call s:UnMap(g:table_mode_eval_formula_map, 'n')
      call s:UnMap(g:table_mode_echo_cell_map, 'n')
      call s:UnMap(g:table_mode_sort_map, 'n')
    endif
  endif
endfunction

function! s:ToggleSyntax() "{{{2
  if !g:table_mode_syntax | return | endif

  if tablemode#IsActive()
    exec 'syntax match Table'
          \ '/' . tablemode#table#StartExpr() . '\zs|.\+|\ze' . tablemode#table#EndExpr() . '/'
          \ 'contains=TableBorder,TableSeparator,TableColumnAlign,yesCell,noCell,maybeCell,redCell,greenCell,yellowCell,blueCell,whiteCell,darkCell'
          \ 'containedin=ALL'
    syntax match TableSeparator /|/ contained
    syntax match TableColumnAlign /:/ contained
    syntax match TableBorder /[\-+]\+/ contained

    hi! link TableBorder Delimiter
    hi! link TableSeparator Delimiter
    hi! link TableColumnAlign Type

    syntax match redCell '|\@<= *r:[^|]*' contained
    hi redCell ctermfg=9 ctermbg=1

    syntax match greenCell '|\@<= *g:[^|]*' contained
    hi greenCell ctermfg=10 ctermbg=2

    syntax match yellowCell '|\@<= *y:[^|]*' contained
    hi yellowCell ctermfg=11 ctermbg=3

    syntax match blueCell '|\@<= *b:[^|]*' contained
    hi blueCell ctermfg=12 ctermbg=4

    syntax match whiteCell '|\@<= *w:[^|]*' contained
    hi whiteCell ctermfg=0 ctermbg=15

    syntax match darkCell '|\@<= *d:[^|]*' contained
    hi darkCell ctermfg=15 ctermbg=0

    if exists("g:table_mode_color_cells") && g:table_mode_color_cells
      syntax match yesCell '|\@<= *yes[^|]*' contained
      syntax match noCell '|\@<= *no\A[^|]*' contained " \A to exclude words like notes
      syntax match maybeCell '|\@<= *?[^|]*' contained
      " '|\@<=' : Match previous characters, excluding them from the group
    endif

  else
    syntax clear Table
    syntax clear TableBorder
    syntax clear TableSeparator
    syntax clear TableColumnAlign

    hi! link TableBorder NONE
    hi! link TableSeparator NONE
    hi! link TableColumnAlign NONE
  endif
endfunction

function! s:ToggleAutoAlign() "{{{2
  if !g:table_mode_auto_align | return | endif

  if tablemode#IsActive()
    augroup TableModeAutoAlign
      au!

      autocmd CursorHold <buffer> nested silent! if &modified | call tablemode#table#Realign('.') | endif
      " autocmd InsertLeave <buffer> nested silent! if &modified | call tablemode#table#Realign('.') | endif
    augroup END
  else
    autocmd! TableModeAutoAlign
  endif
endfunction

function! s:ToggleOptions() "{{{2
  if tablemode#IsActive()
    let b:old_update_time = &updatetime
    exec 'set updatetime='.g:table_mode_update_time
  else
    exec 'set updatetime='.get(b:, 'old_update_time', 4000)
  endif
endfunction

function! s:SetActive(bool) "{{{2
  let b:table_mode_active = a:bool
  call s:CustomMapping()
  call s:ToggleSyntax()
  " call s:ToggleMapping()
  call s:ToggleAutoAlign()
  call s:ToggleOptions()
  if tablemode#IsActive()
    doautocmd User TableModeEnabled
  else
    doautocmd User TableModeDisabled
  endif
endfunction

function! s:ConvertDelimiterToSeparator(line, ...) "{{{2
  let old_gdefault = &gdefault
  set nogdefault

  let delim = g:table_mode_delimiter
  if a:0 | let delim = a:1 | endif
  if delim ==# ','
    silent! execute a:line . 's/' . "[\'\"][^\'\"]*\\zs,\\ze[^\'\"]*[\'\"]/__COMMA__/g"
  endif

  let [cstart, cend] = [tablemode#table#GetCommentStart(), tablemode#table#GetCommentEnd()]
  let [match_char_start, match_char_end] = ['.', '.']
  if tablemode#utils#strlen(cend) > 0 | let match_char_end = '[^' . cend . ']' | endif
  if tablemode#utils#strlen(cstart) > 0 | let match_char_start = '[^' . cstart . ']' | endif

  silent! execute a:line . 's/' . tablemode#table#StartExpr() . '\zs\ze' . match_char_start .
        \ '\|' . delim .  '\|' . match_char_end . '\zs\ze' . tablemode#table#EndExpr() . '/' .
        \ g:table_mode_separator . '/g'

  if delim ==# ','
    silent! execute a:line . 's/' . "[\'\"][^\'\"]*\\zs__COMMA__\\ze[^\'\"]*[\'\"]/,/g"
  endif

  let &gdefault=old_gdefault
endfunction

function! s:Tableizeline(line, ...) "{{{2
  let delim = g:table_mode_delimiter
  if a:0 && type(a:1) == type('') && !empty(a:1) | let delim = a:1[1:-1] | endif
  call s:ConvertDelimiterToSeparator(a:line, delim)
endfunction

" Public API {{{1
function! tablemode#IsActive() "{{{2
  if g:table_mode_always_active | return 1 | endif

  call s:SetBufferOptDefault('table_mode_active', 0)
  return b:table_mode_active
endfunction

function! tablemode#TableizeInsertMode() "{{{2
  if tablemode#IsActive()
    if getline('.') =~# (tablemode#table#StartExpr() . g:table_mode_separator . g:table_mode_separator . tablemode#table#EndExpr())
      call tablemode#table#AddBorder('.')
      normal! A
    elseif getline('.') =~# (tablemode#table#StartExpr() . g:table_mode_separator)
      let column = tablemode#utils#strlen(substitute(getline('.')[0:col('.')], '[^' . g:table_mode_separator . ']', '', 'g'))
      let position = tablemode#utils#strlen(matchstr(getline('.')[0:col('.')], '.*' . g:table_mode_separator . '\s*\zs.*'))
      call tablemode#table#Realign('.')
      normal! 0
      call search(repeat('[^' . g:table_mode_separator . ']*' . g:table_mode_separator, column) . '\s\{-\}' . repeat('.', position), 'ce', line('.'))
    endif
  endif
endfunction

function! tablemode#Enable() "{{{2
  call s:SetActive(1)
endfunction

function! tablemode#Disable() "{{{2
  call s:SetActive(0)
endfunction

function! tablemode#Toggle() "{{{2
  if g:table_mode_always_active
    return 1
  endif

  call s:SetBufferOptDefault('table_mode_active', 0)
  call s:SetActive(!b:table_mode_active)
endfunction

function! tablemode#TableizeRange(...) range "{{{2
  let lnum = a:firstline
  let total = (a:lastline - a:firstline + 1)
  " echom total
  let cntr = 1
  while cntr <= total
    call s:Tableizeline(lnum, a:1)
    undojoin
    if g:table_mode_tableize_auto_border
      if cntr == 1
        normal! O
        call tablemode#table#AddBorder('.')
        normal! j
        let lnum += 1
      endif
      normal! o
      call tablemode#table#AddBorder('.')
      let lnum += 1
    endif
    let cntr += 1
    let lnum += 1
  endwhile

  call tablemode#table#Realign(lnum - 1)
endfunction

function! tablemode#TableizeByDelimiter() "{{{2
  let delim = input('/')
  if delim =~# "\<Esc>" || delim =~# "\<C-C>" | return | endif
  let vm = visualmode()
  if vm ==? 'line' || vm ==? 'V'
    exec line("'<") . ',' . line("'>") . "call tablemode#TableizeRange('/' . delim)"
  endif
endfunction

if !hlexists('yesCell') | hi yesCell cterm=bold ctermfg=10 ctermbg=2 | endif |
if !hlexists('noCell') | hi noCell cterm=bold ctermfg=9 ctermbg=1 | endif |
if !hlexists('maybeCell') | hi maybeCell cterm=bold ctermfg=11 ctermbg=3 | endif |
