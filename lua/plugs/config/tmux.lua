require("tmux").setup({
  copy_sync = {
    enable = false,
  },
  navigation = {
    -- cycles to opposite pane while navigating into the border
    cycle_navigation = true,
    -- enables default keybindings (C-hjkl) for normal mode
    -- enable_default_keybindings = true,
    enable_default_keybindings = true,
    -- prevents unzoom tmux when navigating beyond vim border
    persist_zoom = true,
  },
  resize = {
    -- enables default keybindings (A-hjkl) for normal mode
    enable_default_keybindings = true,

    -- sets resize steps for x axis
    resize_step_x = 1,

    -- sets resize steps for y axis
    resize_step_y = 1,
  },
})

-- TODO: only vim navigate on splits

-- vim.api.nvim_set_keymap("n", "<C-h>", '<cmd>lua require("tmux").move_left()<cr>', {})
-- vim.api.nvim_set_keymap("n", "<C-l>", '<cmd>lua require("tmux").move_right()<cr>', {})
-- vim.api.nvim_set_keymap("n", "<C-k>", '<cmd>lua require("tmux").move_top()<cr>', {})
-- vim.api.nvim_set_keymap("n", "<C-j>", '<cmd>lua require("tmux").move_bottom()<cr>', {})

-- local defaultConfig = {
--   copy_sync = {
--     -- enables copy sync and overwrites all register actions to
--     -- sync registers *, +, unnamed, and 0 till 9 from tmux in advance
--     enable = false,
--     -- ignore specific tmux buffers e.g. buffer0 = true to ignore the
--     -- first buffer or named_buffer_name = true to ignore a named tmux
--     -- buffer with name named_buffer_name :)
--     ignore_buffers = { empty = false },
--     -- TMUX >= 3.2: yanks (and deletes) will get redirected to system
--     -- clipboard by tmux
--     redirect_to_clipboard = false,
--     -- offset controls where register sync starts
--     -- e.g. offset 2 lets registers 0 and 1 untouched
--     register_offset = 0,
--     -- sync clipboard overwrites vim.g.clipboard to handle * and +
--     -- registers. If you sync your system clipboard without tmux, disable
--     -- this option!
--     sync_clipboard = true,
--     -- syncs deletes with tmux clipboard as well, it is adviced to
--     -- do so. Nvim does not allow syncing registers 0 and 1 without
--     -- overwriting the unnamed register. Thus, ddp would not be possible.
--     sync_deletes = true,
--     -- syncs the unnamed register with the first buffer entry from tmux.
--     sync_unnamed = true,
--   },
--   navigation = {
--     -- cycles to opposite pane while navigating into the border
--     cycle_navigation = true,
--     -- enables default keybindings (C-hjkl) for normal mode
--     enable_default_keybindings = false,
--     -- prevents unzoom tmux when navigating beyond vim border
--     persist_zoom = false,
--   },
--   resize = {
--     -- enables default keybindings (A-hjkl) for normal mode
--     enable_default_keybindings = false,
--     -- sets resize steps for x axis
--     resize_step_x = 1,
--     -- sets resize steps for y axis
--     resize_step_y = 1,
--   },
-- }

-- [[<cmd>lua require("tmux").move_left()<cr>]],
-- [[<cmd>lua require("tmux").move_bottom()<cr>]],
-- [[<cmd>lua require("tmux").move_top()<cr>]],
-- [[<cmd>lua require("tmux").move_right()<cr>]],

-- is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

-- bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h' { if -F '#{pane_at_left}' '' 'select-pane -L' }
-- bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j' { if -F '#{pane_at_bottom}' '' 'select-pane -D' }
-- bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k' { if -F '#{pane_at_top}' '' 'select-pane -U' }
-- bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l' { if -F '#{pane_at_right}' '' 'select-pane -R' }

-- bind-key -T copy-mode-vi 'C-h' if -F '#{pane_at_left}' '' 'select-pane -L'
-- bind-key -T copy-mode-vi 'C-j' if -F '#{pane_at_bottom}' '' 'select-pane -D'
-- bind-key -T copy-mode-vi 'C-k' if -F '#{pane_at_top}' '' 'select-pane -U'
-- bind-key -T copy-mode-vi 'C-l' if -F '#{pane_at_right}' '' 'select-pane -R'
