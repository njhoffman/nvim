-- https://raw.githubusercontent.com/nvim-telescope/telescope.nvim/master/README.md
local telescope = require('telescope')
local previewers = require('telescope.previewers')
local strings = require('plenary.strings')
local sorters = require('telescope.sorters')

local commands = require('plugs.config.telescope.commands')
local c_previewers = require('plugs.config.telescope.previewers')
local mappings = require('plugs.config.telescope.mappings')
local plugins = require('plugs.config.telescope.plugins')
local hide_preview = false

local entry_display = require('telescope.pickers.entry_display')
local telescope_utils = require('telescope.utils')

local currwidth = vim.api.nvim_win_get_width(vim.api.nvim_get_current_win())

local telescope_config = {
  defaults = {
    scrolling_limit = 20000,
    dynamic_preview_title = true,
    hidden = true,
    no_ignore = false,
    multi_icon = '◆ ',

    layout_config = {
      bottom_pane = {
        height = 25,
        preview_cutoff = 40,
        prompt_position = 'top',
      },
      center = {
        preview_height = 0.5,
        height = 0.4,
        preview_cutoff = 40,
        prompt_position = 'top',
        width = 0.5,
      },
      cursor = {
        height = 0.9,
        preview_cutoff = 40,
        width = 0.8,
      },
      horizontal = {
        height = 0.9,
        prompt_position = 'top',
        width = 0.8,
        preview_cutoff = 60,
        preview_width = 0.5,
      },
      vertical = {
        height = 0.9,
        preview_cutoff = 40,
        width = 0.8,
        prompt_position = 'top',
        mirror = true,
        preview_height = 0.5,
      },
      flex = {
        flip_columns = 130,
      },
    },
    cache_picker = {
      num_pickers = 20,
      limit_entries = 2000,
    },
    wrap_results = false,
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    history = {
      -- handler = require('telescope.actions.history').get_simple_history(),
      handler = require('telescope._extensions.pickers_history.handler').get_history(),
      path = vim.fn.stdpath('data') .. '/databases/telescope_history.sqlite3',
      limit = 2000,
    },
    layout_strategy = 'flex', -- flex, horizontal, veritical, center
    vimgrep_arguments = commands.vimgrep,
    find_command = commands.rg,
    prompt_prefix = '   ', -- " 🔍 ",
    selection_caret = '▶ ',
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
    path_display = function(_, path) -- tail, hidden, absolute, shorten
      path = string.gsub(path, '^./', '')
      path = string.gsub(path, os.getenv('HOME') or '', '~')
      return path
    end,
    file_ignore_patterns = {},
    preview = {
      check_mime_type = true,
      filesize_limit = 25,
      timeout = 1000, -- default 250
      treesitter = true,
      msg_bg_fillchar = '╱',
      -- hide_on_startup = hide_preview,
    },
  },
  pickers = {
    diagnostics = {
      theme = 'ivy',
      layout_config = { height = 15 },
      entry_maker = function(entry)
        local displayer = entry_display.create({
          separator = ' ',
          items = {
            { width = 4 },
            { width = nil },
            { width = nil },
            { width = nil },
          },
        })
        return {
          value = entry.filename,
          display = function(item)
            local colors = {
              ['ERROR'] = 'Red',
              ['WARN'] = 'Purple',
              ['INFO'] = 'Yellow',
              ['HINT'] = 'Blue',
            }
            return displayer({
              { string.format('%4d', item.lnum), 'Aqua' },
              { telescope_utils.transform_path({}, item.filename), '' },
              {
                string.format('%s> %s', string.lower(string.sub(item.type, 1, 1)), item.text),
                colors[entry.type],
              },
            })
          end,
          filename = entry.filename,
          ordinal = telescope_utils.transform_path({}, entry.filename) .. entry.type,
          lnum = entry.lnum,
          col = entry.col,
          type = entry.type,
          text = entry.text,
        }
      end,
    },
    find_files = {
      mappings = mappings.file_picker,
      find_command = commands.rg,
      debounce = 100,
    },
    fd = {
      mappings = mappings.file_picker,
      find_command = commands.rg,
      debounce = 100,
    },
    colorscheme = { enable_preview = true },
    oldfiles = {
      mappings = mappings.file_picker,
      find_command = commands.rg,
      debounce = 100,
    },
    live_grep = {
      mappings = mappings.grep,
      find_command = commands.rg,
      debounce = 100,
    },
    buffers = {
      debounce = 100,
      show_all_buffers = true,
      sort_mru = true,
      mappings = mappings.buffer,
      ignore_current_buffer = false,
      only_cwd = false,
    },
    keymaps = {
      entry_maker = require('plugs.config.telescope.entry_makers').gen_from_keymaps({}),
    },
    git_status = {
      debounce = 100,
      enabled = false,
      previewer = c_previewers.delta,
      theme = 'dropdown',
    },
    git_commits = false,
    -- git_commits = {
    --   previewer = c_previewers.delta,
    --   layout_strategy = "vertical",
    --   git_command = { "git", "log", "--format=%h%d (%ar) %s <%an>" },
    -- },
    git_branches = {
      debounce = 100,
      show_remote_tracking_branches = true,
    },
    git_bcommits = {
      mappings = mappings.file_picker,
      git_command = {
        'git',
        'log',
        '--date=format:%y/%m/%d %H:%M',
        '--pretty=format:%C(auto) %h %ad %s',
      },
      previewer = {
        previewers.git_commit_diff_as_was.new({ current_file = vim.fn.expand('%') }),
        previewers.git_commit_diff_to_parent.new({ current_file = vim.fn.expand('%') }),
        previewers.git_commit_diff_to_head.new({ current_file = vim.fn.expand('%') }),
        previewers.git_commit_message.new({ current_file = vim.fn.expand('%') }),
        -- c_previewers.delta
      },
      -- previewer = c_previewers.delta,
      layout_strategy = 'vertical',
      -- git_command = { "git", "log", "--date=format:%m-%d-%y", "--format=%h%d %ad %s <%an>" }
      -- git_command = { "git", "log", "--format=%h%d (%ar) %s <%an>" },
    },
    lsp_workspace_symbols = {
      debounce = 100,
      symbols_highlights = {
        'Class',
        'Function',
        'Method',
        'Constructor',
        'Interface',
        'Module',
        'Struct',
        'Trait',
        'Field',
      },
    },
    lsp_references = {
      debounce = 100,
      include_current_line = false,
      theme = 'dropdown',
      path_display = { 'tail' },
    },
    lsp_document_symbols = {
      debounce = 100,
      sorter = require('telescope').extensions.fzf.native_fzf_sorter({
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      }),
      symbols_highlights = {
        'Class',
        'Function',
        'Method',
        'Constructor',
        'Interface',
        'Module',
        'Struct',
        'Trait',
        'Field',
      },
    },
  },
}

telescope_config.extensions = plugins.get_extensions()
telescope.setup(telescope_config)
plugins.load()

-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'TelescopePreviewerLoaded',
--   callback = function(args)
--     require('scrollbar.handlers').show()
--     -- vim.dbglog('PREVIEWER', args)
--   end,
-- })
