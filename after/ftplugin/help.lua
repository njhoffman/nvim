local state = require('utils.help.state')

-- local setup_autocmds = function()
--   vim.api.nvim_create_autocmd('BufWinEnter', {
--     pattern = '*',
--     callback = init_state,
--   })
-- end
-- init_bufstate()

local set_options = function()
  local formatoptions = vim.api.nvim_get_option_value('formatoptions', { buf = state.src_bufnr })
    or ''
  if not string.find(formatoptions, 'c') then
    vim.api.nvim_set_option_value('formatoptions', formatoptions .. 'c', { buf = state.src_bufnr })
  end
  -- nnoremap <buffer> <LocalLeader>K  :<C-U>helpgrep <cword><CR>
  -- let b:undo_ftplugin .= '|nunmap <buffer> K'

  vim.api.nvim_set_option_value('winfixheight', false, { win = state.help_winid })
  vim.api.nvim_set_option_value('winfixwidth', false, { win = state.help_winid })
  vim.api.nvim_set_option_value('cursorcolumn', false, { win = state.help_winid })
  vim.api.nvim_set_option_value('colorcolumn', '', { win = state.help_winid })
  -- vim.api.nvim_set_option_value('tabstop', 2, { buf = state.help_bufnr })
end

local set_keymaps = function()
  local bufmap = vim.api.nvim_buf_set_keymap
  if
    state.help_bufnr
    and state.help_bufnr > -1
    and vim.api.nvim_buf_is_loaded(state.help_bufnr)
  then
    bufmap(state.help_bufnr, 'n', '<C-Space>', '<C-]>', { desc = 'jump to tag definition' })
    bufmap(state.help_bufnr, 'n', '<BS>', '<C-O>', { desc = 'jump to prev visited tag' })
  end
end

local set_syntax = function()
  -- local putils = require('telescope.previewers.utils')
  -- putils.ts_highlighter(state.src_bufnr, 'markdown')
  -- putils.regex_highlighter(state.src_bufnr, 'pandoc')
  -- vim.treesitter.language.register('help', 'markdown')
  -- vim.treesitter.language.register('help', { 'txt', 'text' })
  vim.treesitter.start()
end

local init = function()
  -- resize_window()
  -- read_history()
  -- create_autocmds()
  -- set_options()
  -- set_keymaps()
  set_syntax()
  -- resize_window()

  -- vim.fn.setcursorcharpos(vim.fn.line('.'), 1)

  vim.cmd('normal! 0')
  -- end
end

init()
