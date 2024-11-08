local cfg = {
  headings = {
    -- NOTE: HelpviewHeading1, etc are assigned to the following groups
    -- DiagnosticOk, DiagnosticHint, DiagnosticInfo, Special
    -- in current colorscheme these are assigned to default colors
  },
  code_blocks = {
    hl = "CodeBlock", -- Highlight group for the code block
    -- enable = true,
    -- language_hl = "CodeLang"  -- Highlight group for the language name
  },
}

require("helpview").setup(cfg)

-- stylua: ignore
local default_cfg = {
  -- buftypes to ignore
  buf_ignore = {},
  -- Modes where the plugin is enabled
  modes = {},
  -- Modes where "hybrid_mode" is used
  hybrid_modes = {},
  -- Functions to call on various events
  callbacks = {
    -- When plugin is enabled
    on_enable = nil,
    -- When plugin is disabled
    on_disable = nil,

    -- When mode changes
    on_mode_change = nil,
  },
  -- Rendering configuration
  arguments = {
    enable = true,            -- For toggling this feature
    padding_left = "",        -- Padding for the left side
    padding_right = "",       -- Padding for the right side
    icon = "󰂖 ",              -- Icon to use
    hl = "Argument",          -- Highlight group
  },
  code_blocks = {
    enable = true,
    hl = "Code",              -- Highlight group for the code block
    language_hl = "CodeLang", -- Highlight group for the language name
  },
  group_names = {
    enable = true,
    padding_left = "",        -- Padding for the left side
    padding_right = "",       -- Padding for the right side
    icon = "󰏘 ",              -- Icon for the hl group name
  },
  headings = {
    enable = true,
    heading_1 = {},
    heading_2 = {},
    heading_3 = {},
    heading_4 = {},
    -- { hl = "H1", marker = "═", sign = " " }
  },
  horizontal_rules = {
    enable = true,
    parts = {},               -- parts can be either text or repeat
    -- { type = "text", text = "  ", hl = "Title" }
    -- { type = "simple", text = "•", repeat_amount = 10,
    --   direction = "left", hl = { "Gradient1", "Gradient2" } }
  },
	inline_codes = {
		enable = true,            -- For toggling this feature
		padding_left = " ",       -- Padding for the left side
		padding_right = " ",      -- Padding for the right side
		icon = "",                -- Icon to use
		hl = "InlineCode"         -- Highlight group
	},
  keycodes = {
    enable = true,            -- For toggling this feature
    padding_left = "",        -- Padding for the left side
    padding_right = "",       -- Padding for the right side
    icon = "󰌌 ",              -- Icon to use
    hl = "Special",           -- Highlight group
  },
  mention_links = {
    enable = true,            -- For toggling this feature
    padding_left = "",        -- Padding for the left side
    padding_right = "",       -- Padding for the right side
    icon = " ",              -- Icon to use
    hl = "Mentionlink",       -- Highlight group
  },
	modelines = {
		enable = true,           -- For toggling this feature
		style = "expanded",      -- Style of the modeline
		icon = " ",             -- Icon to use for the selector
		selector = ".vim",       -- Text to use as the selector
	},
	notes = {
		enable = true,            -- For toggling this feature
		-- Default configuration
		default = {
			padding_left = nil,
			padding_right = " ",
			icon = " ",
			hl = "@comment.note"
		},
		-- You can also use the notes text as the key to change it's configuration
		warning = {
			padding_left = " ",
			padding_right = " ",
			icon = " ",
			hl = "@comment.warn"
		}
	},
  option_links = {
		enable = true,            -- For toggling this feature
		padding_left = " ",       -- Padding for the left side
		padding_right = " ",      -- Padding for the right side
		icon = " ",              -- Icon to use
		hl = "Optionlink"         -- Highlight group
  },
	tag_links = {
		enable = true,            -- For toggling this feature
		padding_left = " ",       -- Padding for the left side
		padding_right = " ",      -- Padding for the right side
		icon = "",                -- Icon to use
		hl = "Taglink"            -- Highlight group
	},
	title = {
		style = "simple",         -- Name of the rendering style
		parts = {},               -- Parts of the border when style is
		hl = "Title",             -- Highlight group for the title
	}
}

-- 💻 Code blocks and Inline codes
--    HelpviewCode,                 background of code blocks. From Normal.
--    HelpviewCodeLanguage,         background for language names. From Comment.
-- 🔖 Headings
--    HelpviewHeading1,             from DiagnosticOk.
--    HelpviewHeading2,             from DiagnosticHint.
--    HelpviewHeading3,             from DiagnosticInfo.
--    HelpviewHeading4,             from Special.
-- 📏 Horizontal rules
--    HelpviewGradient1,            from Normal.
--    HelpviewGradient2,            from Tag
--      to HelpviewGradient10,      from Tag
-- 🤔 Others
--    HelpviewTaglink,              from Title.
--    HelpviewOptionlink,           from Tag.
--    HelpviewMentionlink,          from Title.
-- 📖 Title
--    HelpviewTitle,                from DiagnosticWarn.
