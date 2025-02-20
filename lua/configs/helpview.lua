-- arguments = {},          -- {arg}
-- 	highlight_groups = {},        -- $Group$
-- 	inline_codes = {},       -- `code`
-- 	taglinks = {},      -- |link|
-- 	optionlinks = {},       -- 'option'
-- 	taglinks = {},          -- <tag>
-- 	title = {}

local cfg = {
  preview = {
    -- hybrid_modes = { "n", "s", "v" },
    modes = { "n", "s", "c", "x", "v", "V", "" },
  },
  vimdoc = {
    optionlinks = {
      enable = true,
      default = {
        padding_left = "",
        padding_right = "",
        -- icon = " ",
        hl = "Optionlink", -- Highlight group
        -- hl = "HelpviewOptionLink",
      },
    },
    inline_codes = {
      enable = true,
      padding_left = "",
      padding_right = "",
      icon = "",
      hl = "InlineCode",
    },
    keycodes = {
      enable = true, -- For toggling this feature
      default = {
        hl = "Keycode", -- Highlight group
        icon = "",
      },
    },
    arguments = {
      enable = true,
      default = {
        icon = " ",
        hl = "@variable.parameter.vimdoc",
      },
    },
    taglinks = {
      default = {
        enable = true, -- For} toggling this feature
        padding_left = "", -- Padding for the left side
        padding_right = "", -- Padding for the right side
        icon = " ", -- Icon to use
        hl = "Mentionlink", -- Highlight group
      },
    },
    code_blocks = {
      enable = true,
      -- border_hl = "Code",
      default = {
        block_hl = "HelpviewCode",
        -- language_hl = "HelpviewCodeLanguage",
        -- language_hl = "Comment",
      },
    },
    headings = {
      -- ● ○ ◆ ◇
      heading_1 = { style = "simple", hl = "Heading1", marker = "═", sign = "◆" },
      heading_2 = { style = "simple", hl = "Heading2", marker = "─", sign = "◇" },
      heading_3 = { style = "simple", hl = "Heading3", sign = "" },
      heading_4 = { style = "simple", hl = "Heading4", sign = "" },
    },
    notes = {
      default = { padding_right = " ", icon = " ", hl = "@comment.note" },
      warning = { padding_right = " ", icon = "   ", hl = "@comment.warning" },
      deprecated = { padding_right = " ", icon = "  ", hl = "@comment.error" },
    },
  },
}

require("helpview").setup()
