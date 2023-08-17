local wkutils = require('mapper.whichkey')

-- local function total(counts)
--   return counts.normal + counts.visual + counts.insert + counts.operator + counts.command
-- end
--
-- local function length(T)
--   local count = 0
--   if type(T) == 'table' then
--     for _ in pairs(T) do
--       count = count + 1
--     end
--   end
--   return count
-- end
--
-- local modes_map = {
--   ['n'] = { 'normal' },
--   ['i'] = { 'insert' },
--   ['c'] = { 'command' },
--   ['v'] = { 'visual' },
--   ['s'] = { 'select' },
--   ['o'] = { 'operator' },
--   ['t'] = { 'terminal' },
--   ['x'] = { 'visual_select', { 's', 'v' } },
--   ['!'] = { 'map_bang', { 'i', 'c' } },
--   [''] = { 'map', { 'n', 'v', 'o' } },
-- }
--
-- local default_modes = { 'n', 'i', 'c', 'v', 's', 'o', 't', 'x' }
-- local neovim_stats = function(modes)
--   modes = modes or default_modes
--   local stats = {}
--   for _, mode in ipairs(modes) do
--     stats[modes_map[mode][1]] = length(vim.api.nvim_get_keymap(mode))
--   end
--   stats.total = total(stats)
--   return stats
-- end
--
-- local whichkey_stats = function(modes)
--   modes = modes or default_modes
--
--   local todo, ok, conflicts, dupes = wkutils.dump()
--   local whichkey = { ok = {}, todo = {}, conflicts = {}, dupes = {} }
--   for _, mode in ipairs(modes) do
--     whichkey.ok[modes_map[mode][1]] = length(ok[mode])
--     whichkey.todo[modes_map[mode][1]] = length(todo[mode])
--     whichkey.duplicates[modes_map[mode][1]] = length(dupes[mode])
--     whichkey.conflicts[modes_map[mode][1]] = 0
--   end
--   whichkey.ok.total = total(whichkey.ok)
--   whichkey.todo.total = total(whichkey.todo)
--   whichkey.duplicates.total = total(whichkey.duplicates)
--
--   for _, conflict_group in pairs(conflicts) do
--     for mode in pairs(conflict_group) do
--       whichkey.conflicts[modes_map[mode][1]] = whichkey.conflicts[modes_map[mode][1]] + 1
--     end
--   end
--   whichkey.conflicts.total = total(whichkey.conflicts)
--   return whichkey
-- end

-- local get_stats = function()
--   local keystats = {
--     -- mapper = require('mapper').stats,
--     whichkey = whichkey_stats(),
--     neovim = neovim_stats(),
--   }
--   return keystats
-- end

local wk_keys = require('which-key.keys')

local get_stats = function()
  local function length(T)
    local count = 0
    if type(T) == 'table' then
      for _ in pairs(T) do
        count = count + 1
      end
    end
    return count
  end

  local function total(counts)
    return counts.normal
      + counts.visual
      + counts.insert
      + counts.operator
      + counts.command
      + counts.select
      + counts.vis_select
      + counts.terminal
  end

  local maptree = require('mapper').tree
  local mapper = {
    normal = length(maptree['n']),
    insert = length(maptree['i']),
    command = length(maptree['c']),
    operator = length(maptree['o']),
    visual = length(maptree['v']),
    select = length(maptree['s']),
    terminal = length(maptree['t']),
    vis_select = length(maptree['x']),
  }
  mapper.total = total(mapper)

  local neovim = {
    normal = length(vim.api.nvim_get_keymap('n')),
    insert = length(vim.api.nvim_get_keymap('i')),
    command = length(vim.api.nvim_get_keymap('c')),
    operator = length(vim.api.nvim_get_keymap('o')),
    visual = length(vim.api.nvim_get_keymap('v')),
    select = length(vim.api.nvim_get_keymap('s')),
    terminal = length(vim.api.nvim_get_keymap('t')),
    vis_select = length(vim.api.nvim_get_keymap('x')),
  }
  neovim.total = total(neovim)

  local todo, ok, conflicts, dupes = wkutils.dump()
  local whichkey = {}
  whichkey.ok = {
    normal = length(ok.n),
    insert = length(ok.i),
    command = length(ok.c),
    operator = length(ok.o),
    visual = length(ok.v),
    select = length(ok.s),
    terminal = length(ok.t),
    vis_select = length(ok.x),
  }
  whichkey.ok.total = total(whichkey.ok)
  whichkey.todo = {
    normal = length(todo.n),
    insert = length(todo.i),
    command = length(todo.c),
    operator = length(todo.o),
    visual = length(todo.v),
    select = length(todo.s),
    terminal = length(todo.t),
    vis_select = length(todo.x),
  }
  whichkey.todo.total = total(whichkey.todo)
  whichkey.duplicates = {
    normal = length(dupes.n),
    insert = length(dupes.i),
    command = length(dupes.c),
    operator = length(dupes.o),
    visual = length(dupes.v),
    select = length(dupes.s),
    terminal = length(dupes.t),
    vis_select = length(dupes.x),
  }
  whichkey.duplicates.total = total(whichkey.duplicates)

  local conf_count = {
    normal = 0,
    insert = 0,
    command = 0,
    operator = 0,
    visual = 0,
    select = 0,
    vis_select = 0,
    terminal = 0,
  }
  for _, conflict_group in pairs(conflicts) do
    for mode in pairs(conflict_group) do
      if mode == 'n' then
        conf_count.normal = conf_count.normal + 1
      elseif mode == 'i' then
        conf_count.insert = conf_count.insert + 1
      elseif mode == 'c' then
        conf_count.command = conf_count.command + 1
      elseif mode == 'o' then
        conf_count.operator = conf_count.operator + 1
      elseif mode == 'v' then
        conf_count.visual = conf_count.visual + 1
      elseif mode == 's' then
        conf_count.select = conf_count.select + 1
      elseif mode == 'x' then
        conf_count.vis_select = conf_count.vis_select + 1
      elseif mode == 't' then
        conf_count.terminal = conf_count.terminal + 1
      end
    end
  end
  whichkey.conflicts = conf_count
  whichkey.conflicts.total = total(whichkey.conflicts)
  return { neovim = neovim, whichkey = whichkey, mapper = mapper }
end

local function dump_out(opt)
  local todo, ok, conflicts = dump()
  opt = opt
    or {
      -- key_types = { "todo", "ok", "duplicates", "conflicts" },
      key_types = { 'conflicts' },
      output = 'notify', -- buffer, echo, file
    }

  local lines = {}

  if vim.tbl_contains(opt.key_types, 'ok') then
    for mode, keys in pairs(ok) do
      for key, def in pairs(keys) do
        table.insert(lines, 'ok:   (' .. mode .. ') "' .. key .. '" ' .. def)
      end
    end
  end

  if vim.tbl_contains(opt.key_types, 'todo') then
    for mode, keys in pairs(todo) do
      for key, def in pairs(keys) do
        table.insert(lines, 'todo: (' .. mode .. ') ' .. '"' .. key .. '" ' .. def)
      end
    end
  end

  if vim.tbl_contains(opt.key_types, 'duplicates') then
    for _, dup in pairs(wk_keys.duplicates) do
      local msg = ''
      if dup.buf == dup.other.buffer then
        msg = 'dupe: '
      else
        -- msg = "buffer-local keymap overriding global:"
        msg = 'dupe local:'
      end
      -- msg = (msg .. " (**%q**) buf: %d, lhs: **%q**"):format(dup.mode, dup.buf or 0, dup.prefix)
      msg = (msg .. ' (**%s**) buf: %d, lhs: **%s**'):format(dup.mode, dup.buf or 0, dup.prefix)
      table.insert(lines, msg)
    end
  end

  if vim.tbl_contains(opt.key_types, 'conflicts') then
    local sorted_conflicts = {}
    for prefix, _conflicts in pairs(conflicts) do
      for mode, conflict in pairs(_conflicts) do
        conflict.mode = mode
        conflict.prefix = prefix
        table.insert(sorted_conflicts, conflict)
      end
    end
    table.sort(sorted_conflicts, function(a, b)
      return a.prefix_n < b.prefix_n
    end)
    for _, conflict in ipairs(sorted_conflicts) do
      local children = conflict.children and (conflict.children .. 'x') or ''
      local rhs_label = conflict.group and 'rhs-group' or 'rhs'
      -- local msg = ("conf: (%q) %2s lhs: %q, rhs: %q"):format(mode, children, prefix, conflict.cmd or "")
      local msg = ('conf: (%s) %2s lhs: %s   %s: %s'):format(
        conflict.mode,
        children,
        conflict.prefix_n,
        rhs_label,
        conflict.cmd or ''
      )
      table.insert(lines, msg)
    end
  end

  return lines
end

return {
  dump_out = dump_out,
  get_stats = get_stats,
}
