local cfg = {
  lazy_load = false, -- Lazily schedule buffer highlighting setup function
  buftypes = { "*", "!prompt", "!popup" },
  filetypes = {
    "*",
    css = { mode = "virtualtext", names = true, RGB = true },
    html = { mode = "virtualtext", names = true, RGB = true },
    cmp_docs = { always_update = true },
    cmp_menu = { always_update = true },
    "!vim",
    "!noice",
    "!TelescopeResults",
  },
  user_default_options = {
    names = false, -- "Name" codes like Blue or blue
    names_opts = { -- options for mutating/filtering names.
      lowercase = true, -- name:lower(), highlight `blue` and `red`
      camelcase = true, -- name, highlight `Blue` and `Red`
      uppercase = false, -- name:upper(), highlight `BLUE` and `RED`
      strip_digits = false, -- ignore names with digits,
      -- highlight `blue` and `red`, but not `blue3` and `red4`
    },
    rgb_fn = true, -- CSS rgb() and rgba() functions
    hsl_fn = true, -- CSS hsl() and hsla() functions
    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
    -- Available methods are false / true / "normal" / "lsp" / "both" True is same as normal
    tailwind = false, -- Enable tailwind colors (lsp)
    tailwind_opts = { -- Options for highlighting tailwind names
      update_names = false, -- When using tailwind = 'both', update tailwind names from LSP results.  See tailwind section
    },
    mode = "virtualtext", -- foreground, background,  virtualtext
    sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
    virtualtext = "■",
    virtualtext_inline = false,
    virtualtext_mode = "foreground", -- foreground/background
    -- update color values even if buffer is not focused example use: cmp_menu, cmp_docs
    always_update = false,
  },
  hooks = {
    -- called before line parsing.  Accepts boolean or function that returns boolean see hooks section below
    disable_line_highlight = function(line, bufnr, line_num)
      -- Treesitter could also be used, but be warned it will be quite laggy unless you are caching results somehow
      return string.sub(line, 1, 2) ~= "--"
    end,
  },
  -- names = true,
  -- names_custom = function()
  --   local colors = require("kanagawa.colors").setup({ theme = "dragon" })
  --   return colors.palette
  -- end,
  -- filetypes = {
  --   "*",
  --   lua = { -- use different theme for lua filetype
  --     names_custom = function()
  --       local colors = require("kanagawa.colors").setup({ theme = "wave" })
  --       return colors.palette
  --     end,
  --   },
  -- },
}
-- TODO: make highlights work without re-entering buffer

require("colorizer").setup(cfg)
