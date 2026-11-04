-- stylua: ignore
-- git diff --stat HEAD..master
-- git log --pretty=oneline --graph --name-status
-- git whatchanged --stat
 -- git show --stat --oneline nightly..master
 -- git log --shortstat --author="Vorname Nachname" | grep -E "fil(e|es) changed" | awk '{files+=$1; inserted+=$4; deleted+=$6; delta+=$4-$6; ratio=deleted/inserted} END {printf "Commit stats:\n- Files changed (total)..  %s\n- Lines added (total)....  %s\n- Lines deleted (total)..  %s\n- Total lines (delta)....  %s\n- Add./Del. ratio (1:n)..  1 : %s\n", files, inserted, deleted, delta, ratio }' -
-- git log --shortstat --author="$(git config user.name)" | grep -E "fil(e|es) changed" | awk '{files+=$1; inserted+=$4; deleted+=$6; delta+=$4-$6; ratio=deleted/inserted} END {printf "Commit stats:\n- Files changed (total)..  %s\n- Lines added (total)....  %s\n- Lines deleted (total)..  %s\n- Total lines (delta)....  %s\n- Add./Del. ratio (1:n)..  1 : %s\n", files, inserted, deleted, delta, ratio }' -

return {
  diff_commit_line = require('modules.gitops.diff.commit_line').diff_commit_line,
  diff_commit_file = require('modules.gitops.diff.commit_file').diff_commit_file,
  diff_branch      = require('modules.gitops.diff.branch').diff_branch,
  diff_branch_file = require('modules.gitops.diff.branch_file').diff_branch_file,
}
