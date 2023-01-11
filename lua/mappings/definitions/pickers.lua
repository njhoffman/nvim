local M = {
  telescope_repeat = {
    cmd = "<cmd>Telescope resume<cr>",
    short = "repeat last telescope",
  },
  files_tele = {
    cmd = "<cmd>lua _G._FindFiles()<cr>",
    short = "files telescope",
    long = "project files telescope",
  },
  files_telecenter = {
    cmd = "<cmd>lua _G._FindFilesCenter()<cr>",
    short = "files telescope center",
    long = "project files telescope center theme",
  },
  files_teledropdown = {
    cmd = "<cmd>lua _G._FindFilesDropdown()<cr>",
    short = "files telescope dropdown",
    long = "project files telescope dropdown theme",
  },
  files_teleivy = {
    cmd = "<cmd>lua _G._FindFilesIvy()<cr>",
    short = "files telescope ivy",
    long = "projet files telescope ivy theme",
  },
  files_directory_tele = {
    cmd = "<cmd>lua _G._FindFilesDirectory()<cr>",
    short = "files directory telescope",
    long = "directory files with telescope",
  },
  files_directory_teleivy = {
    cmd = "<cmd>lua _G._FindFilesDirectoryIvy()<cr>",
    short = "files directory telescope ivy",
    long = "directory files with telescope ivy theme",
  },
  notifications_teleivy = {
    cmd = "<cmd>lua _G._FindNotificationsIvy()<cr>",
    short = "notifications telescope ivy",
    long = "notifications list with telescope ivy theme",
  },
  notifications_tele = {
    cmd = "<cmd>lua _G._FindNotifications()<cr>",
    short = "notifications telescope",
    long = "notifications list with telescope",
  },
  mru_files_tele = {
    cmd = "<cmd>lua _G._FindOldFiles()<cr>",
    short = "mru telescope",
    long = "mru files telescope",
  },
  mru_files_telecenter = {
    cmd = "<cmd>lua _G._FindOldFilesCenter()<cr>",
    short = "mru center",
    long = "mru files telescope center theme",
  },
  mru_files_teledropdown = {
    cmd = "<cmd>lua _G._FindOldFilesDropdown()<cr>",
    short = "mru dropdown",
    long = "mru files telescope dropdown theme",
  },
  mru_files_teleivy = {
    cmd = "<cmd>lua _G._FindOldFilesIvy()<cr>",
    short = "mru ivy",
    long = "mru files telescope ivy theme",
  },
  frecency_files_tele = {
    cmd = "<cmd>lua _G._FindFrecency()<cr>",
    short = "frecency ",
    long = "frecency files telescope t",
  },
  frecency_files_telecenter = {
    cmd = "<cmd>lua _G._FindFrecencyCenter()<cr>",
    short = "frecency center",
    long = "frecency files telescope center theme",
  },
  frecency_files_teleivy = {
    cmd = "<cmd>lua _G._FindFrecencyIvy()<cr>",
    short = "frecency ivy",
    long = "frecency files telescope ivy theme",
  },
  commit_log_telescope = {
    cmd = "<cmd>Telescope git_commits<cr>",
    short = "git commit log telescope",
    long = "telescope git commit log",
  },
  bcommit_log_telescope = {
    cmd = "<cmd>Telescope git_bcommits<cr>",
    short = "git bcommit log telescope",
    long = "telescope git bcommit log",
  },
  buffers_teledropdown = {
    cmd = "<cmd>lua _G._FindBufferDropdown()<cr>",
    short = "buffers telescope dropdown",
    long = "find buffers telescope dropdown theme",
  },
  buffers_teleleaderf = {
    cmd = "<cmd>lua _G._FindBufferLeaderF()<cr>",
    short = "buffers leader f ",
    long = "find buffers telescope leader f theme",
  },
  buffers_teleleaderf_nopreview = {
    cmd = "<cmd>lua _G._FindBufferLeaderFNoPreview()<cr>",
    short = "buffers leader f no preview ",
    long = "find buffers telescope leader f no preview theme",
  },
  sessions = { cmd = "<cmd>Sessions<cr>", short = "sessions", long = "sessions" },
  helptags_string_cursor = {
    cmd = "<cmd>lua require('telescope.builtin').help_tags({ theme = 'get_ivy', default_text = vim.fn.expand('<cWORD>') })<cr>",
    short = "helptags ",
    long = "helptags search under cursor",
  },
  manpages_tele = {
    cmd = "<cmd>Telescope man_pages<cr>",
    short = "man pages",
    long = "man pages telescope",
  },
  grep_string_cursor = {
    cmd = "<cmd>Telescope grep_string theme=get_ivy<cr>",
    short = "grep files word under cursor",
  },
  live_grep_visual = {
    cmd = "y<ESC>:Telescope live_grep default_text=<c-r>0<CR>",
    short = "live grep word under cursor",
  },
  telescope_grep_search = {
    cmd = "<cmd>Telescope grep_string<CR>",
    short = "grep string search (telescope)",
  },
  find_colorscheme_tele = {
    cmd = "<cmd>Telescope colorscheme<cr>",
    short = "find colorscheme",
    long = "find colorscheme",
  },
  find_file_tele = {
    cmd = "<cmd>Telescope find_files<cr>",
    short = "find file",
    long = "find file",
  },
  grep_text_tele = {
    cmd = "<cmd>Telescope live_grep<cr>",
    short = "grep text",
    long = "grep text",
  },
  find_nvim_dotfiles = {
    cmd = "<cmd>lua require('utils.core').search_nvim()<cr>",
    short = "find nvim dotfiles",
    long = "find nvim dotfiles",
  },
  find_oldfiles = {
    cmd = "<cmd>Telescope oldfiles<cr>",
    short = "find oldfiles",
    long = "find oldfiles",
  },
  find_pickers = {
    cmd = "<cmd>Telescope find_pickers<cr>",
    short = "find mappings (operator)",
    long = "find mappings (operator)",
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
    cmd = "<cmd>lua _G.LoadTelescope('telescope.builtin', 'live_grep', { prompt_title = 'Grep Project' })<cr>",
    short = "telescope grep files live",
  },
  tele_grep_buffers = {
    cmd = "<cmd>lua _G.LoadTelescope('telescope.builtin', 'live_grep', {grep_open_files=true, prompt_title='Grep Buffers'})<cr>",
    short = "Telescope grep within open bufers",
  },
  -- lua require('telescope.builtin').live_grep({ default_text = vim.fn.expand('<cWORD>') })
}
return M
