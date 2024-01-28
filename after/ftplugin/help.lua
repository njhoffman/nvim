-- helpgrep keyword
-- copen
-- :h :command                        " help for ex-command 'command'
-- :h 'option'                        " help for option 'option'
-- :h function()                      " help for function 'function'
-- :h modifier-key                    " help for 'modifier'-'key' in normal mode
-- :h mode_modifier-key               " help for 'modifier'-'key' in 'mode'
-- :h mode_modifier-key_modifier-key  " help for 'modifier'-'key' 'modifier'-'key' in 'mode'

-- :help z?	jump to help for any "z" command
-- :help z.	jump to the help for "z."
-- :help :?	jump to help for ":?"
-- :help index
-- :tselect /.*mode

-- :helpgrep backspace
-- :cnext, :cwindow
-- Use CTRL-T or CTRL-O to jump back.
-- :tag /min && :tnext

-- you can also use autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif to get the same effect, the added advantage being that it will readjust the size of the window if you resize nvim and reenter the buffer.
vim.cmd([[
" autocmd BufEnter *.txt if &buftype == 'help' | setlocal syn=pandoc.help conceallevel=3 signcolumn=no | endif
let g:help_minlines = 0
setlocal nowrap
setlocal formatoptions+=c  " Enable formatting everywhere, not just comments
" ,K runs :helpgrep on the word under the cursor
nnoremap <buffer> <LocalLeader>K  :<C-U>helpgrep <cword><CR>
" Make K jump to the help topic; NeoVim does this, and it's a damned good idea
" nnoremap <buffer> K <C-]>
" let b:undo_ftplugin .= '|nunmap <buffer> K'
]])

if vim.startswith(vim.fn.expand('%'), vim.env.VIMRUNTIME) or vim.bo.readonly then
  vim.api.nvim_create_autocmd('BufWinEnter', { buffer = 0, command = 'wincmd L | vertical resize 70' })
  -- https://vim.fandom.com/wiki/Learn_to_use_help
  -- TODO: reconcile with zoom
  vim.api.nvim_buf_set_keymap(0, 'n', '<C-Space>', '<C-]>', {})
  vim.api.nvim_buf_set_keymap(0, 'n', '<BS>', '<C-O>', {})
else
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ml', 'maGovim:tw=78:ts=8:noet:ft=help:norl:<esc>`a', {})
end

local bufnr = vim.api.nvim_get_current_buf()
local putils = require('telescope.previewers.utils')
putils.ts_highlighter(bufnr, 'markdown')
putils.regex_highlighter(bufnr, 'pandoc')

-- vim.treesitter.register('help', 'markdown')
vim.treesitter.start()
