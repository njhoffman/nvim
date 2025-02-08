-- arguments = {},          -- {arg}
-- 	highlight_groups = {},        -- $Group$
-- 	inline_codes = {},       -- `code`
-- 	keycodes = {},           -- <ESC>
-- 	taglinks = {},      -- |link|
-- 	modelines = {},          -- vim:
-- 	notes = {},              -- Note:
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

-- local deafult = {
--   renderers = {},
--   preview = {
--     enable = true,
--     enable_hybrid_mode = true,

--     modes = { "n", "c", "no" },
--     hybrid_modes = {},
--     linewise_hybrid_mode = false,

--     filetypes = { "help" },
--     ignore_previews = {},
--     ignore_buftypes = {},
--     condition = nil,

--     max_buf_lines = 500,
--     draw_range = { 2 * vim.o.lines, 2 * vim.o.lines },
--     edit_range = { 0, 0 },

--     debounce = 150,
--     callbacks = {},

--     icon_provider = "internal",

--     splitview_winopts = { split = "right" },
--     preview_winopts = { width = math.floor(80) },
--   },
--   vimdoc = {
--     arguments = {
--       enable = true,

--       default = {
--         hl = "Argument",
--         padding_left = " ",
--         padding_right = " ",
--       },
--     },

--     code_blocks = {
--       enable = true,

--       border_hl = "Code",

--       default = { block_hl = "HelpviewCode" },

--       ["diff"] = {
--         block_hl = function(_, line)
--           if line:match("^%s*%+") then
--             return "HelpviewPalette4"
--           elseif line:match("^%s*%-") then
--             return "HelpviewPalette1"
--           else
--             return "HelpviewCode"
--           end
--         end,
--       },
--     },

--     headings = {
--       enable = true,

--       heading_1 = {
--         sign = " ⣾⣿⠛⣿⣷ ",
--         sign_hl = "Palette1Inv",

--         marker_hl = "Palette1Bg",

--         hl = "Palette1Fg",
--       },

--       heading_2 = {
--         sign = " ⣠⠞⠛⠳⣄ ",
--         sign_hl = "Palette2Inv",

--         marker_hl = "Palette2",
--         hl = "Palette2Fg",
--       },

--       heading_3 = {
--         sign = " ⣯⣤⠛⣤⣽ ",
--         sign_hl = "Palette3Inv",

--         marker_hl = "Palette3",
--         hl = "Palette3",
--       },

--       heading_4 = {
--         sign = " ⠓⣠⣿⣄⠚ ",
--         sign_hl = "Palette4Inv",

--         marker_hl = "Palette4",
--         hl = "Palette4",
--       },
--     },

--     highlight_groups = {
--       enable = true,
--     },
--     horizontal_rules = {
--       parts = {
--         {
--           type = "repeating",
--           repeat_amount = function(buffer)
--             return math.ceil((vim.bo[buffer].tw - 3) / 2)
--           end,

--           text = "─",
--           hl = {
--             "HelpviewGradient1",
--             "HelpviewGradient1",
--             "HelpviewGradient2",
--             "HelpviewGradient2",
--             "HelpviewGradient3",
--             "HelpviewGradient3",
--             "HelpviewGradient4",
--             "HelpviewGradient4",
--             "HelpviewGradient5",
--             "HelpviewGradient5",
--             "HelpviewGradient6",
--             "HelpviewGradient6",
--             "HelpviewGradient7",
--             "HelpviewGradient7",
--             "HelpviewGradient8",
--             "HelpviewGradient8",
--             "HelpviewGradient8",
--             "HelpviewGradient8",
--           },
--         },
--         {
--           type = "text",
--           text = " ◈ ",
--         },
--         {
--           type = "repeating",
--           repeat_amount = function(buffer)
--             return math.floor((vim.bo[buffer].tw - 3) / 2)
--           end,
--           direction = "right",

--           text = "─",
--           hl = {
--             "HelpviewGradient1",
--             "HelpviewGradient1",
--             "HelpviewGradient2",
--             "HelpviewGradient2",
--             "HelpviewGradient3",
--             "HelpviewGradient3",
--             "HelpviewGradient4",
--             "HelpviewGradient4",
--             "HelpviewGradient5",
--             "HelpviewGradient5",
--             "HelpviewGradient6",
--             "HelpviewGradient6",
--             "HelpviewGradient7",
--             "HelpviewGradient7",
--             "HelpviewGradient8",
--             "HelpviewGradient8",
--             "HelpviewGradient8",
--             "HelpviewGradient8",
--           },
--         },
--       },
--     },

--     inline_codes = {
--       enable = true,

--       hl = "Palette5",

--       padding_left = " ",
--       padding_right = " ",
--     },

--     keycodes = {
--       enable = true,

--       default = {
--         hl = "Keycode",

--         padding_left = " ",
--         padding_right = " ",
--       },
--     },

--     modelines = {
--       enable = true,

--       border = "─",
--       border_hl = "@text.todo.unchecked",

--       data_types = {
--         ["nil"] = { value_hl = "@constant.builtin" },
--         ["string"] = { value_hl = "String" },
--         ["number"] = { value_hl = "Number" },
--         ["boolean"] = { value_hl = "Boolean" },
--       },

--       default = {
--         option_hl = "@property",
--         value_hl = "Comment",
--       },
--     },

--     notes = {
--       enable = true,

--       default = {
--         hl = "Palette5Inv",
--         padding_left = " ",
--         padding_right = " ",
--       },

--       ["[dD]eprecated"] = {
--         hl = "Palette1Inv",
--       },

--       ["[wW]arning"] = {
--         hl = "Palette3Inv",
--       },
--     },

--     optionlinks = {
--       enable = true,

--       default = {
--         hl = "Optionlink",
--         padding_left = " ",
--         padding_right = " ",
--       },
--     },

--     tags = {
--       enable = true,

--       default = {
--         hl = "Tag",

--         padding_left = " ",
--         padding_right = " ",
--       },

--       ["%.txt$"] = {
--         hl = "Palette3",
--       },
--     },

--     taglinks = {
--       enable = true,

--       default = {
--         hl = "Taglink",

--         padding_left = " ",
--         padding_right = " ",
--       },
--     },
--     urls = {
--       enable = true,

--       default = {
--         icon = "󰌷 ",
--         hl = "@string.special.url.vimdoc",
--       },

--       ---+${lua, Github sites}

--       ["github%.com/[%a%d%-%_%.]+%/?$"] = {
--         --- github.com/<user>
--         icon = " ",
--         hl = "HelpviewPalette0Fg",

--         text = function(_, item)
--           return string.match(item.label, "github%.com/([%a%d%-%_%.]+)%/?$")
--         end,
--       },
--     },
--   },
-- }
