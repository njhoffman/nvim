local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local ags_mappings = require('gitops.mappings')
local generate = require('gitops.menu.generate')
local entry_display = require('telescope.pickers.entry_display')

local M = {}

local menu_entry_maker = function(widths)
  local displayer = entry_display.create({
    separator = ' ',
    items = { { width = widths[1] }, { width = widths[2] }, { remaining = true } },
  })

  local make_display = function(entry)
    return displayer({
      { entry.summary, 'TelescopeResultsOperator' },
      { entry.name, 'TelescopeResultsClass' },
      { entry.desc, 'TelescopeResultsComment' },
    })
  end
  return function(menu_obj)
    return {
      display = make_display,
      summary = menu_obj[1],
      name = menu_obj[2],
      desc = menu_obj[3],
      ordinal = string.format('%s', menu_obj[2]),
    }
  end
end

M.show_menu = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local git_pickers, widths = generate.get_git_pickers(bufnr)
  pickers
    .new({}, {
      results_title = 'Git Pickers',
      finder = finders.new_table({
        results = git_pickers,
        entry_maker = menu_entry_maker(widths),
      }),
      sorter = sorters.get_fuzzy_file(),
      attach_mappings = function(_, map)
        ags_mappings.omnimap(map, '<CR>', function(prompt_bufnr)
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local picker_entry = generate.get_git_pickers(bufnr)
          for _, entry in ipairs(picker_entry) do
            if entry[2] == selection.name then
              -- Find the matching function from the generate module
              break
            end
          end
        end)
        return true
      end,
    })
    :find()
end

return M
