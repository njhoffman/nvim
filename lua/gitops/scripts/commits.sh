#!/bin/bash

# ./commits.sh --work-tree="$HOME"/ghq/github.com/njhoffman/algorithmia  --git-dir="$HOME"/ghq/github.com/njhoffman/algorithmia/.git
# ./commits.sh --work-tree="$HOME"/ghq/github.com/neovim/neovim --git-dir="$HOME"/ghq/github.com/neovim/neovim/.git

method="stats"
base_cmd=("git")
sub_cmd=("log") # sub_cmd=("log" "--max-count=10")
print_cmd=0

commits_count() {
  sub_cmd+=('--oneline')
  cmd="${base_cmd[*]} ${sub_cmd[*]}"
  eval "$cmd" | wc -l
}

commits_range() {
  sub_cmd=("rev-list")
  sub_cmd+=("--format='%ar'")
  sub_cmd+=("--max-parents=0")
  sub_cmd+=("HEAD")
  eval "${base_cmd[*]} ${sub_cmd[*]}" | tail -n1
}

# # awk '{printf "%s+",$0} END {print ""}' sed --unbuffered ':a;N;$!ba;s/\n/ /g' | tr '\n' ' ' |
# eval "$cmd" |
#   sed --unbuffered '/^$/d' |
#   sed --unbuffered 's_\.\. _ _g' |
#   awk '{printf "%s ",$0} END {print ""}' |
#   sed --unbuffered 's_ @@_\n_g' |
#   sed --unbuffered 's_^@@__g' |
#   sed --unbuffered '/^$/d'

commits_stats() {
  sub_cmd+=("--format=' @@%<(12,trunc)%H (%ar) %s %an '")
  sub_cmd+=("--shortstat")
  sub_cmd+=("-- .")

  cmd="${base_cmd[*]} ${sub_cmd[*]}"
  if [[ $print_cmd -eq 1 ]]; then
    printf "%s | sed '/^$/d' | sed 's_\.\. _ _g' | tr '\\\n' ' ' | sed 's_ @@_\\\n_g' | sed 's_^@@__g'" "$cmd"
  else
    lineout=""
    local sep=" "
    while read -r line; do
      if [[ $line =~ ^.\@\@* ]]; then
        echo "$lineout"
        lineout="${line/ @@/}"
      elif [[ $line != "" ]]; then
        lineout="$lineout${sep}$line"
      fi
    done < <(eval "$cmd")
  fi
}

while [[ $1 =~ ^-- && $1 != "--" ]]; do
  case $1 in
    --print) print_cmd=1 ;;
    --work-tree=*) base_cmd+=("--work-tree=${1##*=}") ;;
    --git-dir=*) base_cmd+=("--git-dir=${1##*=}") ;;
    --limit=*) sub_cmd+=("--max-count=${1##*=}") ;;
    --method=*) method="${1##*=}" ;;
    *) ;;
  esac
  shift
done

if [[ $1 == '--' ]]; then shift; fi

eval "commits_$method"
