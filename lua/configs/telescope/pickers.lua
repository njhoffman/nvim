local previewers = require('telescope.previewers')

local commands = require('configs.telescope.commands')
local c_previewers = require('configs.telescope.previewers')
local mappings = require('configs.telescope.mappings')

local entry_display = require('telescope.pickers.entry_display')
local telescope_utils = require('telescope.utils')

-- stylua: ignore
local icons = {
  buffer    = ' 󰽙  ',
  file      = ' 󰝰  ',
  history   = ' 󰋚  ',
  git       = ' 󰊢  ',
  keymap    = '   ',
  misc_1    = '   ',
  palette   = '   ',
  reference = ' 󰒐  ',
  symbol    = ' 󰒕  ',
}

local pickers = {
  diagnostics = {
    theme = 'ivy',
    prompt_prefix = icons.misc_1,
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
    debounce = 100,
    prompt_prefix = icons.file,
    mappings = mappings.file,
    find_command = commands.rg,
  },
  fd = {
    debounce = 100,
    mappings = mappings.file,
    prompt_prefix = icons.file,
    find_command = commands.rg,
  },
  colorscheme = {
    debounce = 100,
    prompt_prefix = icons.palette,
    enable_preview = true,
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        height = 0.4,
        width = 0.3,
        anchor = 'SE',
        preview_width = 1, -- needs preview for live preview of the theme
      },
    },
  },
  oldfiles = {
    debounce = 100,
    prompt_prefix = icons.history,
    mappings = mappings.file,
    find_command = commands.rg,
  },
  live_grep = {
    debounce = 100,
    mappings = mappings.grep,
    find_command = commands.rg,
  },
  buffers = {
    debounce = 100,
    prompt_prefix = icons.buffer,
    show_all_buffers = true,
    sort_mru = true,
    mappings = mappings.buffer,
    ignore_current_buffer = false,
    only_cwd = false,
    -- previewer = false,
    -- layout_config = {
    -- 	horizontal = { anchor = "W", width = 0.5, height = 0.5 },
    -- },
  },
  keymaps = {
    debounce = 100,
    prompt_prefix = icons.keymap,
    entry_maker = require('configs.telescope.entry_makers').gen_from_keymaps({}),
    results_title = '@buffer !silent *noremap +expr  nowait',
    show_plug = false,
    modes = { 'n', 'i', 'c', 'x', 'v', 'o', 't' },
    -- modes = vim.F.if_nil(opts.modes, { "n", "i", "c", "x" })
    -- show_plug = true,
    -- only_buf = false
  },
  highlights = {
    prompt_prefix = icons.palette,
    debounce = 100,
    layout_config = {
      horizontal = { preview_width = { 0.7, min = 30 } },
    },
  },
  git_status = {
    debounce = 100,
    prompt_prefix = icons.git,
    show_untracked = true,
    enabled = false,
    previewer = c_previewers.delta,
    theme = 'dropdown',
  },
  git_commits = {
    enabled = false,
    prompt_prefix = icons.git,
    debounce = 100,
    previewer = require('telescope.previewers').new_termopen_previewer({
      dyn_title = function(_, entry)
        return entry.value
      end, -- use hash as title
      get_command = function(entry, status)
        local hash = entry.value
        local previewWinWidth = vim.api.nvim_win_get_width(status.preview_win)
        local statArgs = ('%s,%s,25'):format(previewWinWidth, math.floor(previewWinWidth / 2))
        local previewFormat =
          '%C(bold)%C(magenta)%s %n%C(reset)%C(cyan)%D%C(reset)%b %n%C(blue)%an %C(yellow)(%ch) %C(reset)'
        local cmd = {
          'git show ' .. hash,
          '--color=always',
          '--stat=' .. statArgs,
          "--format='" .. previewFormat .. "'",
          "| sed -e 's/^ //' -e '$d' ;", -- remove clutter
        }
        return table.concat(cmd, ' ')
      end,
    }),
    layout_config = { horizontal = { height = 0.99 } },
    -- add commit time (%cr) & `--all`
    git_command = { 'git', 'log', '--all', '--pretty=%h %s\t%cr', '--', '.' },
    -- previewer = c_previewers.delta,
  },
  git_branches = {
    debounce = 100,
    prompt_prefix = icons.git,
    show_remote_tracking_branches = true,
  },
  git_bcommits = {
    debounce = 100,
    mappings = mappings.file,
    prompt_prefix = icons.git,
    -- git_command = { "git", "log", "--pretty=%h %s\t%cr" }, -- add commit time (%cr)
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
    layout_config = { horizontal = { height = 0.99 } },
    -- layout_strategy = 'vertical',
    -- git_command = { "git", "log", "--date=format:%m-%d-%y", "--format=%h%d %ad %s <%an>" }
    -- git_command = { "git", "log", "--format=%h%d (%ar) %s <%an>" },
  },
  lsp_workspace_symbols = {
    debounce = 100,
    prompt_prefix = icons.symbol,
    -- ignore_symbols = { "boolean", "number", "string", "variable", "array", "object", "constant", "package" },
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
    prompt_prefix = icons.reference,
    include_current_line = false,
    theme = 'dropdown',
    path_display = { 'tail' },
  },
  lsp_document_symbols = {
    debounce = 100,
    prompt_prefix = icons.symbol,
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
}

return pickers
