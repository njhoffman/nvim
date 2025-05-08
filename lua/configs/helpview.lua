local cfg = {
  preview = {
    -- enable = true,
    modes = { "n", "no", "s", "c", "x", "v", "V", "" },
    enable_hybrid_mode = true,
    hybrid_modes = {},
    linewise_hybrid_mode = false,
    -- filetypes = { "help" },
    -- ignore_previews = {},
    -- ignore_buftypes = {},
    -- condition = nil,

    --   draw_range = { 2 * vim.o.lines, 2 * vim.o.lines },
    --   edit_range = { 0, 0 },
    -- max_buf_lines = 500,
    -- debounce = 150,
    -- callbacks = {},
    -- icon_provider = "internal",
    -- splitview_winopts = { split = "right" },
    -- preview_winopts = { width = math.floor(80) }
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
      enable = true, -- For} toggling this feature
      default = {
        padding_left = "", -- Padding for the left side
        padding_right = "", -- Padding for the right side
        icon = " ", -- Icon to use
        hl = "Mentionlink", -- Highlight group
      },
    },
    code_blocks = {
      enable = true,
      border_hl = "CodeBlock",
      -- border_hl = "HelpviewCode",
      default = {
        block_hl = "CodeBlock",
        language_hl = "Comment",
        -- block_hl = "HelpviewCode",
        -- language_hl = "HelpviewCodeLanguage",
      },
      -- ["diff"] = {
      --   block_hl = function (_, line)
      --     if line:match("^%s*%+") then
      --       return "HelpviewPalette4";
      --     elseif line:match("^%s*%-") then
      --       return "HelpviewPalette1";
      --     else
      --       return "HelpviewCode";
      --     end
      --   end
      -- }
    },
    highlight_groups = {
      enable = true,
    },
    headings = {
      -- ● ○ ◆ ◇
      enable = true,
      heading_1 = { style = "simple", hl = "Heading1", marker = "═", sign = "◆" },
      heading_2 = { style = "simple", hl = "Heading2", marker = "─", sign = "◇" },
      heading_3 = { style = "simple", hl = "Heading3", sign = "" },
      heading_4 = { style = "simple", hl = "Heading4", sign = "" },
      -- heading_1 = { sign = " ⣾⣿⠛⣿⣷ ", sign_hl = "Palette1Inv", marker_hl = "Palette1Bg", hl = "Palette1Fg" },
      -- heading_2 = { sign = " ⣠⠞⠛⠳⣄ ", sign_hl = "Palette2Inv", marker_hl = "Palette2", hl = "Palette2Fg" },
      -- heading_3 = { sign = " ⣯⣤⠛⣤⣽ ", sign_hl = "Palette3Inv", marker_hl = "Palette3", hl = "Palette3" },
      -- heading_4 = { sign = " ⠓⣠⣿⣄⠚ ", sign_hl = "Palette4Inv", marker_hl = "Palette4", hl = "Palette4" },
    },
    notes = {
      enable = true,
      default = { padding_right = " ", icon = " ", hl = "@comment.note" },
      warning = { padding_right = " ", icon = "   ", hl = "@comment.warning" },
      deprecated = { padding_right = " ", icon = "  ", hl = "@comment.error" },
    },
  },
}

require("helpview").setup(cfg)

-- arguments = {},          -- {arg}
-- 	highlight_groups = {},        -- $Group$
-- 	inline_codes = {},       -- `code`
-- 	taglinks = {},      -- |link|
-- 	optionlinks = {},       -- 'option'
-- 	taglinks = {},          -- <tag>
-- 	title = {}
-- horizontal_rules = {
--   parts = {
--     {
--       type = "repeating",
--       repeat_amount = function (buffer)
--         return math.ceil((vim.bo[buffer].tw - 3) / 2);
--       end,
--       text = "─",
--       hl = {
--         "HelpviewGradient1", "HelpviewGradient1",
--         "HelpviewGradient2", "HelpviewGradient2",
--         "HelpviewGradient3", "HelpviewGradient3",
--         "HelpviewGradient4", "HelpviewGradient4",
--         "HelpviewGradient5", "HelpviewGradient5",
--         "HelpviewGradient6", "HelpviewGradient6",
--         "HelpviewGradient7", "HelpviewGradient7",
--         "HelpviewGradient8", "HelpviewGradient8",
--         "HelpviewGradient8", "HelpviewGradient8",
--       }
--     },
--     {
--       type = "text",
--       text = " ◈ "
--     },
--     {
--       type = "repeating",
--       repeat_amount = function (buffer)
--         return math.floor((vim.bo[buffer].tw - 3) / 2);
--       end,
--       direction = "right",
--       text = "─",
--       hl = {
--         "HelpviewGradient1", "HelpviewGradient1",
--         "HelpviewGradient2", "HelpviewGradient2",
--         "HelpviewGradient3", "HelpviewGradient3",
--         "HelpviewGradient4", "HelpviewGradient4",
--         "HelpviewGradient5", "HelpviewGradient5",
--         "HelpviewGradient6", "HelpviewGradient6",
--         "HelpviewGradient7", "HelpviewGradient7",
--         "HelpviewGradient8", "HelpviewGradient8",
--         "HelpviewGradient8", "HelpviewGradient8",
--       }
--     },
--   }
-- },
