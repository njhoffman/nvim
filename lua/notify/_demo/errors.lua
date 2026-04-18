-- editorconfig-checker-disable-file
-- @diagnostic disable: unused-function, unused-local, ProhibitUnnecessaryDoubleQuote
local errors = {}

-- "E5113: Error while calling lua chunk: /home/nicholas/.config/nvim/lua/notify/render/_error.lua:223: Invalid 'end_col': out of range", "stack traceback:", "\t[C]: in function 'nvim_buf_set_extmark'", "\t/home/nicholas/.config/nvim/lua/notify/render/_error.lua:223: in function 'error_highlighting'", "\t/home/nicholas/.config/nvim/lua/notify/render/_error.lua:249: in function 'render'", "\t...holas/git/nvim-notify/lua/notify/service/buffer/init.lua:120: in function 'render'", "\t/home/nicholas/git/nvim-notify/lua/notify/service/init.lua:54: in function 'push'", "\t/home/nicholas/git/nvim-notify/lua/notify/instance.lua:139: in function 'notify'", "\tlua/notify/demo/scratch.lua:9: in function 'notify_errors'", "\tlua/notify/demo/scratch.lua:20: in main chunk"
-- "E5108: Error executing lua vim/_editor.lua:0: nvim_exec2()..function <lambda>6715, line 1: Vim(copen):E5108: Error executing lua scratch/tmp3.lua:17: attempt to compare number with nil", "stack traceback:", "  scratch/tmp3.lua:17: in function 'format_filename'", "  scratch/tmp3.lua:34: in function 'get_max_filename_width'", "  scratch/tmp3.lua:63: in function <scratch/tmp3.lua:46>", "  [C]: in function 'nvim_exec2'", "  vim/_editor.lua: in function 'cmd'", "  /home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:301: in function 'open'", "  /home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:328: in function 'toggle'", '  [string ":lua"]:1: in main chunk', "stack traceback:", "  [C]: in function 'nvim_exec2'", "  vim/_editor.lua: in function 'cmd'", "  /home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:301: in function 'open'", "  /home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:328: in function 'toggle'", '  [string ":lua"]:1: in main chunk', "      "
local add_error = function(msg, testprops)
  table.insert(errors, { msg, testprops })
end

add_error(
  [[
E471: Argument required
]],
  { items = {}, props = {} }
)

add_error(
  [[
E5113: Error while calling lua chunk
     ...local/share/nvim/runtime/lua/vim/treesitter/language.lua:88: 'lua.neozoom' is not a valid language name
]],
  { items = {}, props = {} }
)

add_error(
  [[
E5112: Error while creating lua chunk: lua/scripts/notify-test.lua:10: 'end' expected (to close 'function' at line 50) near '<eof>'
]],
  { items = {}, props = {} }
)

add_error(
  [[
E5108: Error executing lua: /home/nicholas/.config/nvim/lua/funcs/alt-alt.lua:116: Vim:E565: Not allowed to change text or change window
stack traceback:
  [C]: in function 'edit'
  /home/nicholas/.config/nvim/lua/funcs/alt-alt.lua:116: in function 'gotoAltBuffer'
  /home/nicholas/.config/nvim/lua/keymaps.lua:524: in function </home/nicholas/.config/nvim/lua/keymaps.lua:520>
]],
  { items = {}, props = {} }
)

add_error(
  [[
Error executing Lua callback: /home/nicholas/.local/share/nvim/lazy/vimade/lua/vimade.lua:15: table index is nil
stack traceback:
	/home/nicholas/.local/share/nvim/lazy/vimade/lua/vimade.lua:15: in function 'dump'
	/home/nicholas/.config/nvim/lua/mapper/stats.lua:108: in function 'get_stats'
	/home/nicholas/.config/nvim/lua/stats/commands/init.lua:12: in function 'get_items'
	/home/nicholas/.config/nvim/lua/stats/commands/init.lua:113: in function </home/nicholas/.config/nvim/lua/stats/commands/init.lua:112>
]],
  { items = {}, props = {} }
)

add_error(
  [[
Vim(copen):Error executing Lua callback: ./scratch/tmp2.lua:2: attempt to perform arithmetic on global '_sd' (a nil value)
stack traceback:
  ./scratch/tmp2.lua:2: in function <./scratch/tmp2.lua:1>
  [C]: at 0x562710d3ba4b
  [C]: in function 'pcall'
  /home/nicholas/.config/nvim/lua/runner/commands/run_cmd.lua:54: in function 'exec_vim_cmd'
  /home/nicholas/.config/nvim/lua/runner/commands/run_cmd.lua:71: in function 'exec_run_cmd'
  /home/nicholas/.config/nvim/lua/runner/commands/run_cmd.lua:110: in function 'on_confirm'
  ...cal/share/nvim/lazy/dressing.nvim/lua/dressing/input.lua:119: in function ''
  vim/_editor.lua: in function ''
  vim/_editor.lua: in function <vim/_editor.lua:0>
]],
  { items = {}, props = {} }
)

add_error(
  [[
Error detected while processing QuickFixCmdPost Autocommands for "vimgrep":
Error executing lua callback: vim/_editor.lua:0: QuickFixCmdPost Autocommands for "vimgrep"..script nvim_exec2() called at QuickFixCmdPost Autocommands for "vimgrep":0..function <lambda>39, line 1: Vim(copen):E5108: Error executing lua scratch/tmp3.lua:17: attempt to compare number with nil
stack traceback:
  scratch/tmp3.lua:17: in function 'format_filename'
  scratch/tmp3.lua:34: in function 'get_max_filename_width'
  scratch/tmp3.lua:63: in function <scratch/tmp3.lua:46>
  [C]: in function 'nvim_exec2'
  vim/_editor.lua: in function 'cmd'
  /home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:301: in function 'open'
  /home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:934: in function </home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:933>
stack traceback:
  [C]: in function 'nvim_exec2'
  vim/_editor.lua: in function 'cmd'
  /home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:301: in function 'open'
  /home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:934: in function </home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:933>
]],
  { items = {}, props = {} }
)

add_error(
  [[
E5108: Error executing lua vim/_editor.lua:0: nvim_exec2()..function <lambda>6715, line 1: Vim(copen):E5108: Error executing lua scratch/tmp3.lua:17: attempt to compare number with nil
stack traceback:
  scratch/tmp3.lua:17: in function 'format_filename'
  scratch/tmp3.lua:34: in function 'get_max_filename_width'
  scratch/tmp3.lua:63: in function <scratch/tmp3.lua:46>
  [C]: in function 'nvim_exec2'
  vim/_editor.lua: in function 'cmd'
  /home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:301: in function 'open'
  /home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:328: in function 'toggle'
  [string ":lua"]:1: in main chunk
stack traceback:
  [C]: in function 'nvim_exec2'
  vim/_editor.lua: in function 'cmd'
  /home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:301: in function 'open'
  /home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:328: in function 'toggle'
  [string ":lua"]:1: in main chunk
]],
  { items = {}, props = {} }
)

add_error(
  [[
E5108: Error executing lua /home/nicholas/.config/nvim/lua/gitops/core/commits.lua:57: attempt to call field 'new' (a nil value)
stack traceback:
	/home/nicholas/.config/nvim/lua/gitops/core/commits.lua:57: in function </home/nicholas/.config/nvim/lua/gitops/core/commits.lua:41>
	/home/nicholas/.config/nvim/lua/telescope/run.lua:99: in function </home/nicholas/.config/nvim/lua/telescope/run.lua:70>
	.../nvim/lua/telescope/_extensions/find_pickers/actions.lua:17: in function 'select_picker'
	.../nvim/lua/telescope/_extensions/find_pickers/actions.lua:27: in function 'run_replace_or_original'
	...re/nvim/lazy/telescope.nvim/lua/telescope/actions/mt.lua:65: in function 'select_default'
	...las/.config/nvim/lua/plugs/config/telescope/mappings.lua:13: in function 'key_func'
	...hare/nvim/lazy/telescope.nvim/lua/telescope/mappings.lua:350: in function 'execute_keymap'
	[string ":lua"]:1: in main chunk
]],
  { items = {}, props = {} }
)

add_error(
  [[
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
	[string ":lua"]:1: in main chunk
]],
  { items = {}, props = {} }
)

add_error(
  [[
E5113: Error while calling lua chunk: /home/nicholas/.config/nvim/lua/watcher/utils.lua:37: attempt to call method 'info' (a nil value)
stack traceback:
        /home/nicholas/.config/nvim/lua/watcher/utils.lua:37: in function 'clear_timers'
        lua/watcher/init.lua:7: in function 'setup'
        lua/watcher/init.lua:19: in main chunk
]],
  { items = {}, props = {} }
)

add_error(
  [[
Error executing Lua callback: /home/nicholas/.local/share/nvim/lazy/vimade/lua/vimade.lua:15: table index is nil
stack traceback:
  /home/nicholas/.local/share/nvim/lazy/vimade/lua/vimade.lua:15: in function 'dump'
  /home/nicholas/.config/nvim/lua/mapper/stats.lua:108: in function 'get_stats'
  /home/nicholas/.config/nvim/lua/stats/commands/init.lua:12: in function 'get_items'
  /home/nicholas/.config/nvim/lua/stats/commands/init.lua:113: in function </home/nicholas/.config/nvim/lua/stats/commands/init.lua:112>
]],
  { items = {}, props = {} }
)

add_error(
  [[
E5112: Error while creating lua chunk: scratch/tmp3.lua:32: unexpected symbol near 'local'
]],
  { items = {}, props = {} }
)

add_error(
  [[
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
  vim/_editor.lua: in function <vim/_editor.lua:0> ]],
  { items = {}, props = {} }
)

add_error(
  [[
E5108: Error executing lua [string ":lua"]:1: Key not found: visualmode"
stack traceback:
   [C]: in function 'nvim_get_vvar'"
   [string ":lua"]:1: in main chunk
]],
  { items = {}, props = {} }
)

add_error(
  [[
Error executing vim.schedule lua callback: Vim:E5300: Expected a Number or a String
stack traceback:
	[C]: in function 'bufwinid'
	/home/nicholas/.config/nvim/lua/modeman/init.lua:45: in function 'refresh_state'
	/home/nicholas/.config/nvim/lua/modeman/init.lua:62: in main chunk
	[C]: in function 'require'
	/home/nicholas/.config/nvim/init.lua:46: in function ''
	vim/_editor.lua: in function ''
	vim/_editor.lua: in function <vim/_editor.lua:0>
]],
  { items = {}, props = {} }
)

add_error(
  [[
E5113: Error while calling lua chunk: /home/nicholas/.config/nvim/lua/notify/render/_error.lua:223: Invalid 'end_col': out of range
stack traceback:
  [C]: in function 'nvim_buf_set_extmark'
  /home/nicholas/.config/nvim/lua/notify/render/_error.lua:223: in function 'error_highlighting'
  /home/nicholas/.config/nvim/lua/notify/render/_error.lua:249: in function 'render'
  ...holas/git/nvim-notify/lua/notify/service/buffer/init.lua:120: in function 'render'
  /home/nicholas/git/nvim-notify/lua/notify/service/init.lua:54: in function 'push'
  /home/nicholas/git/nvim-notify/lua/notify/instance.lua:139: in function 'notify'
  lua/notify/demo/scratch.lua:9: in function 'notify_errors'
  lua/notify/demo/scratch.lua:20: in main chunk
]],
  { items = {}, props = {} }
)

add_error(
  [[
E5113: Error while calling lua chunk: vim/_editor.lua:0: nvim_exec2(), line 1: Vim:E492: Not an editor command: silent qaq:g/🪚 /y A
stack traceback:
  [C]: in function 'nvim_exec2'
  vim/_editor.lua: in function 'cmd'
  /home/nicholas/.config/nvim/scratch/tmp3.lua:31: in function 'remove_logs'
  /home/nicholas/.config/nvim/scratch/tmp3.lua:58: in function 'remove_logs_open'
  /home/nicholas/.config/nvim/scratch/tmp3.lua:67: in main chunk
]],
  { items = {}, props = {} }
)

add_error(
  [[
E5108: Error executing lua vim/_editor.lua:0: nvim_exec2()..function <lambda>6715, line 1: Vim(copen):E5108: Error executing lua scratch/tmp3.lua:17: attempt to compare number with nil
stack traceback:
  scratch/tmp3.lua:17: in function 'format_filename'
  scratch/tmp3.lua:34: in function 'get_max_filename_width'
  scratch/tmp3.lua:63: in function <scratch/tmp3.lua:46>
  [C]: in function 'nvim_exec2'
  vim/_editor.lua: in function 'cmd'
  /home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:301: in function 'open'
  /home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:328: in function 'toggle'
  [string ":lua"]:1: in main chunk'
stack traceback:"
  [C]: in function 'nvim_exec2'
  vim/_editor.lua: in function 'cmd'
  /home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:301: in function 'open'
  /home/nicholas/.local/share/nvim/lazy/qf.nvim/lua/qf.lua:328: in function 'toggle'
  [string ":lua"]:1: in main chunk'
]],
  { items = {}, props = {} }
)

add_error(
  [[
E5108:Error executing lua
  ...share/nvim/lazy/nvim-lspconfig/lua/lspconfig/manager.lua:262:attempt to index local 'self' (a number value)
  ...share/nvim/lazy/nvim-lspconfig/lua/lspconfig/manager.lua:262: in function 'try_add'
  ...l/share/nvim/lazy/lsp-toggle.nvim/lua/lsp-toggle/lsp.lua:49: in function 'onSubmit'
  .../share/nvim/lazy/lsp-toggle.nvim/lua/lsp-toggle/init.lua:34: in function 'on_choice'
  ...e-ui-select.nvim/lua/telescope/_extensions/ui-select.lua:122: in function 'run_replace_or_original'
  ...nicholas/git/telescope.nvim/lua/telescope/actions/mt.lua:65: in function 'select_default'
  ...nicholas/.config/nvim/lua/configs/telescope/mappings.lua:13: in function 'key_func'
  ...e/nicholas/git/telescope.nvim/lua/telescope/mappings.lua:257: in function <...e/nicholas/git/telescope.nvim/lua/telescope/mappings.lua:256>
]],
  { items = {}, props = {} }
)

add_error(
  [[
E730:Vim
E730:E730:Using a List as a String
  [C]: in function 'split'
  lua/stats/output.lua:2: in function <lua/stats/output.lua:1>
  ...icholas/.config/nvim/lua/stats/commands/lazy/configs.lua:76: in function <...icholas/.config/nvim/lua/stats/commands/lazy/configs.lua:73>
  ...icholas/.config/nvim/lua/stats/commands/lazy/configs.lua:121: in function <...icholas/.config/nvim/lua/stats/commands/lazy/configs.lua:111>
  ...e/nicholas/.config/nvim/lua/stats/commands/lazy/init.lua:45: in function 'stats'
  lua/stats/init.lua:50: in function <lua/stats/init.lua:44>
]],
  { items = {}, props = {} }
)

add_error(
  [[
Error executing vim.schedule lua callback: vim/_editor.lua:0: nvim_exec2(), line 1: Vim:Error executing Lua callback: ...icholas/.config/nvim/lua/stats/commands/lazy/configs.lua:82: attempt to call a nil value
stack traceback:
	...icholas/.config/nvim/lua/stats/commands/lazy/configs.lua:82: in function <...icholas/.config/nvim/lua/stats/commands/lazy/configs.lua:79>
	...icholas/.config/nvim/lua/stats/commands/lazy/configs.lua:121: in function <...icholas/.config/nvim/lua/stats/commands/lazy/configs.lua:111>
	...e/nicholas/.config/nvim/lua/stats/commands/lazy/init.lua:45: in function 'stats'
	/home/nicholas/.config/nvim/lua/stats/commands/init.lua:47: in function </home/nicholas/.config/nvim/lua/stats/commands/init.lua:38>
	[C]: in function 'nvim_exec2'
	vim/_editor.lua: in function 'cmd'
	lua/stats/test.lua:56: in function ''
	vim/_editor.lua: in function ''
	vim/_editor.lua: in function <vim/_editor.lua:0>
stack traceback:
	[C]: in function 'nvim_exec2'
	vim/_editor.lua: in function 'cmd'
	lua/stats/test.lua:56: in function ''
	vim/_editor.lua: in function ''
	vim/_editor.lua: in function <vim/_editor.lua:0>
]],
  { items = {}, props = {} }
)

return errors
