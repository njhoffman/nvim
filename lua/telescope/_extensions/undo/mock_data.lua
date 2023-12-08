-- @    [6] 21 mins ago
-- |
-- | w  [5] 22 mins ago
-- | |
-- | w  [4] 22 mins ago
-- |/
-- w    [3] 22 mins ago
-- |
-- o    [2] 22 mins ago
-- |
-- o    [1] 22 mins ago
-- |
-- o    [0] Original

--    (-1) [6] 34 minutes ago          (+2 -1)   [1]
-- ╶┘   (-1) [5] 34 minutes ago      ┆   (+1 -1) [2]
-- ┤   (-1) [4] 34 minutes ago       ┆   (-1)    [3]
--    (-1) [3] 35 minutes ago         ┘ (-1)     [4]
--    (-1) [2] 35 minutes ago          (-1)      [5]
--    (+4) [1] 35 minutes ago          (+4)      [6]
-- ┤│├ ┆ ─ ╴╶ ╴╶ -- ─ └ ┘┴╰ ╯ ┐┌ ┌╶┐┬ ┌ ┬   
--      (+7)  [1]  4 hours ago
-- ├─   (-3)  [2]  4 hours ago
-- └─   (+2)  [3]  4 hours ago

local undolist = {
  [1] = {
    additions = {
      [1] = "local file_pfx = string.gsub(vim.fn.stdpath('config') .. '/', os.getenv('HOME') .. '/', '')",
      [2] = "vim.dbglog('hi')",
    },
    alt = 0,
    bufnr = 328,
    deletions = {
      [1] = "local file_pfx = string.gsub(vim.fn.stdpath('config') .. '/', os.getenv('HOME') .. '/', '')",
    },
    diff = "--- scratch/tmp6.lua\
+++ scratch/tmp6.lua\
@@ -2 +2,2 @@\
-local file_pfx = string.gsub(vim.fn.stdpath('config') .. '/', os.getenv('HOME') .. '/', '')\
+local file_pfx = string.gsub(vim.fn.stdpath('config') .. '/', os.getenv('HOME') .. '/', '')\
+vim.dbglog('hi')\
",
    first = true,
    ordinal = "local file_pfx = string.gsub(vim.fn.stdpath('config') .. '/', os.getenv('HOME') .. '/', '')local file_pfx = string.gsub(vim.fn.stdpath('config') .. '/', os.getenv('HOME') .. '/', '')vim.dbglog('hi')",
    seq = 6,
    save = 5,
    time = 1701975302,
  },
  [2] = {
    additions = {
      [1] = "vim.dbglog('HEY')",
    },
    alt = 1,
    bufnr = 328,
    deletions = {
      [1] = 'vim.dbglog("HEY")',
    },
    diff = '--- scratch/tmp6.lua\
+++ scratch/tmp6.lua\
@@ -3 +3 @@\
-vim.dbglog("HEY")\
+vim.dbglog(\'HEY\')\
',
    first = true,
    ordinal = 'vim.dbglog("HEY")vim.dbglog(\'HEY\')',
    seq = 5,
    save = 3,
    time = 1701975293,
  },
  [3] = {
    additions = {
      [1] = "local file_pfx = string.gsub(vim.fn.stdpath('config') .. '/', os.getenv('HOME') .. '/', '')",
      [2] = 'vim.dbglog("HEY")',
    },
    alt = 1,
    bufnr = 328,
    deletions = {
      [1] = "local file_pfx = string.gsub(vim.fn.stdpath('config') .. '/', os.getenv('HOME') .. '/', '')",
    },
    diff = "--- scratch/tmp6.lua\
+++ scratch/tmp6.lua\
@@ -2 +2,2 @@\
-local file_pfx = string.gsub(vim.fn.stdpath('config') .. '/', os.getenv('HOME') .. '/', '')\
+local file_pfx = string.gsub(vim.fn.stdpath('config') .. '/', os.getenv('HOME') .. '/', '')\
+vim.dbglog(\"HEY\")\
",
    first = false,
    ordinal = "local file_pfx = string.gsub(vim.fn.stdpath('config') .. '/', os.getenv('HOME') .. '/', '')local file_pfx = string.gsub(vim.fn.stdpath('config') .. '/', os.getenv('HOME') .. '/', '')vim.dbglog(\"HEY\")",
    seq = 4,
    save = 2,
    time = 1701975286,
  },
  [4] = {
    additions = {},
    alt = 0,
    bufnr = 328,
    deletions = {
      [1] = '',
    },
    diff = '--- scratch/tmp6.lua\
+++ scratch/tmp6.lua\
@@ -2 +1,0 @@\
-\
',
    first = false,
    ordinal = '',
    seq = 3,
    save = 4,
    time = 1701975262,
  },
  [5] = {
    additions = {},
    alt = 0,
    bufnr = 328,
    deletions = {
      [1] = '',
    },
    diff = '--- scratch/tmp6.lua\
+++ scratch/tmp6.lua\
@@ -1 +0,0 @@\
-\
',
    first = false,
    ordinal = '',
    seq = 2,
    time = 1701975261,
  },
  [6] = {
    additions = {
      [1] = '',
      [2] = "local utils = require('notify.util.render')",
      [3] = '',
      [4] = "local file_pfx = string.gsub(vim.fn.stdpath('config') .. '/', os.getenv('HOME') .. '/', '')",
    },
    alt = 0,
    bufnr = 328,
    deletions = {},
    diff = "--- scratch/tmp6.lua\
+++ scratch/tmp6.lua\
@@ -0,0 +1,4 @@\
+\
+local utils = require('notify.util.render')\
+\
+local file_pfx = string.gsub(vim.fn.stdpath('config') .. '/', os.getenv('HOME') .. '/', '')\
",
    first = false,
    ordinal = "local utils = require('notify.util.render')local file_pfx = string.gsub(vim.fn.stdpath('config') .. '/', os.getenv('HOME') .. '/', '')",
    seq = 1,
    time = 1701975257,
  },
}
return undolist
