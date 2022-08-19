local feline = require('feline')
local defaults = require('feline.default_components').statusline.icons
-- local defaults = require('feline.default_components').winbar.icons
local colors = require('plugins.config.feline-nvim-colors')
local custom_comps = require('plugins.config.feline-nvim-components')
local provider_project_nvim = require('plugins.config.feline-nvim-provider-project-nvim')
local provider_project_uo = require('plugins.config.feline-nvim-provider-project-uo')

-- require("lsp_signature").status_line(max_width)

table.insert(defaults.active[1], 3, custom_comps.ProjectUoComponent)
defaults.active[1][4].left_sep = { hl = { bg = "oceanblue" }, str = " " }
table.insert(defaults.active[1], 7, custom_comps.AsciiComponent)
table.insert(defaults.active[1], 8, custom_comps.FiletypeComponent)
defaults.active[2][1] = custom_comps.GitBranchComponent
defaults.active[2][2] = custom_comps.GitDiffAddedComponent
defaults.active[2][3] = custom_comps.GitDiffChangedComponent
defaults.active[2][4] = custom_comps.GitDiffRemovedComponent

-- local components = { active = {}, inactive = {} }
-- table.insert(components.active[1], defaults.active.vi_mode.left)
-- table.insert(defaults.active[1], 3, custom_comps.ProjectNvimComponent)
-- table.insert(components.active[1], defaults.active[1])
-- table.insert(components.active[1], defaults.file.info)
-- table.insert(components.inactive[1], defaults.vi_mode.left)
-- table.insert(components.inactive[1], defaults.file.info)
-- table.insert(components.active[3], defaults.diagnos.err)
-- table.insert(components.active[3], defaults.diagnos.warn)
-- table.insert(components.active[3], defaults.diagnos.hint)
-- table.insert(components.active[3], defaults.diagnos.info)
-- table.insert(components.active[3], defaults.lsp.name)
-- table.insert(components.active[3], defaults.file.os)
-- table.insert(components.active[3], defaults.file.position)
-- table.insert(components.active[3], defaults.line_percentage)
-- table.insert(components.active[3], defaults.scroll_bar)
-- table.insert(components.active[3], defaults.vi_mode.right)

feline.setup({
  colors = { bg = colors.main.bg, fg = colors.main.fg },
  components = defaults,
  vi_mode_colors = colors.vi_mode,
  separators = {
    vertical_bar = '┃',
    vertical_bar_thin = '│',
    left = '',
    right = '',
    block = '█',
    left_filled = '',
    right_filled = '',
    slant_left = ' ',
    slant_left_thin = ' ',
    slant_right = ' ',
    slant_right_thin = ' ',
    slant_left_2 = ' ',
    slant_left_2_thin = ' ',
    slant_right_2 = ' ',
    slant_right_2_thin = ' ',
    left_rounded = '',
    left_rounded_thin = '',
    right_rounded = '',
    right_rounded_thin = '',
    circle = '●',
  },
  force_inactive = {
    filetypes = {
      '^NvimTree$',
      '^packer$',
      '^startify$',
      '^fugitive$',
      '^fugitiveblame$',
      '^qf$',
      '^help$'
    },
    buftypes = {
      '^terminal$'
    },
    bufnames = {},
  },
  custom_providers = {
    project_nvim = provider_project_nvim.provider,
    project_uo = provider_project_uo.provider,
  }
  -- highlight_reset_triggers = { 'SessionLoadPost', 'ColorScheme' }
  -- conditional_components = { {
  --  -- Only use this components table for the 2nd window
  --   condition = function()
  --       return vim.api.nvim_win_get_number(0) == 2
  --   end,
  --   active = {
  --       -- Components used for active window
  --   },
  --   inactive = {
  --       -- Components used for inactive windows
  --   }
  --  } }
})

-- TreeSitter
-- local ts_utils = require("nvim-treesitter.ts_utils")
-- local ts_parsers = require("nvim-treesitter.parsers")
-- local ts_queries = require("nvim-treesitter.query")
--[[ table.insert(components.active[2], {
  provider = function()
    local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()
    return ("%d:%s [%d, %d] - [%d, %d]")
      :format(node:symbol(), node:type(), node:range())
  end,
  enabled = function()
    local ok, ts_parsers = pcall(require, "nvim-treesitter.parsers")
    return ok and ts_parsers.has_parser()
  end
}) ]]
