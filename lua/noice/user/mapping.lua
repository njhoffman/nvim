local function is_lsp_float_open(window_id)
  return window_id and window_id ~= 0 and vim.api.nvim_win_is_valid(window_id)
end

local function scroll(sendkeys)
  for _, kind in ipairs({ 'hover', 'signature' }) do
    local message = require('noice.lsp.docs').get(kind)
    local win = message:win()
    if is_lsp_float_open(win) then
      -- vim.api.nvim_feedkeys(sendkeys, 'n', true)
      -- sendkeys = '\\<Plug>(SmoothieDownwards)'
      -- vim.fn.win_execute(win, 'normal! ' .. sendkeys)
      return true
    end
  end
  return false
end

local function escape_term_codes(str)
  return vim.api.nvim_replace_termcodes(str, true, false, true)
end

local scroll_keys = {
  page_up = escape_term_codes('kkk'),
  page_down = escape_term_codes('jjj'),
  scroll_up = escape_term_codes('<Up>'),
  scroll_down = escape_term_codes('<Down>'),
}

local function scroll_lsp_popups(key, scroll_height)
  return function()
    vim.dbglog('try scroll', key)
    if not require('noice.lsp').scroll(scroll_height) then
      vim.dbglog('here', key)
      return key
    end
  end
end

local setup = function()
  vim.keymap.set(
    { 'n', 'i', 's' },
    '<M-f>',
    scroll_lsp_popups('<M-f>', 4),
    { silent = true, expr = true }
  )

  vim.keymap.set(
    { 'n', 'i', 's' },
    '<M-b>',
    scroll_lsp_popups('<M-b>', -4),
    { silent = true, expr = true }
  )

  vim.keymap.set(
    { 'n', 'i', 's' },
    '<C-S-Up>',
    scroll_lsp_popups('<C-S-Up>', -2),
    { silent = true, expr = true }
  )
  vim.keymap.set(
    { 'n', 'i', 's' },
    '<C-S-Down>',
    scroll_lsp_popups('<C-S-Down>', 2),
    { silent = true, expr = true }
  )
end

-- :execute "normal \<Plug>(SmoothieDownwards)"
-- feedkeys(":call g:Func()\<CR>")
-- :call win_execute(1000, 'echo')
return { setup = setup }

-- vim.keymap.set({ 'n', 'i', 's' }, '<M-f>', function()
--   vim.dbglog('ARG', arg)
--   if not require('noice.lsp').scroll(4) then
--     return '<M-f>'
--   end
-- end, { silent = true, expr = true })
--
-- vim.keymap.set({ 'n', 'i', 's' }, '<C-f>', function()
--   if not require('noice.lsp').scroll(2) then
--     return '<C-f>'
--   end
-- end, { silent = true, expr = true })

-- vim.keymap.set({ 'n', 'i', 's' }, '<M-b>', function()
--   if not require('noice.lsp').scroll(-4) then
--     return '<M-b>'
--   end
-- end, { silent = true, expr = true })

-- vim.keymap.set({ 'n', 'i', 's' }, '<C-b>', function()
--   if not require('noice.lsp').scroll(-2) then
--     return '<C-b>'
--   end
-- end, { silent = true, expr = true })

-- -- Adding the following keymap, will redirect the active cmdline when pressing <S-Enter>. The cmdline stays open, so you can change the command and execute it again. When exiting the cmdline, the popup window will be focused.
-- vim.keymap.set('c', '<S-Enter>', function()
--   require('noice').redirect(vim.fn.getcmdline())
-- end, { desc = 'Redirect Cmdline' })
