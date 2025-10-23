--- @class Satellite.Handlers.BaseConfig
---
--- Whether the handler is enabled
--- @field enable boolean
---
--- If `true` decorations are rendered on top of the scrollbar. If `false` the
--- decorations are rendered in a separate column to the right of the scrollbar.
--- @field overlap boolean
---
--- Priority of the decorations from the handler.
--- @field priority integer

--- @class HandlerConfigs
--- @field [string] Satellite.Handlers.BaseConfig
--- @field diagnostic? Satellite.Handlers.DiagnosticConfig
--- @field gitsigns? Satellite.Handlers.GitsignsConfig
--- @field search? Satellite.Handlers.SearchConfig
--- @field marks? Satellite.Handlers.MarksConfig

--- @class SatelliteStateConfig
--- @field shape {head: string, body: string, tail: string}
--- @field highlight {head: string, body: string, tail: string}
--- @field winblend integer

--- @class SatelliteConfig
--- @field handlers HandlerConfigs
--- @field current_only boolean
--- @field winblend? integer
--- @field zindex integer
--- @field excluded_filetypes string[]
--- @field show_in_floating boolean
--- @field shape? {head: string, body: string, tail: string}
--- @field states? {active: SatelliteStateConfig, inactive: SatelliteStateConfig, scrolling: SatelliteStateConfig}
local user_config = {
  handlers = {},
  current_only = false,
  winblend = 50,
  zindex = 40,
  excluded_filetypes = {},
  show_in_floating = false,
  states = {
    active = {
      shape = {
        head = "▎",
        body = "▎",
        tail = "▎",
      },
      highlight = {
        head = "SatelliteBar",
        body = "SatelliteBar",
        tail = "SatelliteBar",
      },
      winblend = 50,
    },
    inactive = {
      shape = {
        head = "▎",
        body = "░",
        tail = "▎",
      },
      highlight = {
        head = "SatelliteBarInactive",
        body = "SatelliteBarInactive",
        tail = "SatelliteBarInactive",
      },
      winblend = 70,
    },
    scrolling = {
      shape = {
        head = "▲",
        body = "█",
        tail = "▼",
      },
      highlight = {
        head = "SatelliteBarScrolling",
        body = "SatelliteBarScrolling",
        tail = "SatelliteBarScrolling",
      },
      winblend = 30,
    },
  },
}

local M = {}

--- @type SatelliteConfig
M.user_config = setmetatable({}, {
  __index = function(_, k)
    return user_config[k]
  end,
})

--- @param config? SatelliteConfig
function M.apply(config)
  user_config = vim.tbl_deep_extend('force', user_config, config or {})
end

return M
