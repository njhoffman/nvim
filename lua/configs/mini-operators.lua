local sort_func = function(content)
  local opts = {}
  if content.submode == "v" then
    -- Ask for delimiter to be treated as is (not as Lua pattern)
    local delimiter = vim.fn.input("Sort delimiter: ")
    -- Treat surrounding whitespace as part of split
    opts.split_patterns = { "%s*" .. vim.pesc(delimiter) .. "%s*" }
  end
  return MiniOperators.default_sort_func(content, opts)
end

local cfg = {
  -- exchange = { prefix = "gtx", reindent_linewise = true },
  evaluate = { prefix = "gh=" },
  exchange = { prefix = "", reindent_linewise = true }, -- gx
  multiply = { prefix = "gm", func = nil },
  replace = { prefix = "cr", reindent_linewise = true },
  sort = { prefix = "gts" },
}

require("mini.operators").setup(cfg)

local defaults = {
  -- Each entry configures one operator.
  -- `prefix` defines keys mapped during `setup()`: in Normal mode
  -- to operate on textobject and line, in Visual - on selection.
  evaluate = {
    prefix = "g=",
    -- Function which does the evaluation
    func = nil,
  },
  -- Exchange text regions
  exchange = {
    prefix = "gx",
    -- Whether to reindent new text to match previous indent
    reindent_linewise = true,
  },
  -- Multiply (duplicate) text
  multiply = {
    prefix = "gm",
    -- Function which can modify text before multiplying
    func = nil,
  },
  -- Replace text with register
  replace = {
    prefix = "gr",
    -- Whether to reindent new text to match previous indent
    reindent_linewise = true,
  },
  -- Sort text
  sort = {
    prefix = "gs",
    -- Function which does the sort
    func = nil,
  },
}


-- require("lib.mapper").map({ "n", "x" }, "gtml", "<cmd>normal gtmm<cr>", { desc = "Multiply line" })
-- require("lib.mapper").map({ "n", "x" }, "gtm<cr>", "<cmd>normal gtmm<cr>", { desc = "Multiply line" })
-- local operators = require("mini.operators")
