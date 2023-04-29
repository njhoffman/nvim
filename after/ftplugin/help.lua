-- helpgrep keyword
-- copen
-- :h :command                        " help for ex-command 'command'
-- :h 'option'                        " help for option 'option'
-- :h function()                      " help for function 'function'
-- :h modifier-key                    " help for 'modifier'-'key' in normal mode
-- :h mode_modifier-key               " help for 'modifier'-'key' in 'mode'
-- :h mode_modifier-key_modifier-key  " help for 'modifier'-'key' 'modifier'-'key' in 'mode'

vim.cmd([[
  setlocal signcolumn=no
  setlocal norelativenumber
  setlocal nonumber
  setlocal textwidth=78
  setlocal nolist
  setlocal nowrap
  setlocal formatoptions+=c  " Enable formatting everywhere, not just comments

  " Make K jump to the help topic; NeoVim does this, and it's a damned good idea
  nnoremap <buffer> K <C-]>
  let b:undo_ftplugin .= '|nunmap <buffer> K'
]])

if vim.startswith(vim.fn.expand('%'), vim.env.VIMRUNTIME) or vim.bo.readonly then
  vim.wo.spell = false
  vim.api.nvim_create_autocmd('BufWinEnter', { buffer = 0, command = 'wincmd L | vertical resize 80' })
  -- https://vim.fandom.com/wiki/Learn_to_use_help
  vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', '<C-]>', {})
  vim.api.nvim_buf_set_keymap(0, 'n', '<BS>', '<C-O>', {})
else
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ml', 'maGovim:tw=78:ts=8:noet:ft=help:norl:<esc>`a', {})
end

vim.cmd([[
function! s:open_help_online()
  let tagstack = gettagstack()
  if tagstack.length < 1
    throw 'E73: tag stack empty'
  endif
  if tagstack.curidx == tagstack.length + 1
    let tag = tagstack.items[-1]
  else
    let tag = tagstack.items[tagstack.curidx - 1]
  endif
  let tagname = tag.tagname
  let file = bufname(tag.bufnr)

  let file = tr(file, '\', '/')
  let local_doc_prefix = resolve($VIMRUNTIME . '/doc/')
  if dotfiles#utils#starts_with(file, local_doc_prefix) && file =~? '\.txt$' && tagname =~# '@en$'
    let file = file[len(local_doc_prefix):-5]
    let tagname = tagname[:-4]

    let tagname = dotfiles#utils#url_encode(tagname)
    if has('nvim')
      let url = 'https://neovim.io/doc/user/' . file . '.html#' . tagname
    else
      let url = 'https://vimhelp.org/' . file . '.txt.html#' . tagname
    endif
    echomsg 'Opening ' . url
    call dotfiles#utils#open_url(url)
  endif
endfunction
command! -bar -buffer OpenHelpOnline call s:open_help_online()
" call dotfiles#utils#undo_ftplugin_hook('silent! delcommand OpenHelpOnline')
]])

vim.treesitter.start()
