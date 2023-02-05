local M = {
  telescope_repeat = {
    cmd = "<cmd>Telescope resume<cr>",
    short = "repeat last telescope",
  },
  find_files = {
    cmd = "<cmd>lua _G.TelescopeLoad('builtin', 'find_files')<cr>",
    short = "files telescope",
    long = "project files telescope",
  },
  find_files_fd = {
    cmd = "<cmd>lua _G.TelescopeLoad('builtin', 'fd')<cr>",
    short = "files telescope",
    long = "project files telescope",
  },
  find_files_currdir = {
    cmd = "<cmd>lua _G._FindFilesDirectory()<cr>",
    short = "files directory telescope",
    long = "directory files with telescope",
  },
  notifications = {
    cmd = "<cmd>lua _G.TelescopeLoad('notify', 'notify')<cr>",
    short = "notifications telescope",
    long = "notifications list with telescope",
  },
  mru_files = {
    cmd = "<cmd>lua _G.TelescopeLoad('builtin', 'old_files')<cr>",
    short = "mru telescope",
    long = "mru files telescope",
  },
  find_projects = {
    cmd = "<cmd>lua _G.TelescopeLoad('projects', 'projects')<cr>",
    short = "find projects in telescope picker",
  },
  frecency_files = {
    cmd = "<cmd>lua _G.TelescopeLoad('frecency', 'frecency')<cr>",
    short = "frecency files telescope",
    long = "frecency files telescope",
  },
  live_grep = {
    cmd = "<cmd>lua _G.TelescopeLoad('builtin', 'live_grep', { prompt_title = 'Grep Project' })<cr>",
    short = "telescope grep files live",
  },
  grep_buffers = {
    cmd = "<cmd>lua _G.TelescopeLoad('builtin', 'live_grep', {grep_open_files=true, prompt_title='Grep Buffers'})<cr>",
    short = "Telescope grep within open bufers",
  },
  find_pickers = {
    cmd = "<cmd>lua _G.TelescopeLoad('find_pickers', 'find_pickers')<cr>",
    short = "find pickers",
    long = "find pickers",
  },
  find_buffers = {
    cmd = "<cmd>lua _G._FindBufferLeaderFNoPreview()<cr>",
    short = "buffers leader f no preview ",
    long = "find buffers telescope leader f no preview theme",
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
    cmd = "<cmd>lua _G.TelescopeLoad('builtin', 'find_files')<cr>",
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
  -- lua require('telescope.builtin').live_grep({ default_text = vim.fn.expand('<cWORD>') })
}
return M
