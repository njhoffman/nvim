-- vim-profiler.py nvim -n 10
-- vim-profiler.py -n 5 nvim foo.cc -c ":exec ':normal ia' | :q\!"
-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

require("globals")
for _, mod_name in ipairs({
  "project",
  "runner",
  "mappings",
  "plugins",
  "lsp",
  "commands",
  "autocommands",
  "stats",
  -- "dashboard"
}) do
  vim.import(mod_name)
end

vim.cmd [[
  try
    colorscheme nord-nick
    set background=dark
  " hi Normal guibg=none ctermbg=none
  " hi LineNr guibg=none ctermbg=none
  " hi Folded guibg=none ctermbg=none
  " hi NonText guibg=none ctermbg=none
  " hi SpecialKey guibg=none ctermbg=none
  " hi VertSplit guibg=none ctermbg=none
  " hi SignColumn guibg=none ctermbg=none
  " hi EndOfBuffer guibg=none ctermbg=none
  " hi StatusLine guibg=NONE
  " hi StatusLineNC guibg=NONE guifg=NONE
    syntax sync fromstart
    BarbarColors
  catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme default
    set background=dark
]]


-- require "plenary.profile".stop()
