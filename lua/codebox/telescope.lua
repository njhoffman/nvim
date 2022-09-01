local has_telescope = pcall(require, "telescope")

local telescope = { has_telescope = has_telescope }

local function open_references_previewer(prompt_title, items)
  if telescope.has_telescope then
    local opts = require("codebox.config").conf.references.telescope
    local entry_maker = telescope.make_entry.gen_from_quickfix(opts)
    local previewer = nil

    if not opts.hide_preview then
      previewer = telescope.conf.qflist_previewer(opts)
    end

    telescope.pickers
      .new(opts, {
        prompt_title = prompt_title,
        finder = telescope.finders.new_table({
          results = items,
          entry_maker = entry_maker,
        }),
        previewer = previewer,
        sorter = telescope.conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr)
          telescope.actions.select_default:replace(function()
            local selection = telescope.action_state.get_selected_entry()
            telescope.actions.close(prompt_bufnr)

            local val = selection.value

            require("codebox.lib").open_floating_win(vim.uri_from_fname(val.filename), { val.lnum, val.col })
          end)

          return true
        end,
      })
      :find()
  else
    error("goto_preview_references requires Telescope.nvim")
  end
end

local function init_telescope()
  telescope.open_reference_previewer = open_references_previewer
  telescope.pickers      = require("telescope.pickers")
  telescope.make_entry   = require("telescope.make_entry")
  telescope.conf         = require("telescope.config").values
  telescope.finders      = require("telescope.finders")
  telescope.actions      = require("telescope.actions")
  telescope.action_state = require("telescope.actions.state")
  telescope.themes       = require("telescope.themes")
end

if has_telescope then
  init_telescope()
end

return telescope
