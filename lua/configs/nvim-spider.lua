require('spider').setup({
  skipInsignificantPunctuation = true,
  subwordMovement = true,
})

local mapper = require('mapper')
local spider_map = function(modes, key, cmd_key, opts, flags)
  -- NOTE: for dot repeat to work, must be in form of Ex-commands
  mapper.map(
    modes,
    key,
    "<cmd>lua require('spider').motion('" .. cmd_key .. "')<CR>",
    vim.tbl_extend('force', {
      desc = '󱇫 spider-' .. cmd_key .. ' motion',
      silent = true,
      category = 'Motion',
      plugin = 'nvim-spider',
    }, opts or {})
  )
end

-- skipInsignificantPunctuation = true for operators
-- cw and dw: Spider should remove the word up to, but not including, the punctuation when using cw on the last word of the last line.
-- map('n', 'w', spider.word({ 'subWord', 'punctuation' })_
--  map({'o', 'x'}, 'w', spider.word({ 'subWord' })
-- ")", "g)", "(", "g(",
-- im.keymap.set({ "n", "o", "x" }, "W", "w", { desc = "Normal w" }
-- { "zw", "<cmd>lua require('spider').motion('w')<CR>", mode = "o", desc = "Spider-w" },
-- { "ze", "<cmd>lua require('spider').motion('e')<CR>", mode = "o", desc = "Spider-e" },
-- { "zb", "<cmd>lua require('spider').motion('b')<CR>", mode = "o", desc = "Spider-b" },
-- spider_key("H", "b"),
-- spider_key("L", "w"),
spider_map({ 'n', 'o', 'x' }, 'w', 'w')
spider_map({ 'n', 'o', 'x' }, 'e', 'e') -- d
spider_map({ 'n', 'o', 'x' }, 'b', 'b')
spider_map({ 'n', 'o', 'x' }, 'ge', 'ge')
-- vim.keymap.set({ "n", "o", "x" }, 'dw', 'de', { remap = true, desc = '󱇫 spider-de motion (dw remap fix)' })
-- vim.keymap.set({ "n", "o", "x" }, 'cw', 'ce', { remap = true, desc = '󱇫 spider-ce motion (cw remap fix)' })
vim.keymap.set({ 'n' }, 'dw', 'de', { remap = true, desc = '󱇫 spider-de motion (dw remap fix)' })
vim.keymap.set({ 'n' }, 'cw', 'ce', { remap = true, desc = '󱇫 spider-ce motion (cw remap fix)' })
-- vim.keymap.set("o", "w", "<cmd>lua require('spider').motion('w')<CR>"

-- For a version of iw that considers camelCase, check out the subword text object of nvim-various-textobjs.

vim.keymap.set(
  'i',
  '<C-f>',
  "<Esc>l<cmd>lua require('spider').motion('w')<CR>i",
  { desc = '󱇫 spider-w insert motion' }
)

vim.keymap.set(
  'i',
  '<C-b>',
  "<Esc><cmd>lua require('spider').motion('b')<CR>i",
  { desc = '󱇫 spider-b insert motion' }
)
-- delete subword before cursor
-- vim.keymap.set('i', '<C-w>', '<Esc>cvb', { remap = true })
vim.keymap.set('i', '<C-w>', '<Esc>cb')

-- jump to next bracket (add line 78)
-- braces = "%f[%[%]{}()]",

-- keymap(nxo, 'w', function()
--   require('spider').motion('w', { skipInsignificantPunctuation = false })
-- end, 'Spider-w')

-- "<leader>uS",
-- function()
--   skipInsignificantPunctuation = not skipInsignificantPunctuation
--   if skipInsignificantPunctuation then
--     require("lazy.core.util").info("Enabled Spider", { title = "Spider" })
--   else
--     require("lazy.core.util").warn("Disabled Spider", { title = "Spider" })
--   end
-- end,
-- desc = "Toggle Spider",
-- {
--   "w",
--   function()
--     require("spider").motion("w", { skipInsignificantPunctuation = false })
--   end,
--   mode = { "n", "o", "x" },
-- },
-- {
--   "W",
--   function()
--     require("spider").motion("w", { subwordMovement = false })
--   end,
--   mode = { "n", "o", "x" },
-- },
-- {
--   "e",
--   function()
--     require("spider").motion("e", { skipInsignificantPunctuation = false })
--   end,
--   mode = { "n", "o", "x" },
-- },
-- {
--   "E",
--   function()
--     require("spider").motion("e", { subwordMovement = false })
--   end,
--   mode = { "n", "o", "x" },
-- },
-- {
--   "b",
--   function()
--     require("spider").motion("b", { skipInsignificantPunctuation = false })
--   end,
--   mode = { "n", "o", "x" },
-- },
-- {
--   "B",
--   function()
--     require("spider").motion("b", { subwordMovement = false })
--   end,
--   mode = { "n", "o", "x" },
-- },
-- {
--   "cw",
--   "c<cmd>lua require('spider').motion('e', { skipInsignificantPunctuation = false })<CR>",
--   mode = { "n" },
-- },
-- {
--   "cW",
--   "c<cmd>lua require('spider').motion('e', { subwordMovement = false })<CR>",
--   mode = { "n" },
-- },
-- {
--   "ce",
--   "c<cmd>lua require('spider').motion('e', { skipInsignificantPunctuation = false })<CR>",
--   mode = { "n" },
-- },
-- {
--   "cE",
--   "c<cmd>lua require('spider').motion('e', { subwordMovement = false })<CR>",
--   mode = { "n" },
-- },

-- mapper.map({ 'n', 'o', 'x' }, 'w', function()
--   require('spider').motion('w', {
--     customPatterns = {
--       patterns = { ('%x'):rep(6) .. '+' },
--       overrideDefault = true,
--     },
--   })
-- end)

-- positions vim's `w` will move to
-- if foo:find("%d") and foo == bar then print("[foo] has" .. bar) end
-- ^  ^^   ^  ^^  ^   ^   ^  ^   ^    ^    ^  ^  ^ ^  ^ ^  ^  ^ ^  -> 21
-- positions spider's `w` will move to
-- if foo:find("%d") and foo == bar then print("[foo] has" .. bar) end
-- ^   ^      ^   ^   ^   ^  ^   ^    ^       ^    ^    ^  ^    ^  -> 14
-- - The motion stops only at numbers.
-- require("spider").motion("w", {
--   customPatterns = { "%d+" },
-- })

-- -- The motion stops at only at words with at least 3 chars or at any punctuation.
-- -- (Lua patterns have no quantifier like `{3,}`, thus the repetition.)
-- require("spider").motion("w", {
--   customPatterns = { "%w%w%w+", "%p+" },
-- })

-- -- The motion stops only at hashes like `ef82a2`, avoiding repetition by using
-- -- `string.rep()`.
-- -- Extend default patterns by passing a `patterns` table and
-- -- setting `overrideDefault` to false.
-- require("spider").motion("w", {
--   customPatterns = {
--     patterns = {
--       ("%x"):rep(6) .. "+" },
--     },
--     overrideDefault = false,
-- })

-- -- The motion stops at the next declaration of a variable in -- javascript.
-- -- (The `e` motion combined with the `.` matching any character in
-- -- lua patterns ensures that you stop at beginning of the variable name.)
-- require("spider").motion("e", {
--   customPatterns = { "const .", "let .", "var ." },
-- })

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
