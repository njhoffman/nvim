local Mapper = require("mappings.mapper")

local M = {}

local function length(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function M.stats()
  -- local whichkeys = Mapper.whichkey_dump()
  -- local conflicts = Mapper.whichkey_conflicts()
  -- local duplicates = Mapper.whichkey_duplicates()

  local stats = {
    neovim = {
      normal   = length(vim.api.nvim_get_keymap('n')),
      insert   = length(vim.api.nvim_get_keymap('i')),
      command  = length(vim.api.nvim_get_keymap('c')),
      operator = length(vim.api.nvim_get_keymap('o')),
      visual   = length(vim.api.nvim_get_keymap('v')),
    },
    mapper = Mapper.stats,
    whichkey = {
      total    = length(Mapper.whichkey_lists.ok),
      normal   = 0,
      insert   = 0,
      command  = 0,
      operator = 0,
      visual   = 0
    },
    whichkey_todo = {
      total    = length(Mapper.whichkey_lists.todo),
      normal   = 0,
      insert   = 0,
      command  = 0,
      operator = 0,
      visual   = 0
    },
    duplicates = {
      total    = length(Mapper.whichkey_lists.duplicates),
      normal   = 0,
      insert   = 0,
      command  = 0,
      operator = 0,
      visual   = 0
    },
    conflicts = {
      total    = length(Mapper.whichkey_lists.conflicts),
      normal   = 0,
      insert   = 0,
      command  = 0,
      operator = 0,
      visual   = 0
    },
    -- mapper_todo = {},
    -- whichkey_group = {},
    -- whichkey_nogroup = {}
  }
  stats.mapper.total = stats.mapper.normal + stats.mapper.visual + stats.mapper.insert + stats.mapper.operator + stats.mapper.command
  stats.neovim.total = stats.neovim.normal + stats.neovim.visual + stats.neovim.insert + stats.neovim.operator + stats.neovim.command

  print("                    total  normal  visual  insert  operator  command ")
  print("---------------------------------------------------------------------")
  print(("neovim               %4d    %4d     %4d     %4d     %4d     %4d     "):format(stats.neovim.total, stats.neovim.normal, stats.neovim.visual, stats.neovim.insert, stats.neovim.operator, stats.neovim.command))
  print(("mapper               %4d    %4d     %4d     %4d     %4d     %4d     "):format(stats.mapper.total, stats.mapper.normal, stats.mapper.visual, stats.mapper.insert, stats.mapper.operator, stats.mapper.command))
  print(("whichkey             %4d    %4d     %4d     %4d     %4d     %4d     "):format(stats.whichkey.total, stats.whichkey.normal, stats.whichkey.visual, stats.whichkey.insert, stats.whichkey.operator, stats.whichkey.command))
  print(("whichkey todo        %4d    %4d     %4d     %4d     %4d     %4d     "):format(stats.whichkey_todo.total, stats.whichkey_todo.normal, stats.whichkey_todo.visual, stats.whichkey_todo.insert, stats.whichkey_todo.operator, stats.whichkey_todo.command))
  print(("conflicts            %4d    %4d     %4d     %4d     %4d     %4d     "):format(stats.conflicts.total, stats.conflicts.normal, stats.conflicts.visual, stats.conflicts.insert, stats.conflicts.operator, stats.conflicts.command))
  print(("duplicates           %4d    %4d     %4d     %4d     %4d     %4d     "):format(stats.duplicates.total, stats.duplicates.normal, stats.duplicates.visual, stats.duplicates.insert, stats.duplicates.operator, stats.duplicates.command))
end

M.stats()
return M
