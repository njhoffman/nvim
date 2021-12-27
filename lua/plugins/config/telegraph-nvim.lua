--  vim :terminal
local default_config = {
  cmd = "",
  session_name = '{current_session_name}-{filename}',
  how = 'tmux_popup'
}

require("telegraph").setup(default_config)

-- nnoremap <leader>s <cmd>Telegraph pipx run lookatme {filepath} --live-reload --style gruvbox-dark<cmd>
-- tmux session
-- nnoremap <leader><leader>s <cmd>lua require'telegraph'.telegraph({cmd='pipx run lookatme {filepath} --live-reload --style gruvbox-dark', how='tmux'})<CR>
-- tmux popup
-- nnoremap <leader><leader>S <cmd>lua require'telegraph'.telegraph({cmd='pipx run lookatme {filepath} --live-reload --style gruvbox-dark', how='tmux_popup'})<CR>

-- :Telegraph ls {parent}
-- :Telegraph cat {filename}
-- :Telegraph man {cword}
-- :Telegraph vd {cWORD}

-- Example usage
-- Man Page Searcher

-- " Using :term
-- nnoremap <leader><leader>m :Telegraph man
-- " Using a tmux popup
-- noremap <leader><leader>M :lua require'telegraph'.telegraph({how='tmux_popup', cmd='man '})<Left><Left><Left>
-- lookatme slides

-- " lookatme in a terminal
-- nnoremap <leader><leader>s :Telegraph pipx run --spec git+https://github.com/waylonwalker/lookatme lookatme {filepath} --live-reload --style gruvbox-dark<cr>
-- " lookatme in a tmux popup
-- nnoremap <leader><leader>S :lua require'telegraph'.telegraph({cmd='pipx run --spec git+https://github.com/waylonwalker/lookatme lookatme {filepath} --live-reload --style gruvbox-dark', how='tmux_popup'})<CR>
-- how
-- Determines how the command should be ran. How may be set to any of the following terms.

-- term(default) runs command in the built in terminal
-- subprocess runs the command in a lua subprocess
-- tmux runs command in a new tmux session and joins it.
-- tmux_popup runs command in a tmux popup window.
-- tmux_popup_session runs command in a tmux session and displays it in a popup
-- subprocess runs command in a subprocess
-- format strings

-- Telegraph will replace the following variables enclosed in braces.
-- cword - the current word under the cursor
-- cWORD - the current BIG Word under the cursor
-- cline - the current line under the cursor
-- filepath - the filepath of the current file
-- filename - the filename of the current file
-- file_extension - the extension of the file (ex lua, py)
-- file_basename - the basename of the file (ie. filename without the extension)
-- parent - the parent directory of the current file
-- current_session_name - name of the current tmux session
-- cwd - the current working directory
