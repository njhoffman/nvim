local default_values = {
	on_substitute = nil,
	yank_substituted_text = false,
	preserve_cursor_position = false,
	modifiers = nil,
	highlight_substituted_text = {
		enabled = true,
		timer = 500,
	},
	range = {
		prefix = "s",
		prompt_current_text = false,
		confirm = false,
		complete_word = false,
		subject = nil,
		range = nil,
		group_substituted_text = false,
		suffix = "",
		auto_apply = false,
		cursor_position = "end",
	},
	exchange = {
		motion = nil,
		use_esc_to_cancel = true,
		preserve_cursor_position = false,
	},
}
-- ["x]S			Delete [count] lines [into register x] and start insert.  Synonym for "cc" |linewise|.
-- replace:  Siw replaces the current word with "+" register
-- exchange: Sxiw (move) Sxiw (or .)
--           cxw (move) cxw (or .)
--           (visual) X (move) (visual) X

require("substitute").setup {
	-- on_substitute = require("yanky.integration").substitute(),
	-- highlight_substituted_text = { timer = 400 },
	on_substitute = function(event)
		local yanky = require("yanky")
		local is_visual = require("substitute.utils").is_visual(event.vmode)
		yanky.init_ring("p", event.register, event.count, is_visual)
		return require("tiny-glimmer.support.substitute").substitute_cb(event)
	end,
	highlight_substituted_text = {
		enabled = false,
	},
	range = { prefix = "S" },
	yank_substituted_text = false,
	exchange = {
		preserve_cursor_position = false,
	},
}

local function setup_keymaps()
	local sub = require("substitute")
	local subrange = require("substitute.range")
	local subex = require("substitute.exchange")
	local map = vim.keymap.set

	local subop = function(...)
		require("reactive").set_opfunc("S")
		sub.operator(...)
	end

  -- stylua: ignore
  map('n', 'S', sub.operator, { noremap = true, desc = '  substitute operator' })
	map("n", "S^", sub.line, { noremap = true, desc = "  substitute line" })
	map("n", "S$", sub.eol, { noremap = true, desc = "  substitute eol" })
	map("x", "S", sub.visual, { noremap = true, desc = "  substitute visual" })
	map("x", "p", sub.visual, { noremap = true })
	map("x", "P", sub.visual, { noremap = true })
	map("n", "<leader>sy", sub.line, { noremap = true, desc = "  substitute line" })

	-- map('n', 'Sxc', subex.cancel, { noremap = true })
	-- map('n', 'Sx', subex.operator, { noremap = true })
	-- map('n', 'Sxx', subex.line, { noremap = true })
	map("n", "cx", subex.operator, { noremap = true, desc = "  substitute exchange operator" })
	map("x", "cx", subex.visual, { noremap = true, desc = "  substitute exchange visual" })
	map("n", "X", subex.operator, { noremap = true, desc = "  substitute exchange operator" })
	map("x", "X", subex.visual, { noremap = true, desc = "  substitute exchange visual" })
	map("n", "cxc", subex.cancel, { noremap = true, desc = "  substitute exchange cancel" })
	map("n", "cxl", subex.line, { noremap = true, desc = "  substitute exchange line" })

	map(
		"n",
		"<leader>s",
		function() subrange.operator { prefix = "S" } end,
		{ noremap = true, desc = "  substitute range operator" }
	)

	map(
		"x",
		"<leader>s",
		function() subrange.visual { prefix = "S" } end,
		{ noremap = true, desc = "  substitute range visual" }
	)

	map(
		"n",
		"<leader>ss",
		function() subrange.word { prefix = "S" } end,
		{ noremap = true, desc = "  substitute range word" }
	)
end

setup_keymaps()

-- vim.keymap.set("n", "s", require('substitute').operator, { noremap = true })
-- vim.keymap.set("n", "ss", require('substitute').line, { noremap = true })
-- vim.keymap.set("n", "S", require('substitute').eol, { noremap = true })
-- vim.keymap.set("x", "s", require('substitute').visual, { noremap = true })

-- vim.keymap.set("n", "<leader>s", require('substitute.range').operator, { noremap = true })
-- vim.keymap.set("x", "<leader>s", require('substitute.range').visual, { noremap = true })
-- vim.keymap.set("n", "<leader>ss", require('substitute.range').word, { noremap = true })

-- exchange operator
-- vim.keymap.set("x", "X", require('substitute.exchange').visual, { noremap = true })
