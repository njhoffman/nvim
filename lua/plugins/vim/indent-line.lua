-- indentLine will overwrite 'conceal' color with grey by default. If you want to highlight conceal color with your colorscheme, disable by:
vim.g.indentLine_setColors = 1

-- Or you can use the same colors as another highlight group. To use the same colors that are used for tab indents, use the 'SpecialKey' group:
vim.g.indentLine_defaultGroup = "SpecialKey"

-- Or you can customize conceal color by: Vim
-- vim.g.indentLine_color_term = 239
vim.g.indentLine_color_term = 235
vim.g.indentLine_color_gui = "#A4E57E"

--  none X terminal
vim.g.indentLine_color_tty_light = 7 -- (default: 4)
vim.g.indentLine_color_dark = 1 -- (default: 2)

-- vim.g.indentLine_bgcolor_term = 202
vim.g.indentLine_bgcolor_term = 232
vim.g.indentLine_bgcolor_gui = "#FF5F00"

vim.g.indentLine_char = "."
-- vim.g.indentLine_char_list = {'|', '¦', '┆', '┊'}

-- where 'c' can be any ASCII character. You can also use one of ¦, ┆, │, ⎸, or ▏ to display more beautiful lines. However, these characters will only work with files whose encoding is UTF-8.
-- or vim.g.indentLine_char_list = ['|', '¦', '┆', '┊']
-- each indent level has a distinct character.

-- Change Conceal Behaviour
-- This plugin enables the Vim conceal feature which automatically hides stretches of text based on syntax highlighting. This setting will apply to all syntax items.
-- For example, users utilizing the built in json.vim syntax file will no longer see quotation marks in their JSON files.
-- indentLine will overwrite your "concealcursor" and "conceallevel" with default value:

vim.g.indentLine_concealcursor = "inc"
vim.g.indentLine_conceallevel = 2
-- You can customize these settings, but the plugin will not function if conceallevel is not set to 1 or 2.
-- If you want to keep your conceal setting, put this line to your vim dotfile:
-- vim.g.indentLine_setConceal = 0

-- Disable by default
vim.g.indentLine_enabled = 0

-- Commands
-- :IndentLinesToggle toggles lines on and off.

-- Font patching
-- If you find all the standard unicode and ASCII characters too obtrusive, you might consider patching your font with the indentLine-dotted-guide.eps glyph provided. FontForge makes the process amazingly simple:

-- Download and install FontForge.
-- Locate and open your terminal/gVim font.
-- Open the font in FontForge, choose Goto from the View menu and select Private Use Area from the drop down box.
-- In the private use area, locate a blank spot for the glyph. Make a note of the code, e.g. U+E0A3.
-- Double-click the selected code point to open the font drawing tool.
-- From the File menu, select Import... and locate the indentLine-dotted-guide.eps file.
-- Once imported, choose File -> Generate Fonts and choose a location and file type for the new font.
-- Once completed, your new font will contain the more subtle dotted guide and all you have to do is set that glyph to g:indentLine_char in your .vimrc file.
