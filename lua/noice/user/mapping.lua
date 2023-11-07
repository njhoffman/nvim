local function get_key_cmd(mode, lhs)
  local keys = vim.api.nvim_get_keymap(mode)
  local old_val = nil
  for _, key in ipairs(keys) do
    if key.lhs == lhs then
      old_val = key.callback or key.rhs
    end
  end
  return old_val
end

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

local old_keys = {
  prev = {
    n = get_key_cmd('n', '<M-b>'),
    i = get_key_cmd('i', '<M-b>'),
    s = get_key_cmd('s', '<M-b>'),
  },
  next = {
    n = get_key_cmd('n', '<M-f>'),
    i = get_key_cmd('i', '<M-f>'),
    s = get_key_cmd('s', '<M-f>'),
  },
}

local function escape_term_codes(str)
  return vim.api.nvim_replace_termcodes(str, true, false, true)
end

local scroll_keys = {
  page_up = escape_term_codes('kkk'),
  page_down = escape_term_codes('jjj'),
  scroll_up = escape_term_codes('<Up>'),
  scroll_down = escape_term_codes('<Down>'),
}

local setup = function()
  vim.keymap.set({ 'n', 'i', 's' }, '<M-f>', function()
    if not require('noice.lsp').scroll(2) then
      return '<M-f>'
    end
  end, { silent = true, expr = true })

  vim.keymap.set({ 'n', 'i', 's' }, '<M-b>', function()
    if not require('noice.lsp').scroll(-2) then
      return '<M-b>'
    end
  end, { silent = true, expr = true })

  -- for _, mode in ipairs({ 'n', 'i', 's' }) do
  --   for _, direction in ipairs({ 'prev', 'next' }) do
  --     local lhs = direction == 'prev' and '<M-b>' or '<M-f>'
  --     local scroll_key = direction == 'prev' and scroll_keys.page_up or scroll_keys.page_down
  --
  --     vim.keymap.set(mode, lhs, function()
  --       local res = scroll(scroll_key)
  --
  --       if not res then
  --         -- old_keys[direction][mode]()
  --         vim.dbglog('no scroll, do the old key', old_keys[direction][mode])
  --       end
  --     end)
  --   end
  -- end
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
