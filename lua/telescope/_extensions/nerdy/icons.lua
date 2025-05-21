local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local icon_list = require("nerdy.icons")
local display = require("telescope._extensions.nerdy.display")

local default_opts = {
  theme = require("telescope.themes").get_dropdown(),
}

return function(opts)
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})
  pickers
    .new(opts.theme, {
      prompt_title = "Nerdy Icons",
      finder = finders.new_table({
        results = icon_list,
        entry_maker = display.generate_icons(icon_list),
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          local selected_entry = action_state.get_selected_entry().value
          local icon = selected_entry.char
          actions.close(prompt_bufnr)
          vim.api.nvim_put({ icon }, "c", true, true)
        end)
        return true
      end,
    })
    :find()
end
