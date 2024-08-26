local augend = require("dial.augend")

local new_augends = {
  -- date with format `yyyy/mm/dd`
  ["%Y/%m/%d"] = augend.date.new({
    pattern = "%Y/%m/%d",
    default_kind = "day",
    -- if true, it does not match dates which does not exist, such as 2022/05/32
    only_valid = true,
    -- if true, it only matches dates with word boundary
    word = false,
  }),
  hexcolor = augend.hexcolor.new({ case = "lower" }),
  -- uppercase hex number (0x1A1A, 0xEEFE, etc.)
  hexinteger = augend.integer.new({
    radix = 16,
    prefix = "0x",
    natural = true,
    case = "upper",
  }),
  hexinteger2 = augend.user.new({
    find = require("dial.augend.common").find_pattern("%d+"),
    add = function(text, addend, cursor)
      local n = tonumber(text)
      n = math.floor(n * (2 ^ addend))
      text = tostring(n)
      cursor = #text
      return { text = text, cursor = cursor }
    end,
  }),
  booland = augend.constant.new({
    elements = { "and", "or" },
    word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
    cyclic = true, -- "or" is incremented into "and".
  }),
  boolenable = augend.constant.new({
    elements = { "enable", "disable" },
    word = true,
    cyclic = true,
  }),
  boolsymbol = augend.constant.new({
    elements = { "&&", "||" },
    word = false,
    cyclic = true,
  }),
}
local common = {
  augend.semver.alias.semver,
  new_augends.hexcolor,

  augend.date.alias["%Y-%m-%d"],
  augend.date.alias["%m/%d"],
  augend.date.alias["%H:%M"],
  new_augends["%Y/%m/%d"],

  augend.integer.alias.decimal,
  augend.integer.alias.hex,
  new_augends.hexinteger,

  augend.constant.alias.bool,
  augend.constant.alias.alpha,
  augend.constant.alias.Alpha,
  new_augends.booland,
  new_augends.boolenable,
  new_augends.boolsymbol,
}

require("dial.config").augends:register_group({
  default = vim.tbl_deep_extend("force", common, {}),
  visual = vim.tbl_deep_extend("force", common, {}),
  typescript = vim.tbl_deep_extend("force", common, {
    augend.constant.new({ elements = { "let", "const" } }),
  }),
  markdown = vim.tbl_deep_extend("force", common, {
    augend.misc.alias.markdown_header,
  }),
})

local rhs_func = function(direction, op)
  return function()
    local buf = vim.api.nvim_get_current_buf()
    local is_readonly = vim.api.nvim_buf_get_option(buf, "readonly")
    local is_modifiable = vim.api.nvim_buf_get_option(buf, "modifiable")
    -- vim.dbglog(buf, is_readonly, is_modifiable)
    if not is_readonly and is_modifiable then
      return require("dial.map").manipulate(direction, op)
    end
    return ""
    -- TODO: should we disable the default <C-a> mappings too?
  end
end

local dial_map = function(mode, lhs, direction, op, desc)
  vim.keymap.set(mode, lhs, rhs_func(direction, op), {
    -- buffer = true,
    noremap = true,
    silent = true,
    desc = desc,
  })
end

-- disable default C-A / C-X behavior because it changes values to easily
vim.keymap.set("n", "<C-a>", "<nop>")
vim.keymap.set("n", "<C-x>", "<nop>")
dial_map("n", "<M-a>", "increment", "normal", " dial increment normal")
dial_map("n", "<M-x>", "decrement", "normal", " dial increment normal")
dial_map("v", "<M-a>", "increment", "visual", " dial increment visual")
dial_map("v", "<M-x>", "decrement", "visual", " dial increment visual")
dial_map("n", "<M-C-A>>", "increment", "gnormal", " dial increment gnormal")
dial_map("n", "<M-C-X>", "decrement", "gnormal", " dial increment gnormal")
dial_map("v", "<M-C-A>", "increment", "gvisual", " dial increment gvisual")
dial_map("v", "<M-C-X>", "decrement", "gvisual", " dial increment gvisual")

vim.cmd([[
  " autocmd FileType typescript lua vim.api.nvim_buf_set_keymap(0, "n", "<C-a>", require("dial.map").inc_normal("typescript"), {noremap = true})
  " autocmd FileType typescript lua vim.api.nvim_buf_set_keymap(0, "n", "<C-x>", require("dial.map").dec_normal("typescript"), {noremap = true})
  " autocmd FileType markdown lua vim.api.nvim_buf_set_keymap(0, "n", "<C-a>", require("dial.map").inc_normal("markdown"), {noremap = true})
  " autocmd FileType markdown lua vim.api.nvim_buf_set_keymap(0, "n", "<C-x>", require("dial.map").dec_normal("markdown"), {noremap = true})

  command! -range -nargs=? DialIncrement lua require"dial.command".command("increment", {from = <line1>, to = <line2>}, {<f-args>})
  command! -range -nargs=? DialDecrement lua require"dial.command".command("decrement", {from = <line1>, to = <line2>}, {<f-args>})
]])

-- local common_examples = {
--   augend.semver.alias.semver,
--   new_augends.hexcolor,

--   augend.date.alias["%Y-%m-%d"],
--   augend.date.alias["%m/%d"],
--   augend.date.alias["%H:%M"],
--   new_augends["%Y/%m/%d"],

--   augend.integer.alias.decimal,
--   augend.integer.alias.hex,
--   new_augends.hexinteger,

--   augend.constant.alias.bool,
--   augend.constant.alias.alpha,
--   augend.constant.alias.Alpha,
--   new_augends.booland,
--   new_augends.boolenable,
--   new_augends.boolsymbol,
-- }
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
