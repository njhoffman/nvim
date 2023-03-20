" https://github.com/rebelot/kanagawa.nvim

lua << EOF
  require('kanagawa').setup()
  vim.schedule(function()
    vim.cmd("colorscheme kanagawa-dragon")
  end
EOF
