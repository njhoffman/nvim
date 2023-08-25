---@diagnostic disable: unused-function, unused-local
local error1 = [[
E5108: Error executing lua /home/nicholas/.config/nvim/lua/gitops/core/commits.lua:57: attempt to call field 'new' (a nil value)
stack traceback:
	/home/nicholas/.config/nvim/lua/gitops/core/commits.lua:57: in function </home/nicholas/.config/nvim/lua/gitops/core/commits.lua:41>
	/home/nicholas/.config/nvim/lua/telescope/run.lua:99: in function </home/nicholas/.config/nvim/lua/telescope/run.lua:70>
	.../nvim/lua/telescope/_extensions/find_pickers/actions.lua:17: in function 'select_picker'
	.../nvim/lua/telescope/_extensions/find_pickers/actions.lua:27: in function 'run_replace_or_original'
	...re/nvim/lazy/telescope.nvim/lua/telescope/actions/mt.lua:65: in function 'select_default'
	...las/.config/nvim/lua/plugs/config/telescope/mappings.lua:13: in function 'key_func'
	...hare/nvim/lazy/telescope.nvim/lua/telescope/mappings.lua:350: in function 'execute_keymap'
	[string ":lua"]:1: in main chunk]]

local error2 = [[
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

local error3 = [[
E5113: Error while calling lua chunk: /home/nicholas/.config/nvim/lua/watcher/utils.lua:37: attempt to call method 'info' (a nil value)
stack traceback:
        /home/nicholas/.config/nvim/lua/watcher/utils.lua:37: in function 'clear_timers'
        lua/watcher/init.lua:7: in function 'setup'
        lua/watcher/init.lua:19: in main chunk ]]

local error4 = [[
Error executing Lua callback: /home/nicholas/.local/share/nvim/lazy/vimade/lua/vimade.lua:15: table index is nil
stack traceback:
  /home/nicholas/.local/share/nvim/lazy/vimade/lua/vimade.lua:15: in function 'dump'
  /home/nicholas/.config/nvim/lua/mapper/stats.lua:108: in function 'get_stats'
  /home/nicholas/.config/nvim/lua/stats/commands/init.lua:12: in function 'get_items'
  /home/nicholas/.config/nvim/lua/stats/commands/init.lua:113: in function </home/nicholas/.config/nvim/lua/stats/commands/init.lua:112> ]]

local error5 = [[
E5112: Error while creating lua chunk: scratch/tmp3.lua:32: unexpected symbol near 'local']]

local error6 = [[
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

local error7 = [[
E5108:Error executing lua
...share/nvim/lazy/nvim-lspconfig/lua/lspconfig/manager.lua:262:attempt to index local 'self' (a number value)
  ...share/nvim/lazy/nvim-lspconfig/lua/lspconfig/manager.lua:262: in function 'try_add'
  ...l/share/nvim/lazy/lsp-toggle.nvim/lua/lsp-toggle/lsp.lua:49: in function 'onSubmit'
  .../share/nvim/lazy/lsp-toggle.nvim/lua/lsp-toggle/init.lua:34: in function 'on_choice'
  ...e-ui-select.nvim/lua/telescope/_extensions/ui-select.lua:122: in function 'run_replace_or_original'
  ...nicholas/git/telescope.nvim/lua/telescope/actions/mt.lua:65: in function 'select_default'
  ...nicholas/.config/nvim/lua/configs/telescope/mappings.lua:13: in function 'key_func'
  ...e/nicholas/git/telescope.nvim/lua/telescope/mappings.lua:257: in function <...e/nicholas/git/telescope.nvim/lua/telescope/mappings.lua:256>  ]]

return {
  error1 = error1,
  error2 = error2,
  error3 = error3,
  error4 = error4,
  error5 = error5,
  error6 = error6,
  error7 = error7,
}
