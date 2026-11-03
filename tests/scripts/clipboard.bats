#!/usr/bin/env bats
# lua/core/globals/clipboard.lua against stub xsel, clipd and tmux.

setup() {
  ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  T="$BATS_TEST_TMPDIR"
  mkdir -p "$T/bin"
  cat >"$T/bin/xsel" <<STUB
#!/bin/sh
case "\$*" in
  *-i*) cat >"$T/xsel\$(echo "\$*" | tr -d ' -')" ;;
  *) cat "$T/xselib" 2>/dev/null ;;
esac
STUB
  printf '#!/bin/sh\necho "$*" >>"%s/clipd.args"; cat >>"%s/clipd.text"\n' "$T" "$T" >"$T/bin/clipd"
  printf '#!/bin/sh\necho "$*" >>"%s/tmux.args"; cat >>"%s/tmux.text"\n' "$T" "$T" >"$T/bin/tmux"
  chmod +x "$T/bin/"*
  cat >"$T/init.lua" <<LUA
vim.opt.rtp:prepend("$ROOT")
package.path = "$ROOT/lua/?.lua;" .. package.path
vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false
require("core.globals.clipboard").setup()
LUA
}

run_nvim() {
  local file=$1 keys=$2
  PATH="$T/bin:$PATH" nvim --clean --headless -u "$T/init.lua" "$file" \
    -c "lua vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[$keys]], true, false, true), 'x', false)" \
    -c 'sleep 300m' -c 'qa!' 2>&1
}

@test "clipboard: y writes + at once and hands clipd the context" {
  printf 'local one = 1\nlocal two = 2\n' >"$T/a.lua"
  run_nvim "$T/a.lua" 'yy'
  [ "$(cat "$T/xselib")" = "local one = 1" ]
  run cat "$T/clipd.args"
  [[ $output == *"yank --source nvim --skip clipboard"* ]]
  [[ $output == *"--ctx filetype=lua"* ]]
  [[ $output == *"--ctx file=$T/a.lua"* ]]
  [[ $output == *"--ctx operator=y"* ]]
  [[ $output == *"--ctx lines=1"* ]]
  [ "$(cat "$T/clipd.text")" = "local one = 1" ]
}

@test "clipboard: a linewise yank over lines gives its range" {
  printf 'a\nb\nc\n' >"$T/b.txt"
  run_nvim "$T/b.txt" 'yj'
  grep -q -- '--ctx lines=1-2' "$T/clipd.args"
}

@test "clipboard: d is nvim-delete, and + still has it for p" {
  printf 'gone\nkept\n' >"$T/c.txt"
  run_nvim "$T/c.txt" 'dd'
  grep -q -- '--source nvim-delete' "$T/clipd.args"
  [ "$(cat "$T/xselib")" = "gone" ]
}

@test "clipboard: a named register reaches nothing" {
  printf 'private\n' >"$T/d.txt"
  run_nvim "$T/d.txt" '"ayy'
  [ ! -e "$T/clipd.args" ]
  [ ! -e "$T/xselib" ]
}

@test "clipboard: setreg counts as a yank, whatever the last operator was" {
  printf 'gone\nkept\n' >"$T/e.txt"
  PATH="$T/bin:$PATH" nvim --clean --headless -u "$T/init.lua" "$T/e.txt" \
    -c "normal dd" -c 'sleep 200m' -c "call setreg('+', 'path')" -c 'sleep 300m' -c 'qa!' 2>&1
  [ "$(grep -c -- '--source nvim ' "$T/clipd.args")" -eq 1 ]
  [ "$(grep -c -- '--source nvim-delete' "$T/clipd.args")" -eq 1 ]
  [ "$(cat "$T/xselib")" = "path" ]
}

@test "clipboard: claude's prompt file is the claude source" {
  printf 'prompt text\n' >"$T/claude-prompt-abc.md"
  run_nvim "$T/claude-prompt-abc.md" 'yy'
  grep -q -- '--source claude' "$T/clipd.args"
}

@test "clipboard: without clipd a yank still reaches tmux, a delete does not" {
  rm "$T/bin/clipd"
  # no directory holding the real clipd, whatever this host has
  PATH="$(printf '%s' "$PATH" | tr ':' '\n' | while IFS= read -r d; do [ -x "$d/clipd" ] || echo "$d"; done | paste -sd: -)"
  printf 'one\ntwo\n' >"$T/f.txt"
  TMUX=fake run_nvim "$T/f.txt" 'yy'
  [ "$(cat "$T/tmux.text")" = "one" ]
  rm -f "$T/tmux.args" "$T/tmux.text"
  TMUX=fake run_nvim "$T/f.txt" 'dd'
  ! grep -q load-buffer "$T/tmux.args"
}
