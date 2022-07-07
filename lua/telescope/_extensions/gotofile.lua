local has_telescope, telescope = pcall(require, "telescope")
local main = require("telescope._extensions.gotofile.main")

if not has_telescope then
  error("This plugins requires nvim-telescope/telescope.nvim")
end

return telescope.register_extension({
  setup = main.setup,
  exports = { gotofile = main.gotofile },
})

-- [count]gf		Edit the file whose name is under or after the cursor.
-- 			Mnemonic: "goto file".
-- 			Uses the 'isfname' option to find out which characters
-- 			are supposed to be in a file name.  Trailing
-- 			punctuation characters ".,:;!" are ignored. Escaped
-- 			spaces "\ " are reduced to a single space.
-- 			Uses the 'path' option as a list of directory names to
-- 			look for the file.  See the 'path' option for details
-- 			about relative directories and wildcards.
-- 			Uses the 'suffixesadd' option to check for file names
-- 			with a suffix added.
-- 			If the file can't be found, 'includeexpr' is used to
-- 			modify the name and another attempt is done.
-- 			If a [count] is given, the count'th file that is found
-- 			in the 'path' is edited.
-- 			This command fails if Vim refuses to |abandon| the
-- 			current file.
-- 			If you want to edit the file in a new window use
-- 			|CTRL-W_CTRL-F|.
-- 			If you do want to edit a new file, use: >
-- 				:e <cfile>
-- <			To make gf always work like that: >
-- 				:map gf :e <cfile><CR>
-- <			If the name is a hypertext link, that looks like
-- 			"type://machine/path", you need the |netrw| plugin.
-- 			For Unix the '~' character is expanded, like in
-- 			"~user/file".  Environment variables are expanded too
-- 			|expand-env|.
-- 							*gF*
-- [count]gF		Same as "gf", except if a number follows the file
-- 			name, then the cursor is positioned on that line in
-- 			the file.
-- 			The file name and the number must be separated by a
-- 			non-filename (see 'isfname') and non-numeric
-- 			character. " line " is also recognized, like it is
-- 			used in the output of `:verbose command UserCmd`
-- 			White space between the filename, the separator and
-- 			the number are ignored.
-- 			Examples:
-- 				eval.c:10 ~
-- 				eval.c @ 20 ~
-- 				eval.c (30) ~
-- 				eval.c 40 ~
