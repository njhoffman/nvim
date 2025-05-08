local cfg = {
  library = {
    -- See the configuration section for more details
    -- Load luvit types when the `vim.uv` word is found
    "lazy.nvim",
    { path = "luvit-meta/library", words = { "vim%.uv" } },
    { path = "LazyVim", words = { "LazyVim" } },
    -- "~/projects/my-awesome-lib",
    -- "luvit-meta/library",
    -- { path = "wezterm-types", mods = { "wezterm" } },
    -- { path = "xmake-luals-addon/library", files = { "xmake.lua" } },
  },
}
require("lazydev").setup(cfg)
