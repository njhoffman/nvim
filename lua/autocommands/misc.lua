-- -- change background color when in insert mode
-- vim.api.nvim_create_autocmd({ "InsertEnter" }, {
--   callback = function()
--     vim.api.nvim_set_hl(0, "Normal", { bg = "#030508" })
--   end
-- })

-- vim.api.nvim_create_autocmd({ "InsertLeave" }, {
--   callback = function()
--     vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--   end
-- })

-- Make window title indicative of our cwd
-- Loaded before normal autocmds (./autocmds) because we leverage the `VimEnter` here.

local set_window_title = function()
  local path = vim.split(vim.fn.getcwd(), '/', {})
  vim.opt.titlestring = [[%{v:progname}: ]] .. vim.fn.join({ path[#path - 1], path[#path] }, '/')
  vim.opt.title = true
end

vim.api.nvim_create_autocmd({ 'DirChanged', 'VimEnter' }, {
  group = vim.api.nvim_create_augroup('UpdateWindowTitle', { clear = true }),
  callback = function()
    local scope = vim.v.event.scope
    if scope == nil or scope == 'global' then
      set_window_title()
    end
  end,
})

local winclose_group = vim.api.nvim_create_augroup('winclose_q', { clear = true })
-- close some filetypes with q or <esc>
vim.api.nvim_create_autocmd('FileType', {
  group = winclose_group,
  pattern = {
    'NvimTree',
    'PlenaryTestPopup',
    'lspinfo',
    'man',
    'nerdtree',
    'notify',
    'noice',
    'startuptime',
  },
  callback = function(event)
    -- vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>q<cr>', { buffer = event.buf, silent = true })
    vim.keymap.set('n', '<esc>', '<cmd>q<cr>', { buffer = event.buf, silent = true })
  end,
})

-- close some filetypes with q or  shift-esc
vim.api.nvim_create_autocmd('FileType', {
  group = winclose_group,
  pattern = {
    'Mundo',
    'MundoDiff',
    'dashboard',
    'fugitive',
    'help',
    'qf',
    'query',
    'spectre_panel',
    'tsplayground',
  },
  callback = function(event)
    -- vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>q<cr>', { buffer = event.buf, silent = true })
    vim.keymap.set('n', '<M-{>', '<cmd>q<cr>', { buffer = event.buf, silent = true })
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--   group = augroup("auto_create_dir"),
--   callback = function(event)
--     local file = vim.loop.fs_realpath(event.match) or event.match
--     vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
--   end,
-- })

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = vim.api.nvim_create_augroup('resize_splits', { clear = true }),
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = vim.api.nvim_create_augroup('checktime', { clear = true }),
  command = 'checktime',
})

vim.cmd([=[
augroup qf-history
    autocmd!
    autocmd QuickFixCmdPost chistory echo printf('Quickfix %d of %d (%d items): %s',  getqflist({'nr': 0}).nr,  getqflist({'nr': '$'}).nr,  getqflist({'size': 0}).size,  getqflist({'title': 0}).title )
    autocmd QuickFixCmdPost lhistory echo printf('Location-list %d of %d (%d items): %s',  getloclist(0, {'nr': 0}).nr,  getloclist(0, {'nr': '$'}).nr, getloclist(0, {'size': 0}).size, getloclist(0, {'title': 0}).title )
augroup END
]=])
-- Automatically open the quickfix or location-list window after selecting a list in the popup menu:
vim.cmd([[
augroup qf-history
  autocmd!
  autocmd QuickFixCmdPost chistory cwindow
  autocmd QuickFixCmdPost lhistory lwindow
augroup END
]])

vim.cmd([[
  augroup IME
    autocmd InsertEnter * call chansend(v:stderr, "\e[?737769h")
    autocmd InsertLeave * call chansend(v:stderr, "\e[?737769l")
  augroup end
]])
-- if config.autocommands.relnum_in_visual_mode and vim.fn.exists('##ModeChanged') == 1 then
--    -- Show relative line numbers only when they matter (linewise and blockwise
--    -- selection) and 'number' is set (avoids horizontal flickering)
--    vim.cmd([[autocmd ModeChanged *:[V\x16]* let &l:relativenumber = &l:number == 1]])
--    -- - Using `mode () =~#...` handles switching between linewise and blockwise mode.
--    vim.cmd([[autocmd ModeChanged [V\x16]*:* let &l:relativenumber = mode() =~# '^[V\x16]']])
--  end

-- #{?pane_in_mode,#[fg=white#,bg=red],#[fg=red#,bg=white]}#W .
vim.cmd([[
  command! SqlVis silent !tmux display-popup -b rounded -S 'fg=\#2255AA' -T '' -E -h 70\% -w90\% "psql --csv postgres://spadash:spadash@localhost/spadash --file=%:p | /bin/zsh -c 'vd -f csv --color-default=\"8 on black\" '"
]])
