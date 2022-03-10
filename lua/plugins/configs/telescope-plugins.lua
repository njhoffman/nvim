local M = {}
local sorters = require "telescope.sorters"
local tele_mappings = require("plugins.configs.telescope-mappings")
local H = require("helpers")

M.load_extensions = function(telescope)
  local tele_plugs = {
    ["aerial"] = "aerial.nvim",
    ["arecibo"] = "telescope-arecibo.nvim",
    ["asynctasks"] = "telescope-asynctasks.nvim",
    ["bookmarks"] = "telescope-bookmarks.nvim",
    ["cheatsheet"] = "cheatsheet.nvim",
    ["command_palette"] = "telescope-command-palette.nvim",
    ["dap"] = "telescope-dap.nvim",
    ["env"] = "telescope-env.nvim",
    ["file_browser"] = "telescope-file-browser.nvim",
    ["frecency"] = "telescope-frecency.nvim",
    ["fzf"] = "telescope-fzf-native.nvim",
    ["ghn"] = "github-notifications",
    ["ghq"] = "telescope-ghq.nvim",
    ["github"] = "telescope-github.nvim",
    ["heading"] = "telescope-heading.nvim",
    ["hop"] = "telescope-hop.nvim",
    ["mapper"] = "telescope-mapper.nvim",
    ["media_files"] = "telescope-media-files.nvim",
    ["neoclip"] = "nvim-neoclip.lua",
    ["node_modules"] = "telescope-node-modules.nvim",
    ["notify"] = "nvim-notify",
    ["npm"] = "telescope-npm.nvim",
    ["openbrowser"] = "telescope-openbrowser.nvim",
    ["packer"] = "telescope-packer.nvim",
    ["projects"] = "project.nvim",
    ["rg"] = "telescope-rg.nvim",
    ["session-lens"] = "session-lens",
    ["tmux"] = "telescope-tmux.nvim",
    ["ui-select"] = "telescope-ui-select.nvim",
    ["ultisnips"] = "telescope-ultisnips.nvim",
    ["vimwiki"] = "telescope-vimwiki.nvim",
    ["z"] = "telescope-z.nvim"
  }

  local installed = {}
  for ext_name, plug_name in pairs(tele_plugs) do
    if H.is_plugin_installed(plug_name) then
      local ok, err = pcall(telescope.load_extension, ext_name)
      if ok then
        -- print(ext_name .. " : " .. plug_name)
        table.insert(installed, 0, ext_name)
      else
        vim.logger:warn("Error loading telescope plugin: " .. ext_name .. " - " .. err)
      end
    else
      vim.logger:warn("Error loading telescope plugin: " .. ext_name)
    end
  end
  vim.logger:debug(
    "Loaded " .. H.table_len(installed) .. " plugins out of " .. H.table_len(tele_plugs) .. " telescope plugins"
  )
  return installed
end

require("cheatsheet").setup(
  {
    -- Whether to show bundled cheatsheets
    -- For generic cheatsheets like default, unicode, nerd-fonts, etc
    bundled_cheatsheets = true,
    -- bundled_cheatsheets = {
    --     enabled = {},
    --     disabled = {},
    -- },
    -- For plugin specific cheatsheets
    bundled_plugin_cheatsheets = true,
    -- bundled_plugin_cheatsheets = {
    --     enabled = {},
    --     disabled = {},
    -- }
    -- For bundled plugin cheatsheets, do not show a sheet if you
    -- don't have the plugin installed (searches runtimepath for
    -- same directory name)
    include_only_installed_plugins = true
  }
)

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

-- Frecency:
--   Default workspace tag to filter by e.g. 'CWD' to filter by default to the current directory
--   overridden by ':*:'
--   default_workspace = 'CWD',
--   specify filter like :directory_name: or  :*:'.
--   :etc: -> workspace browser (tab autocompletes)
extensions.frecency = {
  db_safe_mode = false,
  show_scores = true,
  show_unindexed = true,
  ignore_patterns = {"*.git/*", "*/tmp/*"},
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

M.extensions = extensions

-- local telescope_plugin = require("telescope")
-- M.load_extensions(telescope_plugin)
return M
