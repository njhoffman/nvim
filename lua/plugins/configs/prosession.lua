--  :Obsession {file/dir} Invoke :mksession on {file} and continue updating it.
--  :Obsession! Stop obsession and delete underlying session file
--  :Prosession {dir}     Switch to the session of the directory if one already exists otherwise start a new session, autocompletes paths.
--  :ProsessionDelete [{dir}] Deletes the session attached to the specified {dir} or currently active session.
--  %{ObsessionStatus()}
vim.g.loaded_prosession = 0
vim.g.prosession_dir = vim.fn.getenv("HOME") .. "/.vim/sessions/"
vim.g.prosession_on_startup = 1
vim.g.prosession_default_session = 0

--  g:loaded_prosession   Use this option to disable the plugin. Default: > let g:loaded_prosession = 1
--  g:prosession_dir      Use this option to configure the path to store all
--                        session files. Default: > let g:prosession_dir = '~/.vim/session/'
--  g:prosession_tmux_title
--                        Use this option to enable tmux window name updates as
--                        per current session. Default: > let g:prosession_tmux_title = 0
--  g:prosession_tmux_title_format
--                        Use this option to format the tmux window name updates.
--                        Use -- @@@--  as placeholder for folder name. Default: >  let g:prosession_tmux_title_format = -- vim - @@@--
--  g:prosession_on_startup
--                        Use this option to enable auto loading of session on
--                        startup if no arguments are supplied to vim. Default: > let g:prosession_on_startup = 1
--  g:prosession_default_session
--                        This option creates & uses a 'default' session to be
--                        used in case when launching vim and a corresponding
--                        session hasn't been found yet. > let g:prosession_default_session = 0
--  g:prosession_per_branch
--                        This is disabled by default. You can use this to enable
--                        per git branch sessions. > let g:prosession_per_branch = 0
--  g:prosession_branch_cmd
--                        This defines the shell command to use to determine the
--                        current branch. By default this is set to work with git
--                        but can be changed for other vcs as well. > let g:prosession_branch_cmd = 'git rev-parse --abbrev-ref HEAD 2>/dev/null
--  g:prosession_last_session_dir
--                        This defines the directory where when vim launches
--                        instead of creating / starting the session for that
--                        directory we start the last used session.
--  g:prosession_ignore_dirs
--                        This is a comma (`,`) separated list of dirs we want
--                        prosession to ignore and not create / load a session for
--                        them. By default it's set to be empty. > let g:prosession_ignore_dirs = [  '/path1',  '/path2', ]
--  g:Prosession_ignore_expr
--                        This is a |Funcref| that must return a boolean value,
--                        either |v:true| or |v:false|, upon invocation. > let g:Prosession_ignore_expr = {->v:false}
--                        This could be used to ignore directories by using some
--                        specific criteria. Following is an example to ignore all
--                        directories that are not git repos. > let g:Prosession_ignore_expr = {-> !isdirectory('.git')}
