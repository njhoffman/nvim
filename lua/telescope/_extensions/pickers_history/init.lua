local telescope = require('telescope')
local handlers = require('telescope._extensions.pickers_history.handler')

local sources = {
  history = function()
    return handlers.get_history()
  end,
  smart_history = function()
    return handlers.get_smart_history()
  end,
  simple_history = function()
    return handlers.get_simple_history()
  end,
}

-- vim.fn.fnamemodify(fname, ':t')
local db_status = function()
  for name, source in pairs(sources) do
    local handler = source() or {}
    if not handler or not handler.enabled then
      vim.notify(
        'history error (' .. name .. ') - no db\n' .. tostring(vim.inspect(handler)),
        vim.lsp.log_levels.WARN
      )
    else
      print(
        'success: ('
          .. name
          .. ') '
          .. tostring(handler.index)
          .. '/'
          .. tostring(handler.limit)
          .. '\n      '
          .. tostring(handler.path)
      )
    end
  end
  sources.history()
end

local extension = {
  setup = function(_, config)
    config = config or {}
  end,
  exports = vim.tbl_deep_extend('force', sources, { status = db_status }),
}
-- extension.setup(_, { history = {} })
return telescope.register_extension(extension)
