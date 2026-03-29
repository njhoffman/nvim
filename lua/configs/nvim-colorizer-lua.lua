require("colorizer").setup({
  lazy_load = false,
  buftypes = { "*", "!prompt", "!popup" },
  filetypes = {
    "*",
    css = {
      options = {
        parsers = { names = { enable = true } },
        display = { mode = "virtualtext" },
      },
    },
    html = {
      options = {
        parsers = { names = { enable = true } },
        display = { mode = "virtualtext" },
      },
    },
    cmp_docs = { options = { always_update = true } },
    cmp_menu = { options = { always_update = true } },
    "!vim",
    "!noice",
    "!TelescopeResults",
  },
  options = {
    parsers = {
      names = {
        enable = false,
        lowercase = true,
        camelcase = true,
        uppercase = false,
        strip_digits = false,
      },
      hex = {
        rgb = true,
        rgba = true,
        rrggbb = true,
      },
      rgb = { enable = true },
      hsl = { enable = true },
      css_fn = true,
      tailwind = { enable = false },
      sass = { enable = false },
    },
    display = {
      mode = "virtualtext",
      virtualtext = {
        char = "■",
        position = "eol",
        hl_mode = "foreground",
      },
    },
    hooks = {
      should_highlight_line = function(line, bufnr, line_num)
        return string.sub(line, 1, 2) == "--"
      end,
    },
    always_update = true,
  },
})
