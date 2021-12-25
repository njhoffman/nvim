
local M = require("mappings.mapper")

-- move to commandwin
M.map("Navigation", "n", ";", "quick_cmd", { noremap = true, nowait = true })
M.map("Navigation", "n", ":", "quick_cmdwin", { noremap = true, nowait = true })
M.map("Navigation", "v", ";", "quick_cmd_v", { noremap = true, nowait = true })
M.map("Navigation", "v", ":", "quick_cmdwin_v", { noremap = true, nowait = true })

M.map("Navigation", "n", "<BS>", "buffer_last")
M.map("Navigation", "n", "H", "buffer_left1")
M.map("Navigation", "n", "L", "buffer_right1")
M.map("Navigation", "n", "!", "repeat_cmd")
M.map("Navigation", "n", "<M-r>", "restart")
M.map("Navigation", "n", "<C-x>", "nowrite_exit1")
M.map("Navigation", "n", "<A-x>", "write_exit1")
M.map("Navigation", "n", "<C-d>", "bufclose_nosave")
M.map("Navigation", "n", "<C-s>", "quick_save")
M.map("Navigation", "i", "<C-s>", "insert_quick_save")
M.map("Navigation", "n", "ZZ", "write_exit2") -- virtual
M.map("Navigation", "n", "<leader>x", "bufclose_save")
M.map("Navigation", "n", "<leader>z", "nowrite_exit2")
M.map("Navigation", "n", "<leader>!", "bufclose_all")
M.map("Navigation", "n", "<M-d>", "bufclose_all2")
M.map("Navigation", "n", "<leader>*", "bufwrite_all")
M.map("Navigation", "n", "<leader>w", "bufwrite_noa")
M.map("Navigation", "n", "<leader>d", "bufdelete")
M.map("Navigation", "n", "<leader>.", "open_altfile")
M.map("Navigation", "n", "<leader>fn", "open_newfile")
M.map("Navigation", "n", "<leader>fs", "open_newsplit")
M.map("Navigation", "n", "<leader>fp", "print_filename")
M.map("Navigation", "n", "gF", "goto_fileline") -- TODO: integrate goto definition
M.map("Navigation", "n", "gf", "goto_file") -- virtual
M.map("Navigation", "n", "xf", "open_file") -- virtual
M.map("Navigation", "n", ",cd", "cd_buffer")
M.map("Navigation", "n", ",cdh", "cd_home")
M.map("Navigation", "n", ",cdr", "cd_root")
