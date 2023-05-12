local ok, ts = pcall(require, 'nvim-treesitter')
if ok then
  ts.define_modules({
    illuminate = {
      module_path = 'illuminate.providers.treesitter',
      enable = true,
      disable = {},
      is_supported = require('nvim-treesitter.query').has_locals,
    },
  })
end

require('lsp.illuminate.engine').start()

-- stylua: ignore
vim.api.nvim_create_user_command('IlluminatePause',     require('lsp.illuminate').pause,      { bang = true })
vim.api.nvim_create_user_command('IlluminateResume', require('lsp.illuminate').resume, { bang = true })
vim.api.nvim_create_user_command('IlluminateToggle', require('lsp.illuminate').toggle, { bang = true })
vim.api.nvim_create_user_command('IlluminatePauseBuf', require('lsp.illuminate').pause_buf, { bang = true })
vim.api.nvim_create_user_command('IlluminateResumeBuf', require('lsp.illuminate').resume_buf, { bang = true })
vim.api.nvim_create_user_command('IlluminateToggleBuf', require('lsp.illuminate').toggle_buf, { bang = true })
vim.api.nvim_create_user_command('IlluminateDebug', require('lsp.illuminate').debug, { bang = true })

-- if not require('lsp.illuminate.util').has_keymap('n', '<a-n>') then
--   vim.keymap.set('n', '<a-n>', require('illuminate').goto_next_reference, { desc = 'Move to next reference' })
-- end
-- if not require('lsp.illuminate.util').has_keymap('n', '<a-p>') then
--   vim.keymap.set('n', '<a-p>', require('illuminate').goto_prev_reference, { desc = 'Move to previous reference' })
-- end
-- if not require('lsp.illuminate.util').has_keymap('o', '<a-i>') then
--   vim.keymap.set('o', '<a-i>', require('illuminate').textobj_select)
-- end
-- if not require('lsp.illuminate.util').has_keymap('x', '<a-i>') then
--   vim.keymap.set('x', '<a-i>', require('illuminate').textobj_select)
-- end
--
vim.cmd([[
  lua require('lsp.illuminate').set_highlight_defaults()
  augroup vim_illuminate_autocmds
      autocmd!
      autocmd ColorScheme * lua require('lsp.illuminate').set_highlight_defaults()
  augroup END

  finish
  end

  " Highlight group(s) {{{
  if !hlexists('lsp.illuminatedWord')
    " this is for backwards compatibility
    if !empty(get(g:, 'Illuminate_hl_link', ''))
      exe get(g:, 'Illuminate_hl_link', '')
    else
      hi def link illuminatedWord cursorline
    endif
  endif
  " }}}

  " Autocommands {{{
  if has('autocmd')
    augroup illuminated_autocmd
      autocmd!
      autocmd CursorMoved,InsertLeave * call illuminate#on_cursor_moved()
      autocmd WinLeave,BufLeave * call illuminate#on_leaving_autocmds()
      autocmd CursorMovedI * call illuminate#on_cursor_moved_i()
      autocmd InsertEnter * call illuminate#on_insert_entered()
    augroup END
  else
    echoerr 'Illuminate requires Vim compiled with +autocmd'
    finish
  endif
  " }}}

  " Commands {{{
  command! -nargs=0 -bang IlluminationDisable call illuminate#disable_illumination(<bang>0)
  command! -nargs=0 -bang IlluminationEnable call illuminate#enable_illumination(<bang>0)
  command! -nargs=0 -bang IlluminationToggle call illuminate#toggle_illumination(<bang>0)

]])
