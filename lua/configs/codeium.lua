local cfg = {
  config_path = vim.fn.stdpath('data') .. '/codeium.json',
  bin_path = vim.fn.stdpath('data') .. '/codeium',
}

require('codeium').setup(cfg)
