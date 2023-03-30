local M = {
  telescope_files = {
    cmd = "<cmd>Telescope git_files<cr>",
    short = "telescope git files",
    long = "telescope git files",
  },
  telescope_commits = {
    cmd = "<cmd>Telescope git_commits<cr>",
    short = "telescope git commits",
    long = "telescope git project commits",
  },
  telescope_bcommits = {
    cmd = "<cmd>Telescope git_bcommits<cr>",
    short = "telescope git bcommits",
    long = "telescope git file commits",
  },
  fzf_commits2 = {
    cmd = "<cmd>FzfPreviewGitLogs<cr>",
    short = "fzf preview git commits",
    long = "fzf preview git project commits",
  },
  fzf_bcommits2 = {
    cmd = "<cmd>FzfPreviewGitCurrentLogs<cr>",
    short = "fzf preview git bcommits",
    long = "fzf preview file commits",
  },
  fzf_commits = {
    cmd = "<cmd>FzfLua git_commits<cr>",
    short = "fzf git commits",
    long = "fzf git project commits",
  },
  fzf_bcommits = {
    cmd = "<cmd>FzfLua git_bcommits<cr>",
    short = "fzf git bcommits",
    long = "fzf file commits",
  },
  telescope_branches = {
    cmd = "<cmd>Telescope git_branches<cr>",
    short = "telescope git branches",
    long = "telescope git branches",
  },
  telescope_status = {
    cmd = "<cmd>Telescope git_status<cr>",
    short = "telescope git status",
    long = "telescope git status files",
  },
  signs_next_hunk = { cmd = "<cmd>Gitsigns next_hunk<cr>", short = "git next hunk", long = "gitsigns next hunk" },
  signs_prev_hunk = {
    cmd = "<cmd>Gitsigns prev_hunk<cr>",
    short = "git prev hunk",
    long = "gitsigns previous hunk",
  },
  signs_preview_hunk = {
    cmd = "<cmd>Gitsigns preview_hunk<cr>",
    short = "git preview hunk",
    long = "gitsigns preview hunk",
  },
  signs_reset_hunk = {
    cmd = "<cmd>Gitsigns reset_hunk<cr>",
    short = "git reset hunk",
    long = "gitsigns reset hunk",
  },
  signs_reset_buffer = {
    cmd = "<cmd>Gitsigns reset_buffer<cr>",
    short = "git reset buffer",
    long = "gitsigns reset buffer",
  },
  telescope_projects = {
    cmd = "<cmd>Telescope projects<cr>",
    short = "view projects in telescope",
  },
  telescope_bcommits2 = {
    cmd = "<cmd>Telescope gcommits<cr>",
    short = "git reset buffer",
  },
  telescope_gcommits2 = {
    short = "telescope bcommits",
    cmd = "<cmd>Telescope bcommits<Cr>",
  },
}

return M
