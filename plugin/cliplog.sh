#!/bin/bash

log() {
  prefix=$(date "+%H:%M:%S")
  [[ ${#prefix} -lt 3 ]] && prefix="0$prefix"
  echo -e "\033[35m $prefix:\033[0m   ${*}" \
    >>/tmp/clips.log
}

debug() {
  [[ -f "$HOME/apps.env" ]] && source "$HOME/apps.env"

  [[ -n $CLIPS_LOG ]] && log "${*}"
}
