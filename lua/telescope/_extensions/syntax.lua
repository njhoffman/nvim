local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local putils = require("telescope.previewers.utils")

local function build_modeline(syntax, commentstring)
  local modeline = "vim: syn=" .. syntax
  if commentstring and commentstring ~= "" and commentstring ~= "%s" then
    modeline = commentstring:format(modeline)
  end
  return modeline
end

local show_syntax = function(opts)
  opts = opts or {}

  local source_bufnr = vim.api.nvim_get_current_buf()
  local source_lines = vim.api.nvim_buf_get_lines(source_bufnr, 0, -1, false)
  local commentstring = vim.bo[source_bufnr].commentstring

  local syntaxes = vim.fn.getcompletion("", "syntax")

  pickers
    .new(opts, {
      prompt_title = "Syntax",
      finder = finders.new_table({ results = syntaxes }),
      sorter = sorters.get_fzy_sorter(),
      previewer = previewers.new_buffer_previewer({
        title = "Syntax Preview",
        define_preview = function(self, entry)
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, source_lines)
          putils.highlighter(self.state.bufnr, entry[1])
        end,
      }),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          if selection == nil then
            vim.notify("[telescope] Nothing currently selected", vim.log.levels.WARN)
            return
          end

          actions.close(prompt_bufnr)

          local modeline = build_modeline(selection[1], commentstring)
          local last_line = vim.api.nvim_buf_line_count(source_bufnr)
          vim.api.nvim_buf_set_lines(source_bufnr, last_line, last_line, false, { modeline })
        end)
        return true
      end,
    })
    :find()
end

return require("telescope").register_extension({
  exports = {
    syntax = show_syntax,
  },
})
