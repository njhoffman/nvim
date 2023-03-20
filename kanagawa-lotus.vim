" https://github.com/rebelot/kanagawa.nvim

lua << EOF
  require('kanagawa').setup()
  vim.schedule(function()
    vim.cmd("colorscheme kanagawa-lotus")
  end
EOF
