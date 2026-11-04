-- https://github.com/numToStr/Comment.nvim

local Comment = require("Comment")

local Op = require("Comment.opfunc")
require("configs.comment.opfunc").patch(Op)
local Utils = require("Comment.utils")
require("configs.comment.utils").patch(Utils)

local cfg = {
  ignore = "^$",
  toggler = {
    line = "gcc", -- [count]gcc
    block = "gcb", -- gbc
  },
  opleader = {
    line = "gc", -- normal and visual, gc[count]{motion}
    block = "gb", -- normal and visual, gb[count]{motion}
  },
  extra = { above = "gcO", below = "gco", eol = "gcA" },
  mappings = { basic = true, extra = true },
  -- recognize treesitter pattern of react components and use jsx style comment
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
}

Comment.setup(cfg)

local mapper = require("lib.mapper")
local setup_mappings = function()
  local api = require("Comment.api")
  local config = require("Comment.config"):get()

  -- Toggle current line (linewise) using C-/
  mapper.map("n", "<C-_>", api.toggle.linewise.current, { desc = "comment current line linewise" })

  -- Toggle current line (blockwise) using C-\
  -- vim.keymap.set('n', '<C-\\>', api.toggle.blockwise.current)

  -- Toggle lines (linewise) with dot-repeat support
  -- Example: <leader>gc3j will comment 4 lines
  mapper.map(
    "n",
    "<leader>gc",
    api.call("toggle.linewise", "g@"),
    { expr = true, desc = "comment lines linewise (.)" }
  )

  -- Toggle lines (blockwise) with dot-repeat support
  -- Example: <leader>gb3j will comment 4 lines
  mapper.map(
    "n",
    "<leader>gb",
    api.call("toggle.blockwise", "g@"),
    { expr = true, desc = "comment lines block  (.)" }
  )

  local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)

  -- Toggle selection (linewise)
  mapper.map("x", "<leader>c", function()
    vim.api.nvim_feedkeys(esc, "nx", false)
    api.toggle.linewise(vim.fn.visualmode())
  end, { desc = "comment linewise toggle selection" })

  -- Toggle selection (blockwise)
  mapper.map("x", "<leader>b", function()
    vim.api.nvim_feedkeys(esc, "nx", false)
    api.toggle.blockwise(vim.fn.visualmode())
  end, { desc = "comment block toggle selection" })
  mapper.map(
    "i",
    "<M-?>",
    '<c-o>:execute "normal \\<Plug>(comment_toggle_linewise_current)"<cr>',
    { desc = "comment toggle insert" }
  )
end

setup_mappings()
