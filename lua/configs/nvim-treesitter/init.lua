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

vim.treesitter.language.register('bash', 'zsh')
vim.filetype.add({
  extension = { rasi = 'rasi' },
  pattern = {
    ['.*/waybar/config'] = 'jsonc',
    ['.*/mako/config'] = 'dosini',
    ['.*/kitty/*.conf'] = 'bash',
  },
})

-- local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
-- parser_config.norg = {
--   install_info = {
--     url = 'https://github.com/nvim-neorg/tree-sitter-norg',
--     files = { 'src/parser.c', 'src/scanner.cc' },
--     branch = 'main',
--   },
-- }
-- parser_config.sql = {
--   install_info = {
--     url = 'https://github.com/m-novikov/tree-sitter-sql',
--     files = { 'src/parser.c' },
--     branch = 'main',
--   },
--   filetype = {'sql', 'psql'},
-- }

-- textobj-unit
local textobj_unit = 'treesitter._textobjects.unit'
require(textobj_unit).setup()

vim.api.nvim_set_keymap(
  'x',
  'iu',
  ':lua require"' .. textobj_unit .. '".select()<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'x',
  'au',
  ':lua require"' .. textobj_unit .. '".select(true)<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'o',
  'iu',
  ':<c-u>lua require"' .. textobj_unit .. '".select()<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'o',
  'au',
  ':<c-u>lua require"' .. textobj_unit .. '".select(true)<CR>',
  { noremap = true, silent = true }
)

-- https://github.com/kjuulh/tree-sitter-hurl
-- https://github.com/kjuulh/lazyvim/blob/ff018a06c332ab69d48faa546f789bd4cedb4710/lua/plugins/treesitter.lua
-- local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
--
-- -- https://github.com/nvim-treesitter/nvim-treesitter/tree/master#adding-parsers
-- parser_config.hurl = {
--   install_info = {
--     url = '~/git/github.com/kjuulh/tree-sitter-hurl',
--     files = { 'src/parser.c' },
--     branch = 'main',
--     generate_requires_npm = false,
--     requires_generate_from_grammar = false,
--   },
--   filetype = 'hurl',
-- }
--
-- -- https://neovim.io/doc/user/lua.html#vim.filetype.add()
-- -- Search for vim.filetype.add
-- vim.filetype.add({
--   extension = {
--     hurl = 'hurl',
--   },
-- })

-- Steps for custom language injections
-- Install nvim-treesitter/nvim-treesitter
-- Install nvim-treesitter/playground
-- Read the docs of the treesitter query language
-- Read the :treesitter-language-injections
-- Get some inspiration for queries from the standard injections in ~/.local/share/nvim/lazy/nvim-treesitter/queries/{language}/injections.scm
-- Start treesitter playground with :TSPlaygroundToggle, and try out queries
-- Open the file injections files by :TSEditQueryUser injections markdown, for example
-- Put your queries there and do not forget the ;extends comment on top, when you want to keep the standard queries provided by nvim-treesitter

-- Make sure TS syntax tree is updated when needed by plugin (with some throttling)
-- even if the `highlight` module is not enabled.
-- See https://github.com/nvim-treesitter/nvim-treesitter/issues/2492
-- _G.TreesitterParse = function()
--   local lang = ts_parsers.ft_to_lang(vim.bo.filetype)
--   local parser = ts_parsers.get_parser(vim.fn.bufnr(), lang)
--   if parser then
--     return parser:parse()
--   else
--     return false
--   end
-- end
--
-- local function throttle(fn, ms)
--   local timer = vim.loop.new_timer()
--   local running = false
--   return function(...)
--     if not running then
--       timer:start(ms, 0, function()
--         running = false
--       end)
--       running = true
--       pcall(vim.schedule_wrap(fn), select(1, ...))
--     end
--   end
-- end
--
-- if not (ts_configs.get_module('highlight') or {}).enable then
--   _G.TreesitterParseDebounce = throttle(_G.TreesitterParse, 100) -- 100 ms
--   vim.cmd([[
--     augroup TreesitterUpdateParsing
--       autocmd!
--       autocmd TextChanged,TextChangedI *   call v:lua.TreesitterParseDebounce()
--     augroup END
--   ]])
-- end

-- local ft_to_parser = vim.treesitter.language.register('mdx', 'markdown')

-- making dot repeatable
-- --local CR = vim.api.nvim_replace_termcodes("<cr>", true, true, true)

-- local function swap_textobject(query_string, direction)
--   local bufnr, textobject_range, node = shared.textobject_at_point(query_string)
--   if not node then return end
-- @@ -20,10 +22,12 @@ end

-- function M.swap_next(query_string)
--   swap_textobject(query_string, 1)
--   pcall(vim.fn["repeat#set"], ":TSTextobjectSwapNext "..query_string..CR)
-- end

-- -------------------- TEXT OBJECTS --------------------------
-- for _, ch in ipairs({
--   '<space>', '!', '#', '$', '%', '&', '*', '+', ',', '-', '.',
--   '/', ':', ';', '=', '?', '@', '<bslash>', '^', '_', '~', '<bar>',
-- }) do
--   map('x', fmt('i%s', ch), fmt(':<C-u>normal! T%svt%s<CR>', ch, ch), {silent = true})
--   map('o', fmt('i%s', ch), fmt(':<C-u>normal vi%s<CR>', ch), {silent = true})
--   map('x', fmt('a%s', ch), fmt(':<C-u>normal! F%svf%s<CR>', ch, ch), {silent = true})
--   map('o', fmt('a%s', ch), fmt(':<C-u>normal va%s<CR>', ch), {silent = true})
-- end

-- text objects:
-- @block.inner/outer
-- @call.inner/outer
-- @class.inner/outer
-- @comment.outer
-- @conditional.inner/outer
-- @frame.inner/outer
-- @function.inner/outer
-- @loop.inner/outer
-- @parameter.inner/outer
-- @scopename.inner
-- @statement.outer

-- temporary fix: /home/nicholas/.local/share/nvim/runtime/lua/vim/treesitter.lua:221
-- local ok, lines = pcall(api.nvim_buf_get_text, buf, start_row, start_col, end_row, end_col, {})
-- if not ok then
--   vim.dbglog('Treesitter not get text: ', lines)
--   return ''
-- end
-- -- local lines = api.nvim_buf_get_text(buf, start_row, start_col, end_row, end_col, {})
-- return table.concat(lines or '', '\n')
--
