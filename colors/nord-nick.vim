
let g:nord_bold_vertical_split = 0
let g:nord_cursor_line_number_background = 0
let g:nord_cursorline_transparent = 0
let g:nord_italic_comments = 1
let g:nord_uniform_status_lines = 0
let g:nord_uniform_diff_background = 0
let g:nord_underline = 0

let g:vim_jsx_pretty_colorful_config = 1
let g:vim_jsx_pretty_highlight_close_tag = 1
let g:javascript_sql_dialect = 'pgsql'

lua require("lush")(require("colorschemes.nord-nick"))
