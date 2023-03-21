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
    local lhs = config.mapping.global[key] or ""
    if vim.fn.empty(lhs) == 0 then
      if open == true then
        config.mapping.old[key] = utils.get_key_cmd("n", lhs)
        vim.dbglog("setting map", lhs, commands[key])
        vim.keymap.set("n", lhs, commands[key], { noremap = true })
      else
        local rhs = config.mapping.old[key]
        if vim.fn.empty(rhs) == 0 then
          vim.keymap.set("n", lhs, rhs, { noremap = true })
        else
          vim.keymap.del("n", lhs)
        end
      end
    end
  end
end

local function setup(opts)
  config = vim.tbl_deep_extend("keep", opts or {}, defaults)
  return config
end

return {
  refresh = refresh,
  opts = config,
  setup = setup,
}
