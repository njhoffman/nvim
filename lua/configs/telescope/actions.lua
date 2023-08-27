local actions = require('telescope.actions')
local finders = require('telescope.finders')
local config = require('telescope.config')
local action_state = require('telescope.actions.state')
local actions_set = require('telescope.actions.set')
local state = require('telescope.state')
local H = require('helpers')
local run = require('telescope.run')
local telethemes = require('telescope.telethemes')
local dirpicker = require('configs.telescope.dirpicker')

local M = {}

local _open_buffer = function(open_cmd, prompt_bufnr)
  if open_cmd == 'vsplit' then
    actions.file_vsplit(prompt_bufnr)
  elseif open_cmd == 'split' then
    actions.file_split(prompt_bufnr)
  elseif open_cmd == 'tabe' then
    actions.file_tab(prompt_bufnr)
  else
    -- actions.file_edit(prompt_bufnr)
    actions.select_default(prompt_bufnr)
  end
end

local _multi_open_qf = function(targets, prompt_bufnr)
  -- actions.smart_send_to_qflist(prompt_bufnr)
  for _, target in ipairs(targets) do
    vim.cmd("caddexpr '" .. target.ordinal .. "'")
    -- vim.cmd("qfdo " .. target.ordinal)
    -- actions.smart_add_to_qflist(prompt_bufnr)
    -- -- actions.send_selected_to_qflist(prompt_bufnr)
  end
end

local _multi_open = function(prompt_bufnr, open_cmd)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local multi_targets = picker:get_multi_selection()
  open_cmd = open_cmd or 'insert'
  local num_selections = #multi_targets

  if not num_selections or num_selections <= 1 then
    -- actions.add_selection(prompt_bufnr)
    actions.select_default(prompt_bufnr)
  elseif open_cmd == 'quickfix' then
    _multi_open_qf(multi_targets, prompt_bufnr)
  else -- insert method
    local cwd = picker.cwd
    if cwd == nil then
      cwd = ''
    else
      cwd = string.format('%s/', cwd)
    end
    actions.close(prompt_bufnr)
    for _, entry in ipairs(multi_targets) do
      local edit_cmd = string.format('%s %s%s', open_cmd, cwd, entry.value)
      if entry.filename then
        edit_cmd = string.format('%s %s%s', open_cmd, cwd, entry.filename)
      end
      vim.cmd(edit_cmd)
    end
  end
end

M.multi_open_vsplit = function(prompt_bufnr)
  _multi_open(prompt_bufnr, 'vsplit')
end

M.multi_open_split = function(prompt_bufnr)
  _multi_open(prompt_bufnr, 'split')
end

M.multi_open_tab = function(prompt_bufnr)
  _multi_open(prompt_bufnr, 'tabe')
end

M.multi_open = function(prompt_bufnr)
  _multi_open(prompt_bufnr, 'edit')
end

M.multi_to_qflist = function(prompt_bufnr)
  _multi_open(prompt_bufnr, 'quickfix')
end

vim.g.telescope_cache_index = 1
M.resume_picker_prev = function(prompt_bufnr)
  -- local cached_pickers = #state.get_global_key('cached_pickers')
  -- local picker = action_state.get_current_picker(prompt_bufnr) -- picker state
  -- local opts = {}
  -- if idx then
  --   opts.cache_index = idx + 1 > cached_pickers and 1 or idx + 1
  -- end

  local picker = action_state.get_current_picker(prompt_bufnr)
  local cached_pickers_num = #state.get_global_key('cached_pickers')

  -- local idx = picker.cache_picker and picker.cache_picker.index
  local idx = vim.g.telescope_cache_index
  if cached_pickers_num > 0 then
    idx = idx + 1
    if idx > cached_pickers_num then
      idx = 1
    end
  end
  local opts = { cache_index = idx, initial_mode = picker.initial_mode }

  -- opts._cache_picker = opts.cache_picker
  opts.cache_picker = false
  -- run('builtin', 'resume', opts)
  run('builtin', 'resume')
  vim.g.telescope_cache_index = idx
end

M.resume_picker_next = function(prompt_bufnr)
  actions.toggle_selection(prompt_bufnr)
  actions.move_selection_next(prompt_bufnr)
end

M.results_toggle_up = function(prompt_bufnr)
  actions.toggle_selection(prompt_bufnr)
  actions.move_selection_previous(prompt_bufnr)
end

M.results_toggle_down = function(prompt_bufnr)
  actions.toggle_selection(prompt_bufnr)
  actions.move_selection_next(prompt_bufnr)
end

M.results_page_up = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local results_height = vim.api.nvim_win_get_height(picker.results_win)
  actions_set.shift_selection(prompt_bufnr, -results_height)
end

M.results_page_down = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local results_height = vim.api.nvim_win_get_height(picker.results_win)
  actions_set.shift_selection(prompt_bufnr, results_height)
end

M.preview_scrolling_up = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local previewer = picker.previewer
  -- local results_height = vim.api.nvim_win_get_height(picker.results_win)
  local status = state.get_status(prompt_bufnr)
  -- Check if we actually have a previewer and a preview window
  if type(previewer) ~= 'table' or previewer.scroll_fn == nil or status.preview_win == nil then
    return
  end

  local direction = 1
  local input = direction > 0 and [[]] or [[]]
  -- local count = math.abs(direction)

  vim.dbglog('status', status.preview_win)
  vim.api.nvim_win_call(status.preview_win, function()
    -- :execute "normal \<Plug>(SmoothieDownwards)"
    vim.fn.execute('normal! \\<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)')
  end)
end

M.preview_scrolling_down = function(prompt_bufnr)
  M.preview_scrolling_up(prompt_bufnr)
  -- local picker = action_state.get_current_picker(prompt_bufnr)
  -- local results_height = vim.api.nvim_win_get_height(picker.results_win)
  -- actions_set.shift_selection(prompt_bufnr, results_height)
end

M.toggle_whichkey = function(prompt_bufnr)
  local whichkey_opts = {
    separator = ' ➜ ',
    -- separator = " -> ",
    column_padding = ' ',
    -- column_padding = "  "
    -- max_height = 0.4,
    -- only_show_current_mode = true,
    keybind_width = 9,
    -- keybind_width = 5,
    name_width = 25,
    winblend = 25,
    -- name_width = 30,
    -- line_padding = 1,
    -- close_with_action = true,
    -- mode_hl = "",
    name_hl = 'TelescopeWhichKeyName',
    keybind_hl = 'TelescopeWhichKeyKey',
    normal_hl = 'TelescopeWhichKeyNormal',
    border_hl = 'TelescopeWhichKeyBorder',
    -- normal_hl = "TelescopePrompt",
    -- border_hl = "TelescopePromptBorder",
    -- winblend = 15, --  config.values.winblend,
  }
  actions.which_key(prompt_bufnr, whichkey_opts)
end

M.switch_layout = function(prompt_bufnr, _opts)
  local opts = _opts or {}
  local picker = action_state.get_current_picker(prompt_bufnr)

  if picker.layout_strategy == 'bottom_pane' then
    opts = telethemes.get_theme('dropdown')
  elseif picker.layout_strategy == 'center' then
    opts.layout_config = config.values.layout_config
    opts.layout_strategy = 'flex'
  elseif picker.layout_strategy == 'flex' then
    opts = telethemes.get_theme('cursor')
  elseif picker.layout_strategy == 'cursor' then
    opts = telethemes.get_theme('ivy')
  elseif picker.layout_strategy == 'cursor' then
    opts = telethemes.get_theme('minimal')
  end
  opts.results_title = picker.results_title

  actions.close(prompt_bufnr)

  vim.api.nvim_set_var('project_buf_skip', 1)
  run('builtin', 'resume', opts)
end

M.switch_file_pickers_prev = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local prompt_text = picker:_get_prompt()

  -- local state = require("telescope.actions.state")
  -- if vim.api.nvim_buf_is_valid(prompt_bufnr) then
  --   actions.close(prompt_bufnr)
  -- end
  local opts = { default_text = prompt_text }

  vim.api.nvim_set_var('project_buf_skip', 1)
  if picker.prompt_title == 'Frecency' then
    run('builtin', 'find_files', opts)
  elseif picker.prompt_title == 'Find Files' then
    run('oldfiles', 'oldfiles', opts)
  else
    run('frecency', 'frecency', opts)
  end
end

M.switch_file_pickers_next = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local prompt_text = picker:_get_prompt()

  -- local state = require("telescope.actions.state")
  -- if vim.api.nvim_buf_is_valid(prompt_bufnr) then
  --   actions.close(prompt_bufnr)
  -- end
  local opts = { default_text = prompt_text }

  vim.api.nvim_set_var('project_buf_skip', 1)
  if picker.prompt_title == 'Frecency' then
    run('oldfiles', 'oldfiles', opts)
  elseif picker.prompt_title == 'Find Files' then
    run('frecency', 'frecency', opts)
  else
    run('builtin', 'find_files', opts)
  end
end

M.switch_grep_pickers_prev = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local prompt_text = picker:_get_prompt()
  local opts = { default_text = prompt_text }
  -- if vim.api.nvim_buf_is_valid(prompt_bufnr) then
  --   actions.close(prompt_bufnr)
  -- end

  local bufnr = vim.api.nvim_win_get_buf(picker.original_win_id)
  local bufparts = vim.split(vim.api.nvim_buf_get_name(bufnr), '/')
  table.remove(bufparts)

  local is_grep_project = string.match(picker.prompt_title, 'Live Grep Project')
  local is_grep_buffer = string.match(picker.prompt_title, 'Live Grep Buffers')
  local is_grep_cwd = string.match(picker.prompt_title, 'Live Grep CWD')
  if is_grep_project then
    opts.cwd = vim.fn.join(bufparts, '/')
  elseif is_grep_buffer then
    opts.grep_open_files = false
  elseif is_grep_cwd then
    opts.grep_open_files = true
  end
  vim.api.nvim_set_var('project_buf_skip', 1)
  run('builtin', 'live_grep', opts)
end

M.switch_grep_pickers_next = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local prompt_text = picker:_get_prompt()
  local opts = { default_text = prompt_text }
  -- if vim.api.nvim_buf_is_valid(prompt_bufnr) then
  --   actions.close(prompt_bufnr)
  -- end

  local bufnr = vim.api.nvim_win_get_buf(picker.original_win_id)
  local bufparts = vim.split(vim.api.nvim_buf_get_name(bufnr), '/')
  table.remove(bufparts)

  local is_grep_project = string.match(picker.prompt_title, 'Live Grep Project')
  local is_grep_buffer = string.match(picker.prompt_title, 'Live Grep Buffers')
  local is_grep_cwd = string.match(picker.prompt_title, 'Live Grep CWD')
  if is_grep_project then
    opts.grep_open_files = true
  elseif is_grep_buffer then
    opts.cwd = vim.fn.join(bufparts, '/')
  elseif is_grep_cwd then
    opts.grep_open_files = false
  end
  vim.api.nvim_set_var('project_buf_skip', 1)
  run('builtin', 'live_grep', opts)
end

M.launch_find_pickers = function(prompt_bufnr)
  vim.api.nvim_set_var('project_buf_skip', 1)
  run('find_pickers', 'find_pickers', {})
end

M.launch_projects = function(prompt_bufnr)
  vim.api.nvim_set_var('project_buf_skip', 1)
  run('projects', 'projects', {})
end

M.launch_find_files = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  vim.api.nvim_set_var('project_buf_skip', 1)
  run('builtin', 'find_files', { cwd = picker.cwd })
end

M.launch_live_grep = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  vim.api.nvim_set_var('project_buf_skip', 1)
  run('builtin', 'live_grep', { cwd = picker.cwd })
end

M.launch_dirpicker = function(bufnr)
  local current_picker = action_state.get_current_picker(bufnr) -- picker state
  local picker_title = current_picker.prompt_title

  local opts = {}
  opts.result_title = 'Choose Directory'
  local dirpicker_mappings = {
    default = function(directory)
      opts.cwd = directory
      opts.results_title = string.gsub(directory, os.getenv('HOME') or '', '~')
      if picker_title == 'Find Files' then
        pcall(require('telescope.builtin').find_files, opts)
      elseif string.find(picker_title, '%^Grep') then
        pcall(require('telescope.builtin').live_grep, opts)
      else
        vim.notify("Error: don't know what picker to open: " .. picker_title)
      end
    end,
  }

  opts.mappings = dirpicker_mappings
  pcall(dirpicker.run, opts)
end

M.directory_up = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  local picker = action_state.get_current_picker(prompt_bufnr)
  local prompt_prefix = picker.prompt_prefix
  local dir = picker.cwd or vim.fn.getcwd() or selection.cwd

  if not string.match(dir, '^/') then
    dir = vim.fn.getcwd() .. '/' .. picker.cwd
  end

  if dir ~= '/' then
    local dir_split = H.split_string(dir, '/')
    table.remove(dir_split)
    dir = '/' .. table.concat(dir_split, '/')
    dir = dir:gsub(vim.fn.getenv('HOME'), '~')

    local opts = {
      results_title = dir,
      cwd = dir,
      follow = true,
      prompt_prefix = prompt_prefix,
    }

    actions.close(prompt_bufnr)
    require('telescope.run')('builtin', 'find_files', opts)
  end
end

M.search_reset = function(prompt_bufnr, opts)
  local picker = action_state.get_current_picker(prompt_bufnr)
  picker:reset_prompt()
  -- TODO: detect if search is refined "Fuzzy match over" and reset
  -- local new_title = vim.tbl_get(picker, 'prompt_border', '_border_win_options', 'title')
  -- vim.dbglog('RESET', new_title, picker.prompt_title, picker.results_title, opts)
  -- local new_finder = finders.new_table { results = results, entry_maker = function(x) return x end }
  -- if not opts.reset_multi_selection and current_line ~= "" then
  --   opts.multi = current_picker._multi
  -- end
  -- if opts.prompt_to_prefix then
  --   local current_prefix = current_picker.prompt_prefix
  --   local suffix = current_prefix ~= opts.prompt_prefix and current_prefix or ""
  --   opts.new_prefix = suffix .. current_line .. " " .. opts.prompt_prefix
  -- end
  -- current_picker:refresh(new_finder, opts)
  -- current_picker:set_prompt(entry)
end

M.search_backspace_word = function(_)
  local backspace_key = vim.api.nvim_replace_termcodes('<C-w>', true, true, true)
  vim.api.nvim_feedkeys(backspace_key, 'i', true)
end

M.buffer_delete = function(prompt_bufnr)
  -- picker.cache_picker.limit_entries, picker.__scrolling_limit, picker.max_results,
  local selection = action_state.get_selected_entry()
  local opts = {
    -- show_all_buffers = true,
    -- sort_mru = true,
    -- mappings = mappings.buffer,
    -- ignore_current_buffer = false,
    -- only_cwd = false,
  }
  vim.cmd('Bdelete ' .. selection.value)
  -- actions.close(prompt_bufnr)
  -- require("telescope.run")("leaderf", opts)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local leaderf = require('configs.telescope.leaderf')
  local results = vim.tbl_filter(function(result)
    return result.value ~= selection.value
  end, picker.finder.results)
  -- opts.default_selection_idx = res.default_selection_idx
  local new_finder = finders.new_table({
    results = results,
    entry_maker = leaderf.gen_from_buffer(opts),
  })
  picker:refresh(new_finder, { reset_prompt = true })
  vim.notify('Closed  ' .. selection.file_name, 1)
end

local function create_scratch_win(filetype, lines)
  local buf, win
  filetype = (filetype == nil and 'result') or filetype
  vim.api.nvim_command('enew')
  win = vim.api.nvim_get_current_win()
  -- buf = vim.api.nvim_create_buf(true, true)
  buf = vim.api.nvim_win_get_buf(win)

  vim.api.nvim_buf_set_name(0, 'telecope-out #' .. buf)

  vim.api.nvim_buf_set_option(0, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(0, 'swapfile', false)
  vim.api.nvim_buf_set_option(0, 'filetype', filetype)
  vim.api.nvim_buf_set_option(0, 'bufhidden', 'wipe')

  vim.api.nvim_command('setlocal wrap')
  vim.api.nvim_command('setlocal cursorline')
  -- vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_buf_set_lines(buf, 0, #lines, false, lines)
end

M.yank_selection_to_buffer = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local multi_targets = picker:get_multi_selection()
  local lines = {}
  for _, target in ipairs(multi_targets) do
    table.insert(lines, target.value or target[1])
  end
  actions.close(prompt_bufnr)
  create_scratch_win('txt', lines)
end

M.yank_selection = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local multi_targets = picker:get_multi_selection()
  local lines = {}
  for _, target in ipairs(multi_targets) do
    table.insert(lines, target.value or target[1])
  end
  local register = '+'
  if vim.o.clipboard == 'unnamed' then
    register = '*'
  end
  vim.fn.setreg(register, vim.fn.join(lines, '\n'))
  actions.close(prompt_bufnr)
  vim.notify('Copied ' .. #lines .. ' lines to register ' .. register, 2)
end

M.refresh = function(prompt_bufnr)
  local make_entry = require('telescope.make_entry')

  local opts = {}
  opts.entry_maker = make_entry.gen_from_file(opts)

  local cmd = { 'fd', '--type', 'f', '--hidden' }
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  current_picker:refresh(finders.new_oneshot_job(cmd, opts), {})
end

return M
