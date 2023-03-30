local state = {
  attached_lsp = false,
  last_project = nil,
  recent_projects = nil, -- projects from previous neovim sessions
  session_projects = {}, -- projects from current neovim session
  projects_meta = {},
  has_watch_setup = false,
}

return state
