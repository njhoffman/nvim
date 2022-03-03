#!/bin/bash

# sync clipboard with zsh

# The script vimyanksyncpull.sh fundamentally just has to output the current clipboard contents.
# Since SIGUSR1 is shared as the notification mechanism between different things,
# we want to avoid getting nvim bogged down with spurious clipboard fetch requests,
# so only return a buffer if it was created within the last few seconds.
# Also check to make sure it’s below a specified maximum size.
# Return a nonzero exit status if no clipboard is available.

CWD="$(realpath "$(dirname "$0")")"
source "$CWD/cliplog.sh"
s="vimyanksyncpull.sh"

# buffer must have been created within this number of seconds
MAX_TIME_DIFF=3
# don't output if buffer too large
MAX_SIZE=100000000

csv="$(tmux list-buffers -F \
  '#{buffer_created},#{buffer_size},#{buffer_name}' \
  | grep ',buffer[0-9]')"

if [ $? -ne 0 ]; then exit 1; fi

csv="$(echo "$csv" | head -n1)"

if [ -z "$csv" ]; then exit 1; fi

ctime="$(echo "$csv" | cut -d , -f 1)"
bsize="$(echo "$csv" | cut -d , -f 2)"
bname="$(echo "$csv" | cut -d , -f 3-)"
now="$(date +%s)"
diff=$(expr $now - $ctime)

if [ $diff -gt $MAX_TIME_DIFF ]; then
  debug "$s: tmux show-buffer - skip (too old) - $diff"
  exit 1
fi

if [ $bsize -gt $MAX_SIZE ]; then
  debug "$s: tmux show-buffer - skip (too large) - $bsize"
  exit 1
fi

log_msg="tmux show-buffer - $(echo "$csv" | wc -l) lines"
if [[ $(echo "$csv" |  wc -l) -eq 0 ]]; then
  log_msg="tmux show-buffer - $(echo "$csv" | wc -c) chars"
fi

debug "$s: $log_msg - $(expr $now - $ctime) - $bname"

tmux show-buffer -b "$bname"
