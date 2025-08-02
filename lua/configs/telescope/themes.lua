local telenames = {
  "aerial.aerial",
  "arecibo.websearch",
  "asynctasks.all",
  "bookmarks.bookmarks",
  "builtin.autocommands",
  "builtin.buffers",
  "builtin.builtin",
  "builtin.colorscheme",
  "builtin.command_history",
  "builtin.commands",
  "builtin.current_buffer_fuzzy_find",
  "builtin.current_buffer_tags",
  "builtin.diagnostics",
  "builtin.fd",
  "builtin.filetypes",
  "builtin.find_files",
  "builtin.git_bcommits",
  "builtin.git_branches",
  "builtin.git_commits",
  "builtin.git_files",
  "builtin.git_stash",
  "builtin.git_status",
  "builtin.grep_string",
  "builtin.help_tags",
  "builtin.highlights",
  "builtin.jumplist",
  "builtin.keymaps",
  "builtin.live_grep",
  "builtin.loclist",
  "builtin.lsp_definitions",
  "builtin.lsp_document_symbols",
  "builtin.lsp_dynamic_workspace_symbols",
  "builtin.lsp_implementations",
  "builtin.lsp_incoming_calls",
  "builtin.lsp_outgoing_calls",
  "builtin.lsp_references",
  "builtin.lsp_type_definitions",
  "builtin.lsp_workspace_symbols",
  "builtin.man_pages",
  "builtin.marks",
  "builtin.oldfiles",
  "builtin.pickers",
  "builtin.quickfix",
  "builtin.quickfixhistory",
  "builtin.registers",
  "builtin.reloader",
  "builtin.resume",
  "builtin.search_history",
  "builtin.spell_suggest",
  "builtin.symbols",
  "builtin.tags",
  "builtin.tagstack",
  "builtin.treesitter",
  "builtin.vim_options",
  "cder.cder",
  "changes.changes",
  "cheatsheet.cheatsheet",
  "command_palette.command_palette",
  "dap.commands",
  "dap.configurations",
  "dap.frames",
  "dap.list_breakpoints",
  "dap.variables",
  "env.env",
  "fences.fences",
  "file_browser.file_browser",
  "find_pickers.find_pickers",
  "frecency.frecency",
  "fzf.native_fzf_sorter",
  "gh.gist",
  "gh.issues",
  "gh.pull_request",
  "gh.pull_request_files",
  "gh.run",
  "gh.secret",
  "ghn.ghn",
  "ghn.notifications",
  "ghq.list",
  "gotofile.gotofile",
  "heading.heading",
  "hop.hop",
  "howdoi.howdoi",
  "lazygit.lazygit",
  "live_grep_args.live_grep_args",
  -- "luasnip.luasnip",
  "mapper.mapper",
  "media_files.media_files",
  "neoclip.neoclip",
  "node_modules.list",
  "npm.packages",
  "npm.scripts",
  "openbrowser.list",
  "options.options",
  "ports.ports",
  "project.project",
  "repo.repo",
  "session-lens.search_session",
  "tmux.pane_contents",
  "tmux.sessions",
  "tmux.windows",
  "variables.variables",
  "vimwiki.vimwiki",
  "z.list",
}

local norcalli_dropdown_theme = require("telescope.themes").get_dropdown({
  results_height = 20,
  winblend = 20,
  width = 0.8,
  prompt_title = "",
  prompt_prefix = "Files>",
  previewer = false,
  borderchars = {
    prompt = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
    results = { " ", "▐", "▄", "▌", "▌", "▐", "▟", "▙" },
    preview = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
  },
})

local norcalli_full_theme = {
  winblend = 20,
  width = 0.8,
  show_line = false,
  prompt_prefix = "TS Symbols>",
  prompt_title = "",
  results_title = "",
  preview_title = "",
  borderchars = {
    prompt = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
    results = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
    preview = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
  },
}

local minimalist_box = function()
  return require("telescope.themes").get_dropdown({
    borderchars = {
      { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
      preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    },
    width = 0.8,
    previewer = false,
    prompt_title = false,
  })
end

local center_list = require("telescope.themes").get_dropdown({
  winblend = 10,
  width = 0.5,
  prompt = " ",
  results_height = 15,
  previewer = false,
})

-- Settings for with preview option
local with_preview = {
  winblend = 10,
  show_line = false,
  results_title = false,
  preview_title = false,
  layout_config = {
    preview_width = 0.5,
  },
}

local main = {}

local cutoff_width = 90

local ivy_to_default = function()
  local currwidth = vim.api.nvim_win_get_width(0)
  print("ivy_to_default", currwidth)
end
local ivy_to_center = function()
  local currwidth = vim.api.nvim_win_get_width(0)
  print("ivy_to_center", currwidth)
end
local ivy_to_dropdown = function()
  local currwidth = vim.api.nvim_win_get_width(0)
  print("ivy_to_dropdown", currwidth)
end

local telescopes = {
  fd_nvim = {
    prompt_prefix = "Nvim>",
    fun = "fd",
    theme = center_list,
    cwd = vim.fn.stdpath("config"),
    -- .. other options
  },
  fd = {
    prompt_prefix = "Files>",
    fun = "fd",
    theme = with_preview,
    -- .. other options
  },
}

main.run = function(str, theme)
  local base, fun, opts
  if not telescopes[str] then
    fun = str
    opts = theme or {}
    --return print("Sorry not found")
  else
    base = telescopes[str]
    fun = base.fun
    theme = base.theme
    base.theme = nil
    base.fun = nil
    opts = vim.tbl_extend("force", theme, base)
  end
  if str then
    return require("telescope.builtin")[fun](opts)
  else
    return print("You need to a set a default function")
    -- return require"telescope.builtin".find_files(opts)
  end
end

return main

-- make sure to map it:
-- nnoremap <leader>ff :lua require"main".run("fd")<cr>
-- nnoremap <leader>ff :lua require"main".run("fd_in_nvim")<cr>
--
-- then use it on whatever picker you want
-- require "telescope.builtin".current_buffer_fuzzy_find(minimalist_box())
