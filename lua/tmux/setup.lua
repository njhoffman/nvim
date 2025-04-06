-- { "aserowy/tmux.nvim", event = "VeryLazy" },

require("tmux").setup({
  copy_sync = {
    enable = false,
    redirect_to_clipboard = true,
  },
  navigation = {
    -- cycles to opposite pane while navigating into the border
    cycle_navigation = false,
    -- enables default keybindings (C-hjkl) for normal mode
    enable_default_keybindings = false,
    -- prevents unzoom tmux when navigating beyond vim border
    persist_zoom = true,
  },
  resize = {
    enable_default_keybindings = false,
    resize_step_x = 2,
    resize_step_y = 1,
  },
})

-- TODO: only vim navigate on splits
vim.api.nvim_set_keymap(
  "n",
  "<M-h>",
  '<cmd>lua require("tmux").resize_left()<cr>',
  { nowait = true, noremap = false }
)
vim.api.nvim_set_keymap(
  "n",
  "<M-l>",
  '<cmd>lua require("tmux").resize_right()<cr>',
  { nowait = true, noremap = false }
)
vim.api.nvim_set_keymap("n", "<M-k>", '<cmd>lua require("tmux").resize_top()<cr>', {})
vim.api.nvim_set_keymap("n", "<M-j>", '<cmd>lua require("tmux").resize_bottom()<cr>', {})
vim.api.nvim_set_keymap("n", "<C-h>", '<cmd>lua require("tmux").move_left()<cr>', { nowait = true })
vim.api.nvim_set_keymap(
  "i",
  "<C-h>",
  '<esc><cmd>lua require("tmux").move_left()<cr>',
  { nowait = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<C-l>",
  '<cmd>lua require("tmux").move_right()<cr>',
  { nowait = true }
)

vim.api.nvim_set_keymap(
  "i",
  "<C-l>",
  '<esc><cmd>lua require("tmux").move_right()<cr>',
  { nowait = true }
)
vim.api.nvim_set_keymap("n", "<C-k>", '<cmd>lua require("tmux").move_top()<cr>', { nowait = true })
vim.api.nvim_set_keymap(
  "n",
  "<C-j>",
  '<cmd>lua require("tmux").move_bottom()<cr>',
  { nowait = true }
)
vim.api.nvim_set_keymap("x", "<C-h>", '<cmd>lua require("tmux").move_left()<cr>', { nowait = true })
vim.api.nvim_set_keymap(
  "i",
  "<C-h>",
  '<esc><cmd>lua require("tmux").move_left()<cr>',
  { nowait = true }
)

vim.api.nvim_set_keymap(
  "x",
  "<C-l>",
  '<cmd>lua require("tmux").move_right()<cr>',
  { nowait = true }
)

vim.api.nvim_set_keymap(
  "i",
  "<C-l>",
  '<esc><cmd>lua require("tmux").move_right()<cr>',
  { nowait = true }
)
vim.api.nvim_set_keymap("x", "<C-k>", '<cmd>lua require("tmux").move_top()<cr>', { nowait = true })
vim.api.nvim_set_keymap(
  "x",
  "<C-j>",
  '<cmd>lua require("tmux").move_bottom()<cr>',
  { nowait = true }
)

-- vim.api.nvim_set_keymap("n", "<C-S-H>", '<cmd>lua require("tmux").move_left()<cr>', {})
-- vim.api.nvim_set_keymap("n", "<C-S-L>", '<cmd>lua require("tmux").move_right()<cr>', {})
-- vim.api.nvim_set_keymap("n", "<C-S-K>", '<cmd>lua require("tmux").move_top()<cr>', {})
-- vim.api.nvim_set_keymap("n", "<C-S-J>", '<cmd>lua require("tmux").move_bottom()<cr>', {})

-- vim.api.nvim_set_keymap("n", "<M-C-S-Right>", '<cmd>lua require("tmux").move_right()<cr>', {})
-- vim.api.nvim_set_keymap("n", "<M-C-S-Up>", '<cmd>lua require("tmux").move_top()<cr>', {})
-- vim.api.nvim_set_keymap("n", "<M-C-S-Left>", '<cmd>lua require("tmux").move_left()<cr>', {})
-- vim.api.nvim_set_keymap("n", "<M-C-S-Down>", '<cmd>lua require("tmux").move_bottom()<cr>', {})

local function check_nav_split(movement_key)
  local keymap = { h = { "-L" }, l = { "-R" }, k = { "-U" }, j = { "-D" } }
  return function()
    local curr_win = vim.fn.winnr()
    local mapkeys = keymap[movement_key]
    local keys = { tmux_view = mapkeys[1] }
    -- vim.dbglog('check nav', movement_key)
    -- only check one direction for split if navigating
    if vim.fn.winnr(movement_key) ~= curr_win then
      vim.cmd("wincmd " .. movement_key)
    else
      vim.fn.system("tmux select-pane " .. keys.tmux_view)
    end
  end
end
local setup_tmux_keymaps = function()
  vim.keymap.set(
    { "n", "v" },
    "<C-S-Right>",
    utils.check_nav_split("l"),
    { noremap = true, desc = " right split or tmux pane" }
  )
  vim.keymap.set(
    { "n", "v" },
    "<C-S-Left>",
    utils.check_nav_split("h"),
    { noremap = true, desc = " left split or tmux pane " }
  )
  vim.keymap.set(
    { "n", "v" },
    "<C-S-Down>",
    utils.check_nav_split("j"),
    { noremap = true, desc = "ﰬ down split or tmux pane" }
  )
  vim.keymap.set(
    { "n", "v" },
    "<C-S-Up>",
    utils.check_nav_split("k"),
    { noremap = true, desc = " up split or tmux pane" }
  )
end

local function check_resize_split(navigation_key)
  local keymap = {
    h = { "-L 2", "2>", "l", "2<" },
    l = { "-R 2", "2<", "h", "2>" },
    k = { "-U 1", "1-", "j", "1+" },
    j = { "-D 1", "1+", "k", "1-" },
  }
  return function()
    local curr_win = vim.fn.winnr()
    local mapkeys = keymap[navigation_key]
    local keys = {
      tmux_resize = mapkeys[1],
      vim_resize = mapkeys[2],
      alt_nav = mapkeys[3],
      alt_resize = mapkeys[4],
    }

    local has_split = vim.fn.winnr(navigation_key) ~= curr_win
    local alt_split = vim.fn.winnr(keys.alt_nav) ~= curr_win

    if has_split then
      vim.cmd("wincmd " .. keys.vim_resize)
    elseif alt_split then
      vim.cmd("wincmd " .. keys.alt_resize)
    end
    vim.fn.system("tmux resize-pane " .. keys.tmux_resize)
  end
end

-- check_resize_split = check_resize_split,
-- check_nav_split = check_nav_split,

-- local defaults = {
--   copy_sync = {
--     -- enables copy sync. by default, all registers are synchronized
--     enable = true,

--     -- ignore specific tmux buffers e.g. buffer0 = true to ignore the
--     -- first buffer or named_buffer_name = true to ignore a named tmux
--     -- buffer with name named_buffer_name :)
--     ignore_buffers = { empty = false },

--     -- TMUX >= 3.2: all yanks (and deletes) will get redirected to system clipboard by tmux
--     redirect_to_clipboard = false,

--     -- offset controls where register sync starts, e.g. offset 2 lets registers 0 and 1 untouched
--     register_offset = 0,

--     -- overwrites vim.g.clipboard to redirect * and + to the system clipboard using tmux.
--     -- If you sync your system clipboard without tmux, disable this option!
--     sync_clipboard = true,

--     -- synchronizes registers *, +, unnamed, and 0 till 9 with tmux buffers.
--     sync_registers = true,

--     -- synchronizes registers when pressing p and P.
--     sync_registers_keymap_put = true,

--     -- synchronizes registers when pressing (C-r) and ".
--     sync_registers_keymap_reg = true,

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
--     enable_default_keybindings = true,

--     -- prevents unzoom tmux when navigating beyond vim border
--     persist_zoom = false,
--   },
--   resize = {
--     -- enables default keybindings (A-hjkl) for normal mode
--     enable_default_keybindings = true,

--     -- sets resize steps for x axis
--     resize_step_x = 1,

--     -- sets resize steps for y axis
--     resize_step_y = 1,
--   },
-- }
