-- use bash parser for zsh files

local logger = require("logger").init("treesitter")

local cfg = {
  skip_folding = {},
  skip_highlights = { "zsh" },
  vim_regex_highlights = { "make", "html", "spidercode" },
  skip_indent = { "markdown", "sh", "bash", "vim" },
}

---|fS "config: Parser info"
local update_stack = {}

---@class parser_register_opts
---@field language string Language name.
---@field path? string Local path to parser
---@field url? string URL to parser
---@field parser_name? string Custom name of parser `directory` or `repository`.
---@param opts parser_register_opts
local function register(opts)
  local path = opts.path and opts.path .. (opts.name or opts.lang)
  local url = opts.url and opts.url .. (opts.name or opts.lang)

  -- Add custom parser path for queries
  if path then
    vim.opt.runtimepath:append(path)
  end

  update_stack[opts.lang] = { url = url, path = path }

  if opts.name and opts.name ~= opts.lang then
    vim.treesitter.language.register(opts.name, opts.lang)
  end
end

local function update_parsers()
  for lang, info in pairs(update_stack) do
    require("nvim-treesitter.parsers")[lang] = { install_info = info }
  end
end

local function install_parsers()
  -- auto-install parsers
  update_parsers()
  local ts_config = require("nvim-treesitter.config")
  logger:info(
    "Registered  "
      .. vim.fn.len(update_stack)
      .. " parsers ("
      .. vim.fn.len(ts_config.get_available())
      .. " available)"
  )

  local languages = ts_config.norm_languages("all", { unsupported = true, not_installed = true })
  require("nvim-treesitter").install(languages)

  logger:info(
    "Installed "
      .. #languages
      .. " parsers ("
      .. vim.fn.len(ts_config.get_available())
      .. " available)"
  )
end

local url_pfx = "https://github.com/OXY2DEV/tree-sitter-"
local path_pfx = vim.fn.stdpath("config") .. "/parsers/tree-sitter-"
register({ lang = "doctext", url = url_pfx })
register({ lang = "comment", url = url_pfx, name = "doctext" })
register({ lang = "lua_patterns", url = url_pfx })
register({ lang = "vhs", url = url_pfx })
register({ lang = "qf", url = url_pfx })
register({ lang = "kitty", url = url_pfx })
register({ lang = "spidercode", path = path_pfx })
vim.treesitter.language.register("bash", "zsh")

install_parsers()

local function apply_parser(ctx)
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
  --   if hasStarted and vim.list_contains(cfg.vim_regex_highlights, ctx.match) then
  --     -- vim.bo[ctx.buf].syntax = ctx.match
  --     -- vim.cmd.syntax("enable")
  --   end
end

vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  desc = "-- update additional parsers",
  callback = update_parsers,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable treesitter highlighting and indentation",
  callback = apply_parser,
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
