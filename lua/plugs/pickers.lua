local utils = require('utils.lazy')

local plugins = {
  { 'echasnovski/mini.fuzzy', event = 'VeryLazy', version = false },
  {
    'prochri/telescope-all-recent.nvim',
    dependencies = { 'telescope.nvim', 'kkharji/sqlite.lua', 'telescope-ui-select.nvim', 'dressing.nvim' },
    config = function()
      local default_config = {
        database = {
          folder = vim.fn.stdpath('data'),
          file = 'telescope-all-recent.sqlite3',
          max_timestamps = 10,
        },
        scoring = {
          recency_modifier = {
            [1] = { age = 240, value = 100 }, -- past 4 hours
            [2] = { age = 1440, value = 80 }, -- past day
            [3] = { age = 4320, value = 60 }, -- past 3 days
            [4] = { age = 10080, value = 40 }, -- past week
            [5] = { age = 43200, value = 20 }, -- past month
            [6] = { age = 129600, value = 10 }, -- past 90 days
          },
          boost_factor = 0.0001,
        },
        default = {
          disable = true,
          use_cwd = true,
          sorting = 'recent',
        },
        debug = false,
        -- does not make sense for:
        -- grep string
        -- live grep (too many results)
        -- TODO: buffers: might be useful for project/session, but: we must allow preprocesseing the string
        --
        -- oldfiles: are per definition already recent. If you need frecency files: use telescope-frecency
        -- command history: already recent
        -- search history: already recent
        --
        pickers = {
          -- pickers explicitly enabled
          -- not using cwd
          man_pages = {
            disable = false,
            use_cwd = false,
          },
          vim_options = {
            disable = false,
            use_cwd = false,
          },
          pickers = {
            disable = false,
            use_cwd = false,
          },
          builtin = {
            disable = false,
            use_cwd = false,
          },
          planets = {
            disable = false,
            use_cwd = false,
          },
          commands = {
            disable = false,
            use_cwd = false,
          },
          help_tags = {
            disable = false,
            use_cwd = false,
          },
          -- using cwd
          find_files = {
            disable = false,
            sorting = 'frecency',
          },
          git_files = {
            disable = false,
            sorting = 'frecency',
          },
          tags = {
            disable = false,
          },
          git_commits = {
            disable = false,
          },
          git_branches = {
            disable = false,
          },
          -- some explicitly disabled pickers: I consider them not useful.
          oldfiles = { disable = true },
          live_grep = { disable = true },
          grep_string = { disable = true },
          command_history = { disable = true },
          search_history = { disable = true },
          current_buffer_fuzzy_find = { disable = true },
        },
        -- support for telescope invoked through vim.ui.select, e.g. using dressing.nvim
        -- Specify the kind.
        -- Potentially fix to a specific prompt only.
        -- Other than that, all options are the same as for normal pickers
        -- vim_ui_select = {
        --   kinds = {},
        --   prompts = {},
        -- },
        vim_ui_select = {
          kinds = {
            overseer_template = {
              use_cwd = true,
              prompt = 'Task template',
              name_include_prompt = true,
            },
            overseer_task_options = {
              use_cwd = true,
              -- differentiate pickers, if they use distinct prompts
              name_include_prompt = true,
            },
          },
          -- some plugins don't set a kind. The prompt contents can be used as fallback!
          prompts = {
            ['My Prompt'] = {
              use_cwd = false,
            },
          },
        },
        -- lua require'telescope-all-recent'.toggle_debug()
      }
      return default_config
    end,
    -- elescope does not provide the relevant hooks/callback functions to build this nicely. So, this plugin first stores some of the original functions and then overrides them:
    -- calls to telescope.builtin and telescope.extensions[extension_name] are overriden. This allows us to get the name of the called picker.
    -- the Picker:new is replaced. We want to get all information we can about what picker we are dealing with.
    -- the Sorter:new function is replaced to allow us to insert a custom sorting function, which boosts the scores of (f)recent items by a small amount.
    -- the action.select_default.__call allows us to see, which result is finally selected and add it to the database.
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    lazy = false,
    cmd = { 'NeoTreeFocusToggle', 'NeoTreeShowToggle' },
    event = 'VimEnter',
    branch = 'v2.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
  },
  {
    'njhoffman/telescope.nvim', -- "nvim-telescope/telescope.nvim",
    -- dir = "~/git/telescope.nvim", -- "nvim-telescope/telescope.nvim",
    event = 'VeryLazy',
    cmd = 'Telescope',
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
      'sudormrfbin/cheatsheet.nvim',
      'tamago324/telescope-openbrowser.nvim',
      'tsakirist/telescope-lazy.nvim',
      { 'chip/telescope-code-fence.nvim', build = 'luarocks --local install lunamark' },
      {
        'danielfalk/smart-open.nvim',
        dependencies = { 'kkharji/sqlite.lua' },
      },
      {
        'nvim-telescope/telescope-smart-history.nvim',
        dependencies = { 'kkharji/sqlite.lua' },
      },
      { 'kkharji/sqlite.lua', run = 'luarocks install sqlite luv' },
      -- { "nvim-telescope/telescope-frecency.nvim", dependencies = { "kkharji/sqlite.lua" } },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'AckslD/nvim-neoclip.lua', dependencies = { 'kkharji/sqlite.lua' } },
      { 'GustavoKatel/telescope-asynctasks.nvim', dependencies = { 'skywind3000/asynctasks.vim' } },
      { 'debugloop/telescope-undo.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
      -- { "rmagatti/session-lens", dependencies = "rmagatti/auto-session" },
    },
  },
}

utils.apply_configs(plugins)
return plugins

-- "moevis/smartjump.nvim",
-- "nvim-telescope/telescope-vimspector",
-- "benfowler/telescope-luasnip.nvim",
