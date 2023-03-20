
" https://github.com/marko-cerovac/material.nvim

let g:material_style = "oceanic"
lua require("material").setup()
lua vim.schedule(function() vim.cmd('colorscheme material') end)
