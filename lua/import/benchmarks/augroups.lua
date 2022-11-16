local util = require("import.util")
local provider = {
  name = "augroups",
  output = function(path, delta)
    for _, added in ipairs(delta.added) do
      vim.dbglog(" + augroup " .. path .. " " .. added.event .. " " .. added.pattern)
    end
    for _, removed in ipairs(delta.removed) do
      vim.dbglog(" - augroup " .. path .. " " .. removed.event .. " " .. removed.pattern)
    end
  end,
  get = function(data)
    local augroups = {}
    for _, augroup in ipairs(data or vim.api.nvim_get_autocmds({})) do
      local crc_hash = util.get_crc(augroup.name)
      augroups[tostring(crc_hash)] = {
        name = augroup.name,
      }
    end
    return augroups
  end,
  diff = function(prev, next)
    local delta = { added = {}, removed = {} }
    for hash_next, next_item in pairs(next) do
      for hash_prev, _ in pairs(prev) do
        if hash_prev == hash_next then
          goto continue
        end
      end
      table.insert(delta.added, next_item)
      ::continue::
    end
    for hash_prev, prev_item in pairs(prev) do
      for hash_next, _ in pairs(next) do
        if hash_prev == hash_next then
          goto continue
        end
      end
      table.insert(delta.removed, prev_item)
      ::continue::
    end
    return delta
  end,
}

return provider
