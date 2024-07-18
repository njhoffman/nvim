local defaults = require("feline.default_components").statusline.icons
-- local provider_neocomposer = require('configs.feline.provider-neocomposer')
local custom_status_comps = require("configs.feline.components")
local colors = require("configs.feline.colors")

-- o[a]  N?: dap

local custom_providers = {
  -- lsp_code_actions = require('configs.feline.provider-lsp-code-actions').provider,
  -- lsp_references = require('configs.feline.provider-lsp-references').provider,
  project = require("configs.feline.provider-project").provider,
  neocomposer = require("configs.feline.provider-neocomposer").provider,
  ascii = require("configs.feline.provider-ascii").provider,
  line_count = require("configs.feline.provider-line_count").provider,
}

-- bg_jobs, cmdline and qf components
-- function M:update_status()
--     if vim.env.CLEARCASE_CMDLINE then
--         local pattern = '^' .. username .. '_at_'
--         if vim.env.CLEARCASE_CMDLINE:match(pattern) then
--             return ' ' .. vim.split(vim.env.CLEARCASE_CMDLINE, ' ')[2]:gsub(pattern, '')
--         end
--         return ' ' .. vim.split(vim.env.CLEARCASE_CMDLINE, ' ')[2]
--     end
--     return ''
-- end
-- function M:update_status()
--     local keys = vim.tbl_keys(STORAGE.jobs) or {}
--     if #keys > 0 then
--         -- local icon = vim.env.NO_COOL_FONTS and 'Jobs' or require('utils.functions').get_icon('perf')
--         return ('%sJobs: %s'):format(hl.component_format_highlight(self.jobs_hl), #keys)
--     end
--     return ''
-- end
-- function M:update_status()
--     local qf_values = vim.fn.getqflist { items = 0, idx = 0 }
--     if #qf_values.items > 0 then
--         local valid = 0
--         for _, item in ipairs(qf_values.items) do
--             if item.valid == 1 then
--                 valid = valid + 1
--             end
--         end
--         if valid > 0 then
--             return ('%s%s %s:%s'):format(hl.component_format_highlight(self.qf_counter), 'QF', qf_values.idx, valid)
--         end
--     end
--     return ''
-- end

-- -- Current vi mode ------>
-- local vi_mode_hl = function()
--   return {
--     fg = sett.text,
--     bg = mode_colors[vim.fn.mode()][2],
--     style = "bold",
--   }
-- end
--
-- components.active[1][1] = {
-- 	provider = " " .. assets.mode_icon .. " ",
-- 	hl = function()
-- 		return {
-- 			fg = sett.text,
-- 			bg = mode_colors[vim.fn.mode()][2],
-- 		}
-- 	end,
-- }
-- components.active[1][2] = {
-- 	provider = function() return mode_colors[vim.fn.mode()][1] .. " " end,
-- 	hl = vi_mode_hl,
-- }
-- { "selectioncount", fmt = function(str) return str ~= "" and "礪" .. str or "" end },

local status_comps = vim.deepcopy(defaults)
table.insert(status_comps.active[1], 3, custom_status_comps.ProjectComponent)
status_comps.active[1][4].left_sep = {
  hl = {
    -- bg = require('feline.providers.vi_mode').get_mode_color(),
    bg = "oceanblue",
  },
  str = " ",
}

-- { provider = 'diagnostic_errors', hl = { fg = 'red' } },
-- { provider = 'diagnostic_warnings', hl = { fg = 'yellow' } },
-- { provider = 'diagnostic_hints', hl = { fg = 'cyan' } }
-- { provider = 'diagnostic_info', hl = { fg = 'skyblue' } },
table.insert(status_comps.active[1], 7, custom_status_comps.AsciiComponent)
table.insert(status_comps.active[1], 8, custom_status_comps.LineCountComponent)
-- -- status_comps.active[2][2] = custom_status_comps.NeoComposerComponent
-- status_comps.active[2][1] = custom_status_comps.HelpTagsComponent
-- status_comps.active[2][2] = custom_status_comps.LspReferencesComponent
-- status_comps.active[2][2] = custom_status_comps.LspCodeActionsComponent
status_comps.active[2][1] = custom_status_comps.MacroComponent
-- status_comps.active[2][2] = custom_status_comps.FelineCmdComponent
status_comps.active[2][2] = custom_status_comps.FiletypeComponent
status_comps.active[2][3] = custom_status_comps.NoiceComponent
status_comps.active[2][4] = custom_status_comps.GitBranchComponent
status_comps.active[2][5] = custom_status_comps.GitDiffAddedComponent
status_comps.active[2][6] = custom_status_comps.GitDiffChangedComponent
status_comps.active[2][7] = custom_status_comps.GitDiffRemovedComponent
status_comps.active[2][8] = custom_status_comps.SearchCountComponent
status_comps.active[2][9] = custom_status_comps.LinePercentageComponent
status_comps.active[2][10] = custom_status_comps.ScrollBarComponent

local statusline_cfg = {
  components = status_comps,
  colors = { bg = colors.main.bg, fg = colors.main.fg },
  vi_mode_colors = colors.vi_mode,
  separators = {
    vertical_bar = "┃",
    vertical_bar_thin = "│",
    left = "",
    right = "",
    block = "█",
    left_filled = "",
    right_filled = "",
    slant_left = "",
    slant_left_thin = " ",
    slant_right = "",
    slant_right_thin = " ",
    slant_left_2 = "",
    slant_left_2_thin = " ",
    slant_right_2 = "",
    slant_right_2_thin = " ",
    left_rounded = "",
    left_rounded_thin = "",
    right_rounded = "",
    right_rounded_thin = "",
    circle = "●",
  },
  force_inactive = {
    filetypes = {
      "^NvimTree$",
      "^fugitive$",
      "^fugitiveblame$",
      "^help$",
      "^neo-tree",
      "^packer$",
      "^qf$",
      "^query",
      "^spectre_panel",
      "^startify$",
      "^Telescope",
      "^tablegen$",
      "^tsplayground$",
    },
    buftypes = {
      "^nofile$",
      "^terminal$",
    },
    bufnames = {},
  },
  custom_providers = custom_providers,
}
require("feline").setup(statusline_cfg)

vim.api.nvim_create_user_command("FelineRestart", function()
  require("feline").setup(statusline_cfg)
end, { desc = "Restart feline status line" })
