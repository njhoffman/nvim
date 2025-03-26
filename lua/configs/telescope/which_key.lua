local conf = require("telescope.config").values
local utils = require("telescope.utils")
local entry_display = require("telescope.pickers.entry_display")
local action_state = require("telescope.actions.state")
local resolver = require("telescope.config.resolve")
local popup = require("plenary.popup")
local a = vim.api

-- Best effort to infer function names for actions.which_key
function _get_anon_function_name(info)
  -- info.linedefined = 125,
  -- info.source = "@/home/nicholas/.config/nvim/lua/configs/telescope/actions.lua"
  local Path = require("plenary.path")
  local fname
  -- if fn defined in string (ie loadstring) source is string
  -- if fn defined in file, source is file name prefixed with a `@´
  local path = Path:new((info.source:gsub("@", "")))
  if not path:exists() then
    return "<anonymous>"
  end
  for i, line in ipairs(path:readlines()) do
    if i == info.linedefined then
      fname = line
      break
    end
  end

  -- test if assignment or named function, otherwise anon
  if (fname:match("=") == nil) and (fname:match("function %S+%(") == nil) then
    return "<anonymous>"
  else
    local patterns = {
      { "function", "" }, -- remove function
      { "local", "" }, -- remove local
      { "[%s=]", "" }, -- remove whitespace and =
      { [=[%[["']]=], "" }, -- remove left-hand bracket of table assignment
      { [=[["']%]]=], "" }, -- remove right-ahnd bracket of table assignment
      { "%((.+)%)", "" }, -- remove function arguments
      { "(.+)%.", "" }, -- remove TABLE. prefix if available
    }
    for _, tbl in ipairs(patterns) do
      fname = (fname:gsub(tbl[1], tbl[2])) -- make sure only string is returned
    end
    -- not sure if this can happen, catch all just in case
    if fname == nil or fname == "" then
      return "<anonymous>"
    end
    return fname
  end
end

--- Utility to collect mappings of prompt buffer in array of `{mode, keybind, name}`.
---@param prompt_bufnr number: The prompt bufnr
function get_registered_mappings(prompt_bufnr)
  -- require('telescope.actions.utils').get_registered_mappings
  local ret = {}
  for _, mode in ipairs({ "n", "i" }) do
    for _, mapping in ipairs(vim.api.nvim_buf_get_keymap(prompt_bufnr, mode)) do
      -- ensure only telescope mappings
      if mapping.desc then
        if mapping.desc:sub(1, 10) == "telescope|" then
          table.insert(ret, { mode = mode, keybind = mapping.lhs, desc = mapping.desc:sub(11) })
        elseif mapping.desc:sub(1, 11) == "telescopej|" then
          local fname = _get_anon_function_name(vim.json.decode(mapping.desc:sub(12)))
          fname = fname:lower() == mapping.lhs:lower() and "<anonymous>" or fname
          table.insert(ret, {
            mode = mode,
            keybind = mapping.lhs,
            desc = fname,
          })
        end
      end
    end
  end
  return ret
end

-- TODO: get function name desc like get_registered_mappings
local get_default_mappings = function()
  -- local default_mappings = conf.mappings
  -- <Up> { [1] = "preview_scrolling_up" }
  -- <M-p> function: 0x7fd1b2a82b10
  -- <M-}> false
  -- for key, name in pairs(default_mappings.i) do
  --   local fname = _get_anon_function_name(vim.json.decode(mapping.desc:sub(12)))
  --   fname = fname:lower() == mapping.lhs:lower() and '<anonymous>' or fname
  --   vim.dbglog(key, name, fname)
  -- end

  -- stylua: ignore
  return {
    i = {
      ['<CR>']        = 'select_default',
      ['<C-Q>']       = 'send_to_qflist + open_qflist',
      ['<C-Down>']    = 'cycle_history_next',
      ['<C-G>']       = 'move_to_top',
      ['<C-Up>']      = 'cycle_history_prev',
      ['<C-^>']       = 'switch_layout',
      ['<C-B>']       = 'results_page_up',
      ['<C-F>']       = 'results_page_down',
      ['<C-D>']       = 'search_reset',
      ['<C-U>']       = 'search_backspace_word',
      ['<Esc>']       = 'close',
      ['<F47>']       = 'cycle_previewers_prev',
      ['<F48>']       = 'cycle_previewers_next',
      ['<M-/>']       = 'toggle_preview',
      ['<M-C-Space>'] = 'resume_picker_prev',
      ['<M-C-_>']     = 'toggle_whichkey',
      ['<M-a>']       = 'toggle_all',
      ['<M-b>']       = 'preview_scrolling_up',
      ['<M-c>']       = 'drop_all',
      ['<M-e>']       = 'launch_live_grep',
      ['<M-f>']       = 'preview_scrolling_down',
      ['<M-g>']       = 'launch_projects',
      ['<M-n>']       = 'results_toggle_down',
      ['<M-p>']       = 'results_toggle_up',
      ['<M-u>']       = 'launch_find_files',
      ['<C-Y>']       = 'yank_selection',
      ['<M-y>']       = 'yank_selection_to_buffer',
      ['<S-Tab>']     = 'move_selection_previous',
      ['<Tab>']       = 'move_selection_next',
      ['<C-P>']       = 'move_selection_previous',
      ['<C-N>']       = 'move_selection_next',
      ['<Down>']      = 'preview_scrolling_down',
      ['<Up>']        = 'preview_scrolling_up',
    },
    n = {
      ['<Esc>'] = 'close',
      --     desc = "toggle_selection + move_selection_worse",
      --     keybind = "<Tab>",
      --     desc = "select_default",
      --     keybind = "<CR>",
      --     desc = "close",
      --     keybind = "<Esc>",
      --     desc = "which_key",
      --     keybind = "?",
      --     desc = "move_to_bottom",
      --     keybind = "G",
      --     desc = "move_to_top",
      --     keybind = "H",
      --     mode = "n"
      --     desc = "move_to_bottom",
      --     keybind = "L",
      --     desc = "move_to_middle",
      --     keybind = "M",
      --     desc = "move_to_top",
      --     keybind = "gg",
      --     desc = "move_selection_next",
      --     keybind = "j",
      --     desc = "move_selection_previous",
      --     keybind = "k",
      --     desc = "select_tab",
      --     keybind = "<C-T>",
      --     desc = "send_to_qflist + open_qflist",
      --     keybind = "<C-Q>",
      --     desc = "send_selected_to_qflist + open_qflist",
      --     keybind = "<M-q>",
      --     desc = "select_horizontal",
      --     keybind = "<C-X>",
      --     desc = "select_vertical",
      --     keybind = "<C-V>",
      --     desc = "preview_scrolling_down",
      --     keybind = "<C-D>",
      --     desc = "results_scrolling_up",
      --     keybind = "<PageUp>",
      --     desc = "results_scrolling_down",
      --     keybind = "<PageDown>",
      --     desc = "move_selection_previous",
      --     keybind = "<Up>",
      --     desc = "move_selection_next",
      --     keybind = "<Down>",
      --     desc = "preview_scrolling_up",
      --     keybind = "<C-U>",
      -- }
    },
  }
end

local setup_highlights = function()
  vim.api.nvim_set_hl(0, "TelescopeWhichKeyNormal", { default = true, link = "TelescopePrompt" })
  vim.api.nvim_set_hl(
    0,
    "TelescopeWhichKeyBorder",
    { default = true, link = "TelescopePromptBorder" }
  )
  vim.api.nvim_set_hl(
    0,
    "TelescopeWhichKeyMode",
    { default = true, link = "TelescopeResultsConstant" }
  )
  vim.api.nvim_set_hl(
    0,
    "TelescopeWhichKeyBind",
    { default = true, link = "TelescopeResultsVariable" }
  )
  vim.api.nvim_set_hl(
    0,
    "TelescopeWhichKeyName",
    { default = true, link = "TelescopeResultsFunction" }
  )
  vim.api.nvim_set_hl(
    0,
    "TelescopeWhichKeyModeCustom",
    { default = true, link = "TelescopeWhichKeyMode" }
  )
  vim.api.nvim_set_hl(
    0,
    "TelescopeWhichKeyBindCustom",
    { default = true, link = "TelescopeWhichKeyBind" }
  )
  vim.api.nvim_set_hl(
    0,
    "TelescopeWhichKeyNameCustom",
    { default = true, link = "TelescopeWhichKeyName" }
  )
end

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
    local bufs = a.nvim_list_bufs()
    for _, buf in ipairs(bufs) do
      for _, bufname in ipairs({ "_TelescopeWhichKey", "_TelescopeWhichKeyBorder" }) do
        if string.find(a.nvim_buf_get_name(buf), bufname) then
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
        pcall(a.nvim_win_close, win_id, true)
      end
    end
    return
  end

  setup_highlights()

  local displayer_items = {
    { width = opts.mode_width },
    { width = opts.keybind_width },
    { width = opts.name_width },
  }

  if opts.only_show_current_mode then
    opts.mode_width = 0
    displayer_items = {
      { width = opts.keybind_width },
      { width = opts.name_width },
    }
  end

  local displayer = entry_display.create({
    separator = opts.separator,
    items = displayer_items,
  })

  local make_display = function(mapping)
    local mode_hl = mapping.custom and "TelescopeWhichKeyModeCustom" or "TelescopeWhichKeyMode"
    local bind_hl = mapping.custom and "TelescopeWhichKeyBindCustom" or "TelescopeWhichKeyBind"
    local name_hl = mapping.custom and "TelescopeWhichKeyNameCustom" or "TelescopeWhichKeyName"
    if opts.only_show_current_mode then
      return displayer({
        { mapping.keybind, vim.F.if_nil(opts.keybind_hl, bind_hl) },
        { mapping.name, vim.F.if_nil(opts.name_hl, name_hl) },
      })
    end
    return displayer({
      { mapping.mode, vim.F.if_nil(opts.mode_hl, mode_hl) },
      { mapping.keybind, vim.F.if_nil(opts.keybind_hl, bind_hl) },
      { mapping.name, vim.F.if_nil(opts.name_hl, name_hl) },
    })
  end

  local default_mappings = get_default_mappings()

  local mappings = {}
  local mode = a.nvim_get_mode().mode
  for _, v in pairs(get_registered_mappings(prompt_bufnr)) do
    if v.desc and v.desc ~= "what_key" and v.desc ~= "nop" then
      if not opts.only_show_current_mode or mode == v.mode then
        table.insert(mappings, {
          custom = type(default_mappings[v.mode][v.keybind]) ~= "string",
          mode = v.mode,
          keybind = v.keybind,
          name = v.desc,
        })
        if v.desc == "<anonymous>" then
          utils.notify("actions.what_key", {
            msg = "No name available for anonymous functions.",
            level = "INFO",
            once = true,
          })
        end
      end
    end
  end

  table.sort(mappings, function(x, y)
    if x.name < y.name then
      return true
    elseif x.name == y.name then
      -- show normal mode as the standard mode first
      if x.mode > y.mode then
        return true
      else
        return false
      end
    else
      return false
    end
  end)

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
    return a.nvim_win_get_position(win_nr)[1] + 0.5 * a.nvim_win_get_height(win_nr)
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
  local km_buf = a.nvim_win_get_buf(km_win_id)
  a.nvim_buf_set_name(km_buf, "_TelescopeWhichKey")
  a.nvim_buf_set_name(km_opts.border.bufnr, "_TelescopeTelescopeWhichKeyBorder")
  a.nvim_win_set_option(km_win_id, "winhl", "Normal:" .. opts.normal_hl)
  a.nvim_win_set_option(km_opts.border.win_id, "winhl", "Normal:" .. opts.border_hl)
  a.nvim_win_set_option(km_win_id, "winblend", opts.winblend)
  a.nvim_win_set_option(km_win_id, "foldenable", false)

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = km_buf,
    once = true,
    callback = function()
      pcall(vim.api.nvim_win_close, km_win_id, true)
      pcall(vim.api.nvim_win_close, km_opts.border.win_id, true)
      require("telescope.utils").buf_delete(km_buf)
    end,
  })

  a.nvim_buf_set_lines(
    km_buf,
    0,
    -1,
    false,
    utils.repeated_table(opts.num_rows + 2 * opts.line_padding, column_indent)
  )

  local keymap_highlights = a.nvim_create_namespace("telescope_whatkey")
  local highlights = {}
  for index, mapping in ipairs(mappings) do
    local row = utils.cycle(index, opts.num_rows) - 1 + opts.line_padding
    local prev_line = a.nvim_buf_get_lines(km_buf, row, row + 1, false)[1]
    if index == total_available_entries and total_available_entries > #mappings then
      local new_line = prev_line .. "..."
      a.nvim_buf_set_lines(km_buf, row, row + 1, false, { new_line })
      break
    end
    local display, display_hl = make_display(mapping)
    local new_line = prev_line .. display .. opts.column_padding -- incl. padding
    a.nvim_buf_set_lines(km_buf, row, row + 1, false, { new_line })
    table.insert(highlights, { hl = display_hl, row = row, col = #prev_line })
  end

  -- highlighting only after line setting as vim.api.nvim_buf_set_lines removes hl otherwise
  for _, highlight_tbl in pairs(highlights) do
    local highlight = highlight_tbl.hl
    local row_ = highlight_tbl.row
    local col = highlight_tbl.col
    for _, hl_block in ipairs(highlight) do
      a.nvim_buf_add_highlight(
        km_buf,
        keymap_highlights,
        hl_block[2],
        row_,
        col + hl_block[1][1],
        col + hl_block[1][2]
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
