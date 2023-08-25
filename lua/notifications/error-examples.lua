local error1 = [[
E5113: Error while calling lua chunk: /home/nicholas/.config/nvim/lua/watcher/utils.lua:37: attempt to call method 'info' (a nil value)
stack traceback:
        /home/nicholas/.config/nvim/lua/watcher/utils.lua:37: in function 'clear_timers'
        lua/watcher/init.lua:7: in function 'setup'
        lua/watcher/init.lua:19: in main chunk ]]

local error2 = [[
E5112: Error while creating lua chunk: lua/scripts/notify-test.lua:10: 'end' expected (to close 'function' at line 50) near '<eof>' ]]

local error3 = [[
E5113: Error while calling lua chunk: lua/scripts/notify-test.lua:5: hey
stack traceback:
        [C]: in function 'error'
        lua/scripts/notify-test.lua:63: in function 'notify_error'
        lua/scripts/notify-test.lua:79: in function 'notify_test'
        lua/scripts/notify-test.lua:86: in main chunk ]]

local error4 = [[
E5113: Error while calling lua chunk
     ...local/share/nvim/runtime/lua/vim/treesitter/language.lua:88: 'lua.neozoom' is not a valid language name ]]

local error5 = [[
E5108: Error executing lua ...e/nicholas/.config/nvim/lua/gitops/previewers/commit.lua:226: attempt to concatenate field 'value' (a table value)
stack traceback:
	...e/nicholas/.config/nvim/lua/gitops/previewers/commit.lua:226: in function 'define_preview'
	...e/nicholas/.config/nvim/lua/gitops/previewers/commit.lua:180: in function 'preview'
	...share/nvim/lazy/telescope.nvim/lua/telescope/pickers.lua:1061: in function 'refresh_previewer'
	...share/nvim/lazy/telescope.nvim/lua/telescope/pickers.lua:1017: in function 'set_selection'
	...share/nvim/lazy/telescope.nvim/lua/telescope/pickers.lua:783: in function 'move_selection'
	...e/nvim/lazy/telescope.nvim/lua/telescope/actions/set.lua:39: in function 'run_replace_or_original'
	...re/nvim/lazy/telescope.nvim/lua/telescope/actions/mt.lua:65: in function 'shift_selection'
	.../nvim/lazy/telescope.nvim/lua/telescope/actions/init.lua:87: in function 'run_replace_or_original'
	...re/nvim/lazy/telescope.nvim/lua/telescope/actions/mt.lua:65: in function 'key_func'
	...hare/nvim/lazy/telescope.nvim/lua/telescope/mappings.lua:350: in function 'execute_keymap'
	[string ":lua"]:1: in main chunk ]]

local error6 = [[
Error executing Lua callback: /home/nicholas/.local/share/nvim/lazy/vimade/lua/vimade.lua:15: table index is nil
stack traceback:
	/home/nicholas/.local/share/nvim/lazy/vimade/lua/vimade.lua:15: in function 'dump'
	/home/nicholas/.config/nvim/lua/mapper/stats.lua:108: in function 'get_stats'
	/home/nicholas/.config/nvim/lua/stats/commands/init.lua:12: in function 'get_items'
	/home/nicholas/.config/nvim/lua/stats/commands/init.lua:113: in function </home/nicholas/.config/nvim/lua/stats/commands/init.lua:112> ]]
local error7 = [[
E5108: Error executing lua ...nvim/lua/telescope/_extensions/find_pickers/generate.lua:57: attempt to get length of field
'only_include' (a nil value)
stack traceback:
        ...nvim/lua/telescope/_extensions/find_pickers/generate.lua:57: in function 'metadata'
        .../nvim/lua/telescope/_extensions/find_pickers/finders.lua:14: in function 'get_finder'
        ...fig/nvim/lua/telescope/_extensions/find_pickers/main.lua:84: in function <...fig/nvim/lua/telescope/_extensions/find_pickers/main.lua:73>
        /home/nicholas/.config/nvim/lua/telescope/run.lua:99: in function </home/nicholas/.config/nvim/lua/telescope/run.lua:70>
        [string ":lua"]:1: in main chunk ]]

local vimerror = [[
Vim:Error executing Lua callback: ./scratch/tmp2.lua:2: attempt to perform arithmetic on global '_sd' (a nil value)
stack traceback:
  ./scratch/tmp2.lua:2: in function <./scratch/tmp2.lua:1>
  [C]: at 0x562710d3ba4b
  [C]: in function 'pcall'
  /home/nicholas/.config/nvim/lua/runner/commands/run_cmd.lua:54: in function 'exec_vim_cmd'
  /home/nicholas/.config/nvim/lua/runner/commands/run_cmd.lua:71: in function 'exec_run_cmd'
  /home/nicholas/.config/nvim/lua/runner/commands/run_cmd.lua:110: in function 'on_confirm'
  ...cal/share/nvim/lazy/dressing.nvim/lua/dressing/input.lua:119: in function ''
  vim/_editor.lua: in function ''
  vim/_editor.lua: in function <vim/_editor.lua:0> ]]

return {
  error1 = error1,
  error2 = error2,
  error3 = error3,
  error4 = error4,
  vimerror = vimerror,
}
