" map <Plug> <Plug>(mkdx-checkbox-next-n)
" map <Plug> <Plug>(mkdx-toggle-checkbox-n)
" map <Plug> <Plug>(mkdx-toggle-checkbox-v)
" this will remap <leader>q in every filetype, not very handy in most cases
" map <leader>tn <Plug>(mkdx-toggle-checkbox-n)

let g:mkdx#settings = {
      \ 'image_extension_pattern': 'a\?png\|jpe\?g\|gif',
      \ 'gf_on_steroids':          1,
      \ 'restore_visual':          1,
      \ 'enter':                   { 'enable': 1, 'shift': 0, 'o': 1,
      \                              'shifto': 1, 'malformed': 1 },
      \ 'map':                     { 'prefix': '<leader>', 'enable': 1 },
      \ 'tokens':                  { 'enter':  ['-', '*', '>'],
      \                              'bold':   '**', 'italic': '*',
      \                              'strike': '',
      \                              'list':   '-',  'fence':  '',
      \                              'header': '#' },
      \ 'checkbox':                { 'toggles': [' ', '-', 'x'],
      \                              'update_tree': 2,
      \                              'initial_state': ' ' },
      \ 'toc':                     { 'text':       "TOC",
      \                              'list_token': '-',
      \                              'position':   0,
      \                              'update_on_write':   0,
      \                              'details':    {
      \                                 'enable':  0,
      \                                 'summary': '{{toc.text}}',
      \                                 'nesting_level': -1,
      \                                 'child_count': 5,
      \                                 'child_summary': 'show {{count}} items'
      \                              }
      \                            },
      \ 'table':                   { 'divider': '|',
      \                              'header_divider': '-',
      \                              'align': {
      \                                 'left':    [],
      \                                 'right':   [],
      \                                 'center':  [],
      \                                 'default': 'center'
      \                              }
      \                            },
      \ 'links':                   { 'external': {
      \                                 'enable':     0,
      \                                 'timeout':    3,
      \                                 'host':       '',
      \                                 'relative':   1,
      \                                 'user_agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/9001.0.0000.000 vim-mkdx/1.10.0'
      \                              },
      \                              'fragment': {
      \                                 'jumplist': 1,
      \                                 'complete': 1
      \                              },
      \                              'conceal': 1
      \                            },
      \ 'highlight':               {
      \                              'enable': 0,
      \                              'frontmatter': {
      \                                'yaml': 1,
      \                                'toml': 0,
      \                                'json': 0
      \                              }
      \                            },
      \ 'auto_update':             { 'enable': 1 },
      \ 'fold':                    { 'enable': 0, 'components': ['toc', 'fence'] }
      \ }
