local telescope = require('telescope')
local handler = require('telescope._extensions.pickers_history.handler')

-- local stopinsert = function(callback)
--   return function(prompt_bufnr)
--     vim.cmd.stopinsert()
--     vim.schedule(function()
--       callback(prompt_bufnr)
--     end)
--   end
-- end
--
-- luarocks install luv
-- luarocks install sqlite3
-- sudo apt-get install sqlite3 libsqlite3-dev # Ubuntu

local extension = {
  setup = function(_, config)
    config = config or {}
    if config.history ~= false then
      config.history.handler = function()
        return handler.get_history()
      end
    end
  end,
  exports = {
    history = function()
      return handler.get_history()
    end,
  },
}
return telescope.register_extension(extension)
-- extension.setup()
