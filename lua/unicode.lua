-- :Digraphs        - Search for specific digraph char
-- :UnicodeSearch   - Search for specific Unicode char
-- :UnicodeSearch!  - Search for specific Unicode char (and add at current cursor position)
-- :UnicodeName     - Identify character under cursor (like ga command)
-- :UnicodeTable    - Print Unicode Table in new window
-- :DownloadUnicode - Download (or update) Unicode data
-- :UnicodeCache    - Create cache file
-- <C-X><C-G>  - Complete Digraph char (*X<C-x><C-g> inserts ×)
-- <C-X><C-Z>  - Complete Unicode char (U+00d7<C-x><C-z> inserts ×)
-- <F4>        - Convert selected digraphs into their corresponding characters
-- unicode#FindUnicodeBy() - Find Unicode characters
-- unicode#FindDigraphBy() - Find Digraph char
-- unicode#Digraph()       - Returns digraph char
-- unicode#UnicodeName()   - Identifies Unicode character (by value)

vim.g.Unicode_no_default_mappings = 1

vim.cmd([[
  if !(exists("g:Unicode_no_default_mappings") && g:Unicode_no_default_mappings)
      if !hasmapto('<Plug>(MakeDigraph)', 'n') && maparg('<f4>', 'n') ==# ''
          nmap <F4> <Plug>(MakeDigraph)
      endif

      if !hasmapto('<Plug>(MakeDigraph)', 'v') && maparg('<f4>', 'v') ==# ''
          vmap <F4> <Plug>(MakeDigraph)
      endif

      if !hasmapto('<Plug>(DigraphComplete)', 'i') && maparg('<c-x><c-g>', 'i') ==# ''
          imap <C-X><C-G> <Plug>(DigraphComplete)
      endif

      if !hasmapto('<Plug>(UnicodeComplete)', 'i') && maparg('<c-x><c-z>', 'i') ==# ''
          imap <C-X><C-Z> <Plug>(UnicodeComplete)
      endif

      if !hasmapto('<Plug>(HTMLEntityComplete)', 'i') && maparg('<c-x><c-b>', 'i') ==# ''
          imap <C-X><C-B> <Plug>(HTMLEntityComplete)
      endif

      if !hasmapto('<Plug>(UnicodeFuzzy)', 'i') && maparg('<c-g><c-f>', 'i') ==# ''
          imap <C-G><C-F> <Plug>(UnicodeFuzzy)
      endif

      if !hasmapto('<Plug>(UnicodeSwapCompleteName)', 'n') && maparg('<leader>un', 'n') ==# ''
          nmap <leader>un <Plug>(UnicodeSwapCompleteName)
      endif

  "    if !hasmapto('<Plug>(UnicodeGA)')
  "        nmap ga <Plug>(UnicodeGA)
  "    endif
  endif
]])
