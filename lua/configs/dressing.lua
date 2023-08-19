local default_cfg = {
  input = {
    win_options = {
      winblend = 15,
    },
    select = {
      backend = { 'nui', 'telescope' },
      -- telescope = require('telescope.themes').get_ivy({...})
    },
  },
}

require('dressing').setup(default_cfg)

vim.ui.select = function(...)
  require('lazy').load({ plugins = { 'dressing.nvim' } })
  return vim.ui.select(...)
end

vim.ui.input = function(...)
  require('lazy').load({ plugins = { 'dressing.nvim' } })
  return vim.ui.input(...)
end
