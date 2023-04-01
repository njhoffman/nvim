-- https://raw.githubusercontent.com/nvim-telescope/telescope.nvim/master/README.md
local telescope = require("telescope")
local previewers = require("telescope.previewers")
local sorters = require("telescope.sorters")

local commands = require("plugs.config.telescope.commands")
local c_previewers = require("plugs.config.telescope.previewers")
local mappings = require("plugs.config.telescope.mappings")
local plugins = require("plugs.config.telescope.plugins")
local symbol_highlights = require("plugs.config.telescope.symbol_highlights")

local hide_preview = false
local currwidth = vim.api.nvim_win_get_width(vim.api.nvim_get_current_win())
if currwidth < 120 then
  hide_preview = true
end

local telescope_config = {
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
    vimgrep_arguments = commands.vimgrep,
    find_command = commands.rg,
    prompt_prefix = "   ", -- " 🔍 ",
    selection_caret = "▶ ",
    selection_strategy = "reset", -- follow, reset, row
    sorting_strategy = "ascending",
    scroll_strategy = "cycle",
    color_devicons = true,
    winblend = 10,
    mappings = mappings.main,
    file_sorter = sorters.native_fzf_sorter,
    generic_sorter = require("mini.fuzzy").get_telescope_sorter,
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
      find_command = commands.rg,
    },
    fd = {
      mappings = mappings.file_picker,
      find_command = commands.rg,
    },
    oldfiles = {
      mappings = mappings.file_picker,
      find_command = commands.rg,
    },
    live_grep = {
      mappings = mappings.grep,
      find_command = commands.rg,
    },
    buffers = {
      show_all_buffers = true,
      sort_mru = true,
      mappings = mappings.buffer,
      ignore_current_buffer = false,
      only_cwd = false,
    },
    git_status = {
      previewer = c_previewers.delta,
    },
    git_bcommits = {
      mappings = mappings.file_picker,
      previewer = c_previewers.git_bcommits,
      layout_strategy = "vertical",
      -- git_command = { "git", "log", "--date=format:%m-%d-%y", "--format=%h%d %ad %s <%an>" }
      -- git_command = { "git", "log", '--format=%h%d (%ar) %s <%an>' }
    },
    lsp_workspace_symbols = {
      symbol_highlights = symbol_highlights,
    },
    lsp_document_symbols = {
      symbol_highlights = symbol_highlights,
    },
  },
}

telescope_config.extensions = plugins.get_extensions()
telescope.setup(telescope_config)
plugins.load()
