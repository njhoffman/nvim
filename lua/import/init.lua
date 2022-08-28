local cmds = require('import.commands')
local ui = require("import.ui")
local opts = require('import.opts')

local init = function(init_opts)
  if not vim.g._import_imported then
    opts.config(init_opts)

    -- if our global is not set, we will add Import to global space.
    _G.import = cmds.import
    vim.g._import_imported = true
    local _import = function(command_details)
      local modules = command_details.fargs
      for _, module in ipairs(modules) do
        cmds.import(module)
      end
    end

    local _reload = function(command_details)
      local modules = command_details.fargs
      if not modules then
        modules = cmds.get_all_modules()
      end
      for _, module in ipairs(modules) do
        cmds.reload(module)
      end
    end

    local _status = function(command_details)
      local module = command_details.args
      if module:match('^%s*$') then
        -- Nothing/empty string was passed, display UI
        vim.api.nvim_command('echon ""') -- Be cool if print worked...
        ui.display(opts.user_opts)
        return
      end
      local details = cmds.get_status(module)
      local message = module .. ': { imported=' ..
        tostring(details.imported) .. ', import_duration=' ..
        tostring(details.import_time / 1000000) .. ' milliseconds }'
      print(message)
    end

    -- TODO: Figure out why the sort here isn't being respected?
    local _complete = function()
      return cmds.get_all_modules()
    end

    vim.api.nvim_create_user_command("Import", _import, { nargs = '+', })
    vim.api.nvim_create_user_command("Reload", _reload, { nargs = '*', complete = _complete })
    vim.api.nvim_create_user_command("ImportStatus", _status, { nargs = '?', complete = _complete })
  end
end

return {
  init        = init,
  import      = cmds.import,
  reload      = cmds.reload,
  display     = ui.display,
  get_status  = cmds.get_status,
  get_modules = cmds.get_all_modules
}
