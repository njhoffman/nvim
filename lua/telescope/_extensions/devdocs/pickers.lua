local M = {}

local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local config = require('telescope.config').values

local log = require('devdocs.log')
local list = require('devdocs.list')
local operations = require('devdocs.operations')
local plugin_state = require('devdocs.state')
local plugin_config = require('devdocs.config')

local devdoc_actions = require('telescope._extensions.devdocs.actions')
local previewers = require('telescope._extensions.devdocs.previewers')
local create_registry_maker = require('telescope._extensions.devdocs.display.registry')
local docitems_entry_maker = require('telescope._extensions.devdocs.display.docitems')

---@param prompt string
---@param entries RegistryEntry[]
---@param on_attach function
---@return Picker
local function new_registry_picker(prompt, entries, on_attach)
  return pickers.new(plugin_config.options.telescope, {
    prompt_title = prompt,
    finder = finders.new_table({
      results = entries,
      entry_maker = create_registry_maker(entries),
    }),
    sorter = config.generic_sorter(plugin_config.options.telescope),
    previewer = previewers.metadata_previewer,
    attach_mappings = on_attach,
  })
end

M.installation_picker = function()
  local non_installed = list.get_non_installed_registry()

  if not non_installed then
    return
  end

  local picker = new_registry_picker('Install documentation', non_installed, function()
    actions.select_default:replace(function(prompt_bufnr)
      local selection = action_state.get_selected_entry()

      actions.close(prompt_bufnr)
      operations.install(selection.value)
    end)
    return true
  end)

  picker:find()
end

M.uninstallation_picker = function()
  local installed = list.get_installed_registry()

  if not installed then
    return
  end

  local picker = new_registry_picker('Uninstall documentation', installed, function()
    actions.select_default:replace(function(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      local alias = selection.value.slug:gsub('~', '-')

      actions.close(prompt_bufnr)
      operations.uninstall(alias)
    end)
    return true
  end)

  picker:find()
end

M.update_picker = function()
  local updatable = list.get_updatable_registry()

  if not updatable then
    return
  end

  local picker = new_registry_picker('Update documentation', updatable, function()
    actions.select_default:replace(function(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      local alias = selection.value.slug:gsub('~', '-')

      actions.close(prompt_bufnr)
      operations.install(alias, true, true)
    end)
    return true
  end)

  picker:find()
end

---@param entries DocEntry[]
---@param float? boolean
M.open_picker = function(entries, float)
  local picker = pickers.new(plugin_config.options.telescope, {
    prompt_title = 'Select an entry',
    finder = finders.new_table({
      results = entries,
      entry_maker = docitems_entry_maker,
    }),
    sorter = config.generic_sorter(plugin_config.options.telescope),
    previewer = previewers.doc_previewer,
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          plugin_state.set('current_doc', selection.value.alias)
          devdoc_actions.open_doc(selection, float)
        end
      end)
      return true
    end,
  })
  picker:find()
end

---@param alias string
---@param float? boolean
M.open_picker_alias = function(alias, float)
  local entries = list.get_doc_entries({ alias })

  if not entries then
    return
  end

  if vim.tbl_isempty(entries) then
    log.error(alias .. ' documentation is not installed')
  else
    plugin_state.set('current_doc', alias)
    M.open_picker(entries, float)
  end
end

M.open_picker_alias_dyn = function(opts)
  opts = opts or {}
  opts.entry_maker = opts.entry_maker or docitems_entry_maker
  local script_file = vim.fn.stdpath('config') .. '/luarocks/devdocs/lua_modules/bin/list'
  -- local script_file = vim.fn.stdpath('config') .. '/lua/telescope/_extensions/tester/test.sh'
  local command = { script_file }

  vim.dbglog('oneshot job: ', command)
  local picker = pickers.new(plugin_config.options.telescope, {
    prompt_title = 'Select an entry',
    finder = finders.new_oneshot_job(command, opts),
    -- sorter = config.generic_sorter(plugin_config.options.telescope),
    previewer = previewers.doc_previewer,
    -- attach_mappings = function(prompt_bufnr)
    --   actions.select_default:replace(function()
    --     actions.close(prompt_bufnr)
    --     local selection = action_state.get_selected_entry()
    --     if selection then
    --       plugin_state.set('current_doc', selection.value.alias)
    --       devdoc_actions.open_doc(selection, float)
    --     end
    --   end)
    --   return true
    -- end,
  })
  picker:find()
end

return M
