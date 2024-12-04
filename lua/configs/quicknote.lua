require("quicknote").setup({
  mode = "portable", -- "portable" | "resident"
  sign = " ", --                      
  filetype = "md",
  git_branch_recognizable = false,
})

vim.api.nvim_set_keymap(
  "n",
  "<leader>N",
  "<cmd>:lua require('quicknote').NewNoteAtCurrentLine()<cr>",
  {}
)

-- Description
-- NewNoteAtCWD()                 	create a note at current working directory
-- NewNoteAtLine(line)            	create a note at a give line
-- NewNoteAtCurrentLine()         	create a note at current cursor line
-- NewNoteAtGlobal                	create a note which can be accessed globally

-- OpenNoteAtCWD()                	open a note at CWD, you will input the name of the note
-- OpenNoteAtLine(line)           	open a note associated with a given line
-- OpenNoteAtCurrentLine()        	open a note associated with the current cursor line
-- OpenNoteAtGlobal()             	open a note in global, you will input the name of the note

-- DeleteNoteAtCWD()              	delete a note at CWD, you will input the name of the note
-- DeleteNoteAtLine(line)         	delete a note associated with a given line
-- DeleteNoteAtCurrentLine()      	delete a note associated with the current cursor line
-- DeleteNoteAtGlobal()           	delete a note in global, you will input the name of the note

-- ListNotesForCurrentBuffer()    	list all notes associated with current buffer
-- ListNotesForCWD()              	list all notes created in CWD
-- ListNotesForGlobal()           	list all notes in global
-- ListNotesForAFileOrWDInCWD()   	list all notes for a certain file or directory under CWD

-- JumpToNextNote()               	jump to next avaiable note in current buffer
-- JumpToPreviousNote()           	jump to previous avaiable note in current buffer

-- GetNotesCountForCurrentBuffer()	get notes count for current buffer
-- GetNotesCountForCWD()          	get notes count for CWD
-- GetNotesCountForGlobal()       	get notes count for global

-- ShowNoteSigns()                	show signs for current buffer
-- HideNoteSigns()                	hide signs for current buffer
-- ToggleNoteSigns()              	toggle signs

-- ExportNotesForCurrentBuffer()  	export all notes associated with the current buffer to a destination dir
-- ExportNotesForCWD()            	export all notes associated with CWD, but notes associated with the files under CWD are not exported
-- ExportNotesForGlobal()         	export all notes that have been put in global

-- ImportNotesForCurrentBuffer()  	import notes from external note folder to current buffer
-- ImportNotesForCWD()            	import notes from external note folder to CWD
-- ImportNotesForGlobal()         	import notes from external note folder to global
