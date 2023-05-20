-- telescope modules
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values

-- telescope-mapper modules
local finders = require('telescope._extensions.mapper.finders')
local previewers = require('telescope._extensions.mapper.previewers')
local utils = require('telescope._extensions.mapper.utils')

local M = {}

M.mapper = function(opts)
  opts = opts or {}

  -- if the enter key should execute the selected keybind then set a custom mapping
  if vim.g.mapper_action_on_enter == 'execute' then
    opts = vim.tbl_extend('force', opts, {
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local keybind = action_state.get_selected_entry()
          -- Replace codes (e.g. '<CR>') with their internal representation
          local cmd_k = vim.api.nvim_replace_termcodes(keybind.keys, true, false, true)
          -- Send the keybinding to Neovim
          vim.api.nvim_feedkeys(cmd_k or '', 't', true)
          return actions.close(prompt_bufnr)
        end)
      end,
    })
  end

  pickers
    .new(opts or {}, {
      prompt_title = 'Select a mapping',
      results_title = 'Mappings',
      finder = finders.finder(utils.get_mappers()),
      -- previewer = previewers.previewer.new(opts),
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

return M
