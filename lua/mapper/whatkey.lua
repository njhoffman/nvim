local whatkey_keys = require("what-key.keys")
local whatkey = require("what-key")

local function dump()
  local ok = {}
  local todo = {}
  local conflicts = {}
  for _, tree in pairs(whatkey_keys.mappings) do
    -- whatkey_keys.update_keymaps(tree.mode, tree.buf)
    tree.tree:walk(
      ---@param node Node
      function(node)
        local count = 0
        for _ in pairs(node.children) do
          count = count + 1
        end
        local auto_prefix = not node.mapping
          or (node.mapping.group == true and not node.mapping.cmd)
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

  return todo, ok, conflicts, whatkey_keys.duplicates
end

-- wk.register({ ["<leader>f"] = { name = "+file" }, ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", "Find File" }}, opts)
local map = function(mode, lhs, opts)
  local label = opts.label or opts.desc or ""
  opts.buffer = opts.buffer == true and 0 or opts.buffer
  if mode == "" then
    whatkey.register({ [lhs] = { label } }, vim.tbl_deep_extend("force", opts, { mode = "n" }))
  elseif mode == "x" then
    whatkey.register({ [lhs] = { label } }, vim.tbl_deep_extend("force", opts, { mode = "v" }))
    whatkey.register({ [lhs] = { label } }, vim.tbl_deep_extend("force", opts, { mode = "s" }))
  else
    whatkey.register({ [lhs] = { label } }, vim.tbl_deep_extend("force", opts, { mode = mode }))
  end
end

local prefix = function(mode, prefix, name)
  local desc = "+" .. name
  whatkey.register({ [prefix] = { name = desc } }, { mode = mode })
end

return { map = map, prefix = prefix, dump = dump }
