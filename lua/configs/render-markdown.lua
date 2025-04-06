local bullets = {
  { "●", "○", "◆", "◇" },
  { "", "", "", "" },
}

local cfg = {
  render_modes = { "i", "n", "c", "x", "v", "V", "" },
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
    sign = false,
    position = "right",
    highlight_language = "Comment",
    -- width = "full", -- full/block
    -- language_pad = 0,
    -- language_name = true,
    -- min_width = 0,
    -- border = "thin", -- thick/thin
    -- above = "▄",
    -- below = "▀",
    -- highlight = "RenderMarkdownCode",
    -- highlight_inline = "RenderMarkdownCodeInline",
  },
  anti_conceal = {
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
    border = false,
    border_virtual = true,
    position = "inline",
    -- border = "thin",
    -- above = "▄",
    -- below = "▀",
    -- highlight = "RenderMarkdownCode",
    -- highlight_inline = "RenderMarkdownCodeInline",
    -- icons = { '󰼏 ', '󰎨 ' }
    -- width = 'block',
    -- min_width = 30,
  },
}

require("render-markdown").setup(cfg)
