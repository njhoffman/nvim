-- You can also use below = true here to to change the position of the printf
-- statement (or set two remaps for either one). This remap must be made in normal mode.
vim.api.nvim_set_keymap('n', 'gor', ":lua require('refactoring').debug.printf({below = false})<CR>", { noremap = true })

local tmp = 3

-- Print var
-- Remap in normal mode and passing { normal = true } will automatically find the variable under the cursor and print it
vim.api.nvim_set_keymap(
  'n',
  '<leader>rv',
  ":lua require('refactoring').debug.print_var({ normal = true })<CR>",
  { noremap = true }
)
-- Remap in visual mode will print whatever is in the visual selection
vim.api.nvim_set_keymap('v', '<leader>rv', ":lua require('refactoring').debug.print_var({})<CR>", { noremap = true })

-- Cleanup function: this remap should be made in normal mode
vim.api.nvim_set_keymap('n', '<leader>rc', ":lua require('refactoring').debug.cleanup({})<CR>", { noremap = true })

require('refactoring').setup({
  -- prompt for return type
  prompt_func_return_type = {
    go = true,
    cpp = true,
    c = true,
    java = true,
  },
  -- prompt for function parameters
  prompt_func_param_type = {
    go = true,
    cpp = true,
    c = true,
    java = true,
  },
  -- overriding printf statement for cpp
  printf_statements = {
    -- add a custom printf statement for cpp
    cpp = {
      'std::cout << "%s" << std::endl;',
    },
  },
})

-- -- load refactoring Telescope extension
-- require('telescope').load_extension('refactoring')

-- remap to open the Telescope refactoring menu in visual mode
vim.api.nvim_set_keymap(
  'v',
  '<leader>rr',
  "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
  { noremap = true }
)
