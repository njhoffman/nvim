local config = require("config").Treesitter
local tsmodules = require("plugs.config.nvim-treesitter.modules")

require("plugs.config.nvim-treesitter.context")
local ts = require("nvim-treesitter")

ts.define_modules(tsmodules)

local cfg = {
  -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "all",
  ignore_install = { "phpdoc", "latex", "wgsl", "wgsl_bevy" },
  -- indent = {
  --   enable = config.indent,
  -- },
  context_commentstring = { enable = true, enable_autocmd = false },
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
vim.cmd("packadd matchit")
require("nvim-treesitter.configs").setup(cfg)
require("nvim-treesitter.install").prefer_git = true

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
