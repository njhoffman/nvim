#!/bin/bash

START_TIME=$(date "+%M%S%3N")

log() {
  curr_time=$(date "+%M%S%3N") 2> /dev/null
  prefix=$((${curr_time#0} - ${START_TIME#0})) 2> /dev/null
  [[ "${#prefix}" -lt 3 ]] && prefix="0$prefix"
  echo -e "\033[35m $prefix:\033[0m   ${*}" \
    >> /tmp/clips.log
}

debug() {
  [[ -f "$HOME/.env" ]] && source "$HOME/.env"

  [[ -n "$CLIPS_LOG" ]] && log "${*}"
}
