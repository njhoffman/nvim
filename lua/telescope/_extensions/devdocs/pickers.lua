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

local previewers = require('telescope._extensions.devdocs.previewers')
local entry_maker = require('telescope._extensions.devdocs.display')
local devdoc_actions = require('telescope._extensions.devdocs.actions')

---@param prompt string
---@param entries RegisteryEntry[]
---@param on_attach function
---@return Picker
local function new_registery_picker(prompt, entries, on_attach)
  return pickers.new(plugin_config.options.telescope, {
    prompt_title = prompt,
    finder = finders.new_table({
      results = entries,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.slug:gsub('~', '-'),
          ordinal = entry.slug:gsub('~', '-'),
        }
      end,
    }),
    sorter = config.generic_sorter(plugin_config.options.telescope),
    previewer = previewers.metadata_previewer,
    attach_mappings = on_attach,
  })
end

M.installation_picker = function()
  local non_installed = list.get_non_installed_registery()

  if not non_installed then
    return
  end

  local picker = new_registery_picker('Install documentation', non_installed, function()
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
  local installed = list.get_installed_registery()

  if not installed then
    return
  end

  local picker = new_registery_picker('Uninstall documentation', installed, function()
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
  local updatable = list.get_updatable_registery()

  if not updatable then
    return
  end

  local picker = new_registery_picker('Update documentation', updatable, function()
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
    -- finder = function(_opts)
    --   return finders.new_oneshot_job(command, _opts)
    -- end,
    --   finder = finders.new_dynamic({
    --     fn = async(function(prompt)
    --       return { prompt }
    --     end),
    --     entry_maker = require("telescope.make_entry").gen_from_string {}})

    finder = finders.new_table({
      results = entries,
      entry_maker = entry_maker,
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

return M
