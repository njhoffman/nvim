local M = require("mappings.mapper")

local logger = require("logger").initLogger("mapper")

local function load_module(mod_name)
  local ok, err = pcall(require, mod_name)
  if not ok then
    local msg = "calling module: "..mod_name.." fail"
    logger:error(msg)
    logger:error(err)
  end
end

local mapfiles = {
  "mappings.commandwin",
  "mappings.dap",
  "mappings.format",
  "mappings.git",
  "mappings.interface",
  "mappings.lsp",
  "mappings.markdown",
  "mappings.movement",
  "mappings.navigation",
  "mappings.pickers",
  "mappings.plugins",
  "mappings.search",
  "mappings.unimpaired",
  "mappings.window",
  "mappings.zettel",
  }
for _, mod_name in ipairs(mapfiles) do
  load_module(mod_name)
end

M.map("REPL", "n", "<M-CR>", "tmux_send")

-- print(M.inspect(M.whichkey_map))
-- print(M.inspect(M.stats))

-- local whichkeys = M.whichkeyDump()
-- print("OK:   " .. length(whichkeys.ok) .. "\nTODO: " .. length(whichkeys.todo))

-- yoinks
-- Change current yank and see a preview of it in the status bar
-- " Also replace the default gp with yoink paste so we can toggle paste in this case too
-- You might also want to add a map for toggling whether the current paste is formatted or not:
-- normal p P will swap/cycle through yoinks

vim.cmd([[nmap <expr> p yoink#canSwap() ? '<plug>(YoinkPostPasteSwapBack)' : '<plug>(YoinkPaste_p)']])
vim.cmd([[nmap <expr> P yoink#canSwap() ? '<plug>(YoinkPostPasteSwapForward)' : '<plug>(YoinkPaste_P)']])
-- TODO: paste linewise within
-- Paste yanked line without line breaks before/after cursor position
-- inoremap <c-a> <c-r>1<esc>k$Jxi
vim.cmd([[nnoremap gp <plug>(YoinkPaste_gp) \| kJxJx]])
vim.cmd([[nnoremap gP <plug>(YoinkPaste_gP) \| kJxJx]])
vim.cmd([[nmap [y <plug>(YoinkRotateBack)]])
vim.cmd([[nmap ]y <plug>(YoinkRotateForward)]])
vim.cmd([[nmap y <plug>(YoinkYankPreserveCursorPosition)]])
vim.cmd([[xmap y <plug>(YoinkYankPreserveCursorPosition)]])
-- hitting <c-=> after a paste will toggle between formatted and unformatted (equivalent to using the = key).
-- By default pastes will not be formatted until you toggle it afterwards using <c-=> (however you can also change this with the yoinkAutoFormatPaste setting as described below)
-- vim.cmd([[nmap = <plug>(YoinkPostPasteToggleFormat)]])

vim.cmd([[nmap <leader>fi <Plug>(dial-increment)]])
vim.cmd([[nmap <leader>fd <Plug>(dial-decrement)]])
vim.cmd([[vmap <leader>fi <Plug>(dial-increment)]])
vim.cmd([[vmap <leader>fd <Plug>(dial-decrement)]])

vim.cmd([[nmap <c-Up> <Plug>(dial-increment)]])
vim.cmd([[nmap <c-Down> <Plug>(dial-decrement)]])
vim.cmd([[vmap <c-Up> <Plug>(dial-increment)]])
vim.cmd([[vmap <c-Down> <Plug>(dial-decrement)]])
vim.cmd([[vmap g<c-Up> <Plug>(dial-increment-additional)]])
vim.cmd([[vmap g<c-Down> <Plug>(dial-decrement-additional)]])


-- vim.cmd[[nmap - <Plug>(dial-increment)]]
-- vim.cmd[[nmap = <Plug>(dial-decrement)]]
-- vim.cmd[[vmap - <Plug>(dial-increment)]]
-- vim.cmd[[vmap = <Plug>(dial-decrement)]]
-- vim.cmd[[vmap g- <Plug>(dial-increment-additional)]]
-- vim.cmd[[vmap g= <Plug>(dial-decrement-additional)]]


M.registerWhichkey()

--
-- TODO: come up with iswap key bindings
-- ISwap, ISwapWith: ists, arrays, function arguments, function parameters

--- Spectre
-- vim.api.nvim_set_keymap('n', '<leader>S', ":lua require('spectre').open()<CR>", {noremap = true, silent = false})
-- vim.api.nvim_set_keymap('v', '<leader>S', ":lua require('spectre').open_visual()<CR>", {noremap = true, silent = false})
-- vim.api.nvim_set_keymap('n', '<leader>Sw', "viw:lua require('spectre').open_visual()<CR>", {noremap = true, silent = false})
-- vim.api.nvim_set_keymap('n', '<leader>sp', "viw:lua require('spectre').open_file_search()<CR>", {noremap = true, silent = false})- vim.api.nvim_set_keymap('n', '<leader>to', ':TodoTelescope<CR>', {noremap = true, silent = false})
-- -- Fterm
-- vim.api.nvim_set_keymap('n', '<F5>', '<CMD>lua require("FTerm").toggle()<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('t', '<F5>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { noremap = true, silent = true })

-- vim.api.nvim_set_keymap('n', '<leader>gc', ':Octo issue create<CR>', {noremap = true, silent = false})
-- vim.api.nvim_set_keymap('n', '<leader>i', ':Octo issue list<CR>', {noremap = true, silent = false})

-- vim.api.nvim_set_keymap("n", "<C-p>", ":lua FindFile()<CR>", {silent = true, noremap = true})
-- vim.api.nvim_set_keymap("n", "<leader>ff", ":lua FindBuffer()<CR>", {silent = true, noremap = true})
-- vim.api.nvim_set_keymap("n", "<leader>fg", ":lua FindString()<CR>", {silent = true, noremap = true})
-- vim.api.nvim_set_keymap("n", "<leader>fl", ":lua FindLive()<CR>", {silent = true, noremap = true})
-- vim.api.nvim_set_keymap("n", "<leader>fd", ":lua FindDot()<CR>", {silent = true, noremap = true})
-- vim.api.nvim_set_keymap("n", "<leader>fb", ":lua FindGit()<CR>", {silent = true, noremap = true})
-- map("n", "<leader>fn", ":lua require('utils.core').search_nvim()<CR>")
-- map("n", "<leader>b", ":Telescope buffers show_all=true sort_lastued=true<CR>")
-- ["p"] = {
--   name = "+personal-config",
--   ["n"] = { "<cmd>e ~/.config/nvim/lua/config.lua<cr>", "nvim" },
--   ["s"] = { "<cmd>e ~/.shell/.zshrc<cr>", "shell" },
-- },
-- ["gf"] = {"<cmd>TSLspFixCurrent<cr>", "eslint fix"},
-- ["gr"] = {"<cmd>TSLspRenameFile<cr>", "rename file"},
-- ["gi"] = {"<cmd>TSLspImportAll<cr>", "import all"},
-- vim.api.nvim_set_keymap("n", "<Leader>d", ":Sayonara<CR>", {noremap = true, silent = true})
-- vim.cmd([[xmap <leader>s <plug>(scratch-selection-reuse)]])
-- vim.cmd([[xmap <leader>S <plug>(scratch-selection-clear)]])
-- :map <C-X> <ESC>:x<CR>
-- :imap <C-X> <ESC>:x<CR>
-- nnoremap <leader>e :exe getline(line('.'))<cr>
-- nmap("Format", "^[^M", "] ", "format_insert_line", "insert line")
-- map("n", "<leader>tS", ":luafile %<CR>", { silent = false })
-- map("n", ",gdb", "<Plug>(EasyAlign)", {noremap = false, silent = true})
-- vim.cmd([[xmap <leader>s <plug>(scratch-selection-reuse)]])
-- vim.cmd([[xmap <leader>S <plug>(scratch-selection-clear)]])
--   ["n ]c"] = {expr = true, '&diff ? \']c\' : \'<cmd>lua require"gitsigns".next_hunk()<CR>\''},
--   ["n [c"] = {expr = true, '&diff ? \'[c\' : \'<cmd>lua require"gitsigns".prev_hunk()<CR>\''},
--   ["n <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
--   ["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
--   ["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line()<CR>',
--   -- Text objects
--   ["o ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
--   ["x ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>'

-- ocal log = [[\%C(yellow)\%h\%Cred\%d \%Creset\%s \%Cgreen(\%ar) \%Cblue\%an\%Creset]]
-- map('n', '<leader>g<space>', ':Git ')
-- map('n', '<leader>gd', '<cmd>Gvdiffsplit<CR>')
-- map('n', '<leader>gg', '<cmd>Git<CR>')
-- map('n', '<leader>gl', fmt('<cmd>term git log --graph --all --format="%s"<CR><cmd>start<CR>',
-- ocal log = [[\%C(yellow)\%h\%Cred\%d \%Creset\%s \%Cgreen(\%ar) \%Cblue\%an\%Creset]]
-- map('n', '<leader>g<space>', ':Git ')
-- map('n', '<leader>gd', '<cmd>Gvdiffsplit<CR>')
-- map('n', '<leader>gg', '<cmd>Git<CR>')
-- map('n', '<leader>gl', fmt('<cmd>term git log --graph --all --format="%s"<CR><cmd>start<CR>',

-- nmap("REPL", "<leader>y<cr>", "<Plug>(ripple_open_repl)", "repl_open", "repl open")
-- nmap("REPL", "<leader>yr", "<Plug>(ripple_send_motion)", "repl_send_motion", "repl send motion")
-- nmap("REPL", "<leader>yp", "<Plug>(ripple_send_previous)", "repl_send_previous", "repl send previous")
-- nmap("REPL", "<leader>yrr", "<Plug>(ripple_send_line)", "repl_send_line", "repl send line")
-- nmap("REPL", "<leader>yr<cr>", "<Plug>(ripple_send_buffer)", "repl_send_buffer", "repl send buffer")
-- vmap("REPL", "<leader>r", "<Plug>(ripple_send_selection)", "repl_send_visual", "repl send visual")

-- vmap("Movement", "K", "<cmd>move '<-2<CR>gv=gv<cr>", "movement_selected_up", "move selected text up")
-- vmap("Movement", "J", "<cmd>move '<+1<CR>gv=gv<cr>", "movement_selected_down", "move selected text down")
-- nmap("Navigation", ";", ":", "navigation_quick_cmd", "quickly open up command line", true)
-- nmap("Navigation", ":", ":<C-f>", "navigation_quick_cmdwin", "quickly open command line window")

-- -- Directory
-- wk.register({
--     d = {
--         name = "directory",
--         a = "add directory",
--         l = "list directories",
--         r = "remove directory",
--     }
-- }, { prefix = "<leader>" })
