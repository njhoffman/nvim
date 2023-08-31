local cfg = {
  buftypes = {
    '*',
    '!prompt',
    '!popup',
  },
  filetypes = {
    '*',
    css = { mode = 'virtualtext', names = true, RGB = true },
    html = { mode = 'virtualtext', names = true, RGB = true },
    cmp_docs = { always_update = true },
    cmp_menu = { always_update = true },
    '!vim',
    '!noice',
    '!TelescopeResults',
  },
  user_default_options = {
    RGB = false, -- #RGB hex codes
    RRGGBB = true, -- #RRGGBB hex codes
    names = false, -- "Name" codes like Blue or blue
    RRGGBBAA = true, -- #RRGGBBAA hex codes
    AARRGGBB = true, -- 0xAARRGGBB hex codes
    rgb_fn = true, -- CSS rgb() and rgba() functions
    hsl_fn = true, -- CSS hsl() and hsla() functions
    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
    mode = 'virtualtext', -- foreground, background,  virtualtext
    -- Available methods are false / true / "normal" / "lsp" / "both" True is same as normal
    tailwind = true, -- Enable tailwind colors
    -- parsers can contain values used in |user_default_options|
    sass = { enable = true, parsers = { 'css' } }, -- Enable sass colors
    virtualtext = '■',
    -- update color values even if buffer is not focused example use: cmp_menu, cmp_docs
    always_update = true,
  },
}
-- TODO: make highlights work without re-entering buffer

require('colorizer').setup(cfg)
