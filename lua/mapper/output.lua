local records = require('mapper.records')
local stats = require('mapper.stats')

local function stats_table()
  local lines = {}
  local p = function(line)
    table.insert(lines, line)
  end

  p('             total normal visual insert operator command select term vis_sel')
  p('-----------------------------------------------------------------------------')

  local function gen_row(name, keymap)
    p(
      (name .. ' %4d   %4d   %4d   %4d    %4d   %4d   %4d   %4d   %4d'):format(
        keymap.total,
        keymap.normal,
        keymap.visual,
        keymap.insert,
        keymap.operator,
        keymap.command,
        keymap.select,
        keymap.terminal,
        keymap.vis_select
      )
    )
  end

  local s = stats.get_stats()
  gen_row('neovim      ', s.neovim)
  gen_row('mapper      ', s.mapper)
  gen_row('wk ok       ', s.whichkey.ok)
  gen_row('wk todo     ', s.whichkey.todo)
  gen_row('wk dupes    ', s.whichkey.duplicates)
  gen_row('wk conflicts', s.whichkey.conflicts)
  return lines
end

local tree_log = function()
  vim.dbglog(records.tree)
end

local tree_notify = function()
  vim.dbg(records.tree)
end

local table_log = function()
  vim.dbglog(stats_table())
end

local table_notify = function()
  vim.dbg(stats_table())
end

local list_log = function()
  vim.dbglog(records.list)
end

local list_notify = function()
  vim.dbg(records.list)
end

return {
  table_log = table_log,
  table_notify = table_notify,
  tree_log = tree_log,
  tree_notify = tree_notify,
  list_log = list_log,
  list_notify = list_notify,
}
