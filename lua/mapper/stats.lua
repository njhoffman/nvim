local wkutils = require("mapper.whichkey")
local function total(counts)
  return counts.normal + counts.visual + counts.insert + counts.operator + counts.command
end

local function length(T)
  local count = 0
  if type(T) == "table" then
    for _ in pairs(T) do
      count = count + 1
    end
  end
  return count
end

local modes_map = {
  ["n"] = { "normal" },
  ["i"] = { "insert" },
  ["c"] = { "command" },
  ["v"] = { "visual" },
  ["s"] = { "select" },
  ["o"] = { "operator" },
  ["t"] = { "terminal" },
  ["x"] = { "visual_select", { "s", "v" } },
  ["!"] = { "map_bang", { "i", "c" } },
  [""] = { "map", { "n", "v", "s", "o" } },
}

local default_modes = { "n", "i", "c", "v", "s", "o", "t", "x" }
local neovim_stats = function(modes)
  modes = modes or default_modes
  local stats = {}
  for _, mode in ipairs(modes) do
    stats[modes_map[mode][1]] = length(vim.api.nvim_get_keymap(mode))
  end
  stats.total = total(stats)
  return stats
end

local whichkey_stats = function(modes)
  modes = modes or default_modes

  local todo, ok, conflicts, dupes = wkutils.dump()
  local whichkey = { ok = {}, todo = {}, conflicts = {}, dupes = {} }
  for _, mode in ipairs(modes) do
    whichkey.ok[modes_map[mode][1]] = length(ok[mode])
    whichkey.todo[modes_map[mode][1]] = length(todo[mode])
    whichkey.duplicates[modes_map[mode][1]] = length(dupes[mode])
    whichkey.conflicts[modes_map[mode][1]] = 0
  end
  whichkey.ok.total = total(whichkey.ok)
  whichkey.todo.total = total(whichkey.todo)
  whichkey.duplicates.total = total(whichkey.duplicates)

  for _, conflict_group in pairs(conflicts) do
    for mode in pairs(conflict_group) do
      whichkey.conflicts[modes_map[mode][1]] = whichkey.conflicts[modes_map[mode][1]] + 1
    end
  end
  whichkey.conflicts.total = total(whichkey.conflicts)
  return whichkey
end

local get_stats = function()
  local keystats = {
    -- mapper = require('mapper').stats,
    whichkey = whichkey_stats(),
    neovim = neovim_stats(),
  }
  return keystats
end

local stats_out = function()
  local lines = {}
  local p = function(line)
    table.insert(lines, line)
  end

  local s = get_stats()

  p("                   total normal visual insert operator command")
  p("--------------------------------------------------------------")
  p(
    ("neovim             %4d   %4d   %4d   %4d    %4d    %4d "):format(
      s.neovim.total,
      s.neovim.normal,
      s.neovim.visual,
      s.neovim.insert,
      s.neovim.operator,
      s.neovim.command
    )
  )
  -- p(
  --   ("mapper             %4d   %4d   %4d   %4d    %4d    %4d "):format(
  --     s.mapper.total,
  --     s.mapper.normal,
  --     s.mapper.visual,
  --     s.mapper.insert,
  --     s.mapper.operator,
  --     s.mapper.command
  --   )
  -- )
  p(
    ("whichkey ok        %4d   %4d   %4d   %4d    %4d    %4d "):format(
      s.whichkey.ok.total,
      s.whichkey.ok.normal,
      s.whichkey.ok.visual,
      s.whichkey.ok.insert,
      s.whichkey.ok.operator,
      s.whichkey.ok.command
    )
  )
  p(
    ("whichkey todo      %4d   %4d   %4d   %4d    %4d    %4d "):format(
      s.whichkey.todo.total,
      s.whichkey.todo.normal,
      s.whichkey.todo.visual,
      s.whichkey.todo.insert,
      s.whichkey.todo.operator,
      s.whichkey.todo.command
    )
  )
  p(
    ("whichkey conflicts %4d   %4d   %4d   %4d    %4d    %4d "):format(
      s.whichkey.conflicts.total,
      s.whichkey.conflicts.normal,
      s.whichkey.conflicts.visual,
      s.whichkey.conflicts.insert,
      s.whichkey.conflicts.operator,
      s.whichkey.conflicts.command
    )
  )
  p(
    ("whichkey dupes     %4d   %4d   %4d   %4d    %4d    %4d "):format(
      s.whichkey.duplicates.total,
      s.whichkey.duplicates.normal,
      s.whichkey.duplicates.visual,
      s.whichkey.duplicates.insert,
      s.whichkey.duplicates.operator,
      s.whichkey.duplicates.command
    )
  )
  return lines
end

return { get = get_stats, out = stats_out }
