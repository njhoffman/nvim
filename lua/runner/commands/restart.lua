local utils = require("runner.utils")

vim.cmd([[
  let s:server_name = escape(substitute(substitute(v:servername, '\$', '', ''), '/tmp', '', ''), '\')
  let s:session_restart_path = stdpath('data') . "/sessions/restart"

  function Restart()
    " save session file to <servername>_runonce to indicate a one time reload
    let l:session_path = s:session_restart_path . s:server_name . '_runonce.vim'
    exe "mksession! " . l:session_path
    let l:cmds = []
    if exists("g:argv")
      for arg in g:argv
        let l:cmds += [arg]
        " TODO: append line to length -1 to keep mode line at botom
        call writefile([arg], l:session_path, "a")
      endfor
    endif
    call writefile(['let g:argv = ' . string(l:cmds)], l:session_path, "a")
    quitall!
  endfunction
  command Restart call Restart()

  function RestartCmd()
    let l:session_path = s:session_restart_path . s:server_name . '_runonce.vim'
    exe "mksession! " . l:session_path
    let l:cmds = []
    for arg in v:argv
      if arg =~ '^+.*'
        let l:cmd = substitute(arg, "\+", "", "")
        let l:cmds += [l:cmd]
        " TODO: append line to length -1 to keep mode line at botom
        call writefile([l:cmd], l:session_path, "a")
      endif
    endfor
    if exists("g:argv")
      for arg in g:argv
        let l:cmds += [arg]
        " TODO: append line to length -1 to keep mode line at botom
        call writefile([arg], l:session_path, "a")
      endfor
    endif
    call writefile(['let g:argv = ' . string(l:cmds)], l:session_path, "a")
    quitall!
  endfunction
  command RestartCmd call RestartCmd()

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

local restart_target = function()
  local commands = { "RestartCmd" }
  utils.remote_commands(commands, true)
end

return {
  restart_target = restart_target,
}
