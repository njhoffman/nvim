if [[ $autoenv_event == "enter" ]]; then
  autoenv_source_parent
  ctags --recurse lua plugin scratch autoload ftdetect
  # printf "\t...generated $(cat tags | wc -l) tags"
fi
