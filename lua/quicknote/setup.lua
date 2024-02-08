require('quicknote').setup({
  mode = 'resident', -- "portable" | "resident"
  sign = '', --                     
  filetype = 'md',
  git_branch_recognizable = false,
})
vim.api.nvim_set_keymap('n', '<leader>n', "<cmd>:lua require('quicknote').NewNoteAtCurrentLine()<cr>", {})
