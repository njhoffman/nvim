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

table.insert(status_comps.active[1], 7, custom_status_comps.FiletypeComponent)
-- { provider = 'diagnostic_errors', hl = { fg = 'red' } },
-- { provider = 'diagnostic_warnings', hl = { fg = 'yellow' } },
-- { provider = 'diagnostic_hints', hl = { fg = 'cyan' } }
-- { provider = 'diagnostic_info', hl = { fg = 'skyblue' } },
table.insert(status_comps.active[1], 12, custom_status_comps.AsciiComponent)
-- -- status_comps.active[2][2] = custom_status_comps.NeoComposerComponent
status_comps.active[2][1] = custom_status_comps.HelpTagsComponent
-- status_comps.active[2][2] = custom_status_comps.LspReferencesComponent
-- status_comps.active[2][2] = custom_status_comps.LspCodeActionsComponent
status_comps.active[2][2] = custom_status_comps.GitBranchComponent
status_comps.active[2][3] = custom_status_comps.GitDiffAddedComponent
status_comps.active[2][4] = custom_status_comps.GitDiffChangedComponent
status_comps.active[2][5] = custom_status_comps.GitDiffRemovedComponent
status_comps.active[2][6] = custom_status_comps.ScrollBarComponent

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
    -- lsp_code_actions = require('plugs.config.feline.provider-lsp-code-actions').provider,
    -- lsp_references = require('plugs.config.feline.provider-lsp-references').provider,
    project = require('plugs.config.feline.provider-project').provider,
    neocomposer = require('plugs.config.feline.provider-neocomposer').provider,
    ascii = require('plugs.config.feline.provider-ascii').provider,
    helptags = require('plugs.config.feline.provider-helptags').provider,
  },
}

require('feline').setup(statusline_cfg)

-- lsp = {
--    function()
--      local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }
--      if #buf_clients == 0 then
--        return "LSP Inactive"
--      end
--
--      local buf_ft = vim.bo.filetype
--      local buf_client_names = {}
--      local copilot_active = false
--
--      -- add client
--      for _, client in pairs(buf_clients) do
--        if client.name ~= "null-ls" and client.name ~= "copilot" then
--          table.insert(buf_client_names, client.name)
--        end
--
--        if client.name == "copilot" then
--          copilot_active = true
--        end
--      end
--
--      -- add formatter
--      local formatters = require "lvim.lsp.null-ls.formatters"
--      local supported_formatters = formatters.list_registered(buf_ft)
--      vim.list_extend(buf_client_names, supported_formatters)
--
--      -- add linter
--      local linters = require "lvim.lsp.null-ls.linters"
--      local supported_linters = linters.list_registered(buf_ft)
--      vim.list_extend(buf_client_names, supported_linters)
--
--      local unique_client_names = vim.fn.uniq(buf_client_names)
--
--      local language_servers = "[" .. table.concat(unique_client_names, ", ") .. "]"
--
--      if copilot_active then
--        language_servers = language_servers .. "%#SLCopilot#" .. " " .. lvim.icons.git.Octoface .. "%*"
--      end
--
--      return language_servers
--    end,
--    color = { gui = "bold" },
--    co
