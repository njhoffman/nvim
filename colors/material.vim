let g:material_style = "darker"
lua require("material").setup()
lua vim.schedule(function() vim.cmd('colorscheme material') end)
