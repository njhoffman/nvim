local wk = require("which-key")
local Mapper = require("mappings.mapper")

local function length(T)
  local count = 0
  for _ in pairs(T) do
    count = count + 1
  end
  return count
end

local M = {}

M.get_whichkey_lists = function()
  local wk_keys = require("which-key.keys")
  local wk_lists = {conflicts = {}, duplicates = {}, ok = {}, todo = {}}

  local conflicts = {}
  for _, tree in pairs(wk_keys.mappings) do
    wk_keys.update_keymaps(tree.mode, tree.buf)
    tree.tree:walk(
      function(node)
        local count = 0
        for _ in pairs(node.children) do
          count = count + 1
        end
        local auto_prefix = not node.mapping or (node.mapping.group == true and not node.mapping.cmd)
        if node.prefix ~= "" and count > 0 and not auto_prefix then
          local cmd = node.mapping.cmd or " "
          table.insert(conflicts, {mode = tree.mode, lhs = node.mapping.prefix, rhs = cmd})
        end
      end
    )
  end

  wk_lists.conflicts = conflicts

  local ok = {}
  local todo = {}
  for _, tree in pairs(wk_keys.mappings) do
    local bufnr = tree.buf
    if bufnr == nil then
      bufnr = "root"
    end
    tree.tree:walk(
      function(node)
        if node.mapping then
          if node.mapping.label then
            if type(ok[node.mapping.prefix]) == "nil" then
              ok[node.mapping.prefix] = {}
            end
            table.insert(ok[node.mapping.prefix], bufnr)
            todo[node.mapping.prefix] = nil
          elseif not ok[node.mapping.prefix] then
            if type(todo[node.mapping.prefix]) ~= "nil" then
              table.insert(todo[node.mapping.prefix].buffers, bufnr)
            else
              todo[node.mapping.prefix] = {buffers = {bufnr}, cmd = node.mapping.cmd or ""}
            end
          end
        end
      end
    )
  end

  wk_lists.todo = todo
  wk_lists.ok = ok

  local duplicates = {}
  for _, dup in pairs(wk_keys.duplicates) do
    table.insert(
      duplicates,
      {
        old_rhs = dup.other.rhs,
        rhs = dup.cmd or "",
        mode = dup.mode,
        lhs = dup.prefix,
        other_buffer = (dup.buf ~= dup.other.buffer)
      }
    )
  end

  wk_lists.duplicates = duplicates
  -- print(vim.inspect(M.wk_lists))
  return wk_lists
end

M.get_counts = function()
  local wk_lists = M.get_whichkey_lists()
  -- M.whichkey_lists = { conflicts = {}, duplicates = {}, ok = {}, todo = {} }
  -- n v x s o m i l c t
  local stats = {
    neovim = {
      normal = length(vim.api.nvim_get_keymap("n")),
      insert = length(vim.api.nvim_get_keymap("i")),
      command = length(vim.api.nvim_get_keymap("c")),
      operator = length(vim.api.nvim_get_keymap("o")),
      visual = length(vim.api.nvim_get_keymap("v"))
    },
    mapper = Mapper.stats,
    whichkey = {
      total = length(wk_lists.ok),
      normal = 0,
      insert = 0,
      command = 0,
      operator = 0,
      visual = 0
    },
    whichkey_todo = {
      total = length(wk_lists.todo),
      normal = 0,
      insert = 0,
      command = 0,
      operator = 0,
      visual = 0
    },
    duplicates = {
      total = length(wk_lists.duplicates),
      normal = 0,
      insert = 0,
      command = 0,
      operator = 0,
      visual = 0
    },
    conflicts = {
      total = length(wk_lists.conflicts),
      normal = 0,
      insert = 0,
      command = 0,
      operator = 0,
      visual = 0
    }
    -- mapper_todo = {},
    -- whichkey_group = {},
    -- whichkey_nogroup = {}
  }
  stats.mapper.total =
    stats.mapper.normal + stats.mapper.visual + stats.mapper.insert + stats.mapper.operator + stats.mapper.command
  stats.neovim.total =
    stats.neovim.normal + stats.neovim.visual + stats.neovim.insert + stats.neovim.operator + stats.neovim.command

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
