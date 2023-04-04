local wk = require("which-key")
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

M.map = function(mode, lhs, label)
  if mode == "" then
    wk.register({ [lhs] = { label }, { mode = "n" } })
    wk.register({ [lhs] = { label }, { mode = "o" } })
    wk.register({ [lhs] = { label }, { mode = "v" } })
  elseif mode == "x" then
    wk.register({ [lhs] = { label }, { mode = "v" } })
    wk.register({ [lhs] = { label }, { mode = "s" } })
  else
    wk.register({ [lhs] = { label }, { mode = mode } })
  end
end

M.prefix = function(mode, prefix, name)
  wk.register({ [prefix] = { name = "+" .. name }, { mode = mode } })
end

return M
