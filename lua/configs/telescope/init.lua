-- https://raw.githubusercontent.com/nvim-telescope/telescope.nvim/master/README.md
local telescope = require('telescope')
local commands = require('configs.telescope.commands')
local mappings = require('configs.telescope.mappings')
local pickers = require('configs.telescope.pickers')
local extensions = require('configs.telescope.extensions')
local display_path = require('configs.telescope.display-path')

local telescope_config = {
  defaults = {
    scrolling_limit = 20000,
    dynamic_preview_title = true,
    hidden = true,
    no_ignore = false,
    wrap_results = false,
    layout_strategy = 'flex', -- flex, horizontal, veritical, center
    selection_caret = '▶ ',
    multi_icon = '◆ ', --  '󰒆 ',
    prompt_prefix = ' 🔍 ', -- " 🔍 ",'   '
    border_chars = {
      preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
      prompt = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
      results = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    },
    layout_config = {
      prompt_position = 'top',
      bottom_pane = {
        height = 25,
        preview_cutoff = 40,
      },
      center = {
        preview_height = 0.5,
        height = 0.4,
        preview_cutoff = 40,
        width = 0.5,
      },
      cursor = {
        height = 0.9,
        preview_cutoff = 40,
        width = 0.8,
      },
      horizontal = {
        height = 0.9,
        width = 0.8,
        preview_cutoff = 60,
        preview_width = 0.5,
      },
      vertical = {
        height = 0.9,
        preview_cutoff = 40,
        width = 0.8,
        mirror = true,
        preview_height = 0.5,
      },
      flex = {
        flip_columns = 130,
      },
    },
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    cache_picker = {
      num_pickers = 20,
      limit_entries = 2000,
    },
    history = {
      handler = require('telescope._extensions.pickers_history.handler').get_history,
      path = vim.fn.stdpath('data') .. '/databases/telescope_history.sqlite3',
      limit = 2000,
    },
    vimgrep_arguments = commands.vimgrep,
    find_command = commands.rg,
    selection_strategy = 'reset', -- follow, reset, row
    sorting_strategy = 'ascending',
    scroll_strategy = 'cycle',
    color_devicons = true,
    winblend = 10,
    mappings = mappings.main,
    -- file_sorter = sorters.native_fzf_sorter,
    generic_sorter = require('mini.fuzzy').get_telescope_sorter,
    file_sorter = require('mini.fuzzy').get_telescope_sorter,
    include_extensions = true,
    path_display = display_path.init('simple'),
    file_ignore_patterns = {
      '%.pdf$',
      '%.png$',
      '%.gif$',
      '%.jpe?g$',
      '%.icns$',
      '%.pxd$',
      '%.zip$',
      '%.plist$',
      -- other ignores are defined via .gitignore, .ignore, /fd/ignore, or /git/ignore
    },
    preview = {
      check_mime_type = true,
      ls_short = true,
      filesize_limit = 2,
      timeout = 600, -- default 250
      treesitter = true,
      msg_bg_fillchar = '╱',
      -- hide_on_startup = hide_preview,
    },
  },
  pickers = pickers,
}

telescope_config.extensions = extensions.get()
telescope.setup(telescope_config)
extensions.load()

-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'TelescopePreviewerLoaded',
--   callback = function(args)
--     require('scrollbar.handlers').show()
--     -- vim.dbglog('PREVIEWER', args)
--   end,
-- })
