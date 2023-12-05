local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
local actions = require('telescope.actions')
local conf = require('telescope.config').values

local config = require('yanky.config')
local mapping = require('telescope._extensions.yank_history.mapping')
local display = require('telescope._extensions.yank_history.display')

local yank_history = {}

function yank_history.get_exports()
  return {
    yank_history = yank_history.yank_history,
  }
end

local regtype_to_text = function(regtype)
  if 'v' == regtype then
    return 'charwise'
  elseif 'V' == regtype then
    return 'linewise'
  end
  return 'blockwise'
end

local format_title = function(entry)
  return regtype_to_text(entry.value.regtype)
end

function yank_history.previewer()
  return previewers.new_buffer_previewer({
    dyn_title = function(_, entry)
      return format_title(entry)
    end,
    define_preview = function(self, entry)
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, true, vim.split(entry.value.regcontents, '\n'))
      if entry.value.filetype ~= nil then
        vim.bo[self.state.bufnr].filetype = entry.value.filetype
      end
    end,
  })
end

function yank_history.attach_mappings(_, map)
  local mappings = config.options.picker.telescope.use_default_mappings
      and vim.tbl_deep_extend('force', mapping.get_defaults(), config.options.picker.telescope.mappings or {})
    or (config.options.picker.telescope.mappings or {})

  if mappings.default then
    actions.select_default:replace(mappings.default)
  end

  for _, mode in pairs({ 'i', 'n' }) do
    if mappings[mode] then
      for keys, action in pairs(mappings[mode]) do
        map(mode, keys, action)
      end
    end
  end

  return true
end

function yank_history.yank_history(opts)
  -- TODO: get working wiht sqlite
  local is_visual = vim.fn.mode() == 'v' or vim.fn.mode() == 'V'
  if is_visual then
    vim.cmd([[execute "normal! \<esc>"]])
  end

  mapping.state.is_visual = is_visual

  opts = opts or {}
  local history = {}
  for index, value in pairs(require('yanky.history').all()) do
    value.history_index = index
    history[index] = value
  end

  opts.history_length = #history

  pickers
    .new(opts, {
      prompt_title = 'Yank history',
      finder = finders.new_table({
        results = history,
        entry_maker = display.gen_from_history(opts),
      }),
      attach_mappings = yank_history.attach_mappings,
      previewer = yank_history.previewer(),
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

return yank_history
