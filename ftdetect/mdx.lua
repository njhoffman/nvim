-- https://phelipetls.github.io/posts/mdx-syntax-highlight-treesitter-nvim/

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.mdx',
  callback = function()
    vim.api.nvim_set_option_value('filetype', 'markdown.pandoc.mdx', { scope = 'local' })
  end,
})
