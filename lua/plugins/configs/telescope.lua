local ok, telescope = pcall(require, "telescope")
if not ok then return end

local previewers = require "telescope.previewers"
local sorters = require "telescope.sorters"
local tele_plugins = require("plugins.configs.telescope-plugins")
local tele_mappings = require("plugins.configs.telescope-mappings")

-- TODO: why can't replicate fuzzy matching behavior of fzf-lua
-- TODO: calculate page length for ctrl-f/ctrl-b

local telescopeConfig = {
  defaults = {
    vimgrep_arguments = {
      "rg",
      -- "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--hidden",
      "--column",
      "--smart-case",
      "--vimgrep"
    },
    find_command = { "rg", "--ignore", "--hidden", "--files" },
    hidden = true,
    no_ignore = false,
    multi_icon = "◆ ",
    layout_config = {
      bottom_pane = { height = 25, preview_cutoff = 100, prompt_position = "top" },
      center = { preview_height = 0.5, height = 0.4, preview_cutoff = 40, prompt_position = "top", width = 0.5 },
      cursor = { height = 0.9, preview_cutoff = 40, width = 0.8 },
      horizontal = { height = 0.9, prompt_position = "top", width = 0.8, preview_cutoff = 80, preview_width = 0.5 },
      vertical = {
        height = 0.9,
        preview_cutoff = 40,
        width = 0.8,
        prompt_position = "top",
        mirror = true,
        preview_height = 0.5
      },
      flex = { flip_columns = 130 }
    },
    dynamic_preview_title = true,
    prompt_prefix = " 🔍 ",
    selection_caret = "▶ ",
    selection_strategy = "reset", -- follow, reset, row
    sorting_strategy = "ascending",
    layout_strategy = "flex", -- flex, horizontal, veritical, center
    scroll_strategy = "cycle",
    color_devicons = true,
    winblend = 15,
    mappings = tele_mappings.main,
    file_sorter = sorters.get_fuzzy_file,
    -- file_previewer = previewers.vim_buffer_cat.new,
    generic_sorter = sorters.get_generic_fuzzy_sorter,
    -- generic_sorter = require"telescope.sorters".generic_sorter,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
    include_extensions = true,
    path_display = { "absolute" }, -- tail, hidden, absolute, shorten
    file_ignore_patterns = {},
    preview = {
      check_mime_type = true,
      filesize_limit = 25,
      timeout = 250, -- default 250
      treesitter = true,
      msg_bg_fillchar = "╱",
      hide_on_startup = false
    }
  },
  pickers = {
    find_files = {
      find_command = { "rg", "--ignore", "--hidden", "--sort", "path", "--files" },
      -- find_command = {"fd", "--type", "f", "--strip-cwd-prefix"},
      mappings = tele_mappings.file_picker
    },
    oldfiles = {
      find_command = { "rg", "--ignore", "--hidden", "--sort", "path", "--files" },
      mappings = tele_mappings.file_picker
    },
    git_bcommits = {
      git_command = { "git", "log", "--pretty=oneline", "--abbrev-commit" }
      -- git_command = { "git", "log", "--date=format:%m-%d-%y", "--format=%h%d %ad %s <%an>" }
      -- git_command = { "git", "log", '--format=%h%d (%ar) %s <%an>' }
    }
  },
  extensions = tele_plugins.extensions
}

telescope.setup(telescopeConfig)

tele_plugins.load_extensions(telescope)

require("plugins.configs.telescope-pickers")

return telescope
