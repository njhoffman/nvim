let g:material_style = "palenight"
lua require("material").setup()
lua vim.schedule(function() vim.cmd('colorscheme material') end)
