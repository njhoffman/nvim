local sorters = require("telescope.sorters")
local H = require("helpers")
local actions = require("telescope.actions")
local tele_mappings = require("plugs.config.telescope.mappings")

local tele_plugs = {
  -- locally managed
  ["arecibo"] = {},
  ["devhints"] = {},
  ["env"] = {},
  ["fences"] = {},
  ["filetypes"] = {},
  ["find_pickers"] = {},
  ["gotofile"] = {},
  ["mapper"] = {},
  ["notify"] = {},
  ["options"] = {},
  ["variables"] = {},
  ["which-key"] = {},
  -- 3rd party to sort through
  ["advanced_git_search"] = {},
  ["aerial"] = {},
  ["asynctasks"] = {},
  ["bookmarks"] = {},
  ["changes"] = {},
  ["cheatsheet"] = {},
  ["cder"] = {},
  ["command_palette"] = {},
  ["color_names"] = {},
  ["docker"] = {},
  -- ["dap"]= {},
  ["file_browser"] = {},
  ["frecency"] = {},
  ["fzf"] = {},
  ["gh"] = {},
  ["ghn"] = {},
  ["ghq"] = {},
  ["heading"] = {},
  ["hop"] = {},
  ["howdoi"] = {},
  ["lazy"] = {},
  ["lazygit"] = {},
  ["live_grep_args"] = {},
  ["luasnip"] = {},
  -- ["make"]           = {},
  ["media_files"] = {},
  ["menufacture"] = {},
  ["neoclip"] = {},
  ["node_modules"] = {},
  ["npm"] = {},
  ["openbrowser"] = {},
  ["ports"] = {},
  ["projects"] = {},
  ["repo"] = {},
  -- ["session-lens"]= {},
  ["smart_open"] = {},
  ["terraform"] = {},
  ["tmux"] = {},
  ["undo"] = {},
  ["ui-select"] = {},
  ["vimwiki"] = {},
  ["z"] = {},
}

require("dir-telescope").setup({
  hidden = true,
  respect_gitignore = true,
})

vim.keymap.set("n", "<leader>gfd", "<cmd>GrepInDirectory<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gpd", "<cmd>FileInDirectory<CR>", { noremap = true, silent = true })

local extensions = {}
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

extensions.menufacture = {
  mappings = {
    main_menu = { [{ "i", "n" }] = "<M-Bslash>" },
  },
}

extensions.undo = {
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

extensions.lazy = {
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
extensions.file_browser = {
  theme = "ivy",
  mappings = tele_mappings.file_picker,
}

extensions.openbrowser = {
  -- Add bookmark urls
  bookmarks = {
    ["luv docs"] = "https://github.com/luvit/luv/blob/master/docs.md",
  },
  bookmark_filepath = "~/.vim/telescope_openbrowser_bookmarks",
}

extensions.howdoi = vim.tbl_deep_extend("force", {
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

extensions.cder = {
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

extensions["ui-select"] = {
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

extensions.command_palette = {
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

-- vim.dbglog("mappings", tele_mappings.file_picker)

extensions.frecency = {
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
    ["zettel"] = baseDirs.home .. "/zettelkasten",
    ["zinit"] = baseDirs.home .. "/.zinit",
    ["zsh"] = baseDirs.home .. "/.config/zsh",
  },
}

extensions.fzf = {
  fuzzy = true, -- false will only do exact matching
  override_generic_sorter = true, -- override the generic sorter
  override_file_sorter = true, -- override the file sorter
  case_mode = "smart_case", -- or "ignore_case" or "respect_case"
}

extensions.bookmarks = {
  selected_browser = "chrome",
  url_open_command = "xdg-open",
  url_open_plugin = nil, -- vim_external, open_browser
  firefox_profile_name = nil,
}

extensions.live_grep_args = {
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

extensions.media_files = {
  filetypes = { "png", "webp", "jpg", "jpeg", "webm", "pdf", "mp4", "svg", "mpv", "mkv" },
  find_cmd = "fd", -- find command (defaults to `fd`)
  -- sudo apt install uberzug ffmpegthumbnailer poppler-utils epub-utils
  -- font-viewer (fontpreview)? fd, rg, etc
}

extensions.z = {
  cmd = { "z", "-l" },
  -- cmd = { vim.o.shell, '-c', 'z -l' },
}

extensions.arecibo = {
  ["selected_engine"] = "google",
  ["url_open_command"] = "xdg-open",
  ["show_http_headers"] = false,
  ["show_domain_icons"] = true,
}

extensions.projects = {
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
          path = "~/.local/share/nvim/lazy",
          max_depth = 2,
        },
      },
    },
  },
  -- theme = "dropdown",
}

extensions.mapper = {
  sorter = sorters.fuzzy_with_index_bias,
  -- sorter = sorters.highlighter_only
}

local load = function(telescope)
  local installed = {}
  for ext_name, _ in pairs(tele_plugs) do
    local ok, err = pcall(telescope.load_extension, ext_name)
    if ok then
      table.insert(installed, 0, ext_name)
    else
      local err_str = vim.split(err, "\n")
      local err_msg = "Error loading telescope plugin: " .. ext_name .. " - " .. err_str[1]
      vim.notify(err_msg, 4)
    end
  end
  local end_msg = "Loaded " .. H.table_len(installed) .. " out of " .. H.table_len(tele_plugs) .. " telescope plugins"
  vim.notify(end_msg, 0)
  return telescope
end

return { extensions = extensions, load = load }

--  Z telescope plugin:
--  <CR> (edit)	builtin.find_files    <C-x> (split)	:chdir to the dir
--  <C-v> (vsplit)	:lchdir to the dir  <C-t> (tabedit)	:tchdir to the dir
--  cmd Set command list to execute z -l or compatibles. Default: {vim.o.shell, '-c', 'z -l'}
--  cwd Transform result paths into relative ones with this value as base dir. Default: vim.fn.getcwd()
--  tail_path Show only basename of the path. Default value: false
--  shorten_path Call pathshorten() for each path. Default value: false

--  FZF Syntax:
--  Token	Match type	Description
--  sbtrkt	fuzzy-match	Items that match sbtrkt
--  'wild	exact-match (quoted)	Items that include wild
--  ^music	prefix-exact-match	Items that start with music
--  .mp3$	suffix-exact-match	Items that end with .mp3
--  !fire	inverse-exact-match	Items that do not include fire
--  !^music	inverse-prefix-exact-match	Items that do not start with music
--  !.mp3$	inverse-suffix-exact-match	Items that do not end with .mp3
--  A single bar character term acts as an OR ope

--  File Browser
--  Insert / Normal	Action
--  <C-f>/f	Toggle between file and folder browser
--  <C-y>/y	Copy (multi-selected) files or folders to cwd
--  <C-d>/dd	Delete (multi-selected) files or folders
--  <C-r>/r	Rename (multi-selected) files
--  <C-e>/e	Add File/Folder at cwd; trailing / creates folder
--       /m	Move multi-selected files to cwd
--  <C-h>/h	Toggle hidden files
--  <C-o>/o	Open file with default system application
--  <C-g>/g	Go to parent directory
--  <C-w>/w	Go to current working directory
--  <A-e>/--	Toggle all entires ignoring ./ and ../
