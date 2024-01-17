--------------------------------------------------------------------------------
-- INFO if abbreviations are not working, probably something has been mapped to
-- `<Space>` in insert mode
-----------------------------------------------------------------------------------

local spellfixes = {
  teh = 'the',
  THe = 'the',
  brwoser = 'browser',
  markdwon = 'markdown',
  dwon = 'down',
  keybaord = 'keyboard',
  sicne = 'since',
  ignroe = 'ignore',
  nto = 'not',
  reponse = 'response',
  fodler = 'folder',
  woudl = 'would',
  cleitn = 'client',
  fiel = 'file',
  shwo = 'show',
  hwo = 'how',
  tiem = 'item',
  seperate = 'separate',
  msot = 'most',
  retrun = 'return',
  onyl = 'only',
  esle = 'else',
  treu = 'true',
  ture = 'true',
  terue = 'true',
  fo = 'of',
  oepn = 'open',
  ntoe = 'note',
  verison = 'version',
  ot = 'to',
  ti = 'it',
  cant = "can't",
  dont = "don't",
}

for wrong, correct in pairs(spellfixes) do
  -- TODO lua API for abbreviations for nvim 0.10
  -- vim.keymap.set("ia", wrong, correct)
  vim.cmd.inoreabbrev(wrong .. ' ' .. correct)
end

vim.cmd([[
  cabbrev T Telescope
  cabbrev D lua vim.dbglog(
]])

-- vim.cmd('ab ng Neogit')
-- if vim.o.ft == 'go' then
--   vim.cmd('ab gb GoBuild')
--   vim.cmd('cab gt GoTest')
--   vim.cmd('cab gn GoGenerate')
--   vim.cmd('cab gd GoDebug')
--   vim.cmd('cab dt GoDebug -t')
--   vim.cmd('cab ds GoDebug -s')
--   vim.cmd('cab ts GoTestSum')
--   vim.cmd('cab tc GoCoverage')
--   vim.cmd('cab sc GoTestSubCase')
--   vim.cmd('cab tf GoTestFunc')
--   vim.cmd('cab at GoAddTest')
--
--   -- vim.cmd('ab gg GoGet')
-- end
