-- f{char}/F, t{char}/T enhancement
-- f;/F; to match all symbols
vim.g.clever_f_chars_match_any_signs = ";"
vim.g.clever_f_show_prompt = false
vim.g.clever_f_not_overwrites_standard_mappings = 1
vim.g.clever_f_mark_direct = 0
vim.g.clever_f_across_no_line = 0
vim.g.clever_f_highlight_timeout_ms = 5000

-- TODO: is there a way to keep ";" functionality during search?
-- vim.cmd([[map ; <Plug>(clever-f-repeat-forward)]])
-- vim.cmd([[map , <Plug>(clever-f-repeat-back)]])

vim.cmd [[
    noremap <silent><expr><Plug>(clever-f-f)              clever_f#find_with('f')
    noremap <silent><expr><Plug>(clever-f-F)              clever_f#find_with('F')
    noremap <silent><expr><Plug>(clever-f-reset)          clever_f#reset()
    noremap <silent><expr><Plug>(clever-f-repeat-forward) clever_f#repeat(0)
    noremap <silent><expr><Plug>(clever-f-repeat-back)    clever_f#repeat(1)
    nmap f <Plug>(clever-f-f)
    xmap f <Plug>(clever-f-f)
    omap f <Plug>(clever-f-f)
    nmap F <Plug>(clever-f-F)
    xmap F <Plug>(clever-f-F)
    omap F <Plug>(clever-f-F)
  ]]
