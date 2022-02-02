-- lua require("telekasten").find_notes(), .showw_backlinks, toggle_todo(), follow_link,
-- preview_img(), search_notes(), new_note(),
-- # Note links
-- - [[A cool title]]  ................. links to the note named 'A cool title'
-- - [[A cool title#Heading 27]]  ...... links to the heading 'Heading 27' within the note
-- named 'A cool title'
-- - [[A cool title#^xxxxxxxx]]  ....... links to the paragraph with id ^xxxxxxxx within the note
-- named 'A cool title'
-- - [[#Heading 27]]  .................. links to the heading 'Heading 27' within all notes
-- - [[#^xxxxxxxx]]  ................... links to the paragraph with id ^xxxxxxxx within all notes

-- ## Optionally, notes can live in specific sub-directories
-- - [[some/subdirectory/A cool title]]  ................. links to note named 'A cool title'
-- in some/subdirectory
-- - [[some/subdirectory/A cool title#Heading 27]]  ...... links to the heading 'Heading 27' within
-- the note named 'A cool title'
-- in some/subdirectory
-- - [[some/subdirectory/A cool title#^xxxxxxxx]]  ....... links to the paragraph with
-- id ^xxxxxxxx within the note named
-- 'A cool title' in some/subdirectory

-- # Media links
-- Use these for images, PDF files, videos. If telescope-media-files is installed, these can
-- be previewed.
-- - ![optional title](path/to/file) ... links to the file `path/to/file`
local home = vim.fn.expand("~/zettelkasten")
require("telekasten").setup({
  home = home,
  dailies = home .. "/" .. "daily",
  weeklies = home .. "/" .. "weekly",
  templates = home .. "/" .. "templates",

-- image subdir for pasting
-- subdir name
-- or nil if pasted images shouldn't go into a special subdir
  image_subdir = "img",

-- markdown file extension
  extension = ".md",

-- following a link to a non-existing note will create it
  follow_creates_nonexisting = true,
  dailies_create_nonexisting = true,
  weeklies_create_nonexisting = true,

-- template for new notes (new_note, follow_link)
-- set to `nil` or do not specify if you do not want a template
  template_new_note = home .. "/" .. "templates/new_note.md",

-- template for newly created daily notes (goto_today)
-- set to `nil` or do not specify if you do not want a template
  template_new_daily = home .. "/" .. "templates/daily.md",

-- template for newly created weekly notes (goto_thisweek)
-- set to `nil` or do not specify if you do not want a template
  template_new_weekly = home .. "/" .. "templates/weekly.md",

-- image link style
-- wiki:     ![[image name]]
-- markdown: ![](image_subdir/xxxxx.png)
  image_link_style = "markdown",

-- integrate with calendar-vim
  plug_into_calendar = true,
  calendar_opts = {
-- calendar week display mode: 1 .. 'WK01', 2 .. 'WK 1', 3 .. 'KW01', 4 .. 'KW 1', 5 .. '1'
    weeknm = 4,
-- use monday as first day of week: 1 .. true, 0 .. false
  calendar_monday = 1,
-- calendar mark: where to put mark for marked days: 'left', 'right', 'left-fit'
  calendar_mark = "left-fit",
  },
  })
