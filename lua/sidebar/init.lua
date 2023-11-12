local config = require('sidebar.config')
local state = require('sidebar.state')
local sections = require('sidebar.sections')
local commands = require('sidebar.commands')
local utils = require('sidebar.utils')

local exports = {}

function exports.setup(_opts)
  utils.validate(sections)

  local opts = config.setup(_opts)

  -- validate and initialize available sections
  state.update()

  -- initialize global keymaps
  -- TODO: do this in config and merge into exports
  for _, key in ipairs({ 'toggle', 'open', 'close' }) do
    local lhs = vim.tbl_get(opts, 'mapping', 'global', key)
    if type(lhs) == 'string' and #lhs > 0 then
      opts.mapping.old[key] = utils.get_key_cmd('n', lhs)
      vim.keymap.set('n', lhs, commands[key], { noremap = true })
    end
    exports[key] = commands[key]
  end
end

return exports
