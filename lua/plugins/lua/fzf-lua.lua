local actions = require "fzf-lua.actions"

require"fzf-lua".setup {
  winopts = {
    win_height = 0.85, -- window height
    win_width = 0.80, -- window width
    win_row = 0.30, -- window row position (0=top, 1=bottom)
    win_col = 0.50, -- window col position (0=left, 1=right)
    -- win_border    = false,           -- window border? or borderchars?
    -- win_border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    window_on_create = function() -- nvim window options override
      vim.cmd("set winhl=Normal:Normal") -- popup bg match normal windows
    end,
  },
  -- fzf_bin             = 'sk',        -- use skim instead of fzf?
  fzf_layout = "reverse", -- fzf '--layout='
  fzf_args = "", -- adv: fzf extra args, empty unless adv
  fzf_binds = { -- fzf '--bind=' options
    "f2:toggle-preview",
    "f3:toggle-preview-wrap",
    "shift-down:preview-page-down",
    "shift-up:preview-page-up",
    "ctrl-d:half-page-down",
    "ctrl-u:half-page-up",
    "ctrl-f:page-down",
    "ctrl-b:page-up",
    "ctrl-a:toggle-all",
    "ctrl-l:clear-query",
  },
  preview_border = "border", -- border|noborder
  preview_wrap = "nowrap", -- wrap|nowrap
  preview_opts = "nohidden", -- hidden|nohidden
  preview_vertical = "down:45%", -- up|down:size
  preview_horizontal = "right:60%", -- right|left:size
  preview_layout = "flex", -- horizontal|vertical|flex
  flip_columns = 180, -- #cols to switch to horizontal on flex
  default_previewer = "bat",
  previewers = {
    cmd = {
      -- custom previewer, will execute: `<cmd> <args> <filename>`
      cmd = "echo",
      args = "",
    },
    cat = { cmd = "cat", args = "--number" },
    bat = {
      cmd = "bat",
      args = "--style=changes --color always",
      theme = "Nord-Nick", -- bat preview theme (bat --list-themes)
      config = nil, -- nil uses $BAT_CONFIG_PATH
    },
    head = { cmd = "head", args = nil },
    git_diff = { cmd = "git diff", args = "--color" },
  },
  -- provider setup
  files = {
    prompt = " Files❯ ",
    cmd = "COLORTERM=truecolor fd --hidden --follow --type f --color always",
    -- cmd = "rg --files --hidden --no-ignore-vcs --follow --no-messages --color=always",
    git_icons = true,
    file_icons = true,
    color_icons = true,
    actions = {
      ["default"] = actions.file_edit,
      ["ctrl-s"] = actions.file_split,
      ["ctrl-v"] = actions.file_vsplit,
      ["ctrl-t"] = actions.file_tabedit,
      ["ctrl-q"] = actions.file_sel_to_qf,
      ["ctrl-y"] = function(selected) print(selected[2]) end,
    },
  },
  git = {
    files = {
      prompt = " GitFiles❯ ",
      cmd = "git ls-files --exclude-standard",
      git_icons = true,
      file_icons = true,
      color_icons = true,
    },
    status = {
      prompt = " GitStatus❯ ",
      cmd = "git status -s",
      previewer = "git_diff",
      file_icons = true,
      git_icons = true,
      color_icons = true,
    },
    commits = {
      prompt = " Commits❯ ",
      cmd = "git log --pretty=oneline --abbrev-commit --color",
      preview = "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1}",
      actions = { ["default"] = nil },
    },
    bcommits = {
      prompt = " BCommits❯ ",
      cmd = "git log --pretty=oneline --abbrev-commit --color --",
      preview = "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1}",
      actions = { ["default"] = nil },
    },
    branches = {
      prompt = " Branches❯ ",
      cmd = "git branch --all --color",
      preview = "git log --graph --pretty=oneline --abbrev-commit --color {1}",
      actions = { ["default"] = actions.git_switch },
    },
    icons = {
      ["M"] = { icon = "M", color = "yellow" },
      ["D"] = { icon = "D", color = "red" },
      ["A"] = { icon = "A", color = "green" },
      ["?"] = { icon = "?", color = "magenta" },
      -- ["M"]          = { icon = "★", color = "red" },
      -- ["D"]          = { icon = "✗", color = "red" },
      -- ["A"]          = { icon = "+", color = "green" },
    },
  },
  grep = {
    prompt = " Rg❯ ",
    input_prompt = "Grep For❯ ",
    cmd = "rg --vimgrep",
    rg_opts = "--hidden --column --line-number --no-heading " ..
        "--color=always --smart-case -g '!{.git,node_modules}/*'",
    git_icons = true,
    file_icons = true,
    color_icons = true,
    actions = {
      ["default"] = actions.file_edit,
      ["ctrl-s"] = actions.file_split,
      ["ctrl-v"] = actions.file_vsplit,
      ["ctrl-t"] = actions.file_tabedit,
      ["ctrl-q"] = actions.file_sel_to_qf,
      ["ctrl-y"] = function(selected) print(selected[2]) end,
    },
  },
  oldfiles = {
    prompt = " MRU Files❯ ",
    sort_lastused = true, -- sort buffers() by last used
    cwd_only = false,
    -- TODO: only show files
    -- cmd = "COLORTERM=truecolor fd --hidden --follow --type f --color always",
  },
  -- cmd = "rg --files --hidden --no-ignore-vcs --follow --no-messages --color=always",
  buffers = {
    prompt = " Buffers❯ ",
    file_icons = true, -- show file icons?
    color_icons = true, -- colorize file|git icons
    sort_lastused = true, -- sort buffers() by last used
    actions = {
      ["default"] = actions.buf_edit,
      ["ctrl-s"] = actions.buf_split,
      ["ctrl-v"] = actions.buf_vsplit,
      ["ctrl-t"] = actions.buf_tabedit,
      ["ctrl-x"] = actions.buf_del,
    },
  },
  colorschemes = {
    prompt = " Colorschemes❯ ",
    live_preview = true, -- apply the colorscheme on preview?
    actions = { ["default"] = actions.colorscheme, ["ctrl-y"] = function(selected) print(selected[2]) end },
    winopts = {
      win_height = 0.55,
      win_width = 0.30,
      window_on_create = function() vim.cmd("set winhl=Normal:Normal") end,
    },
    post_reset_cb = function() require("feline").reset_highlights() end,
  },
  quickfix = {
    -- cwd               = vim.loop.cwd(),
    file_icons = true,
    git_icons = true,
  },
  lsp = {
    prompt = "❯ ",
    -- cwd               = vim.loop.cwd(),
    file_icons = true,
    git_icons = false,
    lsp_icons = true,
    severity = "hint",
    icons = {
      ["Error"] = { icon = "", color = "red" }, -- error
      ["Warning"] = { icon = "", color = "yellow" }, -- warning
      ["Information"] = { icon = "", color = "blue" }, -- info
      ["Hint"] = { icon = "", color = "magenta" }, -- hint
    },
  },
  -- placeholders for additional user customizations
  loclist = {},
  helptags = {},
  manpages = {},
  -- optional override of file extension icon colors
  -- available colors (terminal):
  --    clear, bold, black, red, green, yellow
  --    blue, magenta, cyan, grey, dark_grey, white
  file_icon_colors = { ["lua"] = "blue" },
}

-- Command	List
-- buffers	open buffers
-- files	find or fd on a path
-- oldfiles	opened files history
-- quickfix	quickfix list
-- loclist	location list
-- grep	search for a pattern with grep or rg
-- grep_last	run search again with the last pattern
-- grep_cword	search word under cursor
-- grep_cWORD	search WORD under cursor
-- grep_visual	search visual selection
-- grep_curbuf	live grep current buffer
-- live_grep	live grep current project
-- help_tags	help tags
-- man_pages	man pages
-- colorschemes	color schemes
-- builtin	fzf-lua builtin methods
-- git_files	git ls-files
-- git_status	git status
-- git_commits	git commit log (project)
-- git_bcommits	git commit log (buffer)
-- git_branch	git branches
-- LSP Commands
-- lsp_references	References
-- lsp_definitions	Definitions
-- lsp_declarations	Declarations
-- lsp_typedefs	Type Definitions
-- lsp_implementations	Implementations
-- lsp_document_symbols	Document Symbols
-- lsp_workspace_symbols	Workspace Symbols
-- lsp_code_actions	Code Actions
-- lsp_document_diagnostics	Document Diagnostics
-- lsp_workspace_diagnostics	Workspace Diagnostics
