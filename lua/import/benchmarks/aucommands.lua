local util = require("import.util")
local provider = {
  name = "autocommands",
  output = function(path, delta)
    for _, added in ipairs(delta.added) do
      vim.dbglog(" + aucmd " .. path .. " " .. added.event .. " " .. added.pattern)
    end
    for _, removed in ipairs(delta.removed) do
      vim.dbglog(" - aucmd " .. path .. " " .. removed.event .. " " .. removed.pattern)
    end
  end,
  get = function(data)
    local autable = {}
    for _, aucmd in ipairs(data or vim.api.nvim_get_autocmds({})) do
      local crc_hash = util.get_crc(aucmd.command .. aucmd.event .. (aucmd.group or ""))
      autable[tostring(crc_hash)] = {
        buflocal = tostring(aucmd.buflocal),
        command = tostring(aucmd.command),
        event = tostring(aucmd.event),
        group = tostring(aucmd.group),
        pattern = tostring(aucmd.pattern),
        once = tostring(aucmd.once),
      }
    end
    return autable
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
