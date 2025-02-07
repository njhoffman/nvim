-- No need to copy this inside `setup()`. Will be used automatically.
local defaults = {
	-- Each entry configures one operator.
	-- `prefix` defines keys mapped during `setup()`: in Normal mode
	-- to operate on textobject and line, in Visual - on selection.

	-- Evaluate text and replace with output
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

local cfg = {
	-- Each entry configures one operator. `prefix` defines keys mapped during `setup()`:
	-- in Normal mode to operate on textobject and line, in Visual - on selection.
	-- Evaluate text and replace with output
	evaluate = { prefix = "g=" },
	-- Exchange text regions
	exchange = { prefix = "gtx", reindent_linewise = true },
	-- Multiply (duplicate) text
	multiply = { prefix = "gtm", func = nil },
	-- Replace text with register
	replace = { prefix = "gtr", reindent_linewise = true },
	-- Sort text
	sort = { prefix = "gts" },
}

require("mini.operators").setup(cfg)
-- TODO: map shift/ctrl enter in visual mode
require("mapper").map({ "n", "x" }, "gtml", "<cmd>normal gtmm<cr>", { desc = "Multiply line" })
require("mapper").map({ "n", "x" }, "gtm<cr>", "<cmd>normal gtmm<cr>", { desc = "Multiply line" })
