local utils = require('utils.lazy')

-- https://github.com/axkirillov/easypick.nvim
-- https://github.com/adoyle-h/telescope-extension-maker.nvim
-- https://github.com/adoyle-h/ad-telescope-extensions.nvim
-- https://github.com/otavioschwanck/telescope-alternate.nvim
-- https://github.com/lpoto/telescope-tasks.nvim

local plugins = {
  { 'echasnovski/mini.fuzzy', event = 'VeryLazy', version = false },
  {
    'nvim-neo-tree/neo-tree.nvim',
    lazy = false,
    cmd = { 'NeoTreeFocusToggle', 'NeoTreeShowToggle' },
    event = 'VimEnter',
    branch = 'v2.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
  },
  {
    -- 'njhoffman/telescope.nvim',
    -- 'nvim-telescope/telescope.nvim',
    dir = '~/git/telescope.nvim',
    cmd = 'Telescope',
    event = 'VeryLazy',
    dependencies = {
      'ElPiloto/telescope-vimwiki.nvim',
      'LinArcX/telescope-changes.nvim',
      'LinArcX/telescope-command-palette.nvim',
      'LinArcX/telescope-ports.nvim',
      'Zane-/cder.nvim',
      'Zane-/howdoi.nvim',
      'benfowler/telescope-luasnip.nvim',
      'camgraff/telescope-tmux.nvim',
      'cljoly/telescope-repo.nvim',
      'crispgm/telescope-heading.nvim',
      'dhruvmanila/telescope-bookmarks.nvim',
      'dawsers/telescope-file-history.nvim',
      'elianiva/telescope-npm.nvim',
      'frenchtoasters/telescope-kubectl.nvim',
      'nvim-tree/nvim-web-devicons',
      'lpoto/telescope-docker.nvim',
      'molecule-man/telescope-menufacture',
      'smartpde/telescope-recent-files',
      'ghassan0/telescope-glyph.nvim',
      'Marskey/telescope-sg',
      'danielvolchek/tailiscope.nvim',
      'nat-418/telescope-color-names.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-lua/popup.nvim',
      'nvim-telescope/telescope-dap.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-ghq.nvim',
      'nvim-telescope/telescope-github.nvim',
      'nvim-telescope/telescope-hop.nvim',
      'nvim-telescope/telescope-live-grep-args.nvim',
      'nvim-telescope/telescope-media-files.nvim',
      'nvim-telescope/telescope-node-modules.nvim',
      'nvim-telescope/telescope-rg.nvim',
      'nvim-telescope/telescope-symbols.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-telescope/telescope-z.nvim',
      'paopaol/telescope-git-diffs.nvim',
      'ptethng/telescope-makefile',
      'rlch/github-notifications.nvim',
      'sbulav/telescope-terraform.nvim',
      'stevearc/aerial.nvim',
      'doctorfree/cheatsheet.nvim',
      'tamago324/telescope-openbrowser.nvim',
      'tsakirist/telescope-lazy.nvim',
      {
        'prochri/telescope-all-recent.nvim',
        dependencies = { 'kkharji/sqlite.lua', 'telescope-ui-select.nvim', 'dressing.nvim' },
      },
      { 'chip/telescope-code-fence.nvim', build = 'luarocks --local install lunamark' },
      {
        'danielfalk/smart-open.nvim',
        dependencies = { 'kkharji/sqlite.lua' },
      },
      {
        'nvim-telescope/telescope-smart-history.nvim',
        dependencies = { 'kkharji/sqlite.lua' },
      },
      {
        'mvaldes14/terraform.nvim',
        dependencies = { 'plenary.nvim', 'nui.nvim' },
      },
      { 'kkharji/sqlite.lua', run = 'luarocks install sqlite luv' },
      -- { "nvim-telescope/telescope-frecency.nvim", dependencies = { "kkharji/sqlite.lua" } },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'AckslD/nvim-neoclip.lua', dependencies = { 'kkharji/sqlite.lua' } },
      { 'GustavoKatel/telescope-asynctasks.nvim', dependencies = { 'skywind3000/asynctasks.vim' } },
      { 'debugloop/telescope-undo.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
      -- { "rmagatti/session-lens", dependencies = "rmagatti/auto-session" },
      { 'PhilippFeO/telescope-filelinks.nvim' },
      { 'octarect/telescope-menu.nvim' },
      {
        'paopaol/telescope-git-diffs.nvim',
        dependencies = {
          'nvim-lua/plenary.nvim',
          'sindrets/diffview.nvim',
        },
      },
      {
        'luckasRanarison/nvim-devdocs',
        dependencies = {
          'nvim-lua/plenary.nvim',
          'nvim-treesitter/nvim-treesitter',
        },
        -- run = 'DevdocsFetch',
        opts = {
          dir_path = vim.fn.stdpath('data') .. '/devdocs', -- installation directory
          telescope = {}, -- passed to the telescope picker
          telescope_alt = {}, -- when searching globally without preview
          float_win = { -- passed to nvim_open_win(), see :h api-floatwin
            relative = 'editor',
            height = 25,
            width = 100,
            border = 'rounded',
          },
          wrap = false, -- text wrap
          ensure_installed = {}, -- get automatically installed
          -- DevdocsFetch: Fetch DevDocs metadata.
          -- DevdocsInstall: Install documentation, 0-n args.
          -- DevdocsUninstall: Uninstall documentation, 0-n args.
          -- DevdocsOpen: Open documentation in a normal buffer, 0 or 1 arg.
          -- DevdocsOpenFloat: Open documentation in a floating window, 0 or 1 arg.
          -- DevdocsUpdate: Update documentation, 1-n args.
          -- DevdocsUpdateAll: Update all documentations.
        },
      },
    },
  },
}

utils.apply_configs(plugins)
return plugins

-- "moevis/smartjump.nvim",
-- "nvim-telescope/telescope-vimspector",
-- "benfowler/telescope-luasnip.nvim",
