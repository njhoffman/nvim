local config = require('modules.sidebar.config')
local state = require('modules.sidebar.state')
local sections = require('modules.sidebar.sections')
local commands = require('modules.sidebar.commands')
local utils = require('modules.sidebar.utils')

local exports = {}

function exports.setup(_opts)
  utils.validate(sections)

  local opts = config.setup(_opts)

  -- validate and initialize available sections
  state.update()

  -- initialize global keymaps
  local map = require("lib.mapper").map
  for _, key in ipairs({ 'toggle', 'open', 'close' }) do
    local lhs = vim.tbl_get(opts, 'mapping', 'global', key)
    if type(lhs) == 'string' and #lhs > 0 then
      opts.mapping.old[key] = utils.get_key_cmd('n', lhs)
      map('n', lhs, commands[key])
    end
    exports[key] = commands[key]
  end
end

return exports
