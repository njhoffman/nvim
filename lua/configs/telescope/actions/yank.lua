local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')

local create_scratch_win = function(filetype, lines)
  filetype = filetype == nil and 'result' or filetype
  vim.cmd('new')
  local bufnr = vim.api.nvim_get_current_buf()
  -- local winnr = vim.api.nvim_get_current_win()
  -- local bufnr = vim.api.nvim_win_get_buf(winnr)
  -- vim.api.nvim_create_buf(true, true)
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = bufnr })
  vim.api.nvim_buf_set_name(bufnr, 'telescope-out #' .. bufnr)
  vim.api.nvim_set_option_value('filetype', filetype, { buf = bufnr })
  -- vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = bufnr })
  -- vim.api.nvim_set_option_value('swapfile', false, { buf = bufnr })
  vim.api.nvim_buf_set_lines(bufnr, 0, #lines, false, lines)
end

local parse_default_entry = function(entry, is_lua)
  if type(entry) == 'table' or is_lua then
    return vim.split(vim.inspect(entry), '\n')
  end
  local value = type(entry.value) ~= 'nil' and entry.value
    or type(entry[1]) ~= 'nil' and entry[1]
    or entry
  return value
end

local parse_default_entries = function(entries)
  local is_lua = entries and type(entries) == 'table' and type(entries[1]) == 'table'

  local lines = {}
  for i, entry in ipairs(entries) do
    local parsed = parse_default_entry(entry, is_lua)

    if type(parsed) == 'table' then
      for _, l in ipairs(parsed) do
        table.insert(lines, '  ' .. l)
      end
    else
      table.insert(lines, parsed)
    end

    if is_lua and i < #entries then
      lines[#lines] = lines[#lines] .. ','
    end
  end

  if is_lua then
    table.insert(lines, 1, 'local yanked = {')
    table.insert(lines, '}')
  end
  return lines, is_lua and 'lua'
end

local get_yank_lines = function(picker, opts)
  local parse_fn = opts.parse_fn or parse_default_entries
  local entries = picker:get_multi_selection() or { action_state.get_selected_entry() }
  if not entries or #entries == 0 then
    entries = picker:get_selected_entry()
    if entries == nil or #entries == 0 then
      vim.notify('No value to yank\n' .. vim.inspect(entries), 2)
      return false
    end
  end
  return parse_fn(entries)
end

local yank_selection = function(prompt_bufnr, opts)
  opts = opts or {}
  local picker = action_state.get_current_picker(prompt_bufnr)
  local lines, filetype = get_yank_lines(picker, opts)

  local ft = filetype
    or opts.preview_ft
    or picker.preview_bufnr
      and vim.api.nvim_buf_is_valid(picker.preview_bufnr)
      and vim.api.nvim_buf_get_var(picker.preview_bufnr, 'filetype')

  local register = '+'
  if vim.o.clipboard == 'unnamed' then
    register = '*'
  end

  vim.fn.setreg(register, vim.fn.join(lines, '\n'))
  vim.notify('Copied ' .. #lines .. ' lines to register ' .. register, 2, { filetype = ft })
  return lines, ft
end

local yank_selection_to_buffer = function(prompt_bufnr, opts)
  local lines, ft = yank_selection(prompt_bufnr, opts)
  actions.close(prompt_bufnr)
  create_scratch_win(ft or 'log', lines)
end

local yank_keymaps = function(bufnr, opts)
  opts.parse_fn = function(entry)
    return entry
  end
  yank_selection(bufnr, opts)
end

local yank_keymaps_to_buffer = function(bufnr, opts)
  opts.parse_fn = function(entry)
    return entry
  end
  yank_selection_to_buffer(bufnr, opts)
end

local yank_highlights = function(bufnr, opts)
  opts.parse_fn = function(entry)
    return entry
  end
  yank_selection(bufnr, opts)
end

local yank_highlights_to_buffer = function(bufnr, opts)
  opts.parse_fn = function(entry)
    return entry
  end
  yank_selection_to_buffer(bufnr, opts)
end

return {
  yank_highlights = yank_highlights,
  yank_highlights_to_buffer = yank_highlights_to_buffer,
  yank_keymaps = yank_keymaps,
  yank_keymaps_to_buffer = yank_keymaps_to_buffer,
  yank_selection = yank_selection,
  yank_selection_to_buffer = yank_selection_to_buffer,
}
