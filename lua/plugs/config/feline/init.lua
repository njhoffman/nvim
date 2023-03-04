local defaults = require("feline.default_components").statusline.icons
local winbar_defaults = require("feline.default_components").winbar.icons

local provider_project_uo = require("plugs.config.feline.provider-project-uo")
local custom_status_comps = require("plugs.config.feline.components")
local colors = require("plugs.config.feline.colors")

local status_comps = vim.deepcopy(defaults)
local winbar_comps = vim.deepcopy(winbar_defaults)

table.insert(status_comps.active[1], 3, custom_status_comps.ProjectUoComponent)
status_comps.active[1][4].left_sep = { hl = { bg = "oceanblue" }, str = " " }
table.insert(status_comps.active[1], 7, custom_status_comps.AsciiComponent)
table.insert(status_comps.active[1], 8, custom_status_comps.FiletypeComponent)
status_comps.active[2][1] = custom_status_comps.GitBranchComponent
status_comps.active[2][2] = custom_status_comps.GitDiffAddedComponent
status_comps.active[2][3] = custom_status_comps.GitDiffChangedComponent
status_comps.active[2][4] = custom_status_comps.GitDiffRemovedComponent

-- local treesitter_context = require("modules.lang.treesitter").context
--
-- function M.eval()
--   local columns = vim.api.nvim_get_option("columns")
--   if not pcall(require, "lsp_signature") then
--     return treesitter_context(columns)
--   end
--   local sig = require("lsp_signature").status_line(columns)
--
--   if sig == nil or sig.label == nil or sig.range == nil then
--     return treesitter_context(columns)
--   end
--   local label1 = sig.label
--   local label2 = ""
--   if sig.range then
--     label1 = sig.label:sub(1, sig.range["start"] - 1)
--     label2 = sig.label:sub(sig.range["end"] + 1, #sig.label)
--   end
--   local doc = sig.doc or ""
--   if #doc + #sig.label >= columns then
--     local trim = math.max(5, columns - #sig.label - #sig.hint - 10)
--     doc = doc:sub(1, trim) .. "..."
--     -- lprint(doc)
--   end
--
--   return "%#WinBarSignature#"
--       .. label1
--       .. "%*"
--       .. "%#WinBarSigActParm#"
--       .. sig.hint
--       .. "%*"
--       .. "%#WinBarSignature#"
--       .. label2
--       .. "%*"
--       .. "%#WinBarSigDoc#"
--       .. " "
--       .. doc
--     or "" .. "%*"
-- end

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
    slant_right = " ",
    slant_right_thin = " ",
    slant_left_2 = " ",
    slant_left_2_thin = " ",
    -- slant_right_2 = " ",
    slant_right_2 = " ",
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
      "^packer$",
      "^startify$",
      "^fugitive$",
      "^fugitiveblame$",
      "^qf$",
      "^help$",
    },
    buftypes = {
      "^terminal$",
    },
    bufnames = {},
  },
  custom_providers = {
    project_uo = provider_project_uo.provider,
  },
}
-- vim.api.nvim_set_hl(0, "WinBarSignature", { fg = "#dedede", bg = "#363636" })
-- vim.api.nvim_set_hl(0, "WinBarSigDoc", { fg = "#dedede", bg = "#363636" })
-- vim.api.nvim_set_hl(0, "WinBarSigActParm", { fg = "#dedede", bg = "#9f3838" })

require("feline").setup(statusline_cfg)

local winbar_cfg = {
  colors = { bg = colors.main.bg, fg = colors.main.fg },
  vi_mode_colors = colors.vi_mode,
  components = winbar_comps,
}
-- require("feline").winbar.setup(winbar_cfg)
