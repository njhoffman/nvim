local state = {
  vert_cutoff = 0.5, -- under this width ratio switch to vertical layout
  src_bufnr = vim.fn.bufnr('#'),
  help_bufnr = vim.fn.bufnr('%'),
}

return state
