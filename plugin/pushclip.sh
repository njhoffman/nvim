#!/bin/bash

# clipboard sync between vim and tmux

CWD=$(dirname ${BASH_SOURCE[0]})
source "$CWD/cliplog.sh"
s="pushclip.sh"

# Find a filename to use as a temp file
TEMPFILE="$(mktemp 2> /dev/null)"

if [ $? -ne 0 ]; then
  TEMPFILE="/tmp/_clip_temp_yssh$USER"
fi

# Save stdin to file
cat > "$TEMPFILE"

debug "$s: loading buffer from tempfile $TEMPFILE"
# Load tmux buffer
tmux load-buffer "$TEMPFILE"

# Remove file
rm -f "$TEMPFILE"
