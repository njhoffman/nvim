#!/bin/bash
target_dir="$HOME/.local/share/nvim/devhints"
tmp_dir="/tmp/cheatsheets"
repo="git@github.com:rstacruz/cheatsheets"

rm -rfv "$target_dir" "$tmp_dir" && mkdir -p "$target_dir"
git clone --depth=1 "$repo" "$tmp_dir"
cp -v "$tmp_dir/"*.md "$target_dir"
rm -rf "$tmp_dir"
