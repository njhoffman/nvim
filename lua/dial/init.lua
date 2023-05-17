local augend = require('dial.augend')

require('dial.config').augends:register_group({
  default = {
    augend.hexcolor.new({
      case = 'lower',
    }),
    augend.integer.alias.decimal,
    augend.date.alias['%Y/%m/%d'],
  },
  typescript = {
    augend.hexcolor.new({
      case = 'lower',
    }),
    augend.integer.alias.decimal,
    augend.date.alias['%Y/%m/%d'],
    augend.constant.new({ elements = { 'let', 'const' } }),
  },
  visual = {
    augend.hexcolor.new({
      case = 'lower',
    }),
    augend.integer.alias.decimal,
    augend.date.alias['%Y/%m/%d'],
    augend.constant.alias.alpha,
    augend.constant.alias.Alpha,
  },
})

vim.keymap.set('n', '<M-a>', function()
  require('dial.map').manipulate('increment', 'normal')
end)
vim.keymap.set('n', '<M-x>', function()
  require('dial.map').manipulate('decrement', 'normal')
end)
vim.keymap.set('n', 'g<M-a>', function()
  require('dial.map').manipulate('increment', 'gnormal')
end)
vim.keymap.set('n', 'g<M-x>', function()
  require('dial.map').manipulate('decrement', 'gnormal')
end)

vim.keymap.set('v', '<M-a>', function()
  require('dial.map').manipulate('increment', 'visual')
end)
vim.keymap.set('v', '<M-x>', function()
  require('dial.map').manipulate('decrement', 'visual')
end)
vim.keymap.set('v', 'g<M-a>', function()
  require('dial.map').manipulate('increment', 'gvisual')
end)
vim.keymap.set('v', 'g<M-x>', function()
  require('dial.map').manipulate('decrement', 'gvisual')
end)

vim.cmd([[
  command! -range -nargs=? DialIncrement lua require"dial.command".command("increment", {from = <line1>, to = <line2>}, {<f-args>})
  command! -range -nargs=? DialDecrement lua require"dial.command".command("decrement", {from = <line1>, to = <line2>}, {<f-args>})
]])

-- 168
-- change augends in VISUAL mode
-- ,fi <C-up>
-- ,fd <C-down>
-- :DialShowSearchList
-- number#decimal               decimal natural number          0, 1, ..., 9, 10, 11, ...
-- number#decimal#int           decimal integer (including negative number)  0, 314, -1592, ...
-- number#decimal#fixed#zero    fixed-   digit decimal number (  0 padding)   00, 01, ..., 11, ..., 99
-- number#decimal#fixed#spce    fixed-   digit decimal number (half space padding) ␣   0, ␣1, ..., 11, ..., 99
-- number#hex                   hex natural number            0x00, 0x3f3f, ...
-- number#octal                 octal natural number           000, 011, 024, ...
-- number#binary                binary natural number          0b0101, 0b11001111, ...
-- date#[%y/%m/%d]              date in the format %y/%m/%d (  0 padding)   2021/01/04, ...
-- date#[%m/%d]                 date in the format %m/%d (0 padding)   01/04, 02/28, 12/25, ...
-- date#[%-m/%-d]               date in the format %-m/%-d (no paddings)        1/4, 2/28, 12/25, ...
-- date#[%h:%m:%s]              time in the format %h:%m:%s         14:30:00, ...
-- date#[%h:%m]                 time in the format %h:%m            14:30, ...
-- char#alph#small#word         lowercase alphabet letter (word)   a, b, c, ..., z
-- char#alph#capital#word       uppercase alphabet letter (word)   a, b, c, ..., z
-- char#alph#small#str          lowercase alphabet letter (string)   a, b, c, ..., z
-- char#alph#capital#str        uppercase alphabet letter (string)   a, b, c, ..., z
-- color#hex                    hex triplet   #00ff00, #ababab, ...
-- markup#markdown#header       markdown header   #, ##, ..., ######
