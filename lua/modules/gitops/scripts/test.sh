#!/bin/bash
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function test_dotbare {
  db_pfx="--git-dir=/home/nicholas/.cfg --work-tree=/home/nicholas"
  "$dir"/commits.sh $db_pfx --method=subject_length
  "$dir"/commits.sh $db_pfx --method=author_length
  "$dir"/commits.sh $db_pfx --method=hash_length
  "$dir"/commits.sh $db_pfx --method=count
}

function test_neovim {
  db_pfx="--git-dir=/home/nicholas/ghq/github.com/neovim/neovim/.git --work-tree=/home/nicholas/ghq/github.com/neovim/neovim"
  time "$dir"/commits.sh $db_pfx --method=subject_length
  time "$dir"/commits.sh $db_pfx --method=author_length
  time "$dir"/commits.sh $db_pfx --method=hash_length
  time "$dir"/commits.sh $db_pfx --method=count
}
test_neovim
