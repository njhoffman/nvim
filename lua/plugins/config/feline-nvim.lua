local feline = require('feline')
local custom_comps = require('plugins.config.feline-nvim-components')
local defaults = require('plugins.config.feline-default-components').statusline.icons
local colors = require('plugins.config.feline-nvim-colors')

local components = {
  active = {},
  inactive = {}
}


---@diagnostic disable
--@format disable
table.insert(components.active, {})
table.insert(components.active, {})
table.insert(components.active, {})
table.insert(components.inactive, {})
table.insert(components.inactive, {})
table.insert(components.inactive, {})

table.insert(defaults.active[1], 3, custom_comps.ProjectComponent)
-- table.insert(components.active[1], defaults.active.vi_mode.left)
-- table.insert(components.active[1], defaults.active[1])
-- table.insert(components.active[1], custom_comps.ProjectComponent)
-- table.insert(components.active[1], defaults.file.info)
-- table.insert(components.active[1], defaults.git.branch)
-- table.insert(components.active[1], defaults.git.add)
-- table.insert(components.active[1], defaults.git.change)
-- table.insert(components.active[1], defaults.git.remove)
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
    bufnames = {}
  },
  -- highlight_reset_triggers = { 'SessionLoadPost', 'ColorScheme' }
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
