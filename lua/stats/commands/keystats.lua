local function length(T)
  local count = 0
  for _ in pairs(T) do
    count = count + 1
  end
  return count
end

local M = {}
local wkutils = require("whichkey-utils")

-- M.whichkey_lists = { conflicts = {}, duplicates = {}, ok = {}, todo = {} }
-- n v x s o m i l c t
M.get_counts = function()
  local mapper = require("mapper")
  local stats = wkutils.get_stats()
  local stats = {
    neovim = {
      normal = length(vim.api.nvim_get_keymap("n")),
      insert = length(vim.api.nvim_get_keymap("i")),
      command = length(vim.api.nvim_get_keymap("c")),
      operator = length(vim.api.nvim_get_keymap("o")),
      visual = length(vim.api.nvim_get_keymap("v")),
    },
    mapper = mapper.stats,
    whichkey = {
      total = stats.whichkey.ok.total,
      normal = 0,
      insert = 0,
      command = 0,
      operator = 0,
      visual = 0,
    },
    whichkey_todo = {
      total = stats.whichkey.todo.total,
      normal = 0,
      insert = 0,
      command = 0,
      operator = 0,
      visual = 0,
    },
    duplicates = {
      total = stats.whichkey.duplicates.total,
      normal = 0,
      insert = 0,
      command = 0,
      operator = 0,
      visual = 0,
    },
    conflicts = {
      total = stats.whichkey.conflicts.total,
      normal = 0,
      insert = 0,
      command = 0,
      operator = 0,
      visual = 0,
    },
    -- mapper_todo = {},
    -- whichkey_group = {},
    -- whichkey_nogroup = {}
  }
  stats.mapper.total = stats.mapper.normal
    + stats.mapper.visual
    + stats.mapper.insert
    + stats.mapper.operator
    + stats.mapper.command

  stats.neovim.total = stats.neovim.normal
    + stats.neovim.visual
    + stats.neovim.insert
    + stats.neovim.operator
    + stats.neovim.command

  return stats
end

return M

-- :map   :noremap  :unmap     Normal, Visual, Select, Operator-pending
-- :nmap  :nnoremap :nunmap    Normal
-- :vmap  :vnoremap :vunmap    Visual and Select
-- :smap  :snoremap :sunmap    Select
-- :xmap  :xnoremap :xunmap    Visual
-- :omap  :onoremap :ounmap    Operator-pending
-- :map!  :noremap! :unmap!    Insert and Command-line
-- :imap  :inoremap :iunmap    Insert
-- :lmap  :lnoremap :lunmap    Insert, Command-line, Lang-Arg
-- :cmap  :cnoremap :cunmap    Command-line
-- :tmap  :tnoremap :tunmap    Terminal
