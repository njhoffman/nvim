-- use bash parser for zsh files
-- local parsers = require("configs.nvim-treesitter.parsers")

-- Register custom spidercode parser with nvim-treesitter (for :TSInstall, etc.)
local spidercode_path = vim.fn.stdpath("config") .. "/tree-sitter-spidercode"

-- local parser_config = require("nvim-treesitter.parsers")
-- parser_config.spidercode = {
--   install_info = {
--     -- url = spidercode_path,
--     path = spidercode_path,
--     -- files = { "src/parser.c", "src/scanner.c" },
--     -- generate_requires_npm = false,
--     -- requires_generate_from_grammar = false,
--   },
--   tier = 2,
--   filetype = "spidercode",
-- }

-- Add custom parser path for queries
vim.opt.runtimepath:append(spidercode_path)

local spidercode_parser = {
  install_info = {
    path = spidercode_path,
    -- generate = true, -- only needed if repo does not contain pre-generated `src/parser.c`
    -- generate_from_json = false, -- only needed if repo does not contain `src/grammar.json` either
    -- queries = 'queries/neovim', -- also install queries from given directory
  },
}

require("nvim-treesitter.parsers").spidercode = spidercode_parser

local languages = require("nvim-treesitter.config").norm_languages("all", { unsupported = true })

local cfg = {
  install = languages,
  skip_folding = {},
  skip_highlights = { "zsh" },
  vim_regex_highlights = { "make", "html", "spidercode" },
  skip_indent = { "markdown", "sh", "bash", "vim" },
}

vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    require("nvim-treesitter.parsers").spidercode = spidercode_parser
  end,
})

-- auto-install parsers
require("nvim-treesitter").install(cfg.install)

-- use bash parser for zsh files
vim.treesitter.language.register("bash", "zsh")

-- auto-start highlights & indentation
vim.api.nvim_create_autocmd("FileType", {
  desc = "User: enable treesitter highlighting",
  callback = function(ctx)
    -- highlights
    local hasStarted = nil
    if not vim.list_contains(cfg.skip_highlights, ctx.match) then
      hasStarted = pcall(vim.treesitter.start) -- errors for filetypes with no parser
    end

    -- indent
    if hasStarted and not vim.list_contains(cfg.skip_indent, ctx.match) then
      vim.bo[ctx.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end

    -- folding
    if hasStarted and not vim.list_contains(cfg.skip_folding, ctx.match) then
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo.foldmethod = "expr"
    end

    -- -- vim regex highlights
    -- vim.schedule(function()
    --   if hasStarted and vim.list_contains(cfg.vim_regex_highlights, ctx.match) then
    --     vim.dbglog("enabling vim regex highlights for filetype: " .. ctx.match, ctx)
    --     -- vim.bo[ctx.buf].syntax = ctx.match
    --     -- vim.cmd.syntax("enable")
    --   end
    -- end)
  end,
})

-- -- COMMENTS parser
-- vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
--   desc = "User: Highlights for the Treesitter `comments` parser",
--   callback = function()
--     -- FIX todo-comments in languages where LSP overwrites their highlight
--     -- https://github.com/stsewd/tree-sitter-comment/issues/22
--     -- https://github.com/LuaLS/lua-language-server/issues/1809
--     vim.api.nvim_set_hl(0, "@lsp.type.comment", {})
--     -- Define `@comment.bold` for `queries/comment/highlights.scm`
--     vim.api.nvim_set_hl(0, "@comment.bold", { bold = true })
--   end,
-- })

-- -- vim.treesitter.language.register("lua", { "log" })
-- for matcher module
-- vim.cmd("packadd matchit")
-- require("nvim-treesitter.configs").setup(cfg)
-- require("nvim-treesitter.install").prefer_git = true

-- require("configs.nvim-treesitter.context")
-- require("configs.nvim-treesitter.extra-config")

-- {
--   "RRethy/nvim-treesitter-textsubjects",
--   config = function()
--     require("nvim-treesitter-textsubjects").configure({
--       prev_selection = "<leader>.",
--       keymaps = {
--         ["<leader><leader>"] = "textsubjects-smart",
--         ["<leader>\\]"] = "textsubjects-container-outer",
--         ["<leader>\\["] = "textsubjects-container-inner",
--       },
--     })
--   end,
-- },
-- "HiPhish/nvim-ts-rainbow2",
-- "nvim-treesitter/nvim-treesitter-refactor",
-- { "nvim-treesitter/nvim-treesitter-context" },
