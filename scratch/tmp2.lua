-- {|M.foo}('bar') > {\<M-0>M.foo('bar')|
-- vim.keymap.set('n', '<M-0>', '<cmd>execute "normal i<M-0>"', { remap = true })
--  map('x', '*', [[y/\V<C-R>=escape(@", '/\')<CR><CR>]])
-- vim.cmd([[ execute "normal i\<M-0>" ]])
-- vim.cmd([[ execute "normal! \<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)" ]])
-- vim.cmd([[ execute "normal! \<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)" ]])

-- map('n', ']a', ':execute ":" . v:count . "next"<CR>', {
-- vim.fn.execute('normal i\\<M-0>')
-- vim.fn.execute('normal! \\<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)')
