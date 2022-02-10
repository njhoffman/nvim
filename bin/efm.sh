#!/bin/bash

# curl -L https://github.com/rust-analyzer/rust-analyzer/releases/download/nightly/rust-analyzer-linux.gz | gunzip -f > "$HOME"/.local/bin/rust-analyzer && chmod +x "$HOME"/.local/bin/rust-analyzer

function install-efm-tools {
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
}

function install-efm-deps {
  apt install git curl unzip tar gzip
  # For Unix systems: git(1), curl(1) or wget(1), unzip(1), tar(1), gzip(1)
  # For Windows systems: powershell, git, tar, and 7zip or peazip or archiver or winzip or WinRAR
  # Node.js (LTS) & npm
  # Python3 & pip3
  # go >= 1.17
  # JDK
  # Ruby & gem
  # dotnet
  # pwsh
  # valac (and meson & ninja)
  # rebar3
  # Julia
  asdf install julia latest

  # PHP & Composer
  apt install re2c libgd-dev libonig-dev libzip-dev libxml2-dev
  asdf install php latest
}
