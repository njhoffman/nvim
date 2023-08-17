local stats = require('utils.lazy.stats')

local setup = function(opts)
  opts = opts or { cache = true, reload = true, lazy = false, dev_patterns = {} }
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      lazypath,
    })
  end

  vim.opt.rtp:prepend(lazypath)
  local _stats = require('lazy.stats')._stats
  stats.state = vim.tbl_deep_extend('force', stats.state, _stats)

  -- stylua: ignore
  require("lazy").setup("plugins", {
      defaults = {
        lazy = opts.lazy, -- should plugins be lazy-loaded?
        version = nil,
        -- default `cond` you can use to globally disable a lot of plugins
        -- when running inside vscode for example
        cond = nil, ---@type boolean|fun(self:LazyPlugin):boolean|nil
        -- version = "*", -- enable this to try installing the latest stable versions of plugins
      },
    ui = {
      border = "rounded",
      icons = {
        --   cmd   = "⌘",
        -- config  = "🛠",
        -- event   = "📅",
        -- ft      = "📂",
        -- init    = "⚙",
        -- keys    = "🗝",
        -- plugin  = "🔌",
        -- runtime = "💻",
        -- source  = "📄",
        lazy       = "🛠 ",-- 💤 󰒲
        cmd        = " ",
        config     = " ",
        event      = " ",
        ft         = " ",
        init       = " ",
        import     = " ",
        keys       = " ",
        loaded     = "●",
        not_loaded = "○",
        plugin     = " ",
        runtime    = " ",
        source     = " ",
        start      = "", --  "🚀",
        task       = "✔ ", -- "📌",
        list = { "●", "➜", "★", "‒", },
      },
    },
    install = {
      colorscheme = { "nord-nick", "habamax" },
    },
    dev = {
      path = "~/git",
      patterns = opts.dev_patterns or {},
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
        -- "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers", "matchit", "matchparen",
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
