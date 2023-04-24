-- local git = require("gitsigns.git")
-- local bufnr = vim.api.nvim_get_current_buf()
-- local res = vim.api.nvim_buf_get_var(bufnr, "gitsigns_status_dict")
-- return res
--
-- local testobj = {
--   one = "value one",
--   two = "value two",
--   three = "value three",
--
require("refactoring").setup({
  -- prompt for return type
  prompt_func_return_type = {
    go = true,
    cpp = true,
    c = true,
    java = true,
    php = true,
    rust = false,
  },
  -- prompt for function parameters
  prompt_func_param_type = {
    go = true,
    cpp = true,
    c = true,
    java = true,
    php = true,
    rust = false,
  },
})
require("telescope").load_extension("refactoring")
-- prompt for a refactor to apply when the remap is triggered
vim.api.nvim_set_keymap("v", "<leader>rr", "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", { noremap = true })
-- Remaps for the refactoring operations currently offered by the plugin
vim.api.nvim_set_keymap("v", "<leader>xm", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], { noremap = true, silent = true, expr = false })
vim.api.nvim_set_keymap("v", "<leader>xmf", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]], { noremap = true, silent = true, expr = false })
vim.api.nvim_set_keymap("v", "<leader>xv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], { noremap = true, silent = true, expr = false })
vim.api.nvim_set_keymap("v", "<leader>iv", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], { noremap = true, silent = true, expr = false })

-- Inline variable can also pick up the identifier currently under the cursor without visual mode
vim.api.nvim_set_keymap("n", "<leader>iv", [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], { noremap = true, silent = true, expr = false })
