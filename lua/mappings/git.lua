local M = require("mappings.mapper")

M.map("Git", "n", "<leader>gf", "telescope_files")
M.map("Git", "n", "<leader>gc", "telescope_commits")
M.map("Git", "n", "<leader>gC", "telescope_bcommits")
M.map("Git", "n", "<leader>gb", "telescope_branches")
M.map("Git", "n", "<leader>gs", "telescope_status")
M.map("Git", "n", "<leader>gn", "signs_next_hunk")
M.map("Git", "n", "<leader>gp", "signs_prev_hunk")
M.map("Git", "n", "<leader>gv", "signs_preview_hunk")
M.map("Git", "n", "<leader>gr", "signs_reset_hunk")
M.map("Git", "n", "<leader>gR", "signs_reset_buffer")
M.map("Git", "n", "<C-C>", "fzf_bcommits2")
M.map("Git", "n", "<A-c>", "fzf_commits2")
-- Git log, Git diff, Git difftool, Git mergetool, Git blame, Gdiff, Gedit HEAD-3:%, Ggrep
-- http://vimcasts.org/episodes/fugitive-vim-resolving-merge-conflicts-with-vimdiff/
-- DiffviewOpen, DiffviewFileHistory
-- g!;
-- :DiffviewOpen HEAD~2
-- :DiffviewOpen HEAD~4..HEAD~2
-- :DiffviewOpen d4a7b0d
-- :DiffviewOpen d4a7b0d..519b30e
-- :DiffviewOpen origin/main...HEAD
-- :DiffviewOpen HEAD~2 -- lua/diffview plugin
-- :DiffviewOpen d4a7b0d -uno
