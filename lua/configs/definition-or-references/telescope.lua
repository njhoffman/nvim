local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local utils = require('telescope.utils')
local entry_display = require('telescope.pickers.entry_display')

local telescope_data = require('configs.definition-or-references.telescope-data')
local telescope_sorter = require('configs.definition-or-references.telescope-sorter')

local get_filename_fn = function()
  local bufnr_name_cache = {}
  return function(bufnr)
    bufnr = vim.F.if_nil(bufnr, 0)
    local c = bufnr_name_cache[bufnr]
    if c then
      return c
    end

    local n = vim.api.nvim_buf_get_name(bufnr)
    bufnr_name_cache[bufnr] = n
    return n
  end
end

local gen_from_quickfix = function(opts)
  opts = opts or {}
  local show_line = vim.F.if_nil(opts.show_line, true)

  local hidden = utils.is_path_hidden(opts)
  local items = {
    { width = vim.F.if_nil(opts.fname_width, 30) },
    { remaining = true },
  }
  if hidden then
    items[1] = { width = 8 }
  end
  if not show_line then
    table.remove(items, 1)
  end

  local displayer = entry_display.create({ separator = '▏', items = items })
  local make_display = function(entry)
    local input = {}
    if not hidden then
      table.insert(input, string.format('%s:%d:%d', utils.transform_path(opts, entry.filename), entry.lnum, entry.col))
    else
      table.insert(input, string.format('%4d:%2d', entry.lnum, entry.col))
    end

    if show_line then
      local text = entry.text
      if opts.trim_text then
        text = text:gsub('^%s*(.-)%s*$', '%1')
      end
      text = text:gsub('.* | ', '')
      table.insert(input, text)
    end

    return displayer(input)
  end

  local get_filename = get_filename_fn()

  return function(entry)
    local filename = vim.F.if_nil(entry.filename, get_filename(entry.bufnr))
    return {
      value = entry,
      ordinal = (not hidden and filename or '') .. ' ' .. entry.text,
      display = make_display,
      bufnr = entry.bufnr,
      filename = filename,
      lnum = entry.lnum,
      col = entry.col,
      text = entry.text,
      start = entry.start,
      finish = entry.finish,
    }
  end
end

local function handle_references_response(result)
  local locations = telescope_data.get_data(result)
  pickers
    .new({}, {
      prompt_title = 'LSP References',
      finder = finders.new_table({
        results = locations,
        entry_maker = gen_from_quickfix(),
        -- entry_maker = require('telescope.make_entry').gen_from_quickfix(),
      }),
      previewer = require('telescope.config').values.qflist_previewer({}),
      sorter = telescope_sorter,
      theme = 'dropdown',
      path_display = { 'tail' },
    })
    :find()
end

return handle_references_response
