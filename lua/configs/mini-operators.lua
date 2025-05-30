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

-- TODO: map shift/ctrl enter in visual mode

-- require("mapper").map({ "n", "x" }, "gtml", "<cmd>normal gtmm<cr>", { desc = "Multiply line" })
-- require("mapper").map({ "n", "x" }, "gtm<cr>", "<cmd>normal gtmm<cr>", { desc = "Multiply line" })
-- local operators = require("mini.operators")

-- operators.setup({ replace = { prefix = "" } })
-- -- Make custom mappings
-- operators.make_mappings("replace", { textobject = "cr", line = "crr", selection = "cr" })
-- vim.keymap.set("n", "s", function()
-- return require("mini.operators").replace()
-- end, { expr = true, replace_keycodes = false, silent = true, desc = "Replace Operator" })
-- vim.keymap.set("n", "ss", "s_", { remap = true, silent = true, desc = "Replace Line" })
--     evaluate = { prefix = ",=" }, exchange = { prefix = "$", reindent_linewise = false, },
--     multiply = { prefix = "+" },
--     replace = { prefix = "R", reindent_linewise = false, },
--     sort = { prefix = ",s", },
--            { "s", desc = "󰅪 Substitute Operator" }, -- in visual mode, `s` surrounds
--            { "w", mode = { "n", "x" }, desc = "󰅪 Multiply Operator" },
--            { "sy", desc = "󰅪 Sort Operator" },
--            { "sx", desc = "󰅪 Exchange Operator" },
--            { "S", "s$", desc = "󰅪 Substitute to EoL", remap = true },
--            { "W", "w$", desc = "󰅪 Multiply to EoL", remap = true },
--    },
--    opts = {
--            evaluate = { prefix = "" }, -- disable
--            replace = { prefix = "s", reindent_linewise = true },
--            exchange = { prefix = "sx", reindent_linewise = true },
--            sort = { prefix = "sy" },
--            multiply = {
--                    prefix = "", -- set our own in `make_mappings`
--            },
