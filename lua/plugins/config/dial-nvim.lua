local augend = require("dial.augend")

require("dial.config").augends:register_group({
  default = {
    augend.hexcolor.new({
      case = "lower",
    }),
    augend.integer.alias.decimal,
    augend.date.alias["%Y/%m/%d"],
  },
  typescript = {
    augend.hexcolor.new({
      case = "lower",
    }),
    augend.integer.alias.decimal,
    augend.date.alias["%Y/%m/%d"],
    augend.constant.new({ elements = { "let", "const" } }),
  },
  visual = {
    augend.hexcolor.new({
      case = "lower",
    }),
    augend.integer.alias.decimal,
    augend.date.alias["%Y/%m/%d"],
    augend.constant.alias.alpha,
    augend.constant.alias.Alpha,
  },
})

-- change augends in VISUAL mode
vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
-- vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
-- vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
-- vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(), { noremap = true })
-- vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(), { noremap = true })

-- vim.keymap.set("n", "<C-S-Up>", require("dial.map").inc_normal(), { noremap = true })
-- vim.keymap.set("n", "<C-S-Down>", require("dial.map").dec_normal(), { noremap = true })
-- vim.keymap.set("v", "<C-S-Up>", require("dial.map").inc_visual(), { noremap = true })
-- vim.keymap.set("v", "<C-S-Down>", require("dial.map").dec_visual(), { noremap = true })

--
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
