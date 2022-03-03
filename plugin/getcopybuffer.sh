#!/bin/bash

CWD="$(realpath "$(dirname "$0")")"
source "$CWD/cliplog.sh"
s="getcopybuffer.sh"
MAX_SIZE=100000000

# 0 gets most recent copy buffer, 1 gets second-most-recent, etc
# exit status 0=success 1=no_buffer 2=error

if [ $# -ne 1 ]; then
  N=0
else
  N=$1
fi

#csv="`tmux list-buffers -F \
# '#{buffer_created},#{buffer_size},#{buffer_name}' \
# -f '#{m:buffer*,#{buffer_name}}'`"

csv="$(tmux list-buffers -F \
  '#{buffer_created},#{buffer_size},#{buffer_name}' \
  | grep ',buffer[0-9]')"

if [ $? -ne 0 ]; then exit 1; fi

headcount=$(expr $N + 1)
csv="$(echo "$csv" | head -n$headcount | tail -n1)"
if [ -z "$csv" ]; then exit 1; fi

ctime="$(echo "$csv" | cut -d , -f 1)"
bsize="$(echo "$csv" | cut -d , -f 2)"
bname="$(echo "$csv" | cut -d , -f 3-)"

if [ $bsize -gt $MAX_SIZE ]; then
  debug "$s: exit from too big ($bsize)"
  exit 1
fi

debug "$s: tmux show-buffer $bname - $bsize"

tmux show-buffer -b "$bname"

exit 0
