---@alias lc.lang
---| "cpp"
---| "java"
---| "python"
---| "python3"
---| "c"
---| "csharp"
---| "javascript"
---| "typescript"
---| "php"
---| "swift"
---| "kotlin"
---| "dart"
---| "golang"
---| "ruby"
---| "scala"
---| "rust"
---| "racket"
---| "erlang"
---| "elixir"
---| "bash"
---| "html"
---| "pythonml"
---| "react"
---| "vanillajs"

---@alias lc.hook
---| "LeetEnter"
---| "LeetQuestionNew"

---@alias lc.size
---| string
---| number
---| { width: string | number, height: string | number }

---@alias lc.position "top" | "right" | "bottom" | "left"

---@alias lc.direction "col" | "row"

---@class lc.UserConfig
local default_config = {
  ---@type string
  arg = 'leetcode.nvim',

  ---@type lc.lang
  lang = 'cpp',

  cn = { -- leetcode.cn
    enabled = false, ---@type boolean
    translator = true, ---@type boolean
    translate_problems = true, ---@type boolean
  },

  ---@type string
  directory = vim.fn.stdpath('data') .. '/leetcode/',

  ---@type boolean
  logging = true,

  cache = {
    update_interval = 60 * 60 * 24 * 7, ---@type integer 7 days
  },

  console = {
    open_on_runcode = true, ---@type boolean

    dir = 'row', ---@type lc.direction

    size = { ---@type lc.size
      width = '90%',
      height = '75%',
    },

    result = {
      size = '60%', ---@type lc.size
    },

    testcase = {
      virt_text = true, ---@type boolean

      size = '40%', ---@type lc.size
    },
  },

  description = {
    position = 'left', ---@type lc.position

    width = '40%', ---@type lc.size

    show_stats = true, ---@type boolean
  },

  hooks = {
    ---@type fun()[]
    LeetEnter = {},

    ---@type fun(question: { lang: string })[]
    LeetQuestionNew = {},
  },

  ---@type boolean
  image_support = false, -- setting this to `true` will disable question description wrap
}

local leet_arg = 'leetcode.nvim'
local cfg = {
  ---@type lc.lang
  lang = 'javascript',
  lazy = leet_arg ~= vim.fn.argv()[1],
  opts = {
    arg = leet_arg,
  },
}

require('leetcode').setup(cfg)

-- Leet opens menu dashboard
-- menu same as Leet
-- console opens console pop-up for currently opened question
-- info opens a pop-up containing information about the currently opened question
-- tabs opens a picker with all currently opened question tabs
-- lang opens a picker to change the language of the current question
-- run run currently opened question
-- test same as Leet run
-- submit submit currently opened question
-- random opens a random question
-- daily opens the question of today
-- list opens a problemlist picker
-- desc toggle question description
--   toggle same as Leet desc
--   stats toggle description stats visibility
-- cookie
--   update opens a prompt to enter a new cookie
--   delete sign-out
-- cache
--   update updates cache
-- Leet list
-- Can take optional arguments. To stack argument values separate them by a ,
-- Leet list status=<status> difficulty=<difficulty>

--
-- This plugin is meant to be used within a fresh Neovim instance. Meaning that to launch leetcode.nvim you have to pass arg as the first and only Neovim argument
-- nvim leetcode.nvim
-- To switch between questions, use Leet tabs
