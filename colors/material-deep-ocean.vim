let g:material_style = "deep ocean"
lua require("material").setup()
lua vim.schedule(function() vim.cmd('colorscheme material') end)
