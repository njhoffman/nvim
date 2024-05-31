local config = require('config').Treesitter
local tsmodules = require('configs.nvim-treesitter.modules')

require('configs.nvim-treesitter.context')
local ts = require('nvim-treesitter')

ts.define_modules(tsmodules)
local cfg = {
  -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  auto_install = true,
  ensure_installed = 'all',
  -- ignore_install = { 'comment' },
  indent = {
    enable = true,
    disable = {
      'markdown', -- indentation at bullet points worse
      'lua', -- `o` sometimes get weird behavior
      'javascript', -- `o` sometimes get weird behavior
    },
  },

  playground = tsmodules.playground,
  highlight = tsmodules.highlight,
  refactor = tsmodules.refactor,
  autotag = tsmodules.autotag,
  rainbow = tsmodules.rainbow,
  matchup = tsmodules.matchup,
  pairs = tsmodules.pairs,
  textobjects = tsmodules.textobjects,
  textsubjects = tsmodules.textsubjects,
  incremental_selection = tsmodules.incremental_custom,
  endwise = tsmodules.endwise,
}

-- textobj-unit
local textobj_unit = 'treesitter._textobjects.unit'
require(textobj_unit).setup()

-- for matcher module
vim.cmd('packadd matchit')
require('nvim-treesitter.configs').setup(cfg)
require('nvim-treesitter.install').prefer_git = true

vim.g.skip_ts_context_commentstring_module = true
require('ts_context_commentstring').setup({
  enable = true,
  -- enable_autocmd = false,
  config = {
    javascript = {
      __default = '// %s',
      jsx_element = '{/* %s */}',
      jsx_fragment = '{/* %s */}',
      jsx_attribute = '// %s',
      comment = '// %s',
    },
    typescript = { __default = '// %s', __multiline = '/* %s */' },
  },
})

-- vim.treesitter.language.register('bash', 'zsh')
vim.filetype.add({
  extension = { rasi = 'rasi' },
  pattern = {
    ['.*/waybar/config'] = 'jsonc',
    ['.*/mako/config'] = 'dosini',
    ['.*/kitty/*.conf'] = 'bash',
  },
})

local parsers = require('nvim-treesitter.parsers')
local parser_config = parsers.get_parser_configs()
parser_config.org = {
  install_info = {
    url = 'https://github.com/milisims/tree-sitter-org',
    revision = 'f110024d539e676f25b72b7c80b0fd43c34264ef',
    files = { 'src/parser.c', 'src/scanner.cc' },
  },
  filetype = 'org',
}

parser_config.norg = {
  install_info = {
    url = 'https://github.com/nvim-neorg/tree-sitter-norg',
    files = { 'src/parser.c', 'src/scanner.cc' },
    branch = 'main',
  },
}

parser_config.sql = {
  install_info = {
    url = 'https://github.com/m-novikov/tree-sitter-sql',
    files = { 'src/parser.c' },
    branch = 'main',
  },
  filetype = { 'sql', 'psql' },
}

vim.api.nvim_set_keymap(
  'x',
  'iu',
  '<cmd>lua require("' .. textobj_unit .. '").select()<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'x',
  'au',
  '<cmd>lua require("' .. textobj_unit .. '").select(true)<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'o',
  'iu',
  '<cmd><c-u>lua require("' .. textobj_unit .. '").select()<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'o',
  'au',
  ':<c-u>lua require("' .. textobj_unit .. '").select(true)<CR>',
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  'n',
  'ghu',
  '<cmd>lua require("' .. textobj_unit .. '").toggle_highlighting("VisualAlt")<CR>',
  { noremap = true, silent = true }
)

vim.api.nvim_create_user_command( -- :TSUnitHighlight
  'TSUnitHighlight',
  'lua require("' .. textobj_unit .. '").toggle_highlighting("VisualAlt")',
  { nargs = 0 }
)
