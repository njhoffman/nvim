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
local winclose_group = vim.api.nvim_create_augroup("WinClose_q", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = winclose_group,
  pattern = {
    "NvimTree",
    "PlenaryTestPopup",
    "lspinfo",
    "man",
    "nerdtree",
    "noice",
    "startuptime",
  },
  callback = function(event)
    -- vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = event.buf, silent = true })
    vim.keymap.set("n", "<esc>", "<cmd>q<cr>", { buffer = event.buf, silent = true })
  end,
})

-- close some filetypes with q or shift-esc
vim.api.nvim_create_autocmd("FileType", {
  group = winclose_group,
  pattern = {
    "Mundo",
    "MundoDiff",
    "dashboard",
    "fugitive",
    "help",
    "neo-tree",
    "tablegen",
    "qf",
    "query",
    "spectre_panel",
    "tsplayground",
  },
  callback = function(event)
    -- vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = event.buf, silent = true })
    vim.keymap.set("n", "<M-{>", "<cmd>q<cr>", { buffer = event.buf, silent = true })
  end,
})

-- close some buftypes with q or esc
vim.api.nvim_create_autocmd({ "BufRead" }, {
  group = winclose_group,
  callback = function(event)
    -- vim.bo[event.buf].buflisted = false
    local buftype = vim.api.nvim_buf_get_option(event.buf, "buftype")
    if buftype == "nofile" then
      vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = event.buf, silent = true })
      vim.keymap.set("n", "<M-{>", "<cmd>q<cr>", { buffer = event.buf, silent = true })
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

-- Buffer
local file_pattern = {
  "*.css",
  "*.fish",
  "*.html",
  "*.json",
  "*.lua",
  "*.md",
  "*.rb",
  "*.sass",
  "*.scss",
  "*.sh",
  "*.ts",
  "Dockerfile",
  "docker-compose.yaml",
  "*.cpp",
}

-- local cursor_line = vim.api.nvim_create_augroup('BufferDetectChanges', {})
-- autocmd({ 'FocusGained', 'BufEnter' }, {
--   group = buffer,
--   pattern = file_pattern,
--   callback = function()
--     cmd.checktime()
--   end,
-- })
--

local remove_eol_comments = function(comment_syntax, lines)
  if not lines then
    local cur_pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_command("%s/" .. comment_syntax .. ".*//g")
    vim.api.nvim_win_set_cursor(0, cur_pos)
    return ""
  else
    for i, line in ipairs(lines) do
      lines[i] = line:gsub(comment_syntax .. ".*", "")
    end
    return lines
  end
end

local remove_eol_comments_ft = function(lines)
  local ft = vim.bo.filetype
  if ft == "javascript" or ft == "c" or ft == "cpp" then
    remove_eol_comments("//", lines)
  elseif ft == "lua" then
    remove_eol_comments("--", lines)
  elseif ft == "python" then
    remove_eol_comments("#", lines)
  else
    print("Unrecognized filetype.")
  end
end

local get_current_lines = function()
  local cursor = vim.api.nvim_win_get_cursor(0)

  -- local current_line = vim.fn.trim(
  --   remove_eol_comments_ft(vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1])
  -- ) or ''
  local current_line = vim.fn.trim(
    remove_eol_comments_ft(vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]) or ""
  )
end

local get_last_char = function(chars, opts)
  return function()
    opts = opts or {}
    chars = type(chars) == "string" and { chars } or (type(chars) == "table" and chars) or {}
    local key = type(chars) == "table" and chars[1] or chars
    local mode = opts.mode or (vim.tbl_isempty(chars) and "strip") or "toggle"

    local last_character = current_line and current_line:sub(-1) or ""
    local to_remove, to_append = "", ""

    if mode == "toggle" then
      to_append = key
      for _, char in ipairs(chars) do
        if char == last_character then
          to_remove = char
          to_append = ""
        end
      end
    elseif mode == "append" then
      to_append = vim.fn.nr2char(vim.fn.getchar())
    elseif mode == "strip" then
      to_remove = last_character
      vim.dbglog("remove", to_remove)
      to_append = ""
    end

    if to_remove ~= "" then
      -- remove last matching of to_remove
      current_line = current_line:sub(1, #current_line - #to_remove)
    end
    current_line = current_line .. to_append
    vim.api.nvim_buf_set_lines(0, cursor[1] - 1, cursor[1], true, { current_line })
    vim.cmd('silent! normal "0=="')
    vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] })
  end
end

local trail_chars = { ",", ";", ")", "'", '"', "|", "\\", ".", "}" }

-- strip last character
vim.keymap.set("n", "<leader>$", get_last_char(), { desc = "ﲖ strip end characters" })
-- append provided end character
vim.keymap.set(
  "n",
  "<leader>A",
  get_last_char(_, { mode = "append" }),
  { desc = "ﲖ append end character" }
)

-- toggle provided end character
-- vim.keymap.set('n', '<leader>a', get_last_char(_, { mode = 'toggle' }), {
--   desc = 'ﲖ toggle ' .. char .. ' end character',
-- })

-- toggle common end characters
vim.keymap.set(
  "n",
  "<leader>a",
  get_last_char(trail_chars),
  { desc = 'ﲖ toggle end characters: ,;)"|\\.}' }
)

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
