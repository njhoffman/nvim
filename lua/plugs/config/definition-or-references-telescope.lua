local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local utils = require('telescope.utils')
local entry_display = require('telescope.pickers.entry_display')

local fuzzy_sorter = sorters.get_generic_fuzzy_sorter()

-- sorter that moves less important entries to the bottom
local sorter = sorters.Sorter:new({
  scoring_function = function(_, prompt, line, entry, cb_add, cb_filter)
    local base_score = fuzzy_sorter:scoring_function(prompt, line, cb_add, cb_filter)

    if entry.value.is_test_file then
      base_score = base_score + 100
    end

    if entry.value.is_inside_import then
      base_score = base_score + 200
    end

    return base_score
  end,
  highlighter = fuzzy_sorter.highlighter,
})

local function filter_entries(results)
  local function should_include_entry(entry)
    -- if entry is closing tag - just before it there is a closing tag syntax '</'
    if entry.col > 2 and entry.text:sub(entry.col - 2, entry.col - 1) == '</' then
      return false
    end

    return true
  end

  return vim.tbl_filter(should_include_entry, vim.F.if_nil(results, {}))
end

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

--- @return table
local function add_metadata_to_locations(locations)
  return vim.tbl_map(function(location)
    if string.find(location.text, '^import') then
      location.is_inside_import = true
    end

    location.display_path = require('telescope.utils').path_smart(location.filename)

    if string.find(location.filename, '.spec.') or string.find(location.filename, 'TestBuilder') then
      location.is_test_file = true
    end

    return location
  end, locations)
end

local function handle_references_response(result)
  local locations = vim.lsp.util.locations_to_items(result, 'utf-16')
  local filtered_entries = filter_entries(locations)
  pickers
    .new({}, {
      prompt_title = 'LSP References',
      finder = finders.new_table({
        results = add_metadata_to_locations(filtered_entries),
        entry_maker = gen_from_quickfix(),
        -- entry_maker = require('telescope.make_entry').gen_from_quickfix(),
      }),
      previewer = require('telescope.config').values.qflist_previewer({}),
      sorter = sorter,
      theme = 'dropdown',
      path_display = { 'tail' },
    })
    :find()
end

return handle_references_response
