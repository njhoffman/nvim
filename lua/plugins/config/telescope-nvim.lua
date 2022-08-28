-- https://raw.githubusercontent.com/nvim-telescope/telescope.nvim/master/README.md
local telescope = require('telescope')
local previewers = require "telescope.previewers"
local sorters = require "telescope.sorters"
local tele_custom = require "plugins.config.telescope-custom"
local tele_plugins = require("plugins.config.telescope-plugins")
local tele_mappings = require("plugins.config.telescope-mappings")

-- TODO: why can't replicate fuzzy matching behavior of fzf-lua
-- TODO: calculate page length for ctrl-f/ctrl-b
local command_rg = {
  "rg",
  "--color=never",
  "--ignore",
  "--smart-case",
  "--hidden",
  "--files",
  "--sort",
  "path",
}
-- local command_fd = { "fd", "--type", "f", "--strip-cwd-prefix" }
local command_vimgrep = {
  "rg",
  "--color=never",
  "--no-heading",
  "--with-filename",
  "--line-number",
  "--hidden",
  "--column",
  "--smart-case",
  "--vimgrep",
  "--sort",
  "path"
}

local hide_preview = false
local currwidth = vim.api.nvim_win_get_width(vim.api.nvim_get_current_win())
if currwidth < 120 then
  hide_preview = true
end

local telescopeConfig = {
  defaults = {
    dynamic_preview_title = true,
    hidden = true,
    no_ignore = false,
    multi_icon = "◆ ",
    layout_config = {
      bottom_pane = {
        height = 25,
        preview_cutoff = 60,
        prompt_position = "top"
      },
      center = {
        preview_height = 0.5,
        height = 0.4,
        preview_cutoff = 40,
        prompt_position = "top",
        width = 0.5
      },
      cursor = { height = 0.9, preview_cutoff = 40, width = 0.8 },
      horizontal = {
        height = 0.9,
        prompt_position = "top",
        width = 0.8,
        preview_cutoff = 60,
        preview_width = 0.5
      },
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

    vimgrep_arguments = command_vimgrep,
    find_command = command_rg,
    prompt_prefix = "   ", -- " 🔍 ",
    selection_caret = "▶ ",
    selection_strategy = "reset", -- follow, reset, row
    sorting_strategy = "ascending",
    layout_strategy = "flex", -- flex, horizontal, veritical, center
    scroll_strategy = "cycle",
    color_devicons = true,
    -- winblend = 10,
    mappings = tele_mappings.main,
    file_sorter = sorters.native_fzf_sorter,
    generic_sorter = sorters.native_fzf_sorter, -- get_fuzzy_file, fuzzy_with_index_bias
    -- file_previewer = previewers.vim_buffer_cat.new,
    -- generic_sorter = require"telescope.sorters".generic_sorter,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
    include_extensions = true,
    path_display = function(_, path) -- tail, hidden, absolute, shorten
      path = string.gsub(path, "^./", "")
      path = string.gsub(path, os.getenv('HOME'), '~')
      return path
    end,
    file_ignore_patterns = {},
    preview = {
      check_mime_type = true,
      filesize_limit = 25,
      timeout = 500, -- default 250
      treesitter = true,
      msg_bg_fillchar = "╱",
      hide_on_startup = hide_preview
    }
  },
  pickers = {
    pickers = false,
    find_files = {
      mappings = tele_mappings.file_picker,
      find_command = command_rg
    },
    buffers = {
      show_all_buffers = true,
      sort_mru = true,
      ignore_current_buffer = false,
      only_cwd = false
    },
    oldfiles = {
      mappings = tele_mappings.file_picker,
      find_command = command_rg
    },
    git_bcommits = {
      mappings = tele_mappings.file_picker,
      previewer = tele_custom.previewers.git_bcommits,
      -- git_command = { "git", "log", "--date=format:%m-%d-%y", "--format=%h%d %ad %s <%an>" }
      -- git_command = { "git", "log", '--format=%h%d (%ar) %s <%an>' }
    }
  },
  extensions = tele_plugins.extensions
}
telescope.setup(telescopeConfig)
tele_plugins.load_extensions(telescope)

require("plugins.config.telescope-pickers")
require("plugins.config.telescope-preconfigure")
