local stats = require("utils.lazy.stats")

local setup = function(opts)
  opts = opts or { cache = true, reload = false }
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end

  vim.opt.rtp:prepend(lazypath)
  stats.state = require("lazy.stats")._stats
  stats.state.start = {}
  stats.state.lazy = {}
  stats.state.configs_checked = {}
  stats.state.configs_loaded = {}
  stats.state.errors = {}

  require("lazy").setup("plugs", {
    ui = {
      border = "rounded",
      icons = {
        --   cmd = "⌘",
        -- config = "🛠",
        -- event = "📅",
        -- ft = "📂",
        -- init = "⚙",
        -- keys = "🗝",
        -- plugin = "🔌",
        -- runtime = "💻",
        -- source = "📄",
        -- start = "🚀",
        -- task = "📌",
        -- lazy = "💤 ",
        lazy = "🛠 ",
        cmd = " ",
        config = " ",
        event = " ",
        ft = " ",
        init = " ",
        import = " ",
        keys = " ",
        -- lazy = "󰒲 ",
        loaded = "●",
        not_loaded = "○",
        plugin = " ",
        runtime = " ",
        source = " ",
        start = "",
        task = "✔ ",
        list = {
          "●",
          "➜",
          "★",
          "‒",
        },
      },
    },
    install = {
      colorscheme = { "nord-nick", "habamax" },
    },
    dev = {
      path = "~/scratch",
      ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
      patterns = {},
      fallback = false,
    },
    change_detection = {
      -- automatically check for config file changes and reload the ui
      enabled = opts.reload,
    },
    performance = {
      cache = {
        enabled = opts.cache,
      },
      reset_packpath = true,
    },
    custom_keys = {
      -- ["<C-f"] = false,
      -- ["<localleader>f"] = profile_filter
      ["<localleader>l"] = function(plugin)
        require("lazy.util").float_term({ "lazygit", "log" }, {
          cwd = plugin.dir,
        })
      end,
    },
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        -- "netrw",
        -- "netrwPlugin",
        -- "netrwSettings",
        -- "netrwFileHandlers",
        -- "matchit",
        -- "matchparen",
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "rrhelper",
        "spellfile_plugin",
        "tar",
        "tarPlugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
      },
    },
  })
end

return setup
