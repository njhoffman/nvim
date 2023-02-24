local sorters = require("telescope.sorters")
local tele_mappings = require("plugs.config.telescope-mappings")
local H = require("helpers")
local actions = require("telescope.actions")

local tele_plugs = {
  ["arecibo"] = "telescope-arecibo.nvim",
  ["devhints"] = "devhints.nvim",
  ["env"] = "telescope-env.nvim",
  ["fences"] = "telescope-fences.nvim",
  ["filetypes"] = "telescope-filetypes.nvim",
  ["find_pickers"] = "telescope-find-pickers.nvim",
  ["gotofile"] = "telescope-gotofiles.nvim",
  ["mapper"] = "telescope-mapper.nvim",
  ["notify"] = "telescope-notify.nvim",
  ["options"] = "telescope-options.nvim",
  ["variables"] = "telescope-variables.nvim",
  ["which-key"] = "which-key.nvim",
  --
  ["aerial"] = "aerial.nvim",
  ["asynctasks"] = "telescope-asynctasks.nvim",
  ["bookmarks"] = "telescope-bookmarks.nvim",
  ["changes"] = "telescope-changes.nvim",
  ["cheatsheet"] = "cheatsheet.nvim",
  ["cder"] = "cder.nvim",
  ["command_palette"] = "telescope-command-palette.nvim",
  ["color_names"] = "telescope-color-names.nvim",
  ["docker"] = "telescope-docker.nvim",
  -- ["dap"] = "telescope-dap.nvim",
  ["file_browser"] = "telescope-file-browser.nvim",
  ["frecency"] = "telescope-frecency.nvim",
  ["fzf"] = "telescope-fzf-native.nvim",
  ["gh"] = "telescope-github.nvim",
  ["ghn"] = "github-notifications",
  ["ghq"] = "telescope-ghq.nvim",
  ["heading"] = "telescope-heading.nvim",
  ["hop"] = "telescope-hop.nvim",
  ["howdoi"] = "howdoi.nvim",
  ["lazy"] = "telescope-lazy.nvim",
  ["lazygit"] = "lazygit.nvim",
  ["live_grep_args"] = "telescope-rg.nvim",
  ["luasnip"] = "telescope-luasnip.nvim",
  -- ["make"]            = "telescope-makefile",
  ["media_files"] = "telescope-media-files.nvim",
  ["menufacture"] = "telescope-menufacture.nvim",
  ["neoclip"] = "nvim-neoclip.lua",
  ["node_modules"] = "telescope-node-modules.nvim",
  ["npm"] = "telescope-npm.nvim",
  ["openbrowser"] = "telescope-openbrowser.nvim",
  ["ports"] = "telescope-ports.nvim",
  ["projects"] = "project.nvim",
  ["repo"] = "telescope-repo.nvim",
  -- ["session-lens"] = "session-lens",
  ["smart_open"] = "smart-open.nvim",
  ["terraform"] = "telescope-terraform.nvim",
  ["tmux"] = "telescope-tmux.nvim",
  ["undo"] = "telescope-undo.nvim",
  ["ui-select"] = "telescope-ui-select.nvim",
  ["vimwiki"] = "telescope-vimwiki.nvim",
  ["z"] = "telescope-z.nvim",
}

require("dir-telescope").setup({
  hidden = true,
  respect_gitignore = true,
})

vim.keymap.set("n", "<leader>gfd", "<cmd>GrepInDirectory<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gpd", "<cmd>FileInDirectory<CR>", { noremap = true, silent = true })

local M = {}
M.extensions = {}
M.load_extensions = function(telescope)
  local installed = {}
  for ext_name, plug_name in pairs(tele_plugs) do
    -- TODO: if pcall(require, plug_name)
    local ok, err = pcall(telescope.load_extension, ext_name)
    if ok then
      table.insert(installed, 0, ext_name)
    else
      local err_str = vim.split(err, "\n")
      local err_msg = "Error loading telescope plugin: " .. ext_name .. " - " .. err_str[1]
      vim.notify(err_msg, "warn")
    end
  end

  local end_msg = "Loaded " .. H.table_len(installed) .. " out of " .. H.table_len(tele_plugs) .. " telescope plugins"
  vim.notify(end_msg, "trace")
  return telescope
end

-- add menu to menufecture
-- vim.keymap.set(
--   'n',
--   '<leader>sf',
--   require('telescope').extensions.menufacture.add_menu_with_default_mapping(
--     require('telescope.builtin').find_files,
--     vim.tbl_extend('force', require('telescope').extensions.menufacture.find_files_menu, {
--       ['change cwd to parent'] = function(opts, callback)
--         local cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
--         opts.cwd = vim.fn.fnamemodify(cwd, ':p:h:h')
--         callback(opts)
--       end,
--     })
--   )
-- )
M.extensions.menufacture = {
  mappings = {
    main_menu = { [{ "i", "n" }] = "<M-Bslash>" },
  },
}

M.extensions.undo = {
  use_delta = true,
  side_by_side = true,
  layout_strategy = "vertical",
  layout_config = {
    preview_height = 0.8,
  },
  diff_context_lines = vim.o.scrolloff,
  entry_format = "state #$ID, $STAT, $TIME",
  mappings = {
    i = {
      -- IMPORTANT: Note that telescope-undo must be available when telescope is configured if
      -- you want to replicate these defaults and use the following actions. This means
      -- installing as a dependency of telescope in it's `requirements` and loading this
      -- extension from there instead of having the separate plugin definition as outlined
      -- above.
      ["<cr>"] = require("telescope-undo.actions").yank_additions,
      ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
      ["<C-cr>"] = require("telescope-undo.actions").restore,
    },
  },
}

M.extensions.lazy = {
  -- Optional theme (the extension doesn't set a default theme)
  theme = "ivy",
  -- Whether or not to show the icon in the first column
  show_icon = true,
  -- Mappings for the actions
  mappings = {
    open_in_browser = "<M-g>",
    open_in_file_browser = "<C-o>",
    open_in_find_files = "<M-f>",
    open_in_live_grep = "<M-e>",
    open_plugins_picker = "<M-b>", -- Works only after having called first another action
    open_lazy_root_find_files = "<C-r>f",
    open_lazy_root_live_grep = "<C-r>g",
  },
  -- Other telescope configuration options
}
M.extensions.file_browser = {
  theme = "ivy",
  mappings = tele_mappings.file_picker,
}

M.extensions.openbrowser = {
  -- Add bookmark urls
  bookmarks = {
    ["luv docs"] = "https://github.com/luvit/luv/blob/master/docs.md",
  },
  bookmark_filepath = "~/.vim/telescope_openbrowser_bookmarks",
}

M.extensions.howdoi = vim.tbl_deep_extend("force", {
  -- How many answers to return in the response.
  num_answers = 3,
  -- The binary to execute the howdoi command with.
  command_executor = { "bash", "-c" },
  -- The command to pipe the results into for paging.
  pager_command = "less -RS",
  -- Mapping	Action
  -- Ctrl + d	Scroll the results down
  -- Ctrl + u	Scroll the results up
  -- Ctrl + y	Yank the results to the clipboard
  -- Ctrl + p	Pastes the results into the current buffer
  -- Ctrl + v	Pastes the results into a new vertical split
  -- Ctrl + x	Pastes the results into a new horizontal split
  -- Ctrl + r	Removes the selected query from the list
}, require("telescope.themes").get_dropdown())

M.extensions.cder = {
  -- Ctrl + d	Scroll the preview down
  -- Ctrl + u	Scroll the preview up
  -- The title of the prompt.
  prompt_title = "cder",

  -- The command used to generate a list of directories.
  -- Defaults to fd on the home directory.
  -- Example for showing hidden directories:
  --   dir_command = { 'fd', '--hidden', '--type=d', '.', os.getenv('HOME') },
  dir_command = { "fd", "--type=d", ".", os.getenv("HOME") },

  -- The binary used to execute previewer_command | pager_command.
  -- This is needed because termopen in Neovim does not support piping
  -- multiple commands, so we get around this by just using bash -c.
  command_executer = { "bash", "-c" },

  -- The command used to preview directories. Defaults to ls.
  previewer_command = "exa "
    .. "-a "
    .. "--color=always "
    .. "-T "
    .. "--level=3 "
    .. "--icons "
    .. "--git-ignore "
    .. "--long "
    .. "--no-permissions "
    .. "--no-user "
    .. "--no-filesize "
    .. "--git "
    .. "--ignore-glob=.git",

  -- The command used to page directory previews. Defaults to bat.
  -- Receives the output of the previewer_command as input.
  -- Example without bat:
  --   pager_command = 'less -RS'
  pager_command = 'bat --plain --paging=always --pager="less -RS"',

  -- Function to create an entry in the picker given
  -- a line outputted from the dir_command.
  --   value is used as the directory in the :cd command
  --   display is what is actually displayed, so this can
  --     be a function that trims a path prefix for example.
  entry_maker = function(line)
    return {
      value = line,
      display = function(entry)
        return " " .. line:gsub(os.getenv("HOME") .. "/", ""), {
          { { 1, 3 }, "Directory" },
        }
      end,
      ordinal = line,
    }
  end,
}

M.extensions["ui-select"] = {
  require("telescope.themes").get_dropdown({
    -- even more opts
  }),
  -- pseudo code / specification for writing custom displays, like the one
  -- for "codeactions"
  -- specific_opts = {
  --   [kind] = {
  --     make_indexed = function(items) -> indexed_items, width,
  --     make_displayer = function(widths) -> displayer
  --     make_display = function(displayer) -> function(e)
  --     make_ordinal = function(e) -> string
  --   },
  --   codeactions = false,
  -- }
}

M.extensions.command_palette = {
  {
    "File",
    { "entire selection (C-a)", ':call feedkeys("GVgg")' },
    { "save current file (C-s)", ":w" },
    { "save all files (C-A-s)", ":wa" },
    { "quit (C-q)", ":qa" },
    { "file browser (C-i)", ":lua require'telescope'.extensions.file_browser.file_browser()", 1 },
    { "search word (A-w)", ":lua require('telescope.builtin').live_grep()", 1 },
    { "git files (A-f)", ":lua require('telescope.builtin').git_files()", 1 },
    { "files (C-f)", ":lua require('telescope.builtin').find_files()", 1 },
  },
  {
    "Help",
    { "tips", ":help tips" },
    { "cheatsheet", ":help index" },
    { "tutorial", ":help tutor" },
    { "summary", ":help summary" },
    { "quick reference", ":help quickref" },
    { "search help(F1)", ":lua require('telescope.builtin').help_tags()", 1 },
  },
  {
    "Vim",
    { "reload vimrc", ":source $MYVIMRC" },
    { "check health", ":checkhealth" },
    { "jumps (Alt-j)", ":lua require('telescope.builtin').jumplist()" },
    { "commands", ":lua require('telescope.builtin').commands()" },
    { "command history", ":lua require('telescope.builtin').command_history()" },
    { "registers (A-e)", ":lua require('telescope.builtin').registers()" },
    { "colorshceme", ":lua require('telescope.builtin').colorscheme()", 1 },
    { "vim options", ":lua require('telescope.builtin').vim_options()" },
    { "keymaps", ":lua require('telescope.builtin').keymaps()" },
    { "buffers", ":Telescope buffers" },
    { "search history (C-h)", ":lua require('telescope.builtin').search_history()" },
    { "paste mode", ":set paste!" },
    { "cursor line", ":set cursorline!" },
    { "cursor column", ":set cursorcolumn!" },
    { "spell checker", ":set spell!" },
    { "relative number", ":set relativenumber!" },
    { "search highlighting (F12)", ":set hlsearch!" },
  },
}

-- Frecency:
--   Default workspace tag to filter by e.g. 'CWD' to filter by default to the current directory
--   overridden by ':*:'
--   specify filter like :directory_name: or  :*:'.
--   :etc: -> workspace browser (tab autocompletes)
local baseDirs = {
  home = vim.fn.expand("$HOME"),
  config = vim.fn.stdpath("config"),
  data = vim.fn.stdpath("data"),
}

M.extensions.frecency = {
  -- default_workspace = "$HOME/.config",
  db_safe_mode = false,
  auto_validate = true,
  show_scores = true,
  show_unindexed = true,
  ignore_patterns = { "*.git/*", "/mnt/*", "*/tmp/*" },
  mappings = tele_mappings.file_picker,
  workspaces = {
    ["etc"] = "/etc",
    ["bin"] = baseDirs.home .. "/bin",
    ["home"] = baseDirs.home,
    ["config"] = baseDirs.home .. "/.config",
    ["nvim-config"] = baseDirs.config,
    ["nvim-data"] = baseDirs.data,
    ["nvim-plugs"] = baseDirs.home .. "/.local/share/nvim/site/pack/packer/start",
    ["zettel"] = baseDirs.home .. "/zettelkasten",
    ["zinit"] = baseDirs.home .. "/.zinit",
    ["zsh"] = baseDirs.home .. "/.config/zsh",
  },
}

M.extensions.fzf = {
  fuzzy = true, -- false will only do exact matching
  override_generic_sorter = true, -- override the generic sorter
  override_file_sorter = true, -- override the file sorter
  case_mode = "smart_case", -- or "ignore_case" or "respect_case"
}

M.extensions.bookmarks = {
  selected_browser = "chrome",
  url_open_command = "xdg-open",
  url_open_plugin = nil, -- vim_external, open_browser
  firefox_profile_name = nil,
}

M.extensions.live_grep_args = {
  auto_quoting = true, -- enable/disable auto-quoting,
  mappings = {
    -- ... Your other configuration ...
    --[[ ['<C-Space>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
    ["<c-f>"] = function(prompt_bufnr)
      actions_set.shift_selection(prompt_bufnr, 10)
    end,
    ["<c-b>"] = function(prompt_bufnr)
      actions_set.shift_selection(prompt_bufnr, -10)
    end, ]]
    ["<c-u>"] = false,
    ["<a-n>"] = actions.toggle_selection + actions.move_selection_next,
    ["<a-p>"] = actions.toggle_selection + actions.move_selection_previous,
    ["<cr>"] = actions.select_default + actions.center,
  },
}

M.extensions.media_files = {
  filetypes = { "png", "webp", "jpg", "jpeg", "webm", "pdf", "mp4", "svg", "mpv", "mkv" },
  find_cmd = "fd", -- find command (defaults to `fd`)
  -- sudo apt install uberzug ffmpegthumbnailer poppler-utils epub-utils
  -- font-viewer (fontpreview)? fd, rg, etc
}

M.extensions.z = {
  cmd = { "z", "-l" },
  -- cmd = { vim.o.shell, '-c', 'z -l' },
}

M.extensions.arecibo = {
  ["selected_engine"] = "google",
  ["url_open_command"] = "xdg-open",
  ["show_http_headers"] = false,
  ["show_domain_icons"] = true,
}

M.extensions.projects = {
  workspaces = {
    {
      name = "ghq",
      base_dirs = {
        {
          path = "~/ghq",
          max_depth = 4,
        },
      },
    },
    {
      name = "nvim",
      base_dirs = {
        {
          path = "~/.local/share/nvim/site/pack/packer/start",
          max_depth = 2,
        },
        {
          path = "~/.local/share/nvim/site/pack/packer/opt",
          max_depth = 2,
        },
      },
    },
  },
  -- theme = "dropdown",
}

M.extensions.mapper = {
  sorter = sorters.fuzzy_with_index_bias,
  -- sorter = sorters.highlighter_only
}
return M
