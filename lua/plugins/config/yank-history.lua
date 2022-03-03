-- TODO: YankHistoryYank() takes >1 s

vim.g.yank_history_max_size = 100
vim.g.yank_history_dir = os.getenv("HOME") .. "/.vim/yank_history"
