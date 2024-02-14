local wk_keys = require('which-key.keys')
local wk = require('which-key')

local function dump()
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
        if node.prefix_i ~= '' and count > 0 and not auto_prefix then
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
              todo[tree.mode][node.mapping.prefix] = node.mapping.cmd or ''
            end
          end
        end
      end
    )
  end

  return todo, ok, conflicts, wk_keys.duplicates
end

local map = function(mode, lhs, label)
  if mode == '' then
    wk.register({ [lhs] = { label } }, { mode = 'n' })
    wk.register({ [lhs] = { label } }, { mode = 'o' })
    wk.register({ [lhs] = { label } }, { mode = 'v' })
  elseif mode == 'x' then
    wk.register({ [lhs] = { label } }, { mode = 'v' })
    wk.register({ [lhs] = { label } }, { mode = 's' })
  else
    wk.register({ [lhs] = { label } }, { mode = mode })
  end
end

return { map = map, dump = dump }
