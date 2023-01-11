local util = require("import.util")
local provider = {
  name = "aucommands",
  diff = util.diff,
  summary = function(delta)
    local out = ""
    if #delta.added > 0 then
      out = out .. " " .. #delta.added
    end
    -- if #delta.removed > 0 then
    --   out = out .. " +" .. #delta.removed
    -- end
    if #out > 0 then
      out = " " .. out .. " au "
    end
    return string.format("%10s", out)
  end,
  report = function(path, delta)
    local out = ""
    for _, added in ipairs(delta.added) do
      out = out .. "\n" .. " + aucmd add " .. path .. " " .. added.event .. " " .. added.pattern
    end
    for _, removed in ipairs(delta.removed) do
      out = out .. "\n" .. " - aucmd rem " .. path .. " " .. removed.event .. " " .. removed.pattern
    end
    local summary = path .. "  +" .. #delta.added .. ":-" .. #delta.removed .. " lines for autocommands"
    return summary .. out
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
}

return provider
