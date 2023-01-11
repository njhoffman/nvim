local util = require("import.util")

local debuglog = require("debuglog")

local provider = {
  name = "commands",
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
      out = " " .. out .. " cmd "
    end
    return string.format("%5s", out)
  end,
  report = function(path, delta)
    local out = ""
    for _, added in ipairs(delta.added) do
      out = out .. "\n" .. " + cmd add " .. path .. " " .. added.event .. " " .. added.pattern
    end
    for _, removed in ipairs(delta.removed) do
      out = out .. "\n" .. " - cmd rem " .. path .. " " .. removed.event .. " " .. removed.pattern
    end
    local summary = path .. "  +" .. #delta.added .. ":-" .. #delta.removed .. " lines for autocommands"
    return summary .. out
  end,
  get = function(data)
    local cmdtable = {}
    local cmds = data or vim.api.nvim_get_commands({})

    for _, cmd in pairs(cmds) do
      local crc_hash = util.get_crc(cmd.name .. cmd.definition)
      cmdtable[tostring(crc_hash)] = {
        bang = tostring(cmd.bang),
        bar = tostring(cmd.bar),
        definition = tostring(cmd.definition),
        keepscript = tostring(cmd.keepscript),
        name = tostring(cmd.name),
        nargs = tostring(cmd.nargs),
        preview = tostring(cmd.preview),
        register = tostring(cmd.register),
        script_id = tostring(cmd.script_id),
      }
    end
    return cmdtable
  end,
}

provider.get()

-- return provider
