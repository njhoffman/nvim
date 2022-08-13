vim.cmd([[ let g:pandoc#syntax#style#underline_special = 0 ]])
vim.cmd([[ let g:pandoc#syntax#conceal#use = 1 ]])
vim.cmd([[ let g:pandoc#syntax#conceal#urls = 1 ]])

-- NOTE: vim syntax messing up, assigning to vimwiki for now
vim.cmd(
  [[
  let g:pandoc#syntax#codeblocks#embeds#langs =
    \ ["shell=sh", "rust", "ts=typescript", "javascript", "html", "cpp", "c",
    \ "go", "sh", "bash=sh", "yaml", "go", "ruby", "python", "json",
    \ "sql", "lua", "css", "awk", "terraform", "yaml", "vim=vimwiki", "xml"]
  ]]
)

-- E403: syntax sync: line continuations pattern specified twice
-- E403: syntax sync: line continuations pattern specified twice
-- Error detected while processing function <SNR>294_MarkdownRefreshSyntax[2]..<SNR>294_MarkdownHighlightSources:

-- + *g:pandoc#syntax#conceal#urls*
-- a = accents/ligatures
-- b = bold and italic
-- d = delimiters
-- m = math symbols
-- g = Greek
-- s = superscripts/subscripts
-- vim.cmd([[let g:tex_conceal="abmgs" ]])
--     call s:WithConceal("atx", 'syn match AtxStart /#/ contained
--         containedin=pandocAtxHeader', 'conceal cchar='.s:cchars["atx"])
-- will execute
--     syn match AtxStart /#/ contained containedin=pandocAtxHeader conceal cchar=§
-- and
--     syn match AtxStart /#/ contained containedin=pandocAtxHeader

-- vim.cmd([[let g:pandoc#syntax#conceal#blacklist = ["titleblock"] ]])
-- - titleblock
-- - image
-- - block
-- - subscript
-- - superscript
-- - strikeout
-- - atx
-- - codeblock_start
-- - codeblock_delim
-- - footnote
-- - definition
-- - list
-- - newline
-- - dashes
-- - ellipses
-- - quotes
-- - inlinecode

-- vim.cmd([[let g:pandoc#syntax#conceal#cchar_overrides = {"footnote" : "*"}]])
-- + *g:pandoc#syntax#conceal#use*
--   Use |conceal| for pretty highlighting. Default is 1 for vim version > 7.3

--   To review what are the rules for, look for the call to |s:WithConceal| in
--   syntax/pandoc.vim that takes the corresponding  rulename as first argument.

-- + *g:pandoc#syntax#conceal#cchar_overrides*
--   A dictionary of what characters should be used in conceal rules. These
--   override the defaults (see those in |s:cchars|). For example, if you prefer
--   to mark footnotes with the `*` symbol:

--       let g:pandoc#syntax#conceal#cchar_overrides = {"footnote" : "*"}

-- + *g:pandoc#syntax#conceal#urls*
--   Conceal the urls in links.

-- + *g:pandoc#syntax#codeblocks#ignore*
--   Prevent highlighting specific codeblock types so that they remain Normal.
--   Codeblock types include 'definition' for codeblocks inside definition blocks
--   and 'delimited' for delimited codeblocks. Default = []

-- + *g:pandoc#syntax#codeblocks#embeds#use*
--   Use embedded highlighting for delimited codeblocks where a language is
--   specified. Default = 1

-- + *g:pandoc#syntax#style#emphases*
--   Use italics and strong in emphases. Default = 1
--   0 will add "block" to |g:pandoc#syntax#conceal#blacklist|, because otherwise
--   you couldn't tell where the styles are applied.

-- + *g:pandoc#syntax#style#underline_special*
--   Undeline subscript, superscript and strikeout text styles. Default = 1

-- + *g:pandoc#syntax#style#use_definition_lists*
--   Detect and highlight definition lists. Disabling this can improve
--   performance. Default = 1 (i.e., enabled by default)
