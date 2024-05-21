-- stylua: ignore
local ts_objects = {
  'block.inner',         'return.inner',
  'block.outer',         'return.outer',
  'call.outer',          'loop.outer',
  'call.inner',          'loop.inner',
  '_start',              'parameter.inner',
  '_end',                'number.inner',
  'comment.outer',       'assignment.lhs',
  'conditional.inner',   'assignment.inner',
  'conditional.outer',   'assignment.rhs',
  'function.outer',      'assignment.outer',
  'function.inner',      'parameter.outer',
}

-- return {
--   "nvim-treesitter/nvim-treesitter-textobjects",
--   event = "VeryLazy",
--   dependencies = {
--     { "nvim-treesitter/nvim-treesitter" },
--   },
--   config = function()
--     require("nvim-treesitter.configs").setup {
--       textobjects = {
--         select = {
--           enable = true,
--           lookahead = true,
--           keymaps = {
--             ["aa"] = { query = "@parameter.outer", desc = "a argument" },
--             ["ia"] = { query = "@parameter.inner", desc = "inner part of a argument" },
--             ["af"] = { query = "@function.outer", desc = "a function region" },
--             ["if"] = { query = "@function.inner", desc = "inner part of a function region" },
--             ["ar"] = { query = "@return.outer", desc = "a return" },
--             ["ir"] = { query = "@return.outer", desc = "inner return" },
--             ["ac"] = { query = "@class.outer", desc = "a of a class" },
--             ["ic"] = { query = "@class.inner", desc = "inner part of a class region" },
--             ["aj"] = { query = "@conditional.outer", desc = "a judge" },
--             ["ij"] = { query = "@conditional.inner", desc = "inner part of a judge region" },
--             ["al"] = { query = "@loop.outer", desc = "a loop" },
--             ["il"] = { query = "@loop.inner", desc = "inner part of a loop" },
--           },
--         },
--         move = {
--           enable = true,
--           set_jumps = true,
--           goto_next_start = {
--             ["]a"] = { query = "@parameter.outer", desc = "Next argument start" },
--             ["]f"] = { query = "@function.outer", desc = "Next function start" },
--             ["]r"] = { query = "@function.outer", desc = "Next return start" },
--             ["]c"] = { query = "@class.outer", desc = "Next class start" },
--             ["]j"] = { query = "@conditional.outer", desc = "Next judge start" },
--             ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
--           },
--           goto_next_end = {
--             ["]A"] = { query = "@parameter.outer", desc = "Next argument end" },
--             ["]F"] = { query = "@function.outer", desc = "Next function end" },
--             ["]R"] = { query = "@function.outer", desc = "Next return end" },
--             ["]C"] = { query = "@class.outer", desc = "Next class end" },
--             ["]J"] = { query = "@conditional.outer", desc = "Next judge end" },
--             ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
--           },
--           goto_previous_start = {
--             ["[a"] = { query = "@parameter.outer", desc = "Previous argument start" },
--             ["[f"] = { query = "@function.outer", desc = "Previous function start" },
--             ["[r"] = { query = "@function.outer", desc = "Previous return start" },
--             ["[c"] = { query = "@class.outer", desc = "Previous class start" },
--             ["[j"] = { query = "@conditional.outer", desc = "Previous judge start" },
--             ["[l"] = { query = "@loop.outer", desc = "Previous loop start" },
--           },
--           goto_previous_end = {
--             ["[A"] = { query = "@parameter.outer", desc = "Previous argument end" },
--             ["[F"] = { query = "@function.outer", desc = "Previous function end" },
--             ["[R"] = { query = "@function.outer", desc = "Previous return end" },
--             ["[C"] = { query = "@class.outer", desc = "Previous class end" },
--             ["[J"] = { query = "@conditional.outer", desc = "Previous judge end" },
--             ["[L"] = { query = "@loop.outer", desc = "Previous loop end" },
--           },
--         },
--       },
--     }
--   end,
-- }
-- Custom filetype detection logic with the new Lua filetype plugin
-- vim.filetype.add {
--   extension = {
--     cts = 'typescript',
--     es6 = 'javascript',
--     gif = 'image',
--     jpeg = 'image',
--     jpg = 'image',
--     mdx = 'mdx',
--     mts = 'typescript',
--     png = 'image',
--     sh = 'sh',
--     zsh = 'sh',
--   },
--   filename = {
--     ['.babelrc'] = 'json',
--     ['.eslintrc'] = 'json',
--     ['.prettierrc'] = 'json',
--     ['.stylelintrc'] = 'json',
--     ['.zshrc'] = 'sh',
--     ['.zshenv'] = 'sh',
--   },
--   pattern = {
--     ['.*config/git/config'] = 'gitconfig',
--     ['.env.*'] = 'sh',
--   },
-- }
-- 'lua require"treesitter-unit".enable_highlighting()',

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
