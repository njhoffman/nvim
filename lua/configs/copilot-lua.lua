local default_cfg = {
  panel = {
    enabled = true,
    auto_refresh = false,
    keymap = {
      jump_prev = '[[',
      jump_next = ']]',
      accept = '<CR>',
      refresh = 'gr',
      open = '<M-CR>',
    },
    layout = {
      position = 'bottom', -- | top | left | right
      ratio = 0.4,
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = false,
    debounce = 75,
    keymap = {
      accept = '<M-l>',
      accept_word = false,
      accept_line = false,
      next = '<M-]>',
      prev = '<M-[>',
      dismiss = '<C-]>',
    },
  },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ['.'] = false,
  },
  copilot_node_command = 'node', -- Node.js version must be > 16.x
  server_opts_overrides = {},
}

-- local opts = {
-- 	panel = {
-- 		enabled = false,
-- 		auto_refresh = true,
-- 		keymap = {
-- 			jump_prev = false,
-- 			jump_next = false,
-- 			accept = false,
-- 			refresh = false,
-- 			open = false,
-- 		},
-- 		layout = {
-- 			position = "bottom",
-- 			ratio = 0.4,
-- 		},
-- 	},
-- 	suggestion = {
-- 		enabled = true,
-- 		-- auto_trigger = false,
-- 		auto_trigger = true,
-- 		debounce = 75,
-- 		keymap = {
-- 			-- accept = "<S-Tab>",
-- 			accept = "<Tab>",
-- 			-- accept_line = "<M-o>",
-- 			accept_line = "<S-Tab>",
-- 			next = "<M-]>",
-- 			prev = "<M-[>",
-- 			-- dismiss = "<C-]>",
-- 			dismiss = "<M-o>",
-- 		},
-- 	},
-- 	filetypes = {
-- 		help = false,
-- 		gitcommit = false,
-- 		prompt = false,
-- 		TelescopePrompt = false,
-- 		DressingInput = false,
-- 		DressingSelect = false,
-- 		harpoon = false,
-- 		neorepl = false,
-- 		["dap-repl"] = false,
-- 		sh = function()
-- 			if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
-- 				return false
-- 			end
-- 			return true
-- 		end,
-- 		["."] = false,
-- 	},
-- 	copilot_node_command = "node",
-- 	server_opts_overrides = {},
-- }
require('copilot').setup({
  server_opts_overrides = {
    -- trace = 'verbose',
    settings = {
      advanced = {
        listCount = 10, -- #completions for panel
        inlineSuggestCount = 3, -- #completions for getCompletions
      },
    },
  },
  suggestion = { enabled = false },
  panel = { enabled = false },
})
