local set_window_title = function()
  if not os.getenv("TMUX") then
    os.execute("tmux setenv custom_path " .. vim.fn.getcwd())
  end
  local path = vim.split(vim.fn.getcwd(), "/", {})
  vim.opt.titlestring = [[%{v:progname}: ]] .. vim.fn.join({ path[#path - 1], path[#path] }, "/")
  vim.opt.title = true
end

vim.api.nvim_create_autocmd({ "DirChanged", "VimEnter" }, {
  group = vim.api.nvim_create_augroup("UpdateDirectory", { clear = true }),
  callback = function()
    local scope = vim.v.event.scope
    if scope == nil or scope == "global" then
      set_window_title()
    end
  end,
})

-- better jumplists, keepjumps, lock
-- https://github.com/inkarkat/vim-EnhancedJumps
-- function! UpdateHeader()
--     let b:winview = winsaveview()
--
--     " This is where I'd put the command to ignore future movements
--
--     "The periods concatenate all the arguments into one command.
--     "Silent! suppresses errors, usually 'pattern not found'
--     "The 1,6g means search only lines 1 thru 6
--     "Search for File Name: followed by anything
--     "'s'ubstitute
--     "Substitute in 'File Name: ' and the results of the expand command, on the
--     "current filename
--     execute "silent! 1," . 6 . "g/File Name:.*/s//File Name: " . expand("%")
--     execute "silent! 1," . 6 . "g/Last Modified:.*/s//Last Modified: " . strftime("%d-%m-%Y")
--
--     " This is where I'd put the command to start remembering movements again
--
--     call winrestview(b:winview)
-- endfunction
-- -- local timer = vim.loop.new_timer()
-- -- local blink = function()
-- --   local cnt, blink_times = 0, 8
-- --   timer:start(
-- --     0,
-- --     100,
-- --     vim.schedule_wrap(function()
-- --       vim.cmd('set cursorcolumn! cursorline!')
-- --
-- --       cnt = cnt + 1
-- --       if cnt == blink_times then
-- --         timer:stop()
-- --       end
-- --     end)
-- --   )
-- -- end
-- --
-- vim.keymap.set('n', '<leader>cb', blink)

-- Backup files
local backupdir = vim.fn.expand("$HOME") .. "/.local/share/nvim/backup"
vim.fn.mkdir(backupdir, "p")
vim.opt.backupdir = backupdir .. "//"
vim.opt.backup = true
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("VimBackup", { clear = true }),
  desc = "Add timestamp to backup extension",
  pattern = "*",
  callback = function()
    vim.opt.backupext = "-" .. vim.fn.strftime("%Y%m%d%H%M")
  end,
})
--
-- M.reload_lua = function()
--   -- /etc/tmpfiles.d/nvim-backup.conf
--   -- # systemd-tmpfiles configuration for /tmp/nvim-backup/ directory
--   -- # Create directory at boot and clean files with Age parameter
--   -- d /tmp/nvim-backup 755 <user> <user> 3d
--   for _, file in ipairs(M.get_config_modules()) do
--     R('config.' .. file)
--   end
--   cmd.nohlsearch()
-- end

-- M.diag_error = function()
--   return #diag.get(0, { severity = diag.severity.ERROR }) ~= 0
-- end

-- Lua reload
-- local write_source = vim.api.nvim_create_augroup('WritePostReload', {})
-- vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
--   group = write_source,
--   pattern = {
--     '*/nvim/lua/config/*.lua',
--     '*/nvim/lua/util/*.lua',
--   },
--   callback = function()
--     if not u.diag_error() then
--       u.reload_lua()
--     end
--   end,
-- })
-- vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
--   group = write_source,
--   pattern = '*/nvim/lua/snippets/*.lua',
--   callback = function()
--     if not u.diag_error() then
--       require('luasnip.loaders.from_lua').load({ paths = fn.stdpath('config') .. '/lua/snippets' })
--     end
--   end,
-- })
--

-- close some filetypes with q or <esc>
local quick_close = function(event)
  -- vim.bo[event.buf].buflisted = false
  vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = event.buf, silent = true })
  vim.keymap.set("n", "<esc>", "<cmd>q<cr>", { buffer = event.buf, silent = true })
end

-- close some filetypes with q or ctrl-shift-esc
local long_close = function(event)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "", {
  -- callback = function()
  -- vim.api.nvim_command("close")
  -- end,
  -- })
  vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = event.buf, silent = true })
  vim.keymap.set("n", "<M-{>", "<cmd>q<cr>", { buffer = event.buf, silent = true })
end

local winclose_group = vim.api.nvim_create_augroup("WinClose_q", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = winclose_group,
  pattern = {
    "NvimTree",
    "PlenaryTestPopup",
    "checkhealth",
    "fugitive",
    "lspinfo",
    -- "man",
    "noice",
    "startuptime",
    "vim",
    -- "",
  },
  callback = quick_close,
})

vim.api.nvim_create_autocmd("FileType", {
  group = winclose_group,
  pattern = {
    "Mundo",
    "MundoDiff",
    "dashboard",
    "help",
    "neo-tree",
    "qf",
    "query",
    "spectre_panel",
    "tablegen",
    "tsplayground",
  },
  callback = long_close,
})

-- close some buftypes with q or esc
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = winclose_group,
  callback = function(event)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = event.buf })
    local wintype = vim.fn.win_gettype(vim.fn.bufwinid(event.buf))
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = event.buf })

    if buftype == "nofile" and wintype == "popup" then
      quick_close(event)
      -- elseif filetype == "" then
      --   quick_close(event)
    end
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

--
-- function M.enable_reload_config_on_save()
--   -- autocmds require forward slashes (even on windows)
--   local pattern = get_config_dir():gsub("\\", "/") .. "/*.lua"
--
--   vim.api.nvim_create_augroup("lvim_reload_config_on_save", {})
--   vim.api.nvim_create_autocmd("BufWritePost", {
--     group = "lvim_reload_config_on_save",
--     pattern = pattern,
--     desc = "Trigger LvimReload on saving config.lua",
--     callback = function()
--       require("lvim.config"):reload()
--     end,
--   })
-- end

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = vim.api.nvim_create_augroup("resize_splits", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "CursorHold" }, {
  group = vim.api.nvim_create_augroup("buffer_changes", { clear = true }),
  callback = function()
    vim.cmd("checktime")
  end,
})
--
--
-- local all_filetypes = augroup('AllFileTypesLocalOptions')
-- autocmd({ 'FileType' }, {
--   group = all_filetypes,
--   pattern = { '*' },
--   callback = function()
--     opt_local.formatoptions = opt_local.formatoptions - 't' + 'c' - 'r' - 'o' - 'q' - 'a' + 'n' - '2' + 'l' + 'j'
--   end,
-- })
--
-- autocmd({ 'FileType' }, {
--   group = all_filetypes,
--   pattern = { '*' },
--   callback = function()
--     u.restore_cmdheight()
--   end,
-- })
--
-- local terminal = augroup('TerminalLocalOptions')
-- autocmd({ 'TermOpen' }, {
--   group = terminal,
--   pattern = { '*' },
--   callback = function(event)
--     opt_local.number = false
--     opt_local.relativenumber = false
--     opt_local.cursorline = false
--     opt_local.signcolumn = 'no'
--     opt_local.statuscolumn = ''
--     for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
--       vim.keymap.set('t', '<C-' .. key .. '>', function()
--         local code_term_esc = api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true)
--         local code_dir = api.nvim_replace_termcodes('<C-' .. key .. '>', true, true, true)
--         api.nvim_feedkeys(code_term_esc .. code_dir, 't', true)
--       end, { noremap = true })
--     end
--     if bo.filetype == '' then
--       api.nvim_buf_set_option(event.buf, 'filetype', 'terminal')
--       cmd.startinsert()
--     end
--   end,
-- })

-- #{?pane_in_mode,#[fg=white#,bg=red],#[fg=red#,bg=white]}#W .

vim.cmd([[
  command! SqlVis silent !tmux display-popup -b rounded -S 'fg=\#2255AA' -T '' -E -h 70\% -w90\% "psql --csv postgres://spadash:spadash@localhost/spadash --file=%:p | /bin/zsh -c 'vd -f csv --color-default=\"8 on black\" '"
]])
