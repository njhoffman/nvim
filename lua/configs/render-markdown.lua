local bullets = {
  { "●", "○", "◆", "◇" },
  { "", "", "", "" },
}

local cfg = {
  -- render_modes = { "n", "c", "t" },
  render_modes = { "n", "c", "t", "s", "v", "V", "" },
  patterns = {
    -- Highlight patterns to disable for filetypes, i.e. lines concealed around code blocks
    markdown = {
      disable = true,
      directives = {
        { id = 17, name = "conceal_lines" },
        { id = 18, name = "conceal_lines" },
      },
    },
  },
  file_types = { "markdown", "vimwiki" },
  bullet = {
    enabled = true,
    icons = bullets[1],
    ordered_icons = {},
    left_pad = 0,
    right_pad = 0,
    highlight = "RenderMarkdownBullet",
  },
  code = {
    -- border = "thin", below = "▀"
    sign = false, -- Turn on / off any sign column related rendering.
    position = "right", -- language icon position
    highlight_language = "Comment", -- hl for language, overrides icon provider value.
    width = "block", -- full/block
    left_pad = 1, -- < 1 is percentage
    right_pad = 1, -- < 1 is percentage (only for block width)
    language_pad = 1, -- < 1 is percentage
    -- -- Determines how the top / bottom of code block are rendered.
    -- -- | none  | do not render a border                               |
    -- -- | thick | use the same highlight as the code body              |
    -- -- | thin  | when lines are empty overlay the above & below icons |
    -- -- | hide  | conceal lines unless language name or icon is added  |
    border = "thin",
    -- -- Determines how code blocks & inline code are rendered.
    -- -- | none     | disables all rendering                                                    |
    -- -- | normal   | highlight group to code blocks & inline code, adds padding to code blocks |
    -- -- | language | language icon to sign column if enabled and icon + name above code blocks |
    -- -- | full     | normal + language                                                         |
    -- style = "full",
    -- language_icon = true,            -- Whether to include the language icon above code blocks.
    -- language_name = true,            -- Whether to include the language name above code blocks.
    -- disable_background = { "diff" }, -- language names to render borders but no background
    -- left_margin = 0,                 -- < 1 is percentage
    -- min_width = 0,                   -- < 1 is percentage (only for block width)
    -- above = "▄",                     -- Used above code blocks for thin border.
    -- below = "▀",                     -- Used below code blocks for thin border.
    -- inline_left = "",                -- Icon to add to the left of inline code.
    -- inline_right = "",               -- Icon to add to the right of inline code.
    -- inline_pad = 0,                  -- Padding to add to the left & right of inline code.
    -- highlight = "RenderMarkdownCode",                  -- hl for code blocks.
    -- highlight_border = "RenderMarkdownCodeBorder",     -- hl for border,   use false to add no highlight.
    -- highlight_fallback = "RenderMarkdownCodeFallback", -- hl for language, used if icon provider does not have a value.
    -- highlight_inline = "RenderMarkdownCodeInline",     -- hl for inline code.
  },
  anti_conceal = {
    enabled = false, -- if enabled hide any added text on the line the cursor is on
    ignore = {
      --  head_icon, head_background, head_border, code_language, code_background, code_border
      --  dash, bullet, check_icon, check_scope, quote, table_border, callout, link, sign
      bullet = true,
      head_icon = true,
      head_background = true,
      head_border = true,
      code_language = true,
      code_background = true,
      code_border = true,
      sign = true,
    },
  },
  heading = {
    -- border = "thin", highlight = "RenderMarkdownCode", highlight_inline = "RenderMarkdownCodeInline", min_width = 30
    border_virtual = true, -- Always use virtual lines for heading borders instead of attempting to use empty lines
    -- | right   | '#'s are concealed and icon is appended to right side                          |
    -- | inline  | '#'s are concealed and icon is inlined on left side                            |
    -- | overlay | icon is left padded with spaces and inserted on left hiding any additional '#' |
    position = "inline", -- inline: icons left aligned, overlay: L
    -- -- Replaces '#+' of 'atx_h._marker': function `value(context)` | string[] `cycle(value, context.level)` |
    -- icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },  { '󰼏 ', '󰎨 ' }
    -- atx = true,             -- Turn on / off atx heading rendering.
    -- setext = true,          -- Turn on / off setext heading rendering.
    -- sign = true,            -- Turn on / off any sign column related rendering.
    -- width = 'block',        -- background width block (only text) or full
    -- min_width = 0,          -- Minimum width to use for headings when width is 'block', can be level integers list
    -- border = false,         -- Determines if a border is added above and below headings
    -- border_prefix = false,  -- Highlight the start of the border using the foreground highlight
    -- above = "▄",            -- Used above heading for border
    -- below = "▀",            -- Used below heading for border
    -- signs = { "󰫎 " },       -- sign column if enabled, can use levels
    -- left_margin = 0,        -- < 1 is percentage, can be levels
    -- left_pad = 0,           -- < 1 is percentage, can be levels
    -- right_pad = 0,          --  < 1 is percentage, can be levels (only when width is block)
    -- backgrounds = { "RenderMarkdownH1Bg", "RenderMarkdownH2Bg", "RenderMarkdownH3Bg", "RenderMarkdownH4Bg", "RenderMarkdownH5Bg", "RenderMarkdownH6Bg", },
    -- foregrounds = { "RenderMarkdownH1", "RenderMarkdownH2", "RenderMarkdownH3", "RenderMarkdownH4", "RenderMarkdownH5", "RenderMarkdownH6", },
  },
}

require("render-markdown").setup(cfg)
