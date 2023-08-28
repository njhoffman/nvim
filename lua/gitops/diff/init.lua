-- stylua: ignore
-- git diff --stat HEAD..master
-- git log --pretty=oneline --graph --name-status
-- git whatchanged --stat
 -- git show --stat --oneline nightly..master
 -- git log --shortstat --author="Vorname Nachname" | grep -E "fil(e|es) changed" | awk '{files+=$1; inserted+=$4; deleted+=$6; delta+=$4-$6; ratio=deleted/inserted} END {printf "Commit stats:\n- Files changed (total)..  %s\n- Lines added (total)....  %s\n- Lines deleted (total)..  %s\n- Total lines (delta)....  %s\n- Add./Del. ratio (1:n)..  1 : %s\n", files, inserted, deleted, delta, ratio }' -
-- git log --shortstat --author="$(git config user.name)" | grep -E "fil(e|es) changed" | awk '{files+=$1; inserted+=$4; deleted+=$6; delta+=$4-$6; ratio=deleted/inserted} END {printf "Commit stats:\n- Files changed (total)..  %s\n- Lines added (total)....  %s\n- Lines deleted (total)..  %s\n- Total lines (delta)....  %s\n- Add./Del. ratio (1:n)..  1 : %s\n", files, inserted, deleted, delta, ratio }' -

--
-- local function diffview(prompt_bufnr)
--   local picker = action_state.get_current_picker(prompt_bufnr)
--   local selections = picker:get_multi_selection()
--
--   actions.close(prompt_bufnr)
--
--
--   if #selections > 2 then
--     utils.notify("diff_commits", { level = "WARN", msg = "must select 1 or 2 commits" })
--     return
--   end
--
--
--   -- Sort by date
--   table.sort(selections, function(a, b)
--     return tonumber(vim.fn.systemlist("git show -s --format=%ct " .. a.value)[1]) <
--            tonumber(vim.fn.systemlist("git show -s --format=%ct " .. b.value)[1])
--   end)
--
--   local old = #selections == 0 and string.sub(action_state.get_selected_entry().ordinal, 1, 7) or
--                                    string.sub(selections[1].value, 1, 8)
--
--   if #selections == 2 then
--     local new = string.sub(selections[2].value, 1, 8)
--     vim.cmd(string.format("DiffviewOpen %s..%s", old, new))
--   else
--     vim.cmd(string.format("DiffviewOpen %s^!", old))
--   end
--
--   vim.cmd([[stopinsert]])
-- end

return {
  diff_commit_line = require('gitops.diff.commit_line').diff_commit_line,
  diff_commit_file = require('gitops.diff.commit_file').diff_commit_file,
  diff_branch      = require('gitops.diff.branch').diff_branch,
  diff_branch_file = require('gitops.diff.branch_file').diff_branch_file,
}
