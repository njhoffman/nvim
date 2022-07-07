local remote = require('remote')

local commands = {
  "lua vim.notify('TESTING')",
  "lua vim.notify('TESTING 5', 'warn')",
  "lua vim.notify('TESTING 3', 'info')",
}

local restart_target = function()
  remote.send_commands(commands)
end

vim.api.nvim_create_user_command("RestartTarget", restart_target, {
  desc = "Reload and run commands on external vim instance"
})

-- NVIM_UNIQUE=0 NVIM_LISTEN_ADDRESS=/tmp/nick_tickleshits vim
-- :exe "norm! yaw" | exe "silent! norm! b" | exe "norm! P"

vim.cmd([[
  let s:server_name = escape(substitute(substitute(v:servername, '\$', '', ''), '/tmp', '', ''), '\')
  let s:session_restart_path = expand("$HOME") . "/.vim/sessions/restart"

  function Restart()
    " save session file to <servername>_runonce to indicate a one time reload
    let l:session_path = s:session_restart_path . s:server_name . '_runonce.vim'
    exe "PackerCompile"
    exe "mksession! " . l:session_path
    " exit
    quitall
  endfunction
  command Restart call Restart()

  function RestartOn()
    " save session file to <servername>_always to indicate an idefinite reload cycle
    let l:session_path = s:session_restart_path . s:server_name . '_always.vim'
    exe "mksession! " . l:session_path
  endfunction
  command RestartOn call RestartOn()

  function RestartOff()
    " remove  <servername>_always file to prevent restarting
    let l:session_path = s:session_restart_path . s:server_name . '_always.vim'
    exe "!rm " . l:session_path
  endfunction
  command RestartOff call RestartOff()
]])
