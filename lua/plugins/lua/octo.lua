require"octo".setup({
  default_remote = { "upstream", "origin" }, -- order to try remotes
  reaction_viewer_hint_icon = "", -- marker for user reactions
  user_icon = " ", -- user icon
  timeline_marker = "", -- timeline marker
  timeline_indent = "2", -- timeline indentation
  right_bubble_delimiter = "", -- Bubble delimiter
  left_bubble_delimiter = "", -- Bubble delimiter
  github_hostname = "", -- GitHub Enterprise host
  snippet_context_lines = 4, -- number or lines around commented lines
  file_panel = {
    size = 10, -- changed files panel rows
    use_icons = true, -- use web-devicons in file panel
  },
  mappings = {
    issue = {
      close_issue = "<space>ic", -- close issue
      reopen_issue = "<space>io", -- reopen issue
      list_issues = "<space>il", -- list open issues on same repo
      reload = "<C-r>", -- reload issue
      open_in_browser = "<C-b>", -- open issue in browser
      copy_url = "<C-y>", -- copy url to system clipboard
      add_assignee = "<space>aa", -- add assignee
      remove_assignee = "<space>ad", -- remove assignee
      create_label = "<space>lc", -- create label
      add_label = "<space>la", -- add label
      remove_label = "<space>ld", -- remove label
      goto_issue = "<space>gi", -- navigate to a local repo issue
      add_comment = "<space>ca", -- add comment
      delete_comment = "<space>cd", -- delete comment
      next_comment = "]c", -- go to next comment
      prev_comment = "[c", -- go to previous comment
      react_hooray = "<space>rp", -- add/remove 🎉 reaction
      react_heart = "<space>rh", -- add/remove ❤️ reaction
      react_eyes = "<space>re", -- add/remove 👀 reaction
      react_thumbs_up = "<space>r+", -- add/remove 👍 reaction
      react_thumbs_down = "<space>r-", -- add/remove 👎 reaction
      react_rocket = "<space>rr", -- add/remove 🚀 reaction
      react_laugh = "<space>rl", -- add/remove 😄 reaction
      react_confused = "<space>rc", -- add/remove 😕 reaction
    },
    pull_request = {
      checkout_pr = "<space>po", -- checkout PR
      merge_pr = "<space>pm", -- merge PR
      list_commits = "<space>pc", -- list PR commits
      list_changed_files = "<space>pf", -- list PR changed files
      show_pr_diff = "<space>pd", -- show PR diff
      add_reviewer = "<space>va", -- add reviewer
      remove_reviewer = "<space>vd", -- remove reviewer request
      close_issue = "<space>ic", -- close PR
      reopen_issue = "<space>io", -- reopen PR
      list_issues = "<space>il", -- list open issues on same repo
      reload = "<C-r>", -- reload PR
      open_in_browser = "<C-b>", -- open PR in browser
      copy_url = "<C-y>", -- copy url to system clipboard
      add_assignee = "<space>aa", -- add assignee
      remove_assignee = "<space>ad", -- remove assignee
      create_label = "<space>lc", -- create label
      add_label = "<space>la", -- add label
      remove_label = "<space>ld", -- remove label
      goto_issue = "<space>gi", -- navigate to a local repo issue
      add_comment = "<space>ca", -- add comment
      delete_comment = "<space>cd", -- delete comment
      next_comment = "]c", -- go to next comment
      prev_comment = "[c", -- go to previous comment
      react_hooray = "<space>rp", -- add/remove 🎉 reaction
      react_heart = "<space>rh", -- add/remove ❤️ reaction
      react_eyes = "<space>re", -- add/remove 👀 reaction
      react_thumbs_up = "<space>r+", -- add/remove 👍 reaction
      react_thumbs_down = "<space>r-", -- add/remove 👎 reaction
      react_rocket = "<space>rr", -- add/remove 🚀 reaction
      react_laugh = "<space>rl", -- add/remove 😄 reaction
      react_confused = "<space>rc", -- add/remove 😕 reaction
    },
    review_thread = {
      goto_issue = "<space>gi", -- navigate to a local repo issue
      add_comment = "<space>ca", -- add comment
      add_suggestion = "<space>sa", -- add suggestion
      delete_comment = "<space>cd", -- delete comment
      next_comment = "]c", -- go to next comment
      prev_comment = "[c", -- go to previous comment
      select_next_entry = "]q", -- move to previous changed file
      select_prev_entry = "[q", -- move to next changed file
      close_review_tab = "<C-c>", -- close review tab
      react_hooray = "<space>rp", -- add/remove 🎉 reaction
      react_heart = "<space>rh", -- add/remove ❤️ reaction
      react_eyes = "<space>re", -- add/remove 👀 reaction
      react_thumbs_up = "<space>r+", -- add/remove 👍 reaction
      react_thumbs_down = "<space>r-", -- add/remove 👎 reaction
      react_rocket = "<space>rr", -- add/remove 🚀 reaction
      react_laugh = "<space>rl", -- add/remove 😄 reaction
      react_confused = "<space>rc", -- add/remove 😕 reaction
    },
    submit_win = {
      approve_review = "<C-a>", -- approve review
      comment_review = "<C-m>", -- comment review
      request_changes = "<C-r>", -- request changes review
      close_review_tab = "<C-c>", -- close review tab
    },
    review_diff = {
      add_review_comment = "<space>ca", -- add a new review comment
      add_review_suggestion = "<space>sa", -- add a new review suggestion
      focus_files = "<leader>e", -- move focus to changed file panel
      toggle_files = "<leader>b", -- hide/show changed files panel
      next_thread = "]t", -- move to next thread
      prev_thread = "[t", -- move to previous thread
      select_next_entry = "]q", -- move to previous changed file
      select_prev_entry = "[q", -- move to next changed file
      close_review_tab = "<C-c>", -- close review tab
      toggle_viewed = "<leader><space>", -- toggle viewer viewed state
    },
    file_panel = {
      next_entry = "j", -- move to next changed file
      prev_entry = "k", -- move to previous changed file
      select_entry = "<cr>", -- show selected changed file diffs
      refresh_files = "R", -- refresh changed files panel
      focus_files = "<leader>e", -- move focus to changed file panel
      toggle_files = "<leader>b", -- hide/show changed files panel
      select_next_entry = "]q", -- move to previous changed file
      select_prev_entry = "[q", -- move to next changed file
      close_review_tab = "<C-c>", -- close review tab
      toggle_viewed = "<leader><space>", -- toggle viewer viewed state
    },
  },
})

-- There is only an Octo <object> <action> [arguments] command: If no command is passed, the argument to Octo is treated as a URL from where an issue or pr repo and number are extracted

-- Object	Action	Arguments
-- issue	close	Close the current issue
--   reopen	Reopen the current issue
--   create [repo]	Creates a new issue in the current or specified repo
--   edit [repo]	Edit issue <number> in current or specified repo
--   list [repo] [key=value] (1)	List all issues satisfying given filter
--   search	Live issue search
--   reload	Reload issue. Same as doing e!
--   browser	Open current issue in the browser
--   url	Copies the URL of the current issue to the system clipboard
-- pr	list [repo] [key=value] (2)	List all PRs satisfying given filter
--   search	Live issue search
--   edit [repo]	Edit PR <number> in current or specified repo
--   reopen	Reopen the current PR
--   close	Close the current PR
--   checkout	Checkout PR
--   commits	List all PR commits
--   changes	Show all PR changes (diff hunks)
--   diff	Show PR diff
--   merge [commit|rebase|squash] [delete]	Merge current PR using the specified method
--   ready	Mark a draft PR as ready for review
--   checks	Show the status of all checks run on the PR
--   reload	Reload PR. Same as doing e!
--   browser	Open current PR in the browser
--   url	Copies the URL of the current PR to the system clipboard
-- repo	list (3)	List repos user owns, contributes or belong to
--   fork	Fork repo
--   browser	Open current repo in the browser
--   url	Copies the URL of the current repo to the system clipboard
-- gist	list [repo] [key=value] (4)	List user gists
-- comment	add	Add a new comment
--   delete	Delete a comment
-- thread	resolve	Mark a review thread as resolved
--   unresolve	Mark a review thread as unresolved
-- label	add	Add a label from available label menu
--   remove	Remove a label
--   create	Create a new label
-- assignees	add	Assign a user
--   remove	Unassign a user
-- reviewer	add	Assign a PR reviewer
-- reaction	thumbs_up | +1	Add +1 reaction
--   thumbs_down | -1	Add -1 reaction
--   eyes	Add eyes reaction
--   laugh	Add smile reaction
--   confused	Add confused reaction
--   rocket	Add rocket reaction
--   heart	Add heart reaction
--   hooray | party | tada	Add tada reaction
-- card	add	Assign issue/PR to a project new card
--   remove	Delete project card
--   move	Move project card to different project/column
-- review	start	Start a new review
--   submit	Submit the review
--   resume	Edit a pending review for current PR
--   discard	Deletes a pending review for current PR if any
--   comments	View pending review comments
--   [repo]: If repo is not provided, it will be derived from <cwd>/.git/config.

-- In-menu mappings:

-- <CR>: Edit Issue
-- <C-b>: Opens issue in the browser
-- <C-y>: Copies URL to system clipboard Available filter keys
-- In-menu mappings:
-- <CR>: Edit PR
-- <C-b>: Opens PR in the browser
-- <C-o>: Checkout PR
-- <C-y>: Copies URL to system clipboard Available keys
-- In-menu mappings:
-- <CR>: View repo
-- <C-b>: Opens repo in the browser
-- <C-y>: Copies URL to system clipboard
-- In-menu mappings:
-- <CR>: Append Gist to buffer Available keys: repo|public|secret
-- fire Examples
-- Octo https://github.com/pwntester/octo.nvim/issues/12
-- Octo issue create
-- Octo issue create pwntester/octo.nvim
-- Octo comment add
-- Octo reaction add hooray
-- Octo issue edit pwntester/octo.nvim 1
-- Octo issue edit 1
-- Octo issue list createdBy=pwntester
-- Octo issue list neovim/neovim labels=bug,help\ wanted states=OPEN
-- clipboard PR review
-- Open the PR (eg: Octo pr list or Octo pr edit XXX)
-- Start a review with Octo review start or resume a pending review with Octo review resume
-- Quickfix will be populated with the PR changed files
-- Change quickfix entries with ]q and [q or by selecting an entry in the quickfix window
-- Add comments with <space>ca or suggestions with <space>sa on single or multiple visual-selected lines
-- A new buffer will appear in the alternate diff window. Cursor will be positioned in the new buffer
-- When ready, save the buffer to commit changes to GitHub
-- Move back to the diff window and move the cursor, the thread buffer will hide
-- Hold the cursor on a line with a comment to show a thread buffer with all the thread comments
-- To modify, delete, react or reply to a comment, move to the window containing the thread buffer
-- Perform any operations as if you were in a regular issue buffer
-- Review pending comments with Octo review comments
-- Use to jump to the selected pending comment
-- When ready, submit the review with Octo review submit
-- A new float window will pop up. Enter the top level review comment and exit to normal mode. Then press <C-m> to submit a comment, <C-a> to approve it or <C-r> to request changes
