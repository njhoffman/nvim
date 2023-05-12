local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local conf = require('telescope.config').values
local finders = require('telescope.finders')
local internal = require('telescope.builtin.__internal')
local state = require('telescope.state')
local pickers = require('telescope.pickers')
local make_entry = require('telescope.make_entry')

-- local display = require("telescope._extensions.find_pickers.display")
-- local generate = require("telescope._extensions.find_pickers.generate")

-- local sort_pickers = function(a, b)
--   return a.name < b.name
-- end

local get_cached_pickers = function(opts)
  local cached_pickers = state.get_global_key('cached_pickers')
  if cached_pickers == nil or vim.tbl_isempty(cached_pickers) then
    vim.notify('builtin.pickers: No cached picker(s).', 3)
    return
  end
  -- clear cache picker for immediate pickers.new and pass option to resumed picker
  if opts.cache_picker ~= nil then
    opts._cache_picker = opts.cache_picker
    opts.cache_picker = nil
  end
  return opts
end

return function(opts)
  opts = opts or {}
  local cached_pickers = get_cached_pickers(opts)

  pickers
    .new(opts, {
      prompt_title = 'Pickers',
      finder = finders.new_table({
        results = cached_pickers,
        entry_maker = opts.entry_maker or make_entry.gen_from_picker(opts),
      }),
      -- previewer = previewers.pickers.new(opts),
      -- sorter = conf.generic_sorter(opts),
      cache_picker = false,
      attach_mappings = function(_, map)
        actions.select_default:replace(function(prompt_bufnr)
          local current_picker = action_state.get_current_picker(prompt_bufnr)
          local selection_index = current_picker:get_index(current_picker:get_selection_row())
          actions.close(prompt_bufnr)
          opts.cache_picker = opts._cache_picker
          opts['cache_index'] = selection_index
          opts['initial_mode'] = cached_pickers[selection_index].initial_mode
          internal.resume(opts)
        end)
        map({ 'i', 'n' }, '<C-x>', actions.remove_selected_picker)
        return true
      end,
    })
    :find()
end

-- internal.pickers = function(opts)
--   local cached_pickers = state.get_global_key('cached_pickers')
--   if cached_pickers == nil or vim.tbl_isempty(cached_pickers) then
--     utils.notify('builtin.pickers', {
--       msg = 'No cached picker(s).',
--       level = 'INFO',
--     })
--     return
--   end
--
--   opts = opts or {}
--
--   -- clear cache picker for immediate pickers.new and pass option to resumed picker
--   if opts.cache_picker ~= nil then
--     opts._cache_picker = opts.cache_picker
--     opts.cache_picker = nil
--   end
--
--   pickers
--     .new(opts, {
--       prompt_title = 'Pickers',
--       finder = finders.new_table({
--         results = cached_pickers,
--         entry_maker = make_entry.gen_from_picker(opts),
--       }),
--       previewer = previewers.pickers.new(opts),
--       sorter = conf.generic_sorter(opts),
--       cache_picker = false,
--       attach_mappings = function(_, map)
--         actions.select_default:replace(function(prompt_bufnr)
--           local current_picker = action_state.get_current_picker(prompt_bufnr)
--           local selection_index = current_picker:get_index(current_picker:get_selection_row())
--           actions.close(prompt_bufnr)
--           opts.cache_picker = opts._cache_picker
--           opts['cache_index'] = selection_index
--           opts['initial_mode'] = cached_pickers[selection_index].initial_mode
--           internal.resume(opts)
--         end)
--         map({ 'i', 'n' }, '<C-x>', actions.remove_selected_picker)
--         return true
--       end,
--     })
--     :find()
-- end

-- return {
--     local result_table = {}
--     -- generate.builtins(result_table)
--     -- generate.extensions(result_table)
--     -- local parsed_table = generate.metadata(result_table, opts)
--     -- table.sort(parsed_table, sort_pickers)
--     return finders.new_table({
--       results = parsed_table,
--       entry_maker = display.entry_maker(parsed_table)
--     })
--   end
-- }
