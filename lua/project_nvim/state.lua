local state = {
  attached_lsp = false,
  last_project = nil,
  has_watch_setup = false,
  recent_projects = nil, -- projects from previous neovim sessions
  session_projects = {}, -- projects from current neovim session
  projects_meta = {},
  save_project_waiting = false,
}

return state
