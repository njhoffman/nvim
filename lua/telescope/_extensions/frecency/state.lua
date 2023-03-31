local state = {
  results = {},
  active_filter = nil,
  active_filter_tag = nil,
  last_filter = nil,
  previous_buffer = nil,
  cwd = nil,
  show_scores = false,
  default_workspace = nil,
  user_workspaces = {},
  lsp_workspaces = {},
  picker = {},
}

return state
