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

local mapper = require("mapper")
local setup_mappings = function()
  local api = require("Comment.api")
  local config = require("Comment.config"):get()
  -- api.toggle.linewise(motion, config?)
  -- api.toggle.linewise.current(motion?, config?)
  -- api.toggle.linewise.count(count, config?)
  -- api.toggle.blockwise(motion, config?)
  -- api.toggle.blockwise.current(motion?, config?)
  -- api.toggle.blockwise.count(count, config?)

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
  vim.keymap.set(
    "i",
    "<M-?>",
    '<c-o>:execute "normal \\<Plug>(comment_toggle_linewise_current)"<cr>',
    { noremap = true, desc = "comment toggle insert" }
  )
end

setup_mappings()

--  if cfg.mappings then
--      local K = vim.keymap.set
--      -- Basic Mappings
--      if cfg.mappings.basic then
--          -- NORMAL mode mappings
--          K('n',
--              cfg.toggler.line,
--              "v:count == 0 ? '<Plug>(comment_toggle_current_linewise)' : '<Plug>(comment_toggle_linewise_count)'",
--              { expr = true, remap = true })
--          K( 'n',
--              cfg.toggler.block,
--              "v:count == 0 ? '<Plug>(comment_toggle_current_blockwise)' : '<Plug>(comment_toggle_blockwise_count)'",
--              { expr = true, remap = true })
--
--          K('n', cfg.opleader.line, '<Plug>(comment_toggle_linewise)')
--          K('n', cfg.opleader.block, '<Plug>(comment_toggle_blockwise)')
--
--          -- VISUAL mode mappings
--          K('x', cfg.opleader.line, '<Plug>(comment_toggle_linewise_visual)')
--          K('x', cfg.opleader.block, '<Plug>(comment_toggle_blockwise_visual)')
--      end
--
--      -- Extra Mappings
--      if cfg.mappings.extra then
--          K('n', cfg.extra.below, '<CMD>lua require("Comment.api").locked.insert_linewise_below()<CR>')
--          K('n', cfg.extra.above, '<CMD>lua require("Comment.api").locked.insert_linewise_above()<CR>')
--          K('n', cfg.extra.eol, '<CMD>lua require("Comment.api").locked.insert_linewise_eol()<CR>')
--      end
--
--      -- Extended Mappings
--      if cfg.mappings.extended then
--          -- NORMAL mode extended
--          K('n', 'g>', '<CMD>lua require("Comment.api").call("comment_linewise_op")<CR>g@')
--          K('n', 'g>c', '<CMD>lua require("Comment.api").call("comment_current_linewise_op")<CR>g@$')
--          K('n', 'g>b', '<CMD>lua require("Comment.api").call("comment_current_blockwise_op")<CR>g@$')
--
--          K('n', 'g<', '<CMD>lua require("Comment.api").call("uncomment_linewise_op")<CR>g@')
--          K('n', 'g<c', '<CMD>lua require("Comment.api").call("uncomment_current_linewise_op")<CR>g@$')
--          K('n', 'g<b', '<CMD>lua require("Comment.api").call("uncomment_current_blockwise_op")<CR>g@$')
--
--          -- VISUAL mode extended
--          K('x', 'g>', '<ESC><CMD>lua require("Comment.api").locked.comment_linewise_op(vim.fn.visualmode())<CR>')
--          K('x', 'g<', '<ESC><CMD>lua require("Comment.api").locked.uncomment_linewise_op(vim.fn.visualmode())<CR>')
--      end
--  end
