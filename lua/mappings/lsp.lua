local M = require("mappings.mapper")

M.map("LSP", "n", "K", "hover_doc1")
M.map("LSP", "n", "gd", "definitions")
M.map("LSP", "n", "gD", "declaration")
M.map("LSP", "n", "gk", "hover_doc2")
M.map("LSP", "n", "go", "organize_imports")
M.map("LSP", "n", "gr", "references")
M.map("LSP", "n", "gs", "signature_help1")
M.map("LSP", "n", "gy", "buffer_definitions")
M.map("LSP", "n", "[d", "diagnostic_prev")
M.map("LSP", "n", "]d", "diagnostic_next")
M.map("LSP", "n", "<leader>la", "code_action")
M.map("LSP", "n", "<leader>lA", "range_code_action")
M.map("LSP", "n", "<leader>ld", "doc_diagnostics")
M.map("LSP", "n", "<leader>lD", "workspace_diagnostics")
M.map("LSP", "n", "<leader>le", "view_log")
M.map("LSP", "n", "<leader>ll", "line_diagnostics")
M.map("LSP", "n", "<leader>lf", "finder2")
M.map("LSP", "n", "<leader>li", "server_info")
M.map("LSP", "n", "<leader>lk", "signature_help2")
M.map("LSP", "n", "<leader>lF", "format_buffer")
M.map("LSP", "n", "<leader>lp", "preview_definition")
M.map("LSP", "n", "<leader>lr", "rename")
M.map("LSP", "n", "<leader>ls", "doc_symbols")
M.map("LSP", "n", "<leader>lS", "workspace_symbols")
M.map("LSP", "n", "<leader>l.a", "stop_all")
M.map("LSP", "n", "<C-t>", "doc_diagnostics_ivy")
M.map("LSP", "n", "<A-T>", "doc_diagnostics_2")


vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble lsp_workspace_diagnostics<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble lsp_document_diagnostics<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xr", "<cmd>Trouble lsp_references<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
  {silent = true, noremap = true}
)

-- TODO: enable cycling
-- jump to the previous/next item, skipping the groups
vim.api.nvim_set_keymap("n", "[x",
  "<cmd>lua require('trouble').previous({ skip_groups = true, jump = true, })<cr>",
  {silent = true, noremap = true }
)
vim.api.nvim_set_keymap("n", "]x",
  "<cmd>lua require('trouble').next({ skip_groups = true, jump = true, })<cr>",
  {silent = true, noremap = true }

)
