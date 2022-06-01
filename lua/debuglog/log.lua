local output_log = require("debuglog.output")
local logutils = require("logger.utils")
local config = require("debuglog.config")
local unpack = unpack or table.unpack

local log = {}
log.new = function(standalone)
  local obj = standalone and log or {}
  for i, x in ipairs(config.modes) do
    obj[x.name] = function(...)
      return output_log(i, x, logutils.make_string, ...)
    end
    obj[("fmt_%s"):format(x.name)] = function()
      return output_log(
        i,
        x,
        function(...)
          local passed = { ... }
          local fmt = table.remove(passed, 1)
          local inspected = {}
          for _, v in ipairs(passed) do
            table.insert(inspected, vim.inspect(v))
          end
          return string.format(fmt, unpack(inspected))
        end
      )
    end
  end
end

return log
