---@diagnostic disable-next-line: unused-local
local default_cfg = {
  -- Prints useful logs about what event are triggered, and reasons actions are executed.
  debug = false,
  -- Callback that gets called just before sending first request
  before_start_callback = function() end,
  -- Callback that gets called just after opening entry and settig cursor position
  after_jump_callback = function(_) end,
  -- Callback that gets called with all of the references lsp result. You can do whatever you want
  -- with this data e.g. display it in the `telescope` window
  -- For example see Wiki pages
  on_references_result = nil,
}

-- local function handle_references_response(result)
--   require('telescope.pickers')
--     .new({}, {
--       prompt_title = 'LSP References',
--       finder = require('telescope.finders').new_table({
--         results = vim.lsp.util.locations_to_items(result, 'utf-16'),
--         entry_maker = require('telescope.make_entry').gen_from_quickfix(),
--       }),
--       previewer = require('telescope.config').values.qflist_previewer({}),
--     })
--     :find()
-- end
local telescope_handler = require('plugs.config.definition-or-references-telescope')
require('definition-or-references').setup({
  on_references_result = telescope_handler,
})

vim.keymap.set(
  'n',
  'gd',
  require('definition-or-references').definition_or_references,
  { silent = true, desc = 'lsp definition or references' }
)
