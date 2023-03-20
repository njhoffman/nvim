local utils = require("sidebar.utils")

local defaults = {
  width = 30,
  position = "right",
  mapping = {
    old = {},
    global = {
      next = "<M-.>",
      prev = "<M-,>",
      toggle = "<M-p>",
      select = "<M-Bslash>",
      open = nil,
      close = nil,
    },
    sidebar = {
      close = { "q", "<esc>" },
      next = "L",
      prev = "H",
    },
  },
}

local config = defaults

-- update global keymaps that are dependent on state
local function refresh(open, commands)
  local sidebar_commands = { "next", "prev" }
  for _, key in ipairs(sidebar_commands) do
    local lhs = config.mapping.global[key]
    if type(lhs) == "string" and #lhs > 0 then
      if open == true then
        config.mapping.old[key] = utils.get_key_cmd("n", lhs)
        vim.api.nvim_set_keymap("n", lhs, commands[key], { noremap = true })
      else
        local rhs = config.mapping.old[key]
        if type(rhs) == "string" and #rhs > 0 then
          -- config.mapping.old[key] = {}
          vim.api.nvim_set_keymap("n", lhs, rhs, { noremap = true })
        end
      end
    end
  end
end

local function setup(opts)
  config = vim.tbl_deep_extend("keep", opts or {}, defaults)
  vim.dbglog("config", config)
  return config
end

return {
  refresh = refresh,
  opts = config,
  setup = setup,
}
