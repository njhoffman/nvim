-- https://raw.githubusercontent.com/nvim-telescope/telescope.nvim/master/README.md
local telescope = require("telescope")

local commands = require("configs.telescope.commands")
local mappings = require("configs.telescope.mappings")
local pickers = require("configs.telescope.pickers")
local extensions = require("configs.telescope.extensions")
local display_path = require("configs.telescope.display-path")

local basecfg = {
  scrolling_limit = 20000,
  wrap_results = false,
  selection_caret = "▶ ",
  multi_icon = "󰒆 ", --  '◆ 󰒆 ',
  prompt_prefix = " 🔍 ", -- " 🔍 ",'   '
  cycle_layout_list = { "flex", "horizontal", "vertical", "bottom_pane", "center" },
  cache_picker = {
    num_pickers = 10,
    limit_entries = 2000,
  },
  history = {
    handler = require("telescope._extensions.pickers_history.handler").get_history,
    path = vim.fn.stdpath("data") .. "/databases/telescope_history.sqlite3",
    limit = 2000,
  },
  vimgrep_arguments = commands.vimgrep,
  find_command = commands.rg,
  selection_strategy = "reset", -- follow, reset, row
  sorting_strategy = "ascending",
  scroll_strategy = "cycle",
  color_devicons = true,
  use_less = true,
  set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,   color_devicons = true,
  mappings = mappings.main,
  -- generic_sorter = sorters.get_generic_fuzzy_sorter,
  generic_sorter = require("mini.fuzzy").get_telescope_sorter,
  file_sorter = require("mini.fuzzy").get_telescope_sorter,
  -- file_sorter = sorters.get_substr_matcher,
  -- file_sorter = sorters.fuzzy_with_index_bias,
  -- file_sorter = sorters.native_fzf_sorter,
  include_extensions = true,
  path_display = display_path.init("simple"),
  file_ignore_patterns = {
    "%.pdf$",
    "%.png$",
    "%.gif$",
    "%.jpe?g$",
    "%.icns$",
    "%.pxd$",
    "%.zip$",
    "%.plist$",
    -- other ignores are defined via .gitignore, .ignore, /fd/ignore, or /git/ignore
  },
  -- grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
  -- file_previewer = require("telescope.previewers").vim_buffer_cat.new,
  -- qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
  -- buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
}
local layout_config = vim.tbl_deep_extend("force", basecfg, require("telescope._layouts.default"))
local telescope_config = {
  defaults = layout_config,
  pickers = pickers,
  extensions = extensions.get(),
}

telescope.setup(telescope_config)
extensions.load()

local group = vim.api.nvim_create_augroup("Hacks", { clear = true })
-- https://github.com/nvim-telescope/telescope.nvim/issues/2890
-- https://github.com/nvim-telescope/telescope.nvim/issues/2995
-- https://github.com/neovim/neovim/issues/27038
-- vim.api.nvim_create_autocmd("WinLeave", {
--   callback = function()
--     if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
--       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
--       -- local status, cmp = pcall(require, "cmp")
--       -- if status and cmp and cmp.close then
--       --   cmp.close()
--       -- end
--       vim.cmd([[stopinsert]])
--       -- vim.cmd.normal({ 'g`"zz', bang = true })
--       vim.cmd.redraw()
--       vim.cmd.redrawstatus()
--     end
--   end,
--   group = group,
-- })
