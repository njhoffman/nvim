-- https://raw.githubusercontent.com/nvim-telescope/telescope.nvim/master/README.md

local telescope = require("telescope")
local previewers = require("telescope.previewers")
local sorters = require("telescope.sorters")

local custom = require("plugs.config.telescope-nvim.custom")
local mappings = require("plugs.config.telescope-nvim.mappings")
local plugins = require("plugs.config.telescope-nvim.plugins")

local command_rg = {
  "rg",
  "--color=never",
  "--one-file-system",
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
  "path",
}

local hide_preview = false
local currwidth = vim.api.nvim_win_get_width(vim.api.nvim_get_current_win())
if currwidth < 120 then
  hide_preview = true
end

local telescopeConfig = {
  defaults = {
    scrolling_limit = 20000,
    dynamic_preview_title = true,
    hidden = true,
    no_ignore = false,
    multi_icon = "◆ ",
    layout_config = {
      bottom_pane = {
        height = 25,
        preview_cutoff = 40,
        prompt_position = "top",
      },
      center = {
        preview_height = 0.5,
        height = 0.4,
        preview_cutoff = 40,
        prompt_position = "top",
        width = 0.5,
      },
      cursor = {
        height = 0.9,
        preview_cutoff = 40,
        width = 0.8,
      },
      horizontal = {
        height = 0.9,
        prompt_position = "top",
        width = 0.8,
        preview_cutoff = 60,
        preview_width = 0.5,
      },
      vertical = {
        height = 0.9,
        preview_cutoff = 40,
        width = 0.8,
        prompt_position = "top",
        mirror = true,
        preview_height = 0.5,
      },
      flex = {
        flip_columns = 130,
      },
    },
    layout_strategy = "flex", -- flex, horizontal, veritical, center
    vimgrep_arguments = command_vimgrep,
    find_command = command_rg,
    prompt_prefix = "   ", -- " 🔍 ",
    selection_caret = "▶ ",
    selection_strategy = "reset", -- follow, reset, row
    sorting_strategy = "ascending",
    scroll_strategy = "cycle",
    color_devicons = true,
    -- winblend = 10,
    mappings = mappings.main,
    file_sorter = sorters.native_fzf_sorter,
    generic_sorter = sorters.native_fzf_sorter, -- get_fuzzy_file, fuzzy_with_index_bias
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
    include_extensions = true,
    path_display = function(_, path) -- tail, hidden, absolute, shorten
      path = string.gsub(path, "^./", "")
      path = string.gsub(path, os.getenv("HOME") or "", "~")
      return path
    end,
    file_ignore_patterns = {},
    preview = {
      check_mime_type = true,
      filesize_limit = 25,
      timeout = 1000, -- default 250
      treesitter = true,
      msg_bg_fillchar = "╱",
      -- hide_on_startup = hide_preview,
    },
  },
  pickers = {
    pickers = false,
    find_files = {
      mappings = mappings.file_picker,
      find_command = command_rg,
    },
    frecency = {
      mappings = mappings.file_picker,
    },
    buffers = {
      show_all_buffers = true,
      sort_mru = true,
      ignore_current_buffer = false,
      only_cwd = false,
    },
    oldfiles = {
      mappings = mappings.file_picker,
      find_command = command_rg,
    },
    git_status = {
      previewer = custom.previewers.delta,
    },
    git_bcommits = {
      mappings = mappings.file_picker,
      previewer = custom.previewers.git_bcommits,
      layout_strategy = "vertical",
      -- git_command = { "git", "log", "--date=format:%m-%d-%y", "--format=%h%d %ad %s <%an>" }
      -- git_command = { "git", "log", '--format=%h%d (%ar) %s <%an>' }
    },
  },
  extensions = plugins.extensions,
}

telescope.setup(telescopeConfig)
plugins.load_extensions(telescope)

require("plugs.config.telescope-nvim.pickers")
