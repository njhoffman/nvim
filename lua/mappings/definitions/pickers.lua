local M = {
  files_fzflua = {
    cmd = "<cmd>FzfLua files<cr>",
    short = "project files",
    long = "project files (fzf-lua)"
  },
  files_fzflua_ivy = {
    cmd = "lua require('fzf-lua').files({ winopts = { split = 'belowright new' } })",
    short = "project files fzf-ivy",
    long = "project files (fzf-lua) ivy theme"
  },
  files_tele = {
    cmd = "<cmd>lua _G._FindFiles()<cr>",
    short = "files telescope",
    long = "project files telescope"
  },
  files_telecenter = {
    cmd = "<cmd>lua _G._FindFilesCenter()<cr>",
    short = "files telescope center",
    long = "project files telescope center theme"
  },
  files_teledropdown = {
    cmd = "<cmd>lua _G._FindFilesDropdown()<cr>",
    short = "files telescope dropdown",
    long = "project files telescope dropdown theme"
  },
  files_teleivy = {
    cmd = "<cmd>lua _G._FindFilesIvy()<cr>",
    short = "files telescope ivy",
    long = "projet files telescope ivy theme"
  },
  files_directory_tele = {
    cmd = "<cmd>lua _G._FindFilesDirectory()<cr>",
    short = "files directory telescope",
    long = "directory files with telescope"
  },
  files_directory_teleivy = {
    cmd = "<cmd>lua _G._FindFilesDirectoryIvy()<cr>",
    short = "files directory telescope ivy",
    long = "directory files with telescope ivy theme"
  },
  notifications_teleivy = {
    cmd = "<cmd>lua _G._FindNotificationsIvy()<cr>",
    short = "notifications telescope ivy",
    long = "notifications list with telescope ivy theme"
  },
  notifications_tele = {
    cmd = "<cmd>lua _G._FindNotifications()<cr>",
    short = "notifications telescope",
    long = "notifications list with telescope"
  },
  workspace_diagnostics_fzflua = {
    cmd = "<cmd>FzfLua lsp_workspace_diagnostics<cr>",
    short = "workspace diagnostics fzf",
    long = "workspace diagnostics (fzf-lua)"
  },
  workspace_diagnostics_fzflua_ivy = {
    cmd = "lua require('fzf-lua').workspace_diagnostics({ winopts = { split = 'belowright new' } })",
    short = "project workspace_diagnostics fzf-ivy",
    long = "project workspace_diagnostics (fzf-lua) ivy theme"
  },
  home_files_fzfprev = {
    cmd = "<cmd>FzfPreviewDirectoryFiles~<cr>",
    short = "home files fzf",
    long = "home files (fzf-prev)"
  },
  git_actions_fzfprev = {
    cmd = "<cmd>FzfPreviewGitActions<cr>",
    short = "git actions fzf",
    long = "git actions (fzf-prev)"
  },
  git_status_fzfprev = {
    cmd = "<cmd>FzfPreviewGitStatus<cr>",
    short = "git status fzf",
    long = "git status (fzf-prev)"
  },
  mru_files_fzflua = {
    cmd = "<cmd>FzfLua oldfiles<cr>",
    short = "mru files fzf",
    long = "mru files (fzf-lua)"
  },
  mru_files_fzflua_ivy = {
    cmd = "lua require('fzf-lua').oldfiles({ winopts = { split = 'belowright new' } })",
    short = "project mru_files fzf-ivy",
    long = "project mru_files (fzf-lua) ivy theme"
  },
  mru_files_tele = {
    cmd = "<cmd>lua _G._FindOldFiles()<cr>",
    short = "mru telescope",
    long = "mru files telescope"
  },
  mru_files_telecenter = {
    cmd = "<cmd>lua _G._FindOldFilesCenter()<cr>",
    short = "mru center",
    long = "mru files telescope center theme"
  },
  mru_files_teledropdown = {
    cmd = "<cmd>lua _G._FindOldFilesDropdown()<cr>",
    short = "mru dropdown",
    long = "mru files telescope dropdown theme"
  },
  mru_files_teleivy = {
    cmd = "<cmd>lua _G._FindOldFilesIvy()<cr>",
    short = "mru ivy",
    long = "mru files telescope ivy theme"
  },
  frecency_files_tele = {
    cmd = "<cmd>lua _G._FindFrecency()<cr>",
    short = "frecency ",
    long = "frecency files telescope t"
  },
  frecency_files_telecenter = {
    cmd = "<cmd>lua _G._FindFrecencyCenter()<cr>",
    short = "frecency center",
    long = "frecency files telescope center theme"
  },
  frecency_files_teleivy = {
    cmd = "<cmd>lua _G._FindFrecencyIvy()<cr>",
    short = "frecency ivy",
    long = "frecency files telescope ivy theme"
  },
  commands_fzfprev = {
    cmd = "<cmd>FzfPreviewCommandPalette<cr>",
    short = "commands fzf",
    long = "commands (fzf-prev)"
  },
  commit_log_fzfprev = {
    cmd = "<cmd>FzfPreviewGitLogs<cr>",
    short = "git commit log",
    long = "git commit log (fzf-lua)"
  },
  commit_log_telescope = {
    cmd = "<cmd>Telescope git_commits<cr>",
    short = "git commit log telescope",
    long = "telescope git commit log"
  },
  bcommit_log_telescope = {
    cmd = "<cmd>Telescope git_bcommits<cr>",
    short = "git bcommit log telescope",
    long = "telescope git bcommit log"
  },
  buffers_fzflua = {
    cmd = "<cmd>FzfLua buffers<cr>",
    short = "buffers fzf",
    long = "buffers (fzf-lua)"
  },
  buffers_teledropdown = {
    cmd = "<cmd>lua _G._FindBufferDropdown()<cr>",
    short = "buffers telescope dropdown",
    long = "find buffers telescope dropdown theme"
  },
  buffers_teleleaderf = {
    cmd = "<cmd>lua _G._FindBufferLeaderF()<cr>",
    short = "buffers leader f ",
    long = "find buffers telescope leader f theme"
  },
  buffers_teleleaderf_nopreview = {
    cmd = "<cmd>lua _G._FindBufferLeaderFNoPreview()<cr>",
    short = "buffers leader f no preview ",
    long = "find buffers telescope leader f no preview theme"
  },
  sessions = { cmd = "<cmd>Sessions<cr>", short = "sessions", long = "sessions" },
  jumps_fzfprev = { cmd = "<cmd>FzfPreviewJumps<cr>", short = "jumps", long = "jumps" },
  helptags_tele = { cmd = "<cmd>Telescope help_tags<cr>", short = "helptags", long = "helptags" },
  manpages_tele = {
    cmd = "<cmd>Telescope man_pages<cr>",
    short = "man pages",
    long = "man pages telescope"
  },
  location_list_fzfprev = {
    cmd = "<cmd>FzfPreviewLocationList<cr>",
    short = "location list",
    long = "location list"
  },
  telescope_grep_search = {
    cmd = "<cmd>Telescope grep_string<cr>",
    short = "grep string search (telescope)",
  },
  telescope_buffer_search = {
    cmd = "<cmd>FindBuffer<cr>",
    short = "l('telescope.builtin').live_grep in only open buffers)",
  },

  find_buffer = {
    cmd   = "<cmd>FindBuffer<cr>",
    short = "find buffer",
    long  = "find buffer",
  },
  find_colorscheme_tele = {
    cmd = "<cmd>Telescope colorscheme<cr>",
    short = "find colorscheme",
    long = "find colorscheme"
  },
  find_file_tele = {
    cmd = "<cmd>Telescope find_files<cr>",
    short = "find file",
    long = "find file"
  },
  grep_text_tele = {
    cmd = "<cmd>Telescope live_grep<cr>",
    short = "grep text",
    long = "grep text"
  },
  find_helptags_tele = {
    cmd = "<cmd>Telescope help_tags<cr>",
    short = "find helptags",
    long = "find helptags"
  },
  find_nvim_dotfiles = {
    cmd = "<cmd>lua require('utils.core').search_nvim()<cr>",
    short = "find nvim dotfiles",
    long = "find nvim dotfiles"
  },
  find_oldfiles = {
    cmd = "<cmd>Telescope oldfiles<cr>",
    short = "find oldfiles",
    long = "find oldfiles"
  },
  find_mappings_n = {
    cmd = "<plug>(fzf-maps-n)",
    short = "find mappings (normal)",
    long = "find mappings (normal)"
  },
  find_mappings_i = {
    cmd = "<plug>(fzf-maps-i)",
    short = "find mappings (insert)",
    long = "find mappings (insert)"
  },
  find_mappings_v = {
    cmd = "<plug>(fzf-maps-v)",
    short = "find mappings (visual)",
    long = "find mappings (visual)"
  },
  find_mappings_o = {
    cmd = "<plug>(fzf-maps-o)",
    short = "find mappings (operator)",
    long = "find mappings (operator)"
  },
  find_pickers = {
    cmd = "<cmd>Telescope find_pickers<cr>",
    short = "find mappings (operator)",
    long = "find mappings (operator)"
  },
  tele_find_projects = {
    cmd = "<cmd>Telescope projects<cr>",
    short = "find projects in telescope picker",
  },
  tele_find_files = {
    cmd = "<cmd>lua _G.LoadTelescope('telescope.builtin', 'fd')<cr>",
    short = "telescope find files",
  },
  tele_live_grep = {
    cmd = "<cmd>lua _G.LoadTelescope('telescope.builtin', 'live_grep')<cr>",
    short = "telescope grep files live",
  },
  tele_grep_buffers = {
    cmd = "<cmd>lua _G.LoadTelescope('telescope.builtin', 'live_grep', {grep_open_files=true})<cr>",
    short = "Telescope grep within open bufers",
  }

  -- nmap("Pickers", "<C-d>", "<cmd>FzfPreviewGitCurrentLogs<cr>", "buffer_log", "git buffer log")
}
return M
