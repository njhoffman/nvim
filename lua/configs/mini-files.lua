local default = {
  -- Customization of shown content
  content = {
    -- Predicate for which file system entries to show
    filter = nil,
    -- What prefix to show to the left of file system entry
    prefix = nil,
    -- In which order to show file system entries
    sort = nil,
  },

  -- Module mappings created only inside explorer.
  -- Use `''` (empty string) to not create one.
  mappings = {
    close = 'q',
    go_in = 'l',
    go_in_plus = 'L',
    go_out = 'h',
    go_out_plus = 'H',
    reset = '<BS>',
    reveal_cwd = '@',
    show_help = 'g?',
    synchronize = '=',
    trim_left = '<',
    trim_right = '>',
  },

  -- General options
  options = {
    -- Whether to delete permanently or move into module-specific trash
    permanent_delete = true,
    -- Whether to use for editing directories
    use_as_default_explorer = true,
  },

  -- Customization of explorer windows
  windows = {
    -- Maximum number of windows to show side by side
    max_number = math.huge,
    -- Whether to show preview of file/directory under cursor
    preview = false,
    -- Width of focused window
    width_focus = 50,
    -- Width of non-focused window
    width_nofocus = 15,
    -- Width of preview window
    width_preview = 25,
  },
}

local cfg = {
  options = {
    use_as_default_explorer = false,
  },
  mappings = {
    close = '<M-{>',
    -- close = 'q',
    go_in = '',
    -- go_in = 'l',
    go_in_plus = 'L',
    go_out = '',
    -- go_out = 'h',
    go_out_plus = 'H',
    reset = '<esc>',
    -- reset = '<BS>',
    -- reveal_cwd = '@',
    show_help = '<M-C-_>',
    -- show_help = 'g?',
    -- synchronize = '=',
    -- trim_left = '<',
    -- trim_right = '>',
  },
}

local minifiles_toggle = function()
  if not MiniFiles.close() then
    MiniFiles.open()
  end
end

vim.api.nvim_create_user_command('MiniFiles', minifiles_toggle, { desc = 'toggle minifiles file manager' })

-- local buf_map = function(mode, lhs, rhs, desc)
--   -- Use `nowait` to account for non-buffer mappings starting with `lhs`
--   H.map(mode, lhs, rhs, { buffer = buf_id, desc = desc, nowait = true })
-- end
--
-- --stylua: ignore start
-- buf_map('n', mappings.close,       MiniFiles.close,       'Close')
-- buf_map('n', mappings.go_in,       go_in_with_count,      'Go in entry')
-- buf_map('n', mappings.go_in_plus,  go_in_plus,            'Go in entry plus')
-- buf_map('n', mappings.go_out,      go_out_with_count,     'Go out of directory')
-- buf_map('n', mappings.go_out_plus, go_out_plus,           'Go out of directory plus')
-- buf_map('n', mappings.reset,       MiniFiles.reset,       'Reset')
-- buf_map('n', mappings.reveal_cwd,  MiniFiles.reveal_cwd,  'Reveal cwd')
-- buf_map('n', mappings.show_help,   MiniFiles.show_help,   'Show Help')
-- buf_map('n', mappings.synchronize, MiniFiles.synchronize, 'Synchronize')
-- buf_map('n', mappings.trim_left,   MiniFiles.trim_left,   'Trim branch left')
-- buf_map('n', mappings.trim_right,  MiniFiles.trim_right,  'Trim branch right')
--

-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'MiniFilesWindowOpen',
--   callback = function(args)
--     local win_id = args.data.win_id
--
--     -- Customize window-local settings
--     vim.wo[win_id].winblend = 50
--     vim.api.nvim_win_set_config(win_id, { border = 'double' })
--   end,
-- })
-- set cwd
-- local files_set_cwd = function(path)
--   -- Works only if cursor is on the valid file system entry
--   local cur_entry_path = MiniFiles.get_fs_entry().path
--   local cur_directory = vim.fs.dirname(cur_entry_path)
--   vim.fn.chdir(cur_directory)
-- end
--
-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'MiniFilesBufferCreate',
--   callback = function(args)
--     vim.keymap.set('n', 'g~', files_set_cwd, { buffer = args.data.buf_id })
--   end,
-- })

require('mini.files').setup(cfg)
