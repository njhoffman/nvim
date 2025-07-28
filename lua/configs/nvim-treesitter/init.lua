-- use bash parser for zsh files
-- vim.treesitter.language.register("bash", "zsh")
local parsers = require("configs.nvim-treesitter.parsers")

-- https://github.com/github/copilot.vim

local cfg = {
  install = parsers.all,
  skip_highlights = { "zsh" },
  skip_indent = { "bash", "zsh", "markdown" },
}

-- auto-install parsers
parsers.install(cfg.install)

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
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end,
})

-- COMMENTS parser
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  desc = "User: Highlights for the Treesitter `comments` parser",
  callback = function()
    -- FIX todo-comments in languages where LSP overwrites their highlight
    -- https://github.com/stsewd/tree-sitter-comment/issues/22
    -- https://github.com/LuaLS/lua-language-server/issues/1809
    vim.api.nvim_set_hl(0, "@lsp.type.comment", {})
    -- Define `@comment.bold` for `queries/comment/highlights.scm`
    vim.api.nvim_set_hl(0, "@comment.bold", { bold = true })
  end,
})

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
