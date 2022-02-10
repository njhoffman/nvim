#!/bin/bash

# curl -L https://github.com/rust-analyzer/rust-analyzer/releases/download/nightly/rust-analyzer-linux.gz | gunzip -f > "$HOME"/.local/bin/rust-analyzer && chmod +x "$HOME"/.local/bin/rust-analyzer
# markdownlint-cli, llvm
luarocks install luacheck

npm install -g \
  pyright \
  lua-fmt \
  prettier \
  prettier-plugin-toml \
  markdownlint \
  diagnostic-languageserver \
  typescript typescript-language-server \
  dockerfile-language-server-nodejs

# npm install -g lua-check

apt install clang-tools

asdf install shellcheck latest
asdf install shfmt latest

pip install --upgrade cmake-language-server
