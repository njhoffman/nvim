-- https://www.reddit.com/r/neovim/comments/1ee6oqt/helpviewnvim_an_impractical_way_to_view_help_files/

-- local setup_autocmds = function()
--   vim.api.nvim_create_autocmd('BufWinEnter', {
--     pattern = '*',
--     callback = init_state,
--   })
-- end
-- init_bufstate()

local get_state = function()
  local state = {
    vert_cutoff = 0.5, -- under this width ratio switch to vertical layout
    src_bufnr = vim.fn.bufnr("#"),
    help_bufnr = vim.fn.bufnr("%"),
  }
  return state
end

-- TODO: if main.tw + help.tw < columns => help.winfixwidth && winwidth = columns - help.tw
-- TODO: else => help.nowinfixwidth && winwidth = (columns * main.tw/help.tw)

local set_options = function()
  local state = get_state()
  local formatoptions = vim.api.nvim_get_option_value("formatoptions", { buf = state.src_bufnr })
    or ""
  if not string.find(formatoptions, "c") then
    vim.api.nvim_set_option_value("formatoptions", formatoptions .. "c", { buf = state.src_bufnr })
  end

  -- stylua: ignore start
  vim.api.nvim_set_option_value("winfixheight",  false, { win = state.help_winid })
  vim.api.nvim_set_option_value("winfixwidth",   false, { win = state.help_winid })
  vim.api.nvim_set_option_value("cursorcolumn",  false, { win = state.help_winid })
  vim.api.nvim_set_option_value("colorcolumn",   "",    { win = state.help_winid })
  vim.api.nvim_set_option_value("sidescroll",    1,     { win = state.help_winid })
  vim.api.nvim_set_option_value("sidescrolloff", 1,     { win = state.help_winid })
  vim.api.nvim_set_option_value("signcolumn",   "no",   { win = state.help_winid })
  vim.api.nvim_set_option_value("conceallevel",  3,     { win = state.help_winid })
end

local set_keymaps = function()
  local state = get_state()
  local bufmap = vim.api.nvim_buf_set_keymap
  if state.help_bufnr and state.help_bufnr > -1 and vim.api.nvim_buf_is_valid(state.help_bufnr) then
    -- nnoremap <buffer> <LocalLeader>K  :<C-U>helpgrep <cword><CR>
    -- let b:undo_ftplugin .= '|nunmap <buffer> K'
    bufmap(state.help_bufnr, "n", "<C-Space>", "<C-]>", { desc = "jump to tag definition" })
    bufmap(state.help_bufnr, "n", "<BS>", "<C-O>", { desc = "jump to prev visited tag" })
    bufmap(
      state.help_bufnr,
      "n",
      "]",
      "/|.\\{-}|<cr>",
      { desc = "jump to next tag in buffer", silent = true, nowait = true, noremap = false }
    )
    bufmap(
      state.help_bufnr,
      "n",
      "[",
      "?|.\\{-}|<cr>",
      { desc = "jump to prev tag in buffer", silent = true, nowait = true, noremap = false }
    )
  end
end

local set_syntax = function()
  -- local putils = require('telescope.previewers.utils')
  -- putils.ts_highlighter(state.src_bufnr, 'markdown')
  -- putils.regex_highlighter(state.src_bufnr, 'pandoc')
  -- vim.treesitter.language.register('help', 'markdown')
  -- vim.treesitter.language.register('help', { 'txt', 'text' })
  -- vim.treesitter.start()
end

local init = function()
  -- resize_window()
  -- read_history()
  -- create_autocmds()
  set_options()
  set_keymaps()
  set_syntax()
  -- resize_window()

  -- vim.fn.setcursorcharpos(vim.fn.line('.'), 1)

  -- vim.cmd("normal! 0")
end

init()
-- require("after.ftplugin.help-view")
