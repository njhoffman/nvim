-- telescope modules
local pickers = require("telescope.pickers")
local themes = require("telescope.themes")
local finders = require("telescope.finders")
local telescope_config = require("telescope.config").values
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")

local display = require("telescope._extensions.gotofile.display")
local generate = require("telescope._extensions.gotofile.generate")

local M = {}
local default_conf_opts = {
  patterns = {
    ["*"] = {},
    lua = {},
    sh = {}
  }
}

M.setup = function() end

M.gotofile = function(theme_opts, conf_opts)
  theme_opts = themes.get_dropdown(theme_opts)
  conf_opts = vim.tbl_deep_extend("force", default_conf_opts, conf_opts or {})

  local parsed_table = generate.get_files()
  pickers.new(theme_opts, {
    prompt_title = "Find GoToFiles",
    results_title = "GoToFile",
    finder = finders.new_table({
      results = parsed_table,
      entry_maker = display.entry_maker
    }),
    attach_mappings = function()
      action_set.select:enhance({
        post = function()
          local selection = action_state.get_selected_entry()
          vim.dbglog("SELECTION", selection)
          -- if selection.lnum then
          --   vim.api.nvim_win_set_cursor(0, { selection.lnum, 0 })
          -- end
        end,
      })
      return true
    end,
    sorter = telescope_config.file_sorter(theme_opts),

    -- finder = finders.new_table({
    --   results = items,
    --   theme = local_opt.themes,
    --   entry_maker = function(entry)
    --     return {
    --       value = entry.path,
    --       display = entry.path,
    --       ordinal = entry.path,
    --       path = entry.path,
    --       lnum = entry.lnum,
    --       col = entry.col,
    --     }
    --   end,
    -- }),
    -- previewer = conf.grep_previewer(opts),
    -- sorter = conf.generic_sorter(opts),
  }):find()
end

return M
