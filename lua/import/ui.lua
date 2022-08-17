local M = {}

M.lines           = {}
M.is_displayed    = false
M.buf_handle      = nil
M.view_buf_handle = nil
M.buf_win_handle  = nil
M.view_win_handle = nil
M._user_opts      = nil

function M._init(_opts)
  M._user_opts = _opts
  vim.cmd [[
    highlight default link ImportSuccessIcon healthSuccess 
    highlight default link ImportInfoIcon DiagnosticInfo  
    highlight default link ImportErrorIcon DiagnosticError
  ]]
end

local ok, importer = pcall(require, 'import')
if not ok then
  vim.notify({ 'Error loading import wrapper', importer, }, "error")
end

local format_module = function(module, details)
  local icon = ""
  if not details then
    details = importer.get_status(module)
  end

  -- nvim_buf_add_highlight({buffer}, {ns_id}, {hl_group}, {line}, {col_start},
  --                        {col_end})
  if details.imported then
    icon = M._user_opts.import_success_icon
  else
    icon = M._user_opts.import_failed_icon
  end
  return " " .. icon .. " " .. tostring(module)
end

function M._update_main_buffer_line(lineno, new_text)
  vim.api.nvim_buf_set_option(M.buf_handle, 'modifiable', true)
  vim.api.nvim_buf_set_lines(M.buf_handle, lineno - 1, lineno, false, { new_text })
  vim.api.nvim_buf_set_option(M.buf_handle, 'modifiable', false)
end

function M._selected_module(line)
  local module = M._get_module(line)
  if not module then return end
  M._update_main_buffer_line(line, "...")
  importer.reload(module)
  M._update_main_buffer_line(line, format_module(module))
end

function M._scroll_view_pane_down()
  vim.api.nvim_win_call(M.view_win_handle,
    function()
      vim.cmd([[normal!]] .. 1 .. [[]])
    end)
end

function M._scroll_view_pane_up()
  vim.api.nvim_win_call(M.view_win_handle,
    function()
      vim.cmd([[normal!]] .. 1 .. [[]])
    end)
end

function M._get_module(line)
  line = M.lines[line]
  if not line or line == -1 then
    return
  end
  return line
end

local detail_lines = function()
  local module = M._get_module(vim.api.nvim_win_get_cursor(0)[1])
  if not module then
    vim.api.nvim_buf_set_option(M.view_buf_handle, 'modifiable', true)
    vim.api.nvim_buf_set_lines(M.view_buf_handle, 0, -1, false, {})
    vim.api.nvim_buf_set_option(M.view_buf_handle, 'modifiable', true)
    return
  end
  local details = importer.get_status(module)
  local lines = {}
  table.insert(lines, module)
  table.insert(lines, "    Imported: " .. details.status)
  table.insert(lines, "    Import Time: " .. math.floor(details.import_time / 1000000 * 1000) / 1000 .. " ms")
  table.insert(lines, "")
  local whitespace = '        '
  if details.errors and #details.errors > 0 then
    table.insert(lines, "    Errors (" .. #details.errors .. '): ')
    for _, _error in ipairs(details.errors) do
      for _line in _error:gmatch('[^\n]+') do
        -- https://github.com/miversen33/netman.nvim
        -- require("netman").log.debug({ line = _line })
        vim.notify({
          line = _line,
          len  = string.len(_line),
        }, 'debug')
        if not _line:match('^%s*$') then
          table.insert(lines, string.format('%s%s', whitespace, _line))
        end
      end
    end
    table.insert(lines, '')
  end

  if details.message and #details.message > 0 then
    table.insert(lines, "    Messages (" .. #details.message .. '): ')
    for _, _message in ipairs(details.message) do
      for _line in _message:gmatch('[^\n]+') do
        if not _line:match('^%s*$') then
          table.insert(lines, string.format('%s%s', whitespace, _line))
        end
      end
    end
    table.insert(lines, '')
  end

  if details.logs and #details.logs > 0 then
    table.insert(lines, "    Logs (" .. #details.logs .. '): ')
    for _, _log in ipairs(details.logs) do
      for _line in _log:gmatch('[^\n]+') do
        table.insert(lines, string.format('%s%s', whitespace, _line))
      end
    end
  end
  vim.api.nvim_buf_set_option(M.view_buf_handle, 'modifiable', true)
  vim.api.nvim_buf_set_lines(M.view_buf_handle, 0, -1, false, {})
  vim.api.nvim_buf_set_lines(M.view_buf_handle, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(M.view_buf_handle, 'modifiable', false)
  vim.api.nvim_buf_set_option(M.view_buf_handle, 'modified', false)
end

local summary_lines = function(imported, view_width, opts)
  local title = #imported.successes .. " imported"
  if #imported.failures > 0 then
    title = title .. ' - ' .. #imported.failures .. ' failed'
  end
  title = title .. ' - ' .. math.floor(imported.time / 1000000 * 100) / 100 .. " ms total"
  local title_padding = (view_width / 2) - (title:len() / 2)
  title = string.rep(' ', title_padding) .. title

  local lines = { title }
  M.lines = { -1 }
  for _, _failed_import in ipairs(imported.failures) do
    table.insert(lines, format_module(_failed_import, imported.details[_failed_import]))
    table.insert(M.lines, _failed_import)
  end
  table.insert(lines, "")
  table.insert(M.lines, -1)
  for _, _success_import in ipairs(imported.successes) do
    table.insert(lines, format_module(
      _success_import, imported.details[_success_import])
    )
    table.insert(M.lines, _success_import)
  end
  return lines
end

local assign_keys = function()
  vim.api.nvim_buf_set_keymap(M.buf_handle,
    'n', M._user_opts.keypress_select,
    ':lua require("import.ui")._selected_module(vim.fn.line("."))<CR>',
    { noremap = true, silent = true })

  vim.api.nvim_buf_set_keymap(M.buf_handle,
    'n', M._user_opts.keypress_close,
    ':lua require("import.ui").close()<CR>',
    { noremap = true, silent = true })

  vim.api.nvim_buf_set_keymap(M.buf_handle,
    'n', M._user_opts.keypress_scroll_output_down,
    ':lua require("import.ui")._scroll_view_pane_down()<CR>',
    { noremap = true, silent = true })

  vim.api.nvim_buf_set_keymap(M.buf_handle,
    'n', M._user_opts.keypress_scroll_output_up,
    ':lua require("import.ui")._scroll_view_pane_up()<CR>',
    { noremap = true, silent = true })
end

local assign_autocommands = function()
  vim.api.nvim_create_autocmd('BufDelete', {
    buffer = M.buf_handle,
    desc = "Clear out Cache for import UI",
    callback = M.close,
    once = true
  })

  vim.api.nvim_create_autocmd('WinClosed', {
    buffer = M.buf_handle,
    desc = "Clear out cache for import UI",
    callback = M.close,
    once = true
  })

  vim.api.nvim_create_autocmd('CursorMoved', {
    buffer = M.buf_handle,
    desc = "Loading Details into View Buffer",
    callback = detail_lines
  })
end

function M.display(opts)
  -- Short circuit if we are already displayed
  if M.is_displayed then return end

  M._init(opts)

  if not M.buf_handle or not vim.api.nvim_buf_is_loaded(M.buf_handle) then
    M.buf_handle = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(M.buf_handle, "ImportManager")
  end

  if not M.view_buf_handle or not vim.api.nvim_buf_is_loaded(M.view_buf_handle) then
    M.view_buf_handle = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(M.view_buf_handle, "ImportManager_Viewer")
  end

  local cur_ui = vim.api.nvim_list_uis()[1]

  local float_height = math.floor(cur_ui.height * .9)
  local float_width = math.floor(cur_ui.width * .9)
  local view_height = nil
  local view_width = nil
  local float_col = nil
  local float_row = nil
  local view_col = nil
  local view_row = nil

  if M._user_opts.output_split_type == 'horizontal' then
    view_height  = math.floor(float_height * .3)
    view_width   = float_width
    float_height = float_height - view_height
    float_col    = (cur_ui.width / 2) - (float_width / 2)
    float_row    = (cur_ui.height / 2) - (float_height / 2) - (view_height / 2)
    view_col     = (cur_ui.width / 2) - (view_width / 2)
    view_row     = (cur_ui.height / 2) - (view_height / 2) + (float_height / 2)
  else
    view_height = float_height
    view_width  = math.floor(float_width * .6)
    float_width = float_width - view_width
    float_col   = (cur_ui.width / 2) - (float_width / 2) - (view_width / 2)
    float_row   = (cur_ui.height / 2) - (float_height / 2)
    view_col    = (cur_ui.width / 2) - (view_width / 2) + (float_width / 2)
    view_row    = (cur_ui.height / 2) - (view_height / 2)
  end

  local float_opts = {
    relative = 'editor',
    border   = 'double',
    width    = float_width,
    height   = float_height,
    col      = float_col,
    row      = float_row,
    style    = 'minimal'
  }

  local view_opts = {
    relative = 'editor',
    border   = 'rounded',
    width    = view_width,
    height   = view_height,
    col      = view_col,
    row      = view_row,
    style    = 'minimal'
  }

  local imported = { failures = {}, successes = {}, details = {}, time = 0 }
  for _, module in ipairs(importer.get_imported_modules()) do
    local details = importer.get_status(module)
    imported.details[module] = details
    imported.time = imported.time + details.import_time
    if details.imported then
      table.insert(imported.successes, module)
    else
      table.insert(imported.failures, module)
    end
  end

  local lines = summary_lines(imported, view_width, opts)

  vim.api.nvim_buf_set_option(M.buf_handle, 'modifiable', true)
  vim.api.nvim_buf_set_lines(M.buf_handle, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(M.buf_handle, 'modifiable', false)
  vim.api.nvim_buf_set_option(M.buf_handle, 'filetype', "ImportManager")
  vim.api.nvim_buf_set_option(M.buf_handle, 'modified', false)
  vim.api.nvim_buf_set_option(M.view_buf_handle, 'modifiable', false)
  vim.api.nvim_buf_set_option(M.view_buf_handle, 'filetype', "ImportManager")
  vim.api.nvim_buf_set_option(M.view_buf_handle, 'modified', false)
  vim.api.nvim_set_option_value('wrap', true, { scope = 'local' })

  assign_keys()
  assign_autocommands()

  M.view_win_handle = vim.api.nvim_open_win(M.view_buf_handle, 1, view_opts)
  M.buf_win_handle  = vim.api.nvim_open_win(M.buf_handle, 1, float_opts)
end

function M.close()
  M.is_displayed = false
  M.modules = {}
  if M.buf_handle and vim.api.nvim_buf_is_loaded(M.buf_handle) then
    vim.api.nvim_buf_delete(M.buf_handle, { force = true })
  end
  if M.view_buf_handle and vim.api.nvim_buf_is_loaded(M.view_buf_handle) then
    vim.api.nvim_buf_delete(M.view_buf_handle, { force = true })
  end
  if M.buf_win_handle and vim.api.nvim_win_is_valid(M.buf_win_handle) then
    vim.api.nvim_win_close(M.buf_win_handle, { force = true })
  end
  if M.view_win_ and vim.api.nvim_win_is_valid(M.view_win_handle) then
    vim.api.nvim_win_close(M.view_win_handle, { force = true })
  end
  M.buf_handle = nil
  M.view_buf_handle = nil
  M.buf_win_handle = nil
  M.view_win_handle = nil
end

return M
