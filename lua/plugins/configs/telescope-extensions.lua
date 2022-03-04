local M = {}
local sorters = require "telescope.sorters"

local H = require("helpers")

M.load_extensions = function(telescope)
  if H.is_plugin_installed("aerial.nvim") then
    telescope.load_extension("aerial")
  end
  if H.is_plugin_installed("telescope-arecibo.nvim") then
    telescope.load_extension("arecibo")
  end
  if H.is_plugin_installed("telescope-asynctasks.nvim") then
    telescope.load_extension("asynctasks")
  end
  if H.is_plugin_installed("telescope-bookmarks.nvim") then
    telescope.load_extension("bookmarks")
  end
  if H.is_plugin_installed("telescope-dap.nvim") then
    telescope.load_extension("dap")
  end
  if H.is_plugin_installed("telescope-frecency.nvim") then
    telescope.load_extension("frecency")
  end
  if H.is_plugin_installed("telescope-ghq.nvim") then
    telescope.load_extension("ghq")
  end
  if H.is_plugin_installed("telescope-github.nvim") then
    telescope.load_extension("gh")
  end
  if H.is_plugin_installed("telescope-node-modules.nvim") then
    telescope.load_extension("node_modules")
  end

  if H.is_plugin_installed("telescope-media-files.nvim") then
    telescope.load_extension("media_files")
  end
  if H.is_plugin_installed("telescope-tmux.nvim") then
    telescope.load_extension("tmux")
  end
  -- if H.is_plugin_installed("telescope-ultisnips.nvim") then telescope.load_extension("ultisnips") end
  if H.is_plugin_installed("session-lens") then
    telescope.load_extension("session-lens")
  end

  if H.is_plugin_installed("nvim-notify") then
    telescope.load_extension("notify")
  end

  if H.is_plugin_installed("telescope-z.nvim") then
    telescope.load_extension("z")
  --   <CR> (edit)	builtin.find_files    <C-x> (split)	:chdir to the dir
  --   <C-v> (vsplit)	:lchdir to the dir  <C-t> (tabedit)	:tchdir to the dir
  -- cmd Set command list to execute z -l or compatibles. Default: {vim.o.shell, '-c', 'z -l'}
  -- cwd Transform result paths into relative ones with this value as base dir. Default: vim.fn.getcwd()
  -- tail_path Show only basename of the path. Default value: false
  -- shorten_path Call pathshorten() for each path. Default value: false
  end

  if H.is_plugin_installed("telescope-command-palette.nvim") then
    telescope.load_extension("command_palette")
  end

  if H.is_plugin_installed("telescope-openbrowser.nvim") then
    telescope.load_extension("openbrowser")
  end

  if H.is_plugin_installed("cheatsheet.nvim") then
    require("plugins.configs.telescope-cheatsheet")
  end
  -- if H.is_plugin_installed("telescope-lsp-handlers.nvim") then require("plugins.configs.telescope-lsp-handlers") end

  if H.is_plugin_installed("nvim-neoclip.lua") then
    require("plugins.configs.nvim-neoclip")
    telescope.load_extension("neoclip")
  end

  if H.is_plugin_installed("telescope-heading.nvim") then
    pcall(telescope.load_extension, "heading")
  end

  pcall(telescope.load_extension, "env")
  pcall(telescope.load_extension, "file_browser")
  pcall(telescope.load_extension, "fzf")
  --  FZF Syntax:
  -- Token	Match type	Description
  -- sbtrkt	fuzzy-match	Items that match sbtrkt
  -- 'wild	exact-match (quoted)	Items that include wild
  -- ^music	prefix-exact-match	Items that start with music
  -- .mp3$	suffix-exact-match	Items that end with .mp3
  -- !fire	inverse-exact-match	Items that do not include fire
  -- !^music	inverse-prefix-exact-match	Items that do not start with music
  -- !.mp3$	inverse-suffix-exact-match	Items that do not end with .mp3
  -- A single bar character term acts as an OR ope

  if H.is_plugin_installed("telescope-vimwiki.nvim") then
    pcall(telescope.load_extension, "vimwiki")
  end

  if H.is_plugin_installed("nvim-mapper") then
    require("plugins.configs.nvim_mapper")
    pcall(telescope.load_extension, "mapper")
  end

  if H.is_plugin_installed("project.nvim") then
    require("plugins.configs.project_nvim")
    pcall(telescope.load_extension, "projects")
  end

  if H.is_plugin_installed("nvim-notify") then
    telescope.load_extension("notify")
  end

  if H.is_plugin_installed("telescope-ui-select.nvim") then
    pcall(telescope.load_extension, "ui-select")
  end

  if H.is_plugin_installed("telescope-hop.nvim") then
    pcall(telescope.load_extension, "hop")
  end

  -- if H.is_plugin_installed("telescope-packer.nvim") then
  --   pcall(telescope.load_extension, 'packer')
  --   pcall(telescope.extensions.packer.plugins, {})
  -- end

  if H.is_plugin_installed("telescope-rg.nvim") then
    pcall(telescope.load_extension, "rg")
  end

  if H.is_plugin_installed("github-notifications") then
    pcall(telescope.load_extension, "ghn")
  end

  if H.is_plugin_installed("telescope-npm.nvim") then
    pcall(telescope.load_extension, "npm")
  end
end

M.telescope_configs = function()
  local extensions = {}
  -- You don't need to set any of these options.
  local fb_actions = require "telescope".extensions.file_browser.actions

  extensions.file_browser = {
    theme = "ivy"
    -- mappings = {
    --   ["i"] = { ["<C-,>"] = fb_actions.goto_parent_dir(vim.fn.nvim_get_current_buf(), true) },
    --   -- ["n"] = {}, -- your custom normal mode mappings
    -- },
  }

  -- Insert / Normal	Action
  -- <C-f>/f	Toggle between file and folder browser
  -- <C-y>/y	Copy (multi-selected) files or folders to cwd
  -- <C-d>/dd	Delete (multi-selected) files or folders
  -- <C-r>/r	Rename (multi-selected) files
  -- <C-e>/e	Add File/Folder at cwd; trailing / creates folder
  --      /m	Move multi-selected files to cwd
  -- <C-h>/h	Toggle hidden files
  -- <C-o>/o	Open file with default system application
  -- <C-g>/g	Go to parent directory
  -- <C-w>/w	Go to current working directory
  -- <A-e>/--	Toggle all entires ignoring ./ and ../

  extensions.openbrowser = {
    -- Add bookmark urls
    bookmarks = {
      ["luv docs"] = "https://github.com/luvit/luv/blob/master/docs.md"
    },
    bookmark_filepath = "~/.vim/telescope_openbrowser_bookmarks"
  }

  extensions.command_palette = {
    {
      "File",
      {"entire selection (C-a)", ':call feedkeys("GVgg")'},
      {"save current file (C-s)", ":w"},
      {"save all files (C-A-s)", ":wa"},
      {"quit (C-q)", ":qa"},
      {"file browser (C-i)", ":lua require'telescope'.extensions.file_browser.file_browser()", 1},
      {"search word (A-w)", ":lua require('telescope.builtin').live_grep()", 1},
      {"git files (A-f)", ":lua require('telescope.builtin').git_files()", 1},
      {"files (C-f)", ":lua require('telescope.builtin').find_files()", 1}
    },
    {
      "Help",
      {"tips", ":help tips"},
      {"cheatsheet", ":help index"},
      {"tutorial", ":help tutor"},
      {"summary", ":help summary"},
      {"quick reference", ":help quickref"},
      {"search help(F1)", ":lua require('telescope.builtin').help_tags()", 1}
    },
    {
      "Vim",
      {"reload vimrc", ":source $MYVIMRC"},
      {"check health", ":checkhealth"},
      {"jumps (Alt-j)", ":lua require('telescope.builtin').jumplist()"},
      {"commands", ":lua require('telescope.builtin').commands()"},
      {"command history", ":lua require('telescope.builtin').command_history()"},
      {"registers (A-e)", ":lua require('telescope.builtin').registers()"},
      {"colorshceme", ":lua require('telescope.builtin').colorscheme()", 1},
      {"vim options", ":lua require('telescope.builtin').vim_options()"},
      {"keymaps", ":lua require('telescope.builtin').keymaps()"},
      {"buffers", ":Telescope buffers"},
      {"search history (C-h)", ":lua require('telescope.builtin').search_history()"},
      {"paste mode", ":set paste!"},
      {"cursor line", ":set cursorline!"},
      {"cursor column", ":set cursorcolumn!"},
      {"spell checker", ":set spell!"},
      {"relative number", ":set relativenumber!"},
      {"search highlighting (F12)", ":set hlsearch!"}
    }
  }

  extensions.frecency = {
    -- db_safe_mode = false,
    show_scores = true,
    show_unindexed = true,
    -- Default workspace tag to filter by e.g. 'CWD' to filter by default to the current directory
    -- overridden by ':*:'
    -- default_workspace = 'CWD',

    ignore_patterns = {"*.git/*", "*/tmp/*"},
    -- specify filter like :directory_name: or  :*:'.
    -- :etc: -> workspace browser (tab autocompletes)
    workspaces = {
      ["etc"] = "/etc",
      ["bin"] = vim.fn.expand("$HOME") .. "/bin",
      ["nvim"] = vim.fn.stdpath("config"),
      ["home"] = vim.fn.expand("$HOME"),
      ["config"] = vim.fn.expand("$HOME") .. "/.config",
      ["plugins"] = vim.fn.stdpath("data") .. "/site/pack/packer/start",
      ["nvim-cache"] = vim.fn.stdpath("config"),
      ["nvim-data"] = vim.fn.stdpath("data"),
      ["prettyfile"] = vim.fn.expand("$HOME") .. "/git/prettyfile",
      ["zettel"] = vim.fn.expand("$HOME") .. "/zettelkasten",
      ["zk"] = vim.fn.expand("$HOME") .. "/zettelkasten",
      ["zinit"] = vim.fn.expand("$HOME") .. "/.zinit",
      ["zsh"] = vim.fn.expand("$HOME") .. "/.config/zsh"
    }
  }

  extensions.fzf = {
    fuzzy = true, -- false will only do exact matching
    override_generic_sorter = true, -- override the generic sorter
    override_file_sorter = true, -- override the file sorter
    case_mode = "smart_case" -- or "ignore_case" or "respect_case"
  }

  extensions.bookmarks = {
    selected_browser = "google_chrome",
    url_open_command = "xdg-open",
    url_open_plugin = nil, -- vim_external, open_browser
    firefox_profile_name = nil
  }

  extensions.media_files = {
    filetypes = {"png", "webp", "jpg", "jpeg", "webm", "pdf", "mp4", ".svg"},
    find_cmd = "fd" -- find command (defaults to `fd`)
  }

  extensions.arecibo = {
    ["selected_engine"] = "google",
    ["url_open_command"] = "xdg-open",
    ["show_http_headers"] = false,
    ["show_domain_icons"] = true
  }

  extensions.lsp_handlers = {
    disable = {},
    location = {telescope = {}, no_results_message = "No references found"},
    symbol = {telescope = {}, no_results_message = "No symbols found"},
    call_hierarchy = {telescope = {}, no_results_message = "No calls found"},
    code_action = {
      telescope = require("telescope.themes").get_dropdown({}),
      no_results_message = "No code actions available",
      prefix = ""
    }
  }

  extensions.mapper = {
    sorter = sorters.fuzzy_with_index_bias
    -- sorter = sorters.highlighter_only
  }
  return extensions
end

return M
