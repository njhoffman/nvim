#!/bin/bash

WRITE_LOG=0
WRITE_SYSLOG=0
LOG_FILE="$HOME/.cache/nvim/shada.log"
log_cmd="logger --tag=nvim "

nvim_log() {
  [[ $WRITE_LOG -eq 1 ]] && echo -e "$*" >> "$LOG_FILE"
  [[ $WRITE_SYSLOG -eq 1 ]] && logger -p "notice" --tag="nvim" "$*"
}

nvim_error() {
  [[ $WRITE_LOG -eq 1 ]] && echo -e "\nERROR\n------\n$*" >> "$LOG_FILE"
  [[ $WRITE_SYSLOG -eq 1 ]] && logger -p "error" --tag="nvim" "$*"
}

# double check we didnt just save something stupid
verify_buffer() {
  buffer="$*"
  if [[ ! -f "$buffer" ]]; then
    if [[ -d "$buffer" ]]; then
      nvim_error "You just saved a directory : ${buffer}"
    else
      nvim_error "Unknown type saved: ${buffer}"
    fi
    exit 1
  fi
}

broadcast_shada() {
  declare -A pids
  pids=$(ps -C nvim --no-headers |  awk '{print $1}')
  nvim_log "Sending reload signals to ${#pids[@]} processes"
  echo -e "${pids}" | while IFS='$\n' read -r pid; do
    result=$(kill -s USR1 "${pid}" 2> /dev/null)
    nvim_log "Sending USR1 to ${pid} $result"
  done
}

verify_buffer "$*"
nvim_log "File checks out: ${buffer}"
broadcast_shada

# augroup save_and_exit | au!
#     au SigUSR1 * rshada!
# augroup END
# nvim-ctrl "rshada!" &
