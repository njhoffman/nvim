" call Test_bqf_pattern()` and `call Test_bqf_lsp_ranges()`

function s:create_qf()
  enew
  let bufnr = bufnr('%')
  for i in range(1, 3)
    call setline(i, i .. ' | ' .. strftime("%F"))
  endfor

  call setqflist([{'bufnr': bufnr, 'lnum': 1, 'col': 5},
        \  {'bufnr': bufnr, 'lnum': 2, 'col': 10},
        \  {'bufnr': bufnr, 'lnum': 3, 'col': 13}])
endfunction

function! Test_bqf_pattern()
  call s:create_qf()
  call setqflist([], 'r', {'context': {'bqf': {'pattern_hl': '\d\+'}},
        \ 'title': 'pattern_hl'})
  cwindow
endfunc

function! Test_bqf_lsp_ranges()
  call s:create_qf()
  let lsp_ranges = []
  call add(lsp_ranges, {
        \ 'start': {'line': 0, 'character': 4},
        \ 'end': {'line': 0, 'character': 8}
        \ })
  call add(lsp_ranges, {
        \ 'start': {'line': 1, 'character': 9},
        \ 'end': {'line': 1, 'character': 11}
        \ })
  call add(lsp_ranges, {
        \ 'start': {'line': 2, 'character': 12},
        \ 'end': {'line': 2, 'character': 14}
        \ })
  call setqflist([], 'r', {'context': {'bqf': {'lsp_ranges_hl': lsp_ranges}},
        \ 'title': 'lsp_ranges_hl'})
  cwindow
endfunc
