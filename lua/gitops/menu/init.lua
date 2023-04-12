local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local ags_mappings = require("gitops.mappings")
local generate = require("gitops.menu.generate")
local entry_display = require("telescope.pickers.entry_display")

local M = {}

--- Opens all a selector for all advanced git search functions

local menu_entry_maker = function(widths)
  local displayer = entry_display.create({
    separator = " ",
    items = { { width = widths[1] }, { width = widths[2] }, { remaining = true } },
  })

  local make_display = function(entry)
    return displayer({
      { entry.summary, "TelescopeResultsOperator" },
      { entry.name, "TelescopeResultsClass" },
      { entry.desc, "TelescopeResultsComment" },
    })
  end
  return function(menu_obj)
    local entry = {
      display = make_display,
      name = menu_obj.name,
      desc = menu_obj.desc,
      summary = menu_obj.value(),
      ordinal = string.format("%s", menu_obj.name),
    }
    return entry
  end
end

M.show_menu = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local git_pickers, widths = generate.get_git_pickers(bufnr)
  pickers
    .new({
      results_title = "Git Pickers",
      finder = finders.new_table({
        results = git_pickers,
        entry_maker = menu_entry_maker(widths),
      }),
      sorter = sorters.get_fuzzy_file(),
      attach_mappings = function(_, map)
        ags_mappings.omnimap(map, "<CR>", function(prompt_bufnr)
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.dbglog("menu select", selection)
          -- execute_git_function(selection.value)
        end)
        return true
      end,
    }, {})
    :find()
end

M.show_menu()

-- return M
