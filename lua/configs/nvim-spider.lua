local cfg = {
  skipInsignificantPunctuation = true,
  consistentOperatorPending = true,
  subwordMovement = true,
}

require("spider").setup(cfg)

local mapper = require("lib.mapper")
local spider_map = function(modes, key, cmd_key, opts, flags)
  -- NOTE: for dot repeat to work, must be in form of Ex-commands
  mapper.map(modes, key, "<cmd>lua require('spider').motion('" .. cmd_key .. "')<CR>", opts)
end
spider_map({ "n", "o", "x" }, "w", "w", { desc = "󱇫 Spider-w" })
spider_map({ "n", "o", "x" }, "e", "e", { desc = "󱇫 Spider-e" })
spider_map({ "n", "o", "x" }, "b", "b", { desc = "󱇫 Spider-b" })
spider_map({ "n", "o", "x" }, "ge", "ge", { desc = "󱇫 Spider-ge" })
local map = mapper.map
map("i", "<C-f>", "<Esc>l<cmd>lua require('spider').motion('w')<CR>i", { desc = "󱇫 spider-w ins" })
map("i", "<C-b>", "<Esc><cmd>lua require('spider').motion('b')<CR>i", { desc = "󱇫 spider-b ins" })
-- delete subword before cursor
-- vim.keymap.set('i', '<C-w>', '<Esc>cvb', { remap = true })
map("i", "<C-w>", "<Esc>cb")

-- skipInsignificantPunctuation = true for operators
-- cw and dw: Spider should remove the word up to, but not including, the punctuation when using cw on the last word of the last line.
-- map('n', 'w', spider.word({ 'subWord', 'punctuation' })_
-- map({'o', 'x'}, 'w', spider.word({ 'subWord' })

-- For a version of iw that considers camelCase, check out the subword text object of nvim-various-textobjs.

-- jump to next bracket (add line 78)
-- braces = "%f[%[%]{}()]",

-- positions vim's `w` will move to
-- if foo:find("%d") and foo == bar then print("[foo] has" .. bar) end
-- ^  ^^   ^  ^^  ^   ^   ^  ^   ^    ^    ^  ^  ^ ^  ^ ^  ^  ^ ^  -> 21
-- positions spider's `w` will move to
-- if foo:find("%d") and foo == bar then print("[foo] has" .. bar) end
-- ^   ^      ^   ^   ^   ^  ^   ^    ^       ^    ^    ^  ^    ^  -> 14
-- - The motion stops only at numbers.
-- require("spider").motion("w", { customPatterns = { "%d+" }, })

-- -- The motion stops at only at words with at least 3 chars or at any punctuation.
-- -- (Lua patterns have no quantifier like `{3,}`, thus the repetition.)
-- require("spider").motion("w", { customPatterns = { "%w%w%w+", "%p+" }, })

-- -- The motion stops only at hashes like `ef82a2`, avoiding repetition by using
-- -- `string.rep()`.
-- -- Extend default patterns by passing a `patterns` table and
-- -- setting `overrideDefault` to false.
-- require("spider").motion("w", { customPatterns = { patterns = { ("%x"):rep(6) .. "+" }, }, overrideDefault = false, })

-- -- The motion stops at the next declaration of a variable in -- javascript.
-- -- (The `e` motion combined with the `.` matching any character in
-- -- lua patterns ensures that you stop at beginning of the variable name.)
-- require("spider").motion("e", { customPatterns = { "const .", "let .", "var ." }, })

-- changes
-- --(line 86) if not (skipInsignificantPunc and not vim.startswith(vim.api.nvim_get_mode().mode, 'no')) then
-- --   patterns.punctuation = "%p+"
-- -- end
--
-- -- feat: only jump word
-- -- local patterns = {
-- --   camelCaseWord = "%u?[%l]+",
-- --   ALL_UPPER_CASE = "%f[%w][%u]+%f[^%w]",
-- --   number = "%d+", -- see issue #31
-- --   punctuation = "%f[^%s]%p+%f[%s]", -- punctuation surrounded by whitespace
-- --   punctuationAtStart = "^%p+%f[%s]",
-- --   punctuationAtEnd = "%f[^%s]%p+$",
-- --   onlyPunctuationLine = "^%p+$",
-- --   camelCaseWord = "[%w-_]+",
-- --   -- camelCaseWord = "%u?[%l]+",
-- --   -- ALL_UPPER_CASE = "%f[%w][%u]+%f[^%w]",
-- --   -- number = "%d+", -- see issue #31
-- --   -- punctuation = "%f[^%s]" .. symbol .. "%f[%s]", -- punctuation surrounded by whitespace
-- --   -- punctuationAtStart = "^" .. symbol .. "%f[%s]",
-- --   -- punctuationAtEnd = "%f[^%s] " .. symbol .. "$",
-- --   -- onlyPunctuationLine = "^" .. symbol .. "$",
-- -- }
-- -- if not opts.skipInsignificantPunctuation then patterns.punctuation = "%p+" end
-- -- -- if not opts.skipInsignificantPunctuation then patterns.punctuation = "%p+" end
-- --
-- -- -- define motion properties
-- -- local backwards = (key == "b") or (key == "ge")
-- -- local endOfWord = (key == "ge") or (key == "e")
-- -- if backwards then
-- --   patterns.camelCaseWord = "[%l%d]+%u?" -- the other patterns are already symmetric
-- --   -- patterns.camelCaseWord = "[%l%d]+%u?" -- the other patterns are already symmetric
-- --   line = line:reverse()
-- --   endOfWord = not endOfWord
-- --   if col == -1 then
