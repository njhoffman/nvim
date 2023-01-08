-- :DialShowSearchList
local augend = require("dial.augend")
require("dial.config").augends:register_group {
  -- default augends used when no group name is specified
  default = {
    augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
    augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
    augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
  },

  -- augends used when group with name `mygroup` is specified
  mygroup = {
    augend.integer.alias.decimal,
    augend.constant.alias.bool, -- boolean value (true <-> false)
    augend.date.alias["%m/%d/%Y"], -- date (02/19/2022, etc.)
  }
}

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
