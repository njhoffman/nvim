#!/bin/bash

# clipboard sync between vim and tmux

CWD="$(realpath "$(dirname "$0")")"
source "$CWD/cliplog.sh"
s="pushclip.sh"

# Find a filename to use as a temp file
TEMPFILE="$(mktemp /tmp/yankXXXXXX.tmp 2> /dev/null)"

if [ $? -ne 0 ]; then
  TEMPFILE="/tmp/_clip_temp_yssh$USER"
fi

# Save stdin to file
cat > "$TEMPFILE"

log_msg="tmux load-buffer - $(cat $TEMPFILE | wc -l) lines"
if [[ $(cat $TEMPFILE | wc -l) -eq 0 ]]; then
  log_msg="tmux load-buffer - $(cat $TEMPFILE | wc -c) chars"
fi
debug "$s: $log_msg - $TEMPFILE"
# Load tmux buffer

tmux load-buffer "$TEMPFILE"
cat "$TEMPFILE" | xsel -ip

# Remove file
rm -f "$TEMPFILE"
