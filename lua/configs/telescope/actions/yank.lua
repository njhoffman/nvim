local utils = require("telescope.utils")
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")

local create_scratch_win = function(filetype, lines)
  filetype = filetype == nil and "result" or filetype
  vim.cmd("new")
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_name(bufnr, "telescope-out #" .. bufnr)

  vim.api.nvim_set_option_value("buftype", "nofile", { buf = bufnr })
  vim.api.nvim_set_option_value("filetype", filetype, { buf = bufnr })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = bufnr })
  vim.api.nvim_set_option_value("swapfile", false, { buf = bufnr })
  vim.api.nvim_buf_set_lines(bufnr, 0, #lines, false, lines)
end

-- local winnr = vim.api.nvim_get_current_win()
-- local bufnr = vim.api.nvim_win_get_buf(winnr)
--   local current_picker = action_state.get_current_picker(prompt_bufnr)
--   action_utils.map_entries(prompt_bufnr, function(entry, _, row)
--     current_picker._multi:toggle(entry)
--     if current_picker:can_select_row(row) then end
--   end)
--   local curr_entry = action_state.get_selected_entry()
--   filename = from_entry.path(entry, false, false)
--   local entry = self.manager and self.manager:get_entry(self:get_index(row))
--   if not current_picker._multi:is_selected(entry) then current_picker._multi:add(entry)

local parse_default_entry = function(entry, is_lua)
  local value = type(entry) == "table" and type(entry.value) ~= "nil" and entry.value
    or type(entry) == "function" and entry()
    or type(entry[1]) ~= "nil" and entry[1]
    or type(entry.display) ~= "nil" and entry.display
    or entry

  value = type(value) == "table" and table.concat(value, "\n") or value

  local lines = { tostring(entry) }
  if type(entry) == "table" or is_lua then
    lines = vim.split(vim.inspect(entry), "\n")
  end

  return value, lines
end

local parse_default_entries = function(entries)
  local is_lua = entries and type(entries) == "table" and type(entries[1]) == "table"

  local lines = {}
  local values = {}
  for i, entry in ipairs(entries) do
    local value, entry_dump = parse_default_entry(entry, is_lua)

    if type(entry_dump) == "table" then
      for _, l in ipairs(entry_dump) do
        table.insert(lines, "  " .. l)
      end
    else
      table.insert(lines, entry_dump)
    end

    if is_lua and i < #entries then
      lines[#lines] = lines[#lines] .. ","
    end
    table.insert(values, value)
  end

  if is_lua then
    table.insert(lines, 1, "local yanked = {")
    table.insert(lines, "}")
  end
  return values, lines
end

local get_selected_items = function(picker, parse_fn)
  -- local cached_pickers = state.get_global_key "cached_pickers"
  local entries = picker:get_multi_selection()
    or { action_state.get_selected_entry() or picker:get_selected_entry() }
    or {}
  if not entries or #entries == 0 then
    entries = { picker.manager:get_entry(picker:get_index(picker:get_selection_row())) }
    if entries == nil or #entries == 0 then
      vim.notify("No value to yank\n" .. vim.inspect(entries), 2)
      return false
    end
  end
  return parse_fn(entries)
end

local get_selected_summary = function(items)
  items = type(items) == "table" and items or { items }
  local summary = {}
  for _, item in ipairs(items) do
    if type(item) == "table" then
      local lineout = ""
      for _, val in pairs(items) do
        lineout = lineout .. " " .. val
      end
      table.insert(lineout)
    end
    table.insert(summary, tostring(item))
  end
  return table.concat(summary, "\n")
end

local yank_selection = function(prompt_bufnr, opts)
  opts = opts or {}
  opts.register = opts.register or "+"

  local picker = action_state.get_current_picker(prompt_bufnr)
  local ft = opts.filetype
    or opts.preview_ft
    or picker.preview_bufnr
      and vim.api.nvim_buf_is_valid(picker.preview_bufnr)
      and vim.api.nvim_buf_get_var(picker.preview_bufnr, "filetype")

  local parse_fn = opts.parse_fn or parse_default_entries
  local items, lines = get_selected_items(picker, parse_fn)
  local summary = get_selected_summary(items)

  opts.register = vim.o.clipboard == "unnamed" and "*" or "+"
  vim.fn.setreg(opts.register, summary)
  vim.notify(#items .. " summary items copied to register: " .. opts.register)
  return lines, ft
end

local yank_selection_to_buffer = function(prompt_bufnr, opts)
  local lines, ft = yank_selection(prompt_bufnr, opts)
  actions.close(prompt_bufnr)
  create_scratch_win(ft or "log", lines)
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
