local actions = require("fzf-lua.actions")

require("fzf-lua").setup({
	winopts = {
		win_height = 0.85, -- window height
		win_width = 0.80, -- window width
		win_row = 0.30, -- window row position (0=top, 1=bottom)
		win_col = 0.50, -- window col position (0=left, 1=right)
		-- win_border    = false,           -- window border? or borderchars?
		-- win_border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		hl_border = "FloatBorder",
		hl_normal = "Normal",
    --   hl = {
    --     normal         = 'Normal',        -- window normal color (fg+bg)
    --     border         = 'Normal',        -- border color (try 'FloatBorder')
    --     -- Only valid with the builtin previewer:
    --     cursor         = 'Cursor',        -- cursor highlight (grep/LSP matches)
    --     cursorline     = 'CursorLine',    -- cursor line
    --     -- title       = 'Normal',        -- preview border title (file/buffer)
    --     -- scrollbar_f = 'PmenuThumb',    -- scrollbar "full" section highlight
    --     -- scrollbar_e = 'PmenuSbar',     -- scrollbar "empty" section highlight
    --   },

    preview = {
      -- default = "bat",
      border         = 'border',        -- border|noborder, applies only to
      -- native fzf previewers (bat/cat/git/etc)
      wrap           = 'nowrap',        -- wrap|nowrap
      hidden         = 'nohidden',      -- hidden|nohidden
      vertical       = 'down:45%',      -- up|down:size
      horizontal     = 'right:60%',     -- right|left:size
      layout         = 'flex',          -- horizontal|vertical|flex
      flip_columns = 180, -- #cols to switch to horizontal on flex
      winopts = {
        number            = true,
        relativenumber    = false,
        cursorline        = true,
        cursorlineopt     = 'both',
        cursorcolumn      = false,
        signcolumn        = 'no',
        list              = false,
        foldenable        = false,
        foldmethod        = 'manual',
      }
    },
  },
	-- fzf_bin             = 'sk',        -- use skim instead of fzf?
	fzf_layout = "reverse", -- fzf '--layout='
	fzf_args = "--no-hscroll", -- adv: fzf extra args, empty unless adv
	keymap = {
		-- These override the default tables completely
		-- no need to set to `false` to disable a bind
		-- delete or modify is sufficient
		builtin = {
			-- neovim `:tmap` mappings for the fzf win
			["<F2>"] = "toggle-fullscreen",
			-- Only valid with the 'builtin' previewer
			["<F3>"] = "toggle-preview-wrap",
			["<F4>"] = "toggle-preview",
			["<S-down>"] = "preview-page-down",
			["<S-up>"] = "preview-page-up",
			["<S-left>"] = "preview-page-reset",
		},
		fzf = {

			-- fzf_binds = { -- fzf '--bind=' options
			-- "esc:abort",
			-- "f2:toggle-preview",
			-- "f3:toggle-preview-wrap",
			-- "ctrl-e:end-of-line",
			-- "shift-down:preview-page-down",
			-- "shift-up:preview-page-up",
			-- },
			-- fzf '--bind=' options
			["esc"] = "abort",
			["ctrl-u"] = "unix-line-discard",
			["ctrl-f"] = "half-page-down",
			["ctrl-b"] = "half-page-up",
			["ctrl-a"] = "beginning-of-line",
			["ctrl-e"] = "end-of-line",
			["alt-a"] = "toggle-all",
			-- Only valid with fzf previewers (bat/cat/git/etc)
			["f3"] = "toggle-preview-wrap",
			["f4"] = "toggle-preview",
			["shift-down"] = "preview-page-down",
			["shift-up"] = "preview-page-up",
		},
	},
	-- fzf_bin          = 'sk',
	fzf_opts = {
		-- options are sent as `<left>=<right>`
		-- set to `false` to remove a flag
		-- set to '' for a non-value flag
		-- for raw args use `fzf_args` instead
		["--ansi"] = "",
		-- ['--prompt']      = '> ',
		["--info"] = "inline",
		["--height"] = "100%",
		["--layout"] = "reverse",
	},
  previewers = {
    cmd = {
      -- custom previewer, will execute: `<cmd> <args> <filename>`
      cmd = "echo",
      args = "",
    },
    bat = {
      cmd = "bat",
      args = "--style=changes --color always",
      theme = "Nord-Nick", -- bat preview theme (bat --list-themes)
      config = nil, -- nil uses $BAT_CONFIG_PATH
    },
    head = { cmd = "head", args = nil },
    git_diff = {
      cmd  = "git diff",
      args = "--color=always",
      pager = "delta",      -- if you have `delta` installed
    },
    man = {
      cmd             = "man -c %s | col -bx",
    },
    builtin = {
      syntax          = true,         -- preview syntax highlight?
      syntax_limit_l  = 0,            -- syntax limit (lines), 0=nolimit
      syntax_limit_b  = 1024*1024,    -- syntax limit (bytes), 0=nolimit
    },
  },
	-- provider setup
	files = {
		prompt = " Files❯ ",
		cmd = "COLORTERM=truecolor fd --hidden --follow --type f --color never",
		-- cmd = "COLORTERM=truecolor fd --hidden --follow --type f --color always",
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
			["ctrl-y"] = function(selected)
				print(selected[2])
			end,
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
			actions = {
        ["default"] = actions.git_buf_edit,
      }
		},
		bcommits = {
			prompt = " BCommits❯ ",
			cmd = "git log --pretty=oneline --abbrev-commit --color --",
			preview = "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1}",
			actions = {
        ["default"] = actions.git_buf_edit,
        ["ctrl-s"]  = actions.git_buf_split,
        ["ctrl-v"]  = actions.git_buf_vsplit,
     },
      -- git_blame
      -- Defaul value is expand('<sfile>:h:h') . '/bin/git_blame_pr'

      -- git_status
      -- Default value is 'git -c color.status=always status --short --untracked-files=all'

      -- git_status_preview
      -- Default value is  "[[ $(git diff --cached -- {-1}) != \"\" ]] && git diff --cached --color=always -- {-1} || " .
      -- \ "[[ $(git diff -- {-1}) != \"\" ]] && git diff --color=always -- {-1} || " .
      -- \ g:fzf_preview_command
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
		rg_opts = "--hidden --column --line-number --no-heading "
			.. "--color=always --smart-case -g '!{.git,node_modules}/*'",
		git_icons = true,
		file_icons = true,
		color_icons = true,
		actions = {
			["default"] = actions.file_edit,
			["ctrl-s"] = actions.file_split,
			["ctrl-v"] = actions.file_vsplit,
			["ctrl-t"] = actions.file_tabedit,
			["ctrl-q"] = actions.file_sel_to_qf,
			["ctrl-y"] = function(selected)
				print(selected[2])
			end,
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
		actions = {
			["default"] = actions.colorscheme,
			["ctrl-y"] = function(selected)
				print(selected[2])
			end,
		},
		winopts = { win_height = 0.55, win_width = 0.30 },
		post_reset_cb = function()
			require("feline").reset_highlights()
		end,
	},
	quickfix = {
		-- cwd               = vim.loop.cwd(),
		file_icons = true,
		git_icons = true,
	},
	lsp = {
		-- make lsp requests synchronous so they work with null-ls
		async_or_timeout = 3000,
		prompt = " ❯ ",
		-- cwd               = vim.loop.cwd(),
		file_icons = true,
		git_icons = true,
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
})

_G._FindFilesFzfIvy = function()
	require("fzf-lua").files({
		winopts = { split = "belowright new" },
		preview_layout = "horizontal",
	})
end

_G._FindOldFilesFzfIvy = function()
	require("fzf-lua").oldfiles({
		winopts = { split = "belowright new" },
		preview_layout = "horizontal",
	})
end

_G._FindManPagesFzfIvy = function()
	require("fzf-lua").man_pages({
		winopts = { split = "belowright new" },
		preview_layout = "horizontal",
	})
end

_G._FindHelpTagsFzfIvy = function()
	require("fzf-lua").help_tags({
		winopts = { split = "belowright new" },
		preview_layout = "horizontal",
	})
end

_G._GitCommitsFzfIvy = function()
	require("fzf-lua").git_commits({
		winopts = { split = "belowright new" },
		preview_layout = "horizontal",
	})
end

_G._GitBCommitsFzfIvy = function()
	require("fzf-lua").git_bcommits({
		winopts = { split = "belowright new" },
		preview_layout = "horizontal",
	})
end

_G._LspDiagDocumentFzfIvy = function()
	require("fzf-lua").lsp_document_diagnostics({
		winopts = { split = "belowright new" },
		preview_layout = "horizontal",
	})
end

_G._LspDiagWorkspaceFzfIvy = function()
	require("fzf-lua").lsp_workspace_diagnostics({
		winopts = { split = "belowright new" },
		preview_layout = "horizontal",
	})
end

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

-- require'fzf-lua'.setup {
-- winopts = {
--   -- split         = "belowright new",-- open in a split instead?
--                                       -- "belowright new"  : split below
--                                       -- "aboveleft new"   : split above
--                                       -- "belowright vnew" : split right
--                                       -- "aboveleft vnew   : split left
--   -- Only valid when using a float window
--   -- (i.e. when 'split' is not defined)
--   height           = 0.85,            -- window height
--   width            = 0.80,            -- window width
--   row              = 0.35,            -- window row position (0=top, 1=bottom)
--   col              = 0.50,            -- window col position (0=left, 1=right)
--   -- border argument passthrough to nvim_open_win(), also used
--   -- to manually draw the border characters around the preview
--   -- window, can be set to 'false' to remove all borders or to
--   -- 'none', 'single', 'double' or 'rounded' (default)
--   border           = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
--   fullscreen       = false,           -- start fullscreen?
--   hl = {
--     normal         = 'Normal',        -- window normal color (fg+bg)
--     border         = 'Normal',        -- border color (try 'FloatBorder')
--     -- Only valid with the builtin previewer:
--     cursor         = 'Cursor',        -- cursor highlight (grep/LSP matches)
--     cursorline     = 'CursorLine',    -- cursor line
--     -- title       = 'Normal',        -- preview border title (file/buffer)
--     -- scrollbar_f = 'PmenuThumb',    -- scrollbar "full" section highlight
--     -- scrollbar_e = 'PmenuSbar',     -- scrollbar "empty" section highlight
--   },
--   preview = {
--     -- default     = 'bat',           -- override the default previewer?
--                                       -- default uses the 'builtin' previewer
--     border         = 'border',        -- border|noborder, applies only to
--                                       -- native fzf previewers (bat/cat/git/etc)
--     wrap           = 'nowrap',        -- wrap|nowrap
--     hidden         = 'nohidden',      -- hidden|nohidden
--     vertical       = 'down:45%',      -- up|down:size
--     horizontal     = 'right:60%',     -- right|left:size
--     layout         = 'flex',          -- horizontal|vertical|flex
--     flip_columns   = 120,             -- #cols to switch to horizontal on flex
--     -- Only valid with the builtin previewer:
--     title          = true,            -- preview border title (file/buf)?
--     scrollbar      = 'float',         -- `false` or string:'float|border'
--                                       -- float:  in-window floating border
--                                       -- border: in-border chars (see below)
--     scrolloff      = '-2',            -- float scrollbar offset from right
--                                       -- applies only when scrollbar = 'float'
--     scrollchars    = {'█', '' },      -- scrollbar chars ({ <full>, <empty> }
--                                       -- applies only when scrollbar = 'border'
--     delay          = 100,             -- delay(ms) displaying the preview
--                                       -- prevents lag on fast scrolling
--     winopts = {                       -- builtin previewer window options
--       number            = true,
--       relativenumber    = false,
--       cursorline        = true,
--       cursorlineopt     = 'both',
--       cursorcolumn      = false,
--       signcolumn        = 'no',
--       list              = false,
--       foldenable        = false,
--       foldmethod        = 'manual',
--     },
--   },
--   on_create = function()
--     -- called once upon creation of the fzf main window
--     -- can be used to add custom fzf-lua mappings, e.g:
--     --   vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", "<Down>",
--     --     { silent = true, noremap = true })
--   end,
-- },
-- keymap = {
--   -- These override the default tables completely
--   -- no need to set to `false` to disable a bind
--   -- delete or modify is sufficient
--   builtin = {
--     -- neovim `:tmap` mappings for the fzf win
--     ["<F2>"]        = "toggle-fullscreen",
--     -- Only valid with the 'builtin' previewer
--     ["<F3>"]        = "toggle-preview-wrap",
--     ["<F4>"]        = "toggle-preview",
--     -- Rotate preview clockwise/counter-clockwise
--     ["<F5>"]        = "toggle-preview-ccw",
--     ["<F6>"]        = "toggle-preview-cw",
--     ["<S-down>"]    = "preview-page-down",
--     ["<S-up>"]      = "preview-page-up",
--     ["<S-left>"]    = "preview-page-reset",
--   },
--   fzf = {
--     -- fzf '--bind=' options
--     ["ctrl-z"]      = "abort",
--     ["ctrl-u"]      = "unix-line-discard",
--     ["ctrl-f"]      = "half-page-down",
--     ["ctrl-b"]      = "half-page-up",
--     ["ctrl-a"]      = "beginning-of-line",
--     ["ctrl-e"]      = "end-of-line",
--     ["alt-a"]       = "toggle-all",
--     -- Only valid with fzf previewers (bat/cat/git/etc)
--     ["f3"]          = "toggle-preview-wrap",
--     ["f4"]          = "toggle-preview",
--     ["shift-down"]  = "preview-page-down",
--     ["shift-up"]    = "preview-page-up",
--   },
-- },
-- -- use skim instead of fzf?
-- -- https://github.com/lotabout/skim
-- -- fzf_bin          = 'sk',
-- fzf_opts = {
--   -- options are sent as `<left>=<right>`
--   -- set to `false` to remove a flag
--   -- set to '' for a non-value flag
--   -- for raw args use `fzf_args` instead
--   ['--ansi']        = '',
--   ['--prompt']      = '> ',
--   ['--info']        = 'inline',
--   ['--height']      = '100%',
--   ['--layout']      = 'reverse',
-- },
-- -- fzf '--color=' options (optional)
-- --[[ fzf_colors = {
--     ["fg"] = { "fg", "CursorLine" },
--     ["bg"] = { "bg", "Normal" },
--     ["hl"] = { "fg", "Comment" },
--     ["fg+"] = { "fg", "Normal" },
--     ["bg+"] = { "bg", "CursorLine" },
--     ["hl+"] = { "fg", "Statement" },
--     ["info"] = { "fg", "PreProc" },
--     ["prompt"] = { "fg", "Conditional" },
--     ["pointer"] = { "fg", "Exception" },
--     ["marker"] = { "fg", "Keyword" },
--     ["spinner"] = { "fg", "Label" },
--     ["header"] = { "fg", "Comment" },
--     ["gutter"] = { "bg", "Normal" },
-- }, ]]
-- previewers = {
--   cat = {
--     cmd             = "cat",
--     args            = "--number",
--   },
--   bat = {
--     cmd             = "bat",
--     args            = "--style=numbers,changes --color always",
--     theme           = 'Coldark-Dark', -- bat preview theme (bat --list-themes)
--     config          = nil,            -- nil uses $BAT_CONFIG_PATH
--   },
--   head = {
--     cmd             = "head",
--     args            = nil,
--   },
--   git_diff = {
--     cmd             = "git diff",
--     args            = "--color",
--     -- pager        = "delta",      -- if you have `delta` installed
--   },
--   man = {
--     cmd             = "man -c %s | col -bx",
--   },
--   builtin = {
--     syntax          = true,         -- preview syntax highlight?
--     syntax_limit_l  = 0,            -- syntax limit (lines), 0=nolimit
--     syntax_limit_b  = 1024*1024,    -- syntax limit (bytes), 0=nolimit
--   },
-- },
-- -- provider setup
-- files = {
--   -- previewer      = "cat",          -- uncomment to override previewer
--   prompt            = 'Files❯ ',
--   git_icons         = true,           -- show git icons?
--   file_icons        = true,           -- show file icons?
--   color_icons       = true,           -- colorize file|git icons
--   -- executed command priority is 'cmd' (if exists)
--   -- otherwise auto-detect prioritizes `fd` over `find`
--   -- default options are controlled by 'fd|find_opts'
--   -- NOTE: 'find -printf' requires GNU find
--   -- cmd            = "find . -type f -printf '%P\n'",
--   find_opts         = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
--   fd_opts           = [[--color never --type f --hidden --follow ]] ..
--           [[--exclude .git --exclude node_modules --exclude '*.pyc']],
--   actions = {
--     -- set bind to 'false' to disable an action
--     -- default action opens a single selection
--     -- or sends multiple selection to quickfix
--     -- replace the default aciton with the below
--     -- to open all files whether single or multiple
--     -- ["default"]     = actions.file_edit,
--     ["default"]       = actions.file_edit_or_qf,
--     ["ctrl-s"]      = actions.file_split,
--     ["ctrl-v"]      = actions.file_vsplit,
--     ["ctrl-t"]      = actions.file_tabedit,
--     ["alt-q"]       = actions.file_sel_to_qf,
--     -- custom actions are available too
--     ["ctrl-y"]      = function(selected) print(selected[1]) end,
--   }
-- },
-- git = {
--   files = {
--     prompt          = 'GitFiles❯ ',
--     cmd             = 'git ls-files --exclude-standard',
--     git_icons       = true,           -- show git icons?
--     file_icons      = true,           -- show file icons?
--     color_icons     = true,           -- colorize file|git icons
--   },
--   status = {
--     prompt        = 'GitStatus❯ ',
--     cmd           = "git status -s",
--     previewer     = "git_diff",
--     file_icons    = true,
--     git_icons     = true,
--     color_icons   = true,
--   },
--   commits = {
--     prompt          = 'Commits❯ ',
--     cmd             = "git log --pretty=oneline --abbrev-commit --color",
--     preview         = "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1}",
--     actions = {
--       ["default"] = actions.git_checkout,
--     },
--   },
--   bcommits = {
--     prompt          = 'BCommits❯ ',
--     cmd             = "git log --pretty=oneline --abbrev-commit --color",
--     preview         = "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1}",
--     actions = {
--       ["default"] = actions.git_buf_edit,
--       ["ctrl-s"]  = actions.git_buf_split,
--       ["ctrl-v"]  = actions.git_buf_vsplit,
--       ["ctrl-t"]  = actions.git_buf_tabedit,
--     },
--   },
--   branches = {
--     prompt          = 'Branches❯ ',
--     cmd             = "git branch --all --color",
--     preview         = "git log --graph --pretty=oneline --abbrev-commit --color {1}",
--     actions = {
--       ["default"] = actions.git_switch,
--     },
--   },
--   icons = {
--     ["M"]           = { icon = "M", color = "yellow" },
--     ["D"]           = { icon = "D", color = "red" },
--     ["A"]           = { icon = "A", color = "green" },
--     ["?"]           = { icon = "?", color = "magenta" },
--     -- ["M"]          = { icon = "★", color = "red" },
--     -- ["D"]          = { icon = "✗", color = "red" },
--     -- ["A"]          = { icon = "+", color = "green" },
--   },
-- },
-- grep = {
--   prompt            = 'Rg❯ ',
--   input_prompt      = 'Grep For❯ ',
--   git_icons         = true,           -- show git icons?
--   file_icons        = true,           -- show file icons?
--   color_icons       = true,           -- colorize file|git icons
--   -- executed command priority is 'cmd' (if exists)
--   -- otherwise auto-detect prioritizes `rg` over `grep`
--   -- default options are controlled by 'rg|grep_opts'
--   -- cmd            = "rg --vimgrep",
--   rg_opts           = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
--   grep_opts         = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp",
--   -- 'true' enables file and git icons in 'live_grep'
--   -- degrades performance in large datasets, YMMV
--   experimental      = false,
--   -- live_grep_glob options
--   glob_flag         = "--iglob",  -- for case sensitive globs use '--glob'
--   glob_separator    = "%s%-%-"    -- query separator pattern (lua): ' --'
-- },
-- args = {
--   prompt            = 'Args❯ ',
--   files_only        = true,
--   actions = {
--     -- added on top of regular file actions
--     ["ctrl-x"]      = actions.arg_del,
--   }
-- },
-- oldfiles = {
--   prompt            = 'History❯ ',
--   cwd_only          = false,
-- },
-- buffers = {
--   -- previewer      = false,        -- disable the builtin previewer?
--   prompt            = 'Buffers❯ ',
--   file_icons        = true,         -- show file icons?
--   color_icons       = true,         -- colorize file|git icons
--   sort_lastused     = true,         -- sort buffers() by last used
--   actions = {
--     ["default"]     = actions.buf_edit,
--     ["ctrl-s"]      = actions.buf_split,
--     ["ctrl-v"]      = actions.buf_vsplit,
--     ["ctrl-t"]      = actions.buf_tabedit,
--     ["ctrl-x"]      = actions.buf_del,
--   }
-- },
-- lines = {
--   previewer         = "builtin",    -- set to 'false' to disable
--   prompt            = 'Lines❯ ',
--   show_unlisted     = false,        -- exclude 'help' buffers
--   no_term_buffers   = true,         -- exclude 'term' buffers
--   fzf_opts = {
--     -- do not include bufnr in fuzzy matching
--     -- tiebreak by line no.
--     ['--delimiter'] = vim.fn.shellescape(']'),
--     ["--nth"]       = '2..',
--     ["--tiebreak"]  = 'index',
--   },
--   actions = {
--     ["default"]     = actions.buf_edit,
--     ["ctrl-s"]      = actions.buf_split,
--     ["ctrl-v"]      = actions.buf_vsplit,
--     ["ctrl-t"]      = actions.buf_tabedit,
--   }
-- },
-- blines = {
--   previewer         = "builtin",    -- set to 'false' to disable
--   prompt            = 'BLines❯ ',
--   show_unlisted     = true,         -- include 'help' buffers
--   no_term_buffers   = false,        -- include 'term' buffers
--   fzf_opts = {
--     -- hide filename, tiebreak by line no.
--     ['--delimiter'] = vim.fn.shellescape('[:]'),
--     ["--with-nth"]  = '2..',
--     ["--tiebreak"]  = 'index',
--   },
--   actions = {
--     ["default"]     = actions.buf_edit,
--     ["ctrl-s"]      = actions.buf_split,
--     ["ctrl-v"]      = actions.buf_vsplit,
--     ["ctrl-t"]      = actions.buf_tabedit,
--   }
-- },
-- colorschemes = {
--   prompt            = 'Colorschemes❯ ',
--   live_preview      = true,       -- apply the colorscheme on preview?
--   actions = {
--     ["default"]     = actions.colorscheme,
--     ["ctrl-y"]      = function(selected) print(selected[1]) end,
--   },
--   winopts = {
--     height          = 0.55,
--     width           = 0.30,
--   },
--   post_reset_cb     = function()
--     -- reset statusline highlights after
--     -- a live_preview of the colorscheme
--     -- require('feline').reset_highlights()
--   end,
-- },
-- quickfix = {
--   -- cwd               = vim.loop.cwd(),
--   file_icons        = true,
--   git_icons         = true,
-- },
-- lsp = {
--   prompt            = '❯ ',
--   -- cwd               = vim.loop.cwd(),
--   cwd_only          = false,      -- LSP/diagnostics for cwd only?
--   async_or_timeout  = true,       -- timeout(ms) or false for blocking calls
--   file_icons        = true,
--   git_icons         = false,
--   lsp_icons         = true,
--   severity          = "hint",
--   icons = {
--     ["Error"]       = { icon = "", color = "red" },       -- error
--     ["Warning"]     = { icon = "", color = "yellow" },    -- warning
--     ["Information"] = { icon = "", color = "blue" },      -- info
--     ["Hint"]        = { icon = "", color = "magenta" },   -- hint
--   },
-- },
-- -- uncomment to disable the previewer
-- -- nvim = { marks    = { previewer = { _ctor = false } } },
-- -- helptags = { previewer = { _ctor = false } },
-- -- manpages = { previewer = { _ctor = false } },
-- -- uncomment to set dummy win location (help|man bar)
-- -- "topleft"  : up
-- -- "botright" : down
-- -- helptags = { previewer = { split = "topleft" } },
-- -- uncomment to use `man` command as native fzf previewer
-- -- manpages = { previewer = { _ctor = require'fzf-lua.previewer'.fzf.man_pages } },
-- -- optional override of file extension icon colors
-- -- available colors (terminal):
-- --    clear, bold, black, red, green, yellow
-- --    blue, magenta, cyan, grey, dark_grey, white
-- -- padding can help kitty term users with
-- -- double-width icon rendering
-- file_icon_padding = '',
-- file_icon_colors = {
--   ["lua"]   = "blue",
-- },
-- }
