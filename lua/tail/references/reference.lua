local Status_Char = '|'

local function exists_option(option)
  return vim.g[option] ~= nil
end

-- set the default options for the plugin
if not exists_option('tail#Height') then
  vim.g['tail#Height'] = 10
end

if not exists_option('tail#Center_Win') then
  vim.g['tail#Center_Win'] = 0
end

-- sets up the preview window to watch the specified file for changes
local function tail_open(type, file)
  file = file:gsub('\\', '/')

  if not vim.fn.filereadable(file) then
    vim.api.nvim_command('echohl ErrorMsg')
    vim.api.nvim_echo('Cannot open for reading: ' .. file, false, {})
    vim.api.nvim_command('echohl None')
  else
    if vim.api.nvim_buf_is_valid(vim.fn.bufnr(file)) then
      vim.api.nvim_command('bwipeout ' .. vim.fn.bufnr(file))
    end

    vim.api.nvim_command('augroup Tail')
    vim.api.nvim_command("autocmd CursorHold * lua require('plugin').tail_monitor()")
    vim.api.nvim_command("autocmd CursorHoldI * lua require('plugin').tail_monitor()")
    vim.api.nvim_command("autocmd FocusLost * lua require('plugin').tail_monitor()")
    vim.api.nvim_command("autocmd FocusGained * lua require('plugin').tail_monitor()")
    vim.api.nvim_command("autocmd BufEnter * lua require('plugin').tail_monitor()")
    vim.api.nvim_command("autocmd BufWinEnter * lua require('plugin').tail_setup()")
    vim.api.nvim_command("autocmd BufWinLeave * lua require('plugin').tail_stop()")
    vim.api.nvim_command("autocmd FileChangedShell * lua require('plugin').tail_refresh()")
    vim.api.nvim_command('augroup END')

    vim.api.nvim_command(type .. ' ' .. file)
  end
end

-- watch the specified file for changes in different split window
local function tail_open_split(file)
  tail_open(vim.g['tail#Height'] .. 'new', file)
end

-- watch the specified file for changes in different tabs
local function tail_open_tabs(...)
  for i = 1, select('#', ...) do
    tail_open('tabnew', select(i, ...))
  end
end

-- used by Tail to check the file status
local function tail_monitor()
  vim.api.nvim_command('checktime')
  require('plugin').tail_status()
end

-- used by Tail to check the file status
local function tail_status()
  if Status_Char == '|' then
    Status_Char = '/'
  elseif Status_Char == '/' then
    Status_Char = '-'
  elseif Status_Char == '-' then
    Status_Char = '\\'
  elseif Status_Char == '\\' then
    Status_Char = '|'
  end
  return Status_Char
end

local function tail_setup()
  vim.api.nvim_command(
    'setlocal autoread bufhidden=delete nobuflisted nomodifiable'
      .. ' nonumber noshowcmd noswapfile nowrap previewwindow'
  )
  vim.api.nvim_set_keymap('n', 'i', ':setlocal wrap<CR>', { noremap = true, buffer = true })
  vim.api.nvim_set_keymap('n', 'I', ':setlocal nowrap<CR>', { noremap = true, buffer = true })
  -- ...
end

-- ... continue translating the rest of the functions
