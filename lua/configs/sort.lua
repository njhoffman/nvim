local cfg = {
  -- List of delimiters, in descending order of priority, to automatically sort on.
  delimiters = {
    ",",
    "|",
    ";",
    ":",
    "s", -- Space
    "t", -- Tab
  },
}
require("sort").setup()

-- vim.cmd([[
--   nnoremap <silent> go <Cmd>Sort<CR>
--   vnoremap <silent> go <Esc><Cmd>Sort<CR>
--   ]])
