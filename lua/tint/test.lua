-- https://github.com/sunjon/Shade.nvim
-- https://github.com/miversen33/sunglasses.nvim
-- https://github.com/nvim-zh/colorful-winsep.nvim
-- https://github.com/levouh/tint.nvim/pull/54

local total_width = 20
local excluded_hls = { "WinSeparator", { "lualine_.*", glob = true } }
local excluded_ft = {
  -- "DiffviewFileHistory",
  -- "DiffviewFiles",
  -- "DressingInput",
  -- "Navbuddy",
  -- "NeogitPopup",
  -- "NeogitStatus",
  -- "NvimTree",
  -- "Outline",
  -- "OverseerList",
  -- "TelescopePrompt",
  -- "alpha",
  -- "better_term",
  -- "checkhealth",
  -- "dashboard",
  -- "fugitiveblame",
  -- "lazy",
  -- "lspsagafinder",
  -- "mason",
  -- "neo-tree",
  -- "noice",
  -- "notify",
  -- "packer",
  -- "plugin",
  -- "registers",
  -- "saga_codeaction",
  -- "sagafinder",
  -- "sagarename",
  -- "spectre_panel",
  -- "starter",
  -- "startuptime",
  -- "toggleterm",
  -- "zsh",
}

local utils = require("tint.utils")
local tint = require("tint")
local tint_hls = require("tint.highlights")
local cmds = require("tint.test_commands")

local build_virtual_text = function(bufnr, range, highlights)
  bufnr = bufnr or 0
  local virt_text = {}

  -- [61] = { anon = "chunk", name = "boolean", range = { [1] = 51, [2] = 73, [3] = 51, [4] = 76, n = 4 }, text = "true" },
  for _, hl in ipairs(highlights.ts) do
  end
  -- vim.api.nvim_buf_set_extmark(bufnr, ns_id, line, col, opts)
end

local tint_cfg = {
  -- tint = -45, -- Darken colors, use a positive value to brighten
  -- saturation = 0.5, -- Saturation to preserve
  focus_change_events = { focus = { "WinEnter" }, unfocus = { "WinLeave" } },
  tint_background_colors = false,
  transforms = {
    require("tint.transforms").tint_with_threshold(-60, "#041026", 150),
    -- Try to tint by `-100`, but keep all colors at least `150` away from `#1C1C1C`
    require("tint.transforms").saturate(0.3),
  },
}

local ns_opts = { filter = { has_hls = true, has_leaked = false }, sort = "name" }

utils.list_namespaces(ns_opts)
cmds.setup_tint(tint_cfg)
utils.list_namespaces(ns_opts)

vim.keymap.set("n", "<F10>", cmds.toggle_tint, { noremap = true, nowait = true })
vim.keymap.set("n", "<F12>", tint.debuginfo, { noremap = true, nowait = true })

local range_1 = { { 50, 0 }, { 51, 0 } }
-- local buf_lines = vim.api.nvim_buf_line_count(0)

local ns_name1, buf_range, hls = tint_hls.buffer_overlay(0, range_1, {
  name = "search_1",
  transform = { opacity = 0.9 },
})
vim.dbglog("ns", ns_name1, buf_range, highlights and #highlights or "")
utils.list_namespaces(ns_opts)
-- ns _tint_7_search_14
-- [57] = { anon = "chunk", name = "boolean", range = { [1] = 51, [2] = 75, [3] = 51, [4] = 78, n = 4 }, text = "true" },
-- [58] = { anon = "chunk", name = "constructor", range = { [1] = 51, [2] = 80, [3] = 51, [4] = 80, n = 4 }, text = "}" },
-- build_virtual_text(bufnr, buf_range, hls)
-- vim.dbglog("**", ns_id1, buf, buf_range, hls)
-- local range_2 = parse_range({ 50, 10 }, { 53, 0 })
