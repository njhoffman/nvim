local resolver = require("telescope.config.resolve")
local conf = require("telescope.config").values
local utils = require("telescope.utils")
local action_state = require("telescope.actions.state")
local popup = require("plenary.popup")
local wk_highlights = require("configs.telescope.which_key.highlights")
local wk_mappings = require("configs.telescope.which_key.mappings")
local wk_display = require("configs.telescope.which_key.display")

--- Display the keymaps of registered actions similar to which-key.nvim.<br>
--- - Notes:
---   - The defaults can be overridden via |action_generate.which_key|.
---@param prompt_bufnr number: The prompt bufnr
local what_key = function(prompt_bufnr, opts)
  opts = opts or {}
  opts.max_height = vim.F.if_nil(opts.max_height, 0.4)
  opts.only_show_current_mode = vim.F.if_nil(opts.only_show_current_mode, true)
  opts.mode_width = vim.F.if_nil(opts.mode_width, 1)
  opts.keybind_width = vim.F.if_nil(opts.keybind_width, 7)
  opts.name_width = vim.F.if_nil(opts.name_width, 30)
  opts.line_padding = vim.F.if_nil(opts.line_padding, 1)
  opts.separator = vim.F.if_nil(opts.separator, " -> ")
  opts.close_with_action = vim.F.if_nil(opts.close_with_action, true)
  opts.normal_hl = vim.F.if_nil(opts.normal_hl, "TelescopeWhichKeyNormal")
  opts.border_hl = vim.F.if_nil(opts.border_hl, "TelescopeWhichKeyBorder")
  opts.winblend = vim.F.if_nil(opts.winblend, conf.winblend)
  opts.column_padding = vim.F.if_nil(opts.column_padding, "  ")

  -- Assigning into 'opts.column_indent' would override a number with a string and
  -- cause issues with subsequent calls, keep a local copy of the string instead
  local column_indent = table.concat(utils.repeated_table(vim.F.if_nil(opts.column_indent, 4), " "))

  -- close on repeated keypress
  local km_bufs = (function()
    local ret = {}
    local bufs = vim.api.nvim_list_bufs()
    for _, buf in ipairs(bufs) do
      for _, bufname in ipairs({ "_TelescopeWhichKey", "_TelescopeWhichKeyBorder" }) do
        if string.find(vim.api.nvim_buf_get_name(buf), bufname) then
          table.insert(ret, buf)
        end
      end
    end
    return ret
  end)()

  if not vim.tbl_isempty(km_bufs) then
    for _, buf in ipairs(km_bufs) do
      utils.buf_delete(buf)
      local win_ids = vim.fn.win_findbuf(buf)
      for _, win_id in ipairs(win_ids) do
        pcall(vim.api.nvim_win_close, win_id, true)
      end
    end
    return
  end

  wk_highlights.setup_highlights()
  local mappings = wk_mappings.setup_mappings()

  local entry_width = #opts.column_padding
    + opts.mode_width
    + opts.keybind_width
    + opts.name_width
    + (3 * #opts.separator)

  local num_total_columns = math.floor((vim.o.columns - #column_indent) / entry_width)
  opts.num_rows = math.min(
    math.ceil(#mappings / num_total_columns),
    resolver.resolve_height(opts.max_height)(_, _, vim.o.lines)
  )
  local total_available_entries = opts.num_rows * num_total_columns
  local winheight = opts.num_rows + 2 * opts.line_padding

  -- place hints at top or bottom relative to prompt
  local win_central_row = function(win_nr)
    return vim.api.nvim_win_get_position(win_nr)[1] + 0.5 * vim.api.nvim_win_get_height(win_nr)
  end

  -- TODO(fdschmidt93|l-kershaw): better generalization of where to put which key float
  local picker = action_state.get_current_picker(prompt_bufnr)
  local prompt_row = win_central_row(picker.prompt_win)
  local results_row = win_central_row(picker.results_win)
  local preview_row = picker.preview_win
      and vim.api.nvim_win_is_valid(picker.preview_win)
      and win_central_row(picker.preview_win)
    or results_row
  local prompt_pos = prompt_row < 0.4 * vim.o.lines
    or prompt_row < 0.6 * vim.o.lines and results_row + preview_row < vim.o.lines

  local modes = { n = "Normal", i = "Insert" }
  local title_mode = opts.only_show_current_mode and modes[mode] .. " Mode " or ""
  local title_text = title_mode .. "Keymaps"
  local popup_opts = {
    relative = "editor",
    enter = false,
    minwidth = vim.o.columns,
    maxwidth = vim.o.columns,
    minheight = winheight,
    maxheight = winheight,
    line = prompt_pos == true and vim.o.lines - winheight + 1 or 1,
    col = 0,
    border = { prompt_pos and 1 or 0, 0, not prompt_pos and 1 or 0, 0 },
    borderchars = {
      prompt_pos and "─" or " ",
      "",
      not prompt_pos and "─" or " ",
      "",
      "",
      "",
      "",
      "",
    },
    noautocmd = true,
    title = { { text = title_text, pos = prompt_pos and "N" or "S" } },
  }
  local km_win_id, km_opts = popup.create("", popup_opts)
  local km_buf = vim.api.nvim_win_get_buf(km_win_id)
  vim.api.nvim_buf_set_name(km_buf, "_TelescopeWhichKey")
  vim.api.nvim_buf_set_name(km_opts.border.bufnr, "_TelescopeTelescopeWhichKeyBorder")
  vim.api.nvim_set_option_value("winhl", "Normal:" .. opts.normal_hl, { win = km_win_id })
  vim.api.nvim_set_option_value(
    "winhl",
    "Normal:" .. opts.border_hl,
    { win = km_opts.border.win_id }
  )
  vim.api.nvim_set_option_value("winblend", tostring(opts.winblend), { win = km_win_id })
  vim.api.nvim_set_option_value("foldenable", false, { win = km_win_id })

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = km_buf,
    once = true,
    callback = function()
      pcall(vim.api.nvim_win_close, km_win_id, true)
      pcall(vim.api.nvim_win_close, km_opts.border.win_id, true)
      require("telescope.utils").buf_delete(km_buf)
    end,
  })

  vim.api.nvim_buf_set_lines(
    km_buf,
    0,
    -1,
    false,
    utils.repeated_table(opts.num_rows + 2 * opts.line_padding, column_indent)
  )

  local keymap_highlights = vim.api.nvim_create_namespace("telescope_whatkey")
  local hls = {}

  for index, mapping in ipairs(mappings) do
    local row = utils.cycle(index, opts.num_rows) - 1 + opts.line_padding
    local prev_line = vim.api.nvim_buf_get_lines(km_buf, row, row + 1, false)[1]
    if index == total_available_entries and total_available_entries > #mappings then
      local new_line = prev_line .. "..."
      vim.api.nvim_buf_set_lines(km_buf, row, row + 1, false, { new_line })
      break
    end
    local display, display_hl = wk_display.make_display(mapping, opts)
    local new_line = prev_line .. display .. opts.column_padding -- incl. padding
    vim.api.nvim_buf_set_lines(km_buf, row, row + 1, false, { new_line })
    table.insert(hls, { hl = display_hl, row = row, col = #prev_line })
  end

  -- highlighting only after line setting as vim.api.nvim_buf_set_lines removes hl otherwise
  for _, hl in pairs(hls) do
    local highlight = hl.hl
    local row_ = hl.row
    local col = hl.col
    for _, hl_block in ipairs(highlight) do
      vim.api.nvim_add_highlight(
        keymap_highlights,
        hl_block[2],
        row_,
        col + hl_block[1][1],
        col + hl_block[1][2]({ buf = km_buf })
      )
    end
  end

  -- only set up autocommand after showing preview completed
  if opts.close_with_action then
    vim.schedule(function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "TelescopeKeymap",
        once = true,
        callback = function()
          pcall(vim.api.nvim_win_close, km_win_id, true)
          pcall(vim.api.nvim_win_close, km_opts.border.win_id, true)
          require("telescope.utils").buf_delete(km_buf)
        end,
      })
    end)
  end
end

return what_key
