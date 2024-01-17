local cfg = {}
require('rest-nvim').setup(cfg)

vim.api.nvim_create_user_command('RestRun', "lua require('rest-nvim').run({verbose=false})", { nargs = '*' })
vim.api.nvim_create_user_command('RestPreview', "lua require('rest-nvim').run({verbose=true})", { nargs = '*' })
vim.api.nvim_create_user_command('RestFile', function(_)
  require('rest-nvim').run_file(vim.fn.expand('%f:%h'), { verbose = true })
end, { nargs = '*' })
vim.api.nvim_create_user_command('RestLast', "lua require('rest-nvim').last()", { nargs = '*' })
