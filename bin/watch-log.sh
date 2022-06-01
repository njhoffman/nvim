#!/bin/bash

tail -f \
  ~/.cache/nvim/lsp.log \
  ~/.cache/nvim/dap.log \
  ~/.cache/nvim/nvim.log \
  ~/.cache/nvim/packer.nvim.log \
  ~/.cache/nvim/telescope.log \
  | ccze -A

# /tmp/nvim-socket.log \
# ~/.cache/nvim/log \

# grc -es -c conf.log --colour=auto tail -f ~/.local/share/nvim/vlog.nvim.log
