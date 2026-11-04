--------------------------------------------------------------------------------
-- INFO if abbreviations are not working, probably something has been mapped to
-- `<Space>` in insert mode
-----------------------------------------------------------------------------------

local spellfixes = {
  teh = "the",
  THe = "the",
  brwoser = "browser",
  markdwon = "markdown",
  dwon = "down",
  keybaord = "keyboard",
  sicne = "since",
  ignroe = "ignore",
  nto = "not",
  reponse = "response",
  fodler = "folder",
  woudl = "would",
  cleitn = "client",
  fiel = "file",
  shwo = "show",
  hwo = "how",
  tiem = "item",
  seperate = "separate",
  msot = "most",
  retrun = "return",
  onyl = "only",
  esle = "else",
  treu = "true",
  ture = "true",
  terue = "true",
  fo = "of",
  oepn = "open",
  ntoe = "note",
  verison = "version",
  ot = "to",
  ti = "it",
  cant = "can't",
  dont = "don't",
}

for wrong, correct in pairs(spellfixes) do
  -- vim.keymap.set("ia", wrong, correct)
  vim.cmd.inoreabbrev(wrong .. " " .. correct)
end

vim.cmd([[

   " func Eatchar(pat)
   "    let c = nr2char(getchar(0))
   "    return (c =~ a:pat) ? '' : c
   " endfunc
   " iabbr <silent> if if ()<Left><C-R>=Eatchar('\s')<CR>

  cabbrev T Telescope
  cabbrev ( lua vim.dbglog(
]])
