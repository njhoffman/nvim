vim.cmd([[
  let g:lazygit_floating_window_winblend = 0 " transparency of floating window
  let g:lazygit_floating_window_scaling_factor = 0.9 " scaling factor for floating window
  let g:lazygit_floating_window_corner_chars = ['╭', '╮', '╰', '╯'] " customize lazygit popup window corner characters
  let g:lazygit_floating_window_use_plenary = 1 " use plenary.nvim to manage floating window if available
  let g:lazygit_use_neovim_remote = 1 " fallback to 0 if neovim-remote is not installed
  " setup mapping to call :LazyGit
  " nnoremap <silent> <leader>gg :LazyGit<CR>
  " :LazyGitConfig<CR>
]])

-- Using neovim-remote

-- If you have neovim-remote and have configured to use it in neovim, it'll launch the commit editor inside your neovim instance when you use C inside lazygit.
-- pip install neovim-remote

-- Add the following to your ~/.bashrc:
-- if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
-- alias nvim=nvr -cc split --remote-wait +'set bufhidden=wipe'
-- fi

-- Set EDITOR environment variable in ~/.bashrc:
-- if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
-- export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
--     export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
-- else
-- export VISUAL="nvim"
-- export EDITOR="nvim"
-- fi

-- Add the following to ~/.vimrc:
-- if has('nvim') && executable('nvr')
--   let $GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
--   endif
--   If you have neovim-remote and don't want lazygit.nvim to use it, you can disable it using the following configuration option:
--   let g:lazygit_use_neovim_remote = 0

-- By default the paths of each repo is stored only when lazygit is triggered. Though, this may not be convenient, so it possible to do something like this:
-- autocmd BufEnter * :lua require('lazygit.utils').project_root_dir()
-- That makes sure that any opened buffer which is contained in a git repo will be tracked.
-- Once you have loaded the extension, you can invoke the plugin using:
-- lua require("telescope").extensions.lazygit.lazygit()
