local wk_keys = require("which-key.keys")
local M = {}

function M.dump()
  local ok = {}
  local todo = {}
  local conflicts = {}
  for _, tree in pairs(wk_keys.mappings) do
    wk_keys.update_keymaps(tree.mode, tree.buf)
    tree.tree:walk(
      ---@param node Node
      function(node)
        local count = 0
        for _ in pairs(node.children) do
          count = count + 1
        end
        local auto_prefix = not node.mapping or (node.mapping.group == true and not node.mapping.cmd)
        if node.prefix_i ~= "" and count > 0 and not auto_prefix then
          conflicts[node.mapping.prefix] = conflicts[node.mapping.prefix] or {}
          conflicts[node.mapping.prefix][tree.mode] = {
            group = node.mapping.group,
            cmd = node.mapping.cmd,
            label = node.mapping.label,
            opts = node.mapping.opts,
            prefix_n = node.prefix_n,
            prefix_i = node.prefix_i,
          }
          if count > 0 then
            conflicts[node.mapping.prefix][tree.mode].children = count
            -- for _, child in pairs(node.children) do
            --   local child_count = 0
            --   for _ in pairs(child.children) do
            --     child_count = child_count + 1
            --   end
            --   local child_prefix = not child.mapping or (child.mapping.group == true and not child.mapping.cmd)
            --
            --   if child.prefix_i ~= "" and child_count > 0 and not child_prefix then
            --     conflicts[child.mapping.prefix] = conflicts[child.mapping.prefix] or {}
            --
            --     conflicts[child.mapping.prefix][tree.mode] = {
            --       group = child.mapping.group,
            --       cmd = child.mapping.cmd,
            --       label = child.mapping.label,
            --       desc = child.mapping.desc,
            --       opts = child.mapping.opts,
            --       prefix_i = child.prefix_i,
            --       prefix_n = child.prefix_n,
            --     }
            --     if child_count > 0 then
            --       conflicts[child.mapping.prefix][tree.mode].children = child_count
            --     end
            --   end
            -- end
          end
        else
          if node.mapping then
            if node.mapping.label then
              ok[tree.mode] = ok[tree.mode] or {}
              todo[tree.mode] = todo[tree.mode] or {}
              ok[tree.mode][node.mapping.prefix] = node.mapping.label
              todo[tree.mode][node.mapping.prefix] = nil
            elseif not ok[node.mapping.prefix] then
              todo[tree.mode] = todo[tree.mode] or {}
              todo[tree.mode][node.mapping.prefix] = node.mapping.cmd or ""
            end
          end
        end
      end
    )
  end

  return todo, ok, conflicts, wk_keys.duplicates
end

M.get_stats = function()
  local function length(T)
    local count = 0
    if type(T) == "table" then
      for _ in pairs(T) do
        count = count + 1
      end
    end
    return count
  end
  local function total(counts)
    return counts.normal + counts.visual + counts.insert + counts.operator + counts.command
  end

  local mapper = require("mapper").stats
  mapper.total = total(mapper)

  local todo, ok, conflicts, dupes = M.dump()

  local neovim = {
    normal = length(vim.api.nvim_get_keymap("n")),
    insert = length(vim.api.nvim_get_keymap("i")),
    command = length(vim.api.nvim_get_keymap("c")),
    operator = length(vim.api.nvim_get_keymap("o")),
    visual = length(vim.api.nvim_get_keymap("v")),
  }
  neovim.total = total(neovim)
  local whichkey = {}
  whichkey.ok = {
    normal = length(ok.n),
    insert = length(ok.i),
    command = length(ok.c),
    operator = length(ok.o),
    visual = length(ok.v),
  }
  whichkey.ok.total = total(whichkey.ok)
  whichkey.todo = {
    normal = length(todo.n),
    insert = length(todo.i),
    command = length(todo.c),
    operator = length(todo.o),
    visual = length(todo.v),
  }
  whichkey.todo.total = total(whichkey.todo)
  whichkey.duplicates = {
    normal = length(dupes.n),
    insert = length(dupes.i),
    command = length(dupes.c),
    operator = length(dupes.o),
    visual = length(dupes.v),
  }
  whichkey.duplicates.total = total(whichkey.duplicates)

  local conf_count = { normal = 0, insert = 0, command = 0, operator = 0, visual = 0 }
  for _, conflict_group in pairs(conflicts) do
    for mode in pairs(conflict_group) do
      if mode == "n" then
        conf_count.normal = conf_count.normal + 1
      elseif mode == "i" then
        conf_count.insert = conf_count.insert + 1
      elseif mode == "c" then
        conf_count.command = conf_count.command + 1
      elseif mode == "o" then
        conf_count.operator = conf_count.operator + 1
      elseif mode == "v" then
        conf_count.visual = conf_count.visual + 1
      end
    end
  end
  whichkey.conflicts = conf_count
  whichkey.conflicts.total = total(whichkey.conflicts)
  return { neovim = neovim, whichkey = whichkey, mapper = mapper }
end

function M.dump_out(_opt)
  local todo, ok, conflicts = M.dump()
  local opt = _opt
    or {
      -- key_types = { "todo", "ok", "duplicates", "conflicts" },
      key_types = { "conflicts" },
      output = "notify", -- buffer, echo, file
    }

  local lines = {}

  if vim.tbl_contains(opt.key_types, "ok") then
    for mode, keys in pairs(ok) do
      for key, def in pairs(keys) do
        table.insert(lines, "ok:   (" .. mode .. ') "' .. key .. '" ' .. def)
      end
    end
  end

  if vim.tbl_contains(opt.key_types, "todo") then
    for mode, keys in pairs(todo) do
      for key, def in pairs(keys) do
        table.insert(lines, "todo: (" .. mode .. ") " .. '"' .. key .. '" ' .. def)
      end
    end
  end

  if vim.tbl_contains(opt.key_types, "duplicates") then
    for _, dup in pairs(wk_keys.duplicates) do
      local msg = ""
      if dup.buf == dup.other.buffer then
        msg = "dupe: "
      else
        -- msg = "buffer-local keymap overriding global:"
        msg = "dupe local:"
      end
      -- msg = (msg .. " (**%q**) buf: %d, lhs: **%q**"):format(dup.mode, dup.buf or 0, dup.prefix)
      msg = (msg .. " (**%s**) buf: %d, lhs: **%s**"):format(dup.mode, dup.buf or 0, dup.prefix)
      table.insert(lines, msg)
    end
  end

  if vim.tbl_contains(opt.key_types, "conflicts") then
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
      local children = conflict.children and (conflict.children .. "x") or ""
      local rhs_label = conflict.group and "rhs-group" or "rhs"
      -- local msg = ("conf: (%q) %2s lhs: %q, rhs: %q"):format(mode, children, prefix, conflict.cmd or "")
      local msg = ("conf: (%s) %2s lhs: %s   %s: %s"):format(
        conflict.mode,
        children,
        conflict.prefix_n,
        rhs_label,
        conflict.cmd or ""
      )
      table.insert(lines, msg)
    end
  end

  return lines
end

function M.stats_out(_opt)
  local lines = {}
  local p = function(line)
    table.insert(lines, line)
  end

  local s = M.get_stats()

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
  p(
    ("mapper             %4d   %4d   %4d   %4d    %4d    %4d "):format(
      s.mapper.total,
      s.mapper.normal,
      s.mapper.visual,
      s.mapper.insert,
      s.mapper.operator,
      s.mapper.command
    )
  )
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

return M
