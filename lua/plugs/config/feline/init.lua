local defaults = require('feline.default_components').statusline.icons

-- local provider_neocomposer = require('plugs.config.feline.provider-neocomposer')
local custom_status_comps = require('plugs.config.feline.components')
local colors = require('plugs.config.feline.colors')

local status_comps = vim.deepcopy(defaults)

table.insert(status_comps.active[1], 3, custom_status_comps.ProjectComponent)
status_comps.active[1][4].left_sep = {
  hl = {
    -- bg = require('feline.providers.vi_mode').get_mode_color(),
    bg = 'oceanblue',
  },
  str = ' ',
}

table.insert(status_comps.active[1], 7, custom_status_comps.AsciiComponent)
table.insert(status_comps.active[1], 8, custom_status_comps.FiletypeComponent)
table.insert(status_comps.active[1], 9, custom_status_comps.LspExtrasComponent)
status_comps.active[2][1] = custom_status_comps.HelpTagsComponent
status_comps.active[2][2] = custom_status_comps.NeoComposerComponent
status_comps.active[2][3] = custom_status_comps.GitBranchComponent
status_comps.active[2][4] = custom_status_comps.GitDiffAddedComponent
status_comps.active[2][5] = custom_status_comps.GitDiffChangedComponent
status_comps.active[2][6] = custom_status_comps.GitDiffRemovedComponent
status_comps.active[2][7] = custom_status_comps.ScrollBarComponent

local statusline_cfg = {
  components = status_comps,
  colors = { bg = colors.main.bg, fg = colors.main.fg },
  vi_mode_colors = colors.vi_mode,
  separators = {
    vertical_bar = '┃',
    vertical_bar_thin = '│',
    left = '',
    right = '',
    block = '█',
    left_filled = '',
    right_filled = '',
    slant_left = '',
    slant_left_thin = ' ',
    slant_right = ' ',
    slant_right_thin = ' ',
    slant_left_2 = ' ',
    slant_left_2_thin = ' ',
    -- slant_right_2 = " ",
    slant_right_2 = ' ',
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
      '^help$',
    },
    buftypes = {
      '^terminal$',
    },
    bufnames = {},
  },
  custom_providers = {
    lspextras = require('plugs.config.feline.provider-lspextras').provider,
    project = require('plugs.config.feline.provider-project').provider,
    neocomposer = require('plugs.config.feline.provider-neocomposer').provider,
    ascii = require('plugs.config.feline.provider-ascii').provider,
    helptags = require('plugs.config.feline.provider-helptags').provider,
  },
}

require('feline').setup(statusline_cfg)
