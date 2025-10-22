# Task: Look at why

[telescope] [WARN  01:21:42] /home/nicholas/.config/nvim/lua/telescope/log.lua:8: Finder failed with msg:  .../nvim/lua/telescope/_extensions/egrepify/entry_maker.lua:264: Expected value but found T_END at character 1514

vim.schedule callback: /home/nicholas/.config/nvim/lua/telescope/pickers.lua:1673: Invalid buffer id: 51
stack traceback:
	[C]: in function 'nvim_buf_get_lines'
	/home/nicholas/.config/nvim/lua/telescope/pickers.lua:1673: in function ''
	vim/_editor.lua: in function ''
	vim/_editor.lua: in function <vim/_editor.lua:0>

Lua callback: /home/nicholas/.config/nvim/lua/telescope/_.lua:148: 75
stack traceback:
	[C]: in function 'assert'
	/home/nicholas/.config/nvim/lua/telescope/_.lua:148: in function </home/nicholas/.config/nvim/lua/telescope/_.lua:147>

Lua callback: ...local/share/nvim/runtime/lua/vim/lsp/_changetracking.lua:202: attempt to index local 'buf_state' (a nil value)
stack traceback:
	...local/share/nvim/runtime/lua/vim/lsp/_changetracking.lua:202: in function 'reset_buf'
	...icholas/.local/share/nvim/runtime/lua/vim/lsp/client.lua:1251: in function '_on_detach'
	/home/nicholas/.local/share/nvim/runtime/lua/vim/lsp.lua:939: in function </home/nicholas/.local/share/nvim/runtime/lua/vim/lsp.lua:936>
