#!/bin/bash

base_cmd=("git")
method="log"
sub_cmd=("--no-pager" "log" "--no-merges") # sub_cmd=("log" "--max-count=10")
print_cmd=0

commits_count() {
  sub_cmd+=('--oneline')
  sub_cmd+=("HEAD")
  if [[ $# -gt 0 ]]; then
    sub_cmd+=("-- $*")
  fi
  post_cmd="sed '/^$/d' | head -n-1 | wc -l"
  cmd="${base_cmd[*]} ${sub_cmd[*]} | $post_cmd"
  if [[ $print_cmd -eq 1 ]]; then
    printf "%s" "$cmd"
  else
    eval "$cmd"
  fi
}

commits_author_length() {
  sub_cmd+=("--format='%an'")
  sub_cmd+=("HEAD")
  if [[ $# -gt 0 ]]; then
    sub_cmd+=("-- $*")
  fi
  post_cmd="sort -u | awk '{ print length(), \$0 | \"sort -nr\" }' | head -n1 | cut -f1 -d' '"
  cmd="${base_cmd[*]} ${sub_cmd[*]} | $post_cmd"
  if [[ $print_cmd -eq 1 ]]; then
    printf "%s" "$cmd"
  else
    eval "$cmd"
  fi
}

commits_subject_length() {
  sub_cmd+=("--format='%s'")
  # sub_cmd+=("--max-parents=1")
  sub_cmd+=("HEAD")
  if [[ $# -gt 0 ]]; then
    sub_cmd+=("-- $*")
  fi
  post_cmd="awk '{ print length, \$0 }' | sort -nr | head -n1 | cut -d' ' -f1"
  cmd="${base_cmd[*]} ${sub_cmd[*]} | $post_cmd"
  if [[ $print_cmd -eq 1 ]]; then
    printf "%s" "$cmd"
  else
    eval "$cmd"
  fi
}

commits_hash_length() {
  sub_cmd+=("--format='%h'")
  # sub_cmd+=("--max-parents=1")
  sub_cmd+=("HEAD")
  if [[ $# -gt 0 ]]; then
    sub_cmd+=("-- $*")
  fi
  post_cmd="tail -n1 | tr -d '\n' | wc --chars"
  cmd="${base_cmd[*]} ${sub_cmd[*]} | $post_cmd"
  if [[ $print_cmd -eq 1 ]]; then
    printf "%s" "$cmd"
  else
    eval "$cmd"
  fi
}

commits_range() {
  sub_cmd+=("--format='%ar'")
  if [[ $# -gt 0 ]]; then
    sub_cmd+=("--max-parents=1")
    sub_cmd+=("HEAD")
    sub_cmd+=("-- $*")
  else
    sub_cmd+=("--max-parents=0")
    sub_cmd+=("HEAD")
  fi
  post_cmd="tail -n1 | sed 's/ ago//'"
  cmd="${base_cmd[*]} ${sub_cmd[*]} | $post_cmd"
  if [[ $print_cmd -eq 1 ]]; then
    printf "%s" "$cmd"
  else
    eval "$cmd"
  fi
}

commits_log() {
  sub_cmd+=("--format=' @@%h (%ar) %s %an '")
  sub_cmd+=("--shortstat")
  sub_cmd+=("HEAD")
  if [[ $# -gt 0 ]]; then
    sub_cmd+=("-- $*")
  fi
  cmd="${base_cmd[*]} ${sub_cmd[*]}"
  if [[ $print_cmd -eq 1 ]]; then
    printf "%s" "$cmd"
    # printf "%s | sed '/^$/d' | sed 's_\.\. _ _g' | tr '\\\n' ' ' | sed 's_ @@_\\\n_g' | sed 's_^@@__g'" "$cmd"
  else
    lineout=""
    while read -r line; do
      if [[ $line =~ ^.\@\@* ]]; then
        [[ $lineout != "" ]] && echo "$lineout"
        lineout="${line/ @@/}"
      elif [[ $line != "" ]]; then
        lineout="${lineout}${line}"
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

eval "commits_$method $*"

# ./commits.sh --work-tree="$HOME"  --git-dir="$HOME"/.cfg
# ./commits.sh --work-tree="$HOME"/ghq/github.com/njhoffman/algorithmia  --git-dir="$HOME"/ghq/github.com/njhoffman/algorithmia/.git
# ./commits.sh --work-tree="$HOME"/ghq/github.com/neovim/neovim --git-dir="$HOME"/ghq/github.com/neovim/neovim/.git

# # awk '{printf "%s+",$0} END {print ""}' sed --unbuffered ':a;N;$!ba;s/\n/ /g' | tr '\n' ' ' |
# eval "$cmd" |
#   sed --unbuffered '/^$/d' |
#   sed --unbuffered 's_\.\. _ _g' |
#   awk '{printf "%s ",$0} END {print ""}' |
#   sed --unbuffered 's_ @@_\n_g' |
#   sed --unbuffered 's_^@@__g' |
#   sed --unbuffered '/^$/d'
