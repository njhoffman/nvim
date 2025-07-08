local utils = require("utils.lazy")
local lz_syn = false

-- NOTE: generate new plugins from https://github.com/ellisonleao/nvim-plugin-template
-- https://github.com/meznaric/key-analyzer.nvim?tab=readme-ov-file
-- https://github.com/kovidgoyal/kitty/pull/7681
-- https://github.com/folke/snacks.nvim/blob/main/lua/snacks/debug.lua

local plugins = {
  -- https://gist.github.com/GnikDroy/62556534324f9dc9192f7bba5a88cc43
  { "dundalek/bloat.nvim", cmd = "Bloat" },
  { "goolord/alpha-nvim", event = "VimEnter", dependencies = "nvim-web-devicons" },
  { "tamton-aquib/zone.nvim", enabled = false },
  -- https://github.com/romgrk/barbar.nvim/pull/540
  -- { 'akinsho/bufferline.nvim', version = '*', dependencies = 'nvim-tree/nvim-web-devicons' },
  { "jrop/u.nvim", lazy = true },
  {
    "romgrk/barbar.nvim",
    -- branch = 'fix-telescope-insert',
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    event = "VimEnter",
    dependencies = "nvim-web-devicons",
  },
  { "declancm/cinnamon.nvim", event = "VeryLazy", enabled = false },
  { "karb94/neoscroll.nvim", event = "VeryLazy", enabled = true },
  {
    "00sapo/visual.nvim",
    enabled = false,
    dependencies = { "nvim-treesitter", "nvim-various-textobjs", "nvim-treesitter-textobjects" },
    event = "VeryLazy",
  },
  { "Makaze/watch.nvim", cmd = { "WatchStart", "WatchStop", "WatchFile" } },
  -- https://www.reddit.com/r/neovim/comments/1aupy8c/a_simple_journaling_system_built_with_mind_and/
  {
    "RutaTang/quicknote.nvim",
    enabled = false,
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "LintaoAmons/scratch.nvim",
    event = "VeryLazy",
    -- Scratch, ScratchOpen, ScrathWithName, ScratchOpenFzf, ScratchPad
    -- nvim -c 'lua require("scratch").scratchByType("md")'
  },
  { "rgroli/other.nvim", event = "VeryLazy" },

  -- https://www.reddit.com/r/neovim/comments/1jelzey/pathfindernvim_a_multiline_gfgf_replacement/
  -- https://github.com/hawkinst/pathfinder.nvim
  {
    "chrishrb/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  { "rmagatti/gx-extended.nvim" },
  { "OXY2DEV/helpview.nvim", ft = "help", dependencies = { "nvim-treesitter/nvim-treesitter" } },
  { "monaqa/dial.nvim", event = { "VeryLazy" }, dependencies = { "nvim-lua/plenary.nvim" } },
  { "tris203/hawtkeys.nvim", event = { "VeryLazy" } },
  { "nvzone/showkeys", cmd = "ShowkeysToggle" },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    "tris203/precognition.nvim",
    --event = "VeryLazy",
    opts = {
      startVisible = false,
      -- showBlankVirtLine = true,
      -- highlightColor = { link = "Comment" },
      -- hints = {
      --      Caret = { text = "^", prio = 2 },
      --      Dollar = { text = "$", prio = 1 },
      --      MatchingPair = { text = "%", prio = 5 },
      --      Zero = { text = "0", prio = 1 },
      --      w = { text = "w", prio = 10 },
      --      b = { text = "b", prio = 9 },
      --      e = { text = "e", prio = 8 },
      --      W = { text = "W", prio = 7 },
      --      B = { text = "B", prio = 6 },
      --      E = { text = "E", prio = 5 },
      -- },
      -- gutterHints = {
      --     G = { text = "G", prio = 10 },
      --     gg = { text = "gg", prio = 9 },
      --     PrevParagraph = { text = "{", prio = 8 },
      --     NextParagraph = { text = "}", prio = 8 },
      -- },
      -- disabled_fts = {
      --     "startify",
      -- },
    },
  },

  { "echasnovski/mini.clue", enabled = false, event = { "VeryLazy" } },
  { "echasnovski/mini.visits", event = "VeryLazy" },
  { "echasnovski/mini.diff", event = "VeryLazy" },
  { "echasnovski/mini.trailspace", event = "VeryLazy" },
  {
    "nmac427/guess-indent.nvim",
    event = "BufReadPre",
    opts = require("configs.guess-indent__opts"),
  },
  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPre", "BufNewFile" },
    init = function()
      require("configs.mini-indentscope__init")
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
  },
  { "shellRaining/hlchunk.nvim", event = { "BufReadPre", "BufNewFile" } },
  {
    "huy-hng/anyline.nvim",
    enabled = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "Diffview",
      "DiffviewLog",
      "DiffviewOpen",
      "DiffviewToggleFiles",
      "DiffviewFileHistory",
    },
  },
  { "m00qek/baleia.nvim", lazy = false, commit = "56ad00d" },
  { "folke/zen-mode.nvim", cmd = "ZenMode" },
  { "folke/twilight.nvim", cmd = { "Twilight", "TwilightEnable" } },
  -- { 'benlubas/wrapping-paper.nvim' },
  {
    "kevinhwang91/nvim-ufo",
    enabled = false,
    dependencies = "kevinhwang91/promise-async",
    cmd = { "UfoEnable", "UfoAttach", "UfoEnableFold" },
    event = { "UIEnter" },
  },
  {
    "soemre/commentless.nvim",
    cmd = "Commentless",
    keys = {
      {
        "<leader>-",
        function()
          require("commentless").toggle()
        end,
        desc = "Toggle Comments",
      },
      {
        "z-",
        function()
          require("commentless").toggle()
        end,
        desc = "Toggle Comments",
      },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      hide_following_blank_lines = true,
      foldtext = function(folded_count)
        return "(" .. folded_count .. " comments)"
      end,
    },
  },
  {
    -- https://github.com/luckasRanarison/tailwind-tools.nvim
    "laytan/tailwind-sorter.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
    enabled = false,
    build = "cd formatter && npm i && npm run build",
    config = function()
      require("tailwind-sorter").setup({
        on_save_enabled = true, -- If `true`, automatically enables on save sorting.
        node_path = "/home/nicholas/.asdf/shims/node",
      })
    end,
  },

  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hakonharnes/img-clip.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/codecompanion-history.nvim",
      {
        "Davidyz/VectorCode",
        build = "pipx upgrade vectorcode", -- If you used pipx to install the CLI
        dependencies = { "nvim-lua/plenary.nvim" },
      },
      {
        "ravitemer/mcphub.nvim",
        build = "npm install -g mcp-hub@latest",
        config = function()
          require("mcphub").setup()
        end,
      },
      {
        "yetone/avante.nvim",
        -- build from source: `make BUILD_FROM_SOURCE=true, must add this setting
        build = function()
          return "make"
        end,
        event = "VeryLazy",
        version = false, -- Never set this value to "*"! Never!
        dependencies = {
          "nvim-lua/plenary.nvim",
          "MunifTanjim/nui.nvim",
          --- The below dependencies are optional,
          "echasnovski/mini.pick", -- for file_selector provider mini.pick
          "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
          "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
          "ibhagwan/fzf-lua", -- for file_selector provider fzf
          "stevearc/dressing.nvim", -- for input provider dressing
          "folke/snacks.nvim", -- for input provider snacks
          "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
          "zbirenbaum/copilot.lua", -- for providers='copilot'
        },
      },
    },
    -- init = function()
    -- 	require("hanipcode.plugins.codecompanion.fidget_spinner"):init()
    -- 	adapter.init_config()
    -- end,
  },
  -- https://github.com/Aaronik/GPTModels.nvim
  {
    "jackMort/ChatGPT.nvim",
    enabled = false,
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },

  -- lazy.nvim
  { "robitx/gp.nvim" },
  { "BlackLight/nvim-http" },
  -- https://github.com/oysandvik94/curl.nvim
  { "oysandvik94/curl.nvim", cmd = { "CurlOpen" }, dependencies = { "nvim-lua/plenary.nvim" } },
  {
    "mistweaverco/kulala.nvim",
    config = function()
      -- Setup is required, even if you don't pass any options
      require("kulala").setup()
    end,
  },
  {
    "jellydn/hurl.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    ft = "hurl",
    -- keys = {
    --   -- Run API request
    --   { "<leader>A", "<cmd>HurlRunner<CR>", desc = "Run All requests" },
    --   { "<leader>a", "<cmd>HurlRunnerAt<CR>", desc = "Run Api request" },
    --   { "<leader>te", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
    --   { "<leader>tm", "<cmd>HurlToggleMode<CR>", desc = "Hurl Toggle Mode" },
    --   { "<leader>tv", "<cmd>HurlVerbose<CR>", desc = "Run Api in verbose mode" },
    --   -- Run Hurl request in visual mode
    --   { "<leader>h", ":HurlRunner<CR>", desc = "Hurl Runner", mode = "v" },
    -- },
  },
  {
    "MaximilianLloyd/tw-values.nvim",
    -- ft = 'typescriptreact, typescript, astro, vue, svelte, html'
    keys = { { "<leader>sv", "<cmd>TWValues<cr>", desc = "Show tailwind CSS values" } },
    opts = {
      border = "rounded", -- Valid window border style,
      show_unknown_classes = true, -- Shows the unknown classes popup
    },
  },
  -- https://github.com/jackplus-xyz/monaspace.nvim
  { "nyngwang/NeoZoom.lua", enabled = false, event = "VeryLazy" },
  { "matbme/JABS.nvim", event = { "BufReadPost", "BufNewFile" } },
  -- { 'ghillb/cybu.nvim', event = { 'BufRead', 'BufNewFile' } },
  { "nacro90/numb.nvim", event = { "BufReadPost", "BufNewFile" } },
  -- https://github.com/tzachar/local-highlight.nvim
  { "winston0410/range-highlight.nvim", event = { "CmdlineEnter" } },
  -- { 'petertriho/nvim-scrollbar', event = { 'BufReadPost', 'BufNewFile' } },
  {
    "echasnovski/mini.jump2d",
    version = false,
    config = function()
      require("mini.jump2d").setup({
        allowed_lines = { cursor_before = false },
        allowed_windows = { not_current = false },
      })
    end,
  },

  -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-keymap.md
  -- https://www.reddit.com/r/neovim/comments/1kdrhjn/minikeymap_make_special_key_mappings_multistep/
  {
    "echasnovski/mini.jump",
    -- local override
    config = function()
      require("mini.jump").setup({
        mappings = {
          forward = "f",
          backward = "F",
          forward_till = "t",
          backward_till = "T",
          repeat_jump = ";",
        },
        delay = {
          highlight = 500,
          idle_stop = 10000000,
        },
      })
    end,
  },

  { "miversen33/sunglasses.nvim", enabled = false },
  {
    "kevinhwang91/nvim-hlslens",
    event = { "VimEnter" },
    init = function()
      -- cannot use my utility, as the value of IncSearch needs to be retrieved dynamically
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          local reversed = require("utils.core").getHighlightValue("CurSearch", "bg")
          vim.api.nvim_set_hl(0, "HlSearchReversed", { fg = reversed })
        end,
      })
    end,
  },
  { "hrsh7th/nvim-kit" },
  { "Bekaboo/deadcolumn.nvim" },
  -- treesitter
  -- https://github.com/ziontee113/query-secretary
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSTextobjectSelect", "TSTextobjectGotoPreviousStart" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
        opts = {
          enable_autocmd = false,
        },
      },

      {
        -- "RRethy/nvim-treesitter-endwise",
        -- https://github.com/RRethy/nvim-treesitter-endwise/pull/42
        "metiulekm/nvim-treesitter-endwise",
      },
      "theHamsta/nvim-treesitter-pairs",
      {
        "RRethy/nvim-treesitter-textsubjects",
        config = function()
          require("nvim-treesitter-textsubjects").configure({
            prev_selection = "<leader>.",
            keymaps = {
              ["<leader><leader>"] = "textsubjects-smart",
              ["<leader>\\]"] = "textsubjects-container-outer",
              ["<leader>\\["] = "textsubjects-container-inner",
            },
          })
        end,
      },
      "HiPhish/nvim-ts-rainbow2",
      "jbyuki/tree-sitter-ntangle",
      { "sustech-data/wildfire.nvim", enabled = false },
      "nvim-lua/plenary.nvim",
      { "ThePrimeagen/refactoring.nvim", dependencies = { { "nvim-lua/plenary.nvim" } } },
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/playground",
      { "nvim-treesitter/nvim-treesitter-context" },
      "windwp/nvim-ts-autotag",
      {
        "ziontee113/query-secretary",
        keys = {
          {
            "ghq",
            function()
              require("query-secretary").query_window_initiate()
            end,
            mode = { "n" },
            desc = "open treesitter query secretary",
          },
        },
      },
    },
  },
  {
    "echasnovski/mini.ai",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "echasnovski/mini.extra" },
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    event = { "BufReadPost", "BufNewFile" },
  },
  { "stevearc/aerial.nvim", event = { "VeryLazy" }, dependencies = { "nvim-treesitter" } },
  -- motion

  -- https://github.com/FluxxField/smart-motion.nvim
  { "rainbowhxch/accelerated-jk.nvim", enabled = false, event = "VeryLazy" },
  -- https://github.com/AgusDOLARD/backout.nvim
  { "abecodes/tabout.nvim", event = { "InsertEnter" } },
  { "roobert/tabtree.nvim", event = { "BufReadPost", "BufNewFile" } },
  { "Weissle/easy-action" },
  { "gbprod/stay-in-place.nvim" },
  {
    "cbochs/portal.nvim",
    enabled = false,
    dependencies = { "cbochs/grapple.nvim", "ThePrimeagen/harpoon" },
  },
  {
    "csessh/stopinsert.nvim",
    enabled = false,
    opts = {
      idle_time_jms = 30000,
      show_popup_msg = false,
      clear_popup_msg = 5000,
      disabled_filetypes = {
        "TelescopePrompt",
        "checkhealth",
        "help",
        "lspinfo",
        "mason",
        "neo%-tree*",
      },
      -- StopInsertPlug enable/disable/toggle/status
    },
  },
  { "jake-stewart/multicursor.nvim", branch = "1.0" },
  -- movement highlighters
  -- https://github.com/tzachar/local-highlight.nvim
  -- https://github.com/jjshoots/betterf.nvim/tree/main
  { "smoka7/hop.nvim", event = { "BufReadPost", "BufNewFile" } },
  { "folke/flash.nvim", event = "VeryLazy" },
  { "s1n7ax/nvim-window-picker", name = "window-picker", event = "VeryLazy", version = "2.*" },
  -- cursor
  -- { "gen740/SmoothCursor.nvim", event = { "BufReadPost", "BufNewFile" } },
  { "sphamba/smear-cursor.nvim", cond = false and vim.g.neovide == nil },
  { "rasulomaroff/reactive.nvim", enabled = true, dependencies = { "sphamba/smear-cursor.nvim" } },
  { "echasnovski/mini.animate", cond = vim.g.neovide == nil, event = "VeryLazy" },
  -- { 'otavioschwanck/cool-substitute.nvim' },
  -- matching

  {
    "andymass/vim-matchup",
    lazy = false,
    init = function()
      require("configs.vim-matchup__init")
    end,
  },
  -- pairs
  -- { 'windwp/nvim-autopairs', event = 'InsertEnter', enabled = false, dependencies = { 'nvim-cmp' } },
  {
    "njhoffman/ultimate-autopair.nvim",
    dir = "~/git/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6",
  },
  { "gbprod/substitute.nvim", event = { "VeryLazy" } },
  -- split/join
  { "echasnovski/mini.splitjoin", event = { "VeryLazy" } },
  { "njhoffman/treesj", event = { "VeryLazy" }, dependencies = { "nvim-treesitter" } },
  -- surround
  { "echasnovski/mini.surround", event = { "VeryLazy" } },
  -- traversal/swapping
  { "mizlan/iswap.nvim", event = { "BufReadPost", "BufNewFile" } },
  { "gsuuon/tshjkl.nvim", event = "VeryLazy" },
  { "chrisgrieser/nvim-spider", event = "VeryLazy" },
  { "echasnovski/mini.move", event = "VeryLazy" },
  -- alignment
  { "echasnovski/mini.align", event = "VeryLazy" },

  --   "dhruvasagar/vim-table-mode",
  --   lazy = false,
  --   -- ft = { "markdown", "pandoc", "vimwiki" },
  --   init = function()
  --     require("configs.vim-table-mode")
  --   end,
  -- },
  { "echasnovski/mini.doc", version = false, event = "VeryLazy" },
  {
    "echasnovski/mini.bracketed" --[[ , event = "VeryLazy" ]],
  },
  -- formatting
  { "ckolkey/ts-node-action", dependencies = { "nvim-treesitter" } },
  { "johmsalas/text-case.nvim", event = "VeryLazy" },
  { "echasnovski/mini.operators", version = false },

  {
    -- https://www.reddit.com/r/neovim/comments/1bq0cxy/minidiff_work_with_diff_hunks_interactively/
    -- keep this for operator  (dgc, dgb, cgc) and visual functions
    "mini.comment",
    dir = "~/.config/nvim/lua/mini/comment",
    event = "VeryLazy",
  },
  -- keep this for block functions
  { "numToStr/Comment.nvim", event = "VeryLazy" },
  { "andrewferrier/debugprint.nvim", event = "VeryLazy" },
  -- https://github.com/kr40/nvim-macros
  -- {
  --   "chrisgrieser/nvim-recorder",
  --   dependencies = "rcarriga/nvim-notify", -- optional
  --   opts = {}, -- required even with default settings, since it calls `setup()`
  -- },
  -- {
  --   "ecthelionvi/NeoComposer.nvim",
  --   event = "VeryLazy",
  --   dependencies = { "kkharji/sqlite.lua", "nvim-telescope/telescope.nvim" },
  -- },
  { "smilhey/ed-cmd.nvim", enabled = false },
  { "tpope/vim-repeat", event = "VeryLazy" },
  -- https://github.com/chentoast/live.nvim/tree/master
  { "Konfekt/vim-alias", event = "VeryLazy" },
  --
  -- pickers
  -- https://github.com/axkirillov/easypick.nvim
  -- https://github.com/adoyle-h/telescope-extension-maker.nvim
  -- https://github.com/adoyle-h/ad-telescope-extensions.nvim
  -- https://github.com/otavioschwanck/telescope-alternate.nvim
  -- https://github.com/lpoto/telescope-tasks.nvim
  -- "moevis/smartjump.nvim",
  -- "nvim-telescope/telescope-vimspector",
  -- "benfowler/telescope-luasnip.nvim",
  { "echasnovski/mini.fuzzy", event = "VeryLazy" },
  { "stevearc/oil.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "echasnovski/mini.files", version = false },
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    cmd = { "Neotree" },
    event = "VimEnter",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-web-devicons", "MunifTanjim/nui.nvim" },
  },
  { "moyiz/git-dev.nvim", event = "VeryLazy", opts = {} },
  { "neo451/feed.nvim", enabled = false },
  -- Lazy
  {
    "2kabhishek/nerdy.nvim",
    dependencies = { "stevearc/dressing.nvim", "nvim-telescope/telescope.nvim" },
    -- Running the python scripts/generator.py command will automatically fetch new icons from source and update the icons.
    cmd = "Nerdy",
  },
  -- https://github.com/2KAbhishek/pickme.nvim
  {
    -- 'njhoffman/telescope.nvim',
    "nvim-telescope/telescope.nvim",
    dir = "/home/nicholas/git/telescope.nvim",
    cmd = "Telescope",
    lazy = false,
    -- opts = { extensions = { gpt = { title = "Gpt Actions", } } },
    -- event = 'VeryLazy',
    dependencies = {
      "HPRIOR/telescope-gpt",
      "ElPiloto/telescope-vimwiki.nvim",
      "LinArcX/telescope-changes.nvim",
      "LinArcX/telescope-command-palette.nvim",
      "LinArcX/telescope-ports.nvim",
      "Zane-/cder.nvim",
      "Zane-/howdoi.nvim",
      "benfowler/telescope-luasnip.nvim",
      "camgraff/telescope-tmux.nvim",
      "cljoly/telescope-repo.nvim",
      "crispgm/telescope-heading.nvim",
      "dhruvmanila/telescope-bookmarks.nvim",
      "jonarrien/telescope-cmdline.nvim",
      "elianiva/telescope-npm.nvim",
      "frenchtoasters/telescope-kubectl.nvim",
      "nvim-web-devicons",
      "lpoto/telescope-docker.nvim",
      "molecule-man/telescope-menufacture",
      "smartpde/telescope-recent-files",
      "ghassan0/telescope-glyph.nvim",
      "Marskey/telescope-sg",
      "danielvolchek/tailiscope.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
      "dharmx/telescope-media.nvim",
      "nat-418/telescope-color-names.nvim",
      "piersolenski/telescope-import.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-ghq.nvim",
      "nvim-telescope/telescope-github.nvim",
      "nvim-telescope/telescope-hop.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-media-files.nvim",
      "nvim-telescope/telescope-node-modules.nvim",
      "nvim-telescope/telescope-rg.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-z.nvim",
      "dawsers/telescope-file-history.nvim",
      "Azeirah/nvim-redux",
      "catgoose/telescope-helpgrep.nvim",
      "paopaol/telescope-git-diffs.nvim",
      "ptethng/telescope-makefile",
      "rlch/github-notifications.nvim",
      "sbulav/telescope-terraform.nvim",
      "doctorfree/cheatsheet.nvim",
      "tamago324/telescope-openbrowser.nvim",
      "tsakirist/telescope-lazy.nvim",
      {
        "agoodshort/telescope-git-submodules.nvim",
        enabled = false,
        dependencies = {
          "akinsho/toggleterm.nvim",
        },
        config = function()
          require("telescope").load_extension("git_submodules")
          -- require("telescope").setup({
          --     extensions = {
          --       git_submodules = {
          --         git_cmd = "lazygit",
          --         previewer = true,
          --         terminal_id = 9,
          --         terminal_display_name = "Lazygit",
          --         diffview_keymap = "<C-d>",
          --       },
          --     },
          --   })
        end,
      },
      -- { "natecraddock/telescope-zf-native.nvim" },
      { "lalitmee/browse.nvim" },
      { "isak102/telescope-git-file-history.nvim", dependencies = { "tpope/vim-fugitive" } },
      -- {
      --   "fdschmidt93/telescope-egrepify.nvim",
      --   dependencies = { "nvim-lua/plenary.nvim" },
      -- },
      {
        "prochri/telescope-all-recent.nvim",
        dependencies = { "kkharji/sqlite.lua", "telescope-ui-select.nvim", "dressing.nvim" },
      },
      { "chip/telescope-code-fence.nvim", build = "luarocks --local install lunamark" },
      { "danielfalk/smart-open.nvim", dependencies = { "kkharji/sqlite.lua" } },
      { "nvim-telescope/telescope-smart-history.nvim", dependencies = { "kkharji/sqlite.lua" } },
      { "mvaldes14/terraform.nvim", dependencies = { "plenary.nvim", "nui.nvim" } },
      { "kkharji/sqlite.lua", run = "luarocks install sqlite luv" },
      { "nvim-telescope/telescope-frecency.nvim", dependencies = { "kkharji/sqlite.lua" } },
      { "nvim-telescope/telescope-fzy-native.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      -- https://github.com/ptdewey/yankbank-nvim
      -- https://github.com/mistricky/codesnap.nvim
      { "gbprod/yanky.nvim" },
      -- https://github.com/rktjmp/fwatch.nvim
      { "GustavoKatel/telescope-asynctasks.nvim", dependencies = { "skywind3000/asynctasks.vim" } },
      -- { "rmagatti/session-lens", dependencies = "rmagatti/auto-session" },
      -- https://github.com/sachinsenal0x64/hot.nvim
      { "PhilippFeO/telescope-filelinks.nvim" },
      { "octarect/telescope-menu.nvim" },
      {
        "paopaol/telescope-git-diffs.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
      },
    },
  },

  --
  -- git tools
  --
  -- https://github.com/dlvhdr/gh-blame.nvim
  -- https://github.com/ejrichards/baredot.nvim
  {
    -- https://vi.stackexchange.com/questions/42785/how-to-do-fuzzy-live-grep-on-git-files
    "moyiz/git-dev.nvim",
    config = function()
      -- local repo = vim.fn.input('Repository name / URI: ')
      -- git = {
      --    base_uri_format = "https://git.home.arpa/%s.git",
      --  }
      -- if repo ~= '' then
      --   require('git-dev').open(repo)
      -- end
    end,
    -- -- Change default URI
    -- opts = { git = { base_uri_format = "https://git.home.arpa/%s.git" } }
    -- -- Open my own repositories by name with SSH.
    -- -- E.g. "git-dev.nvim" rather than "moyiz/git-dev.nvim"
    -- opts = { git = { default_org = "moyiz", base_uri_format = "git@github.com:%s.git" } }
    -- -- Enforce only full URIs (do not accept partial names).
    -- opts = { git = { base_uri_format = "%s" } }
  },
  { "ray-x/forgit.nvim" },
  -- https://www.reddit.com/r/neovim/comments/1broo6b/my_git_github_workflow_an_efficient_yet_messy/
  { "rbong/vim-flog", cmd = { "Flog", "Flogsplit" } },
  { "ThePrimeagen/git-worktree.nvim", event = "VeryLazy" },
  { "napisani/nvim-github-codesearch", cmd = "GithubSearch", build = "make" },
  { "akinsho/git-conflict.nvim", version = "*", lazy = false },
  { "pwntester/octo.nvim", cmd = "Octo", dependencies = "nvim-web-devicons" },
  { "kdheepak/lazygit.nvim", cmd = "LazyGit" },
  { "lewis6991/gitsigns.nvim", event = "BufReadPost", dependencies = "nvim-lua/plenary.nvim" },
  {
    "lewis6991/satellite.nvim",
    enabled = false,
    event = "VeryLazy",
    init = function()
      vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
        desc = "User: Change `SatelliteQuickfix` color",
        callback = function()
          vim.api.nvim_set_hl(0, "SatelliteQuickfix", { link = "DiagnosticSignInfo" })
        end,
      })
    end,
    opts = {
      winblend = 10, -- only little transparency, since otherwise hard to see in some themes
      handlers = {
        cursor = { enable = false },
        marks = { enable = false },
      },
    },
  },
  { "rhysd/git-messenger.vim", cmd = "GitMessenger" },
  {
    "tpope/vim-fugitive",
    init = function()
      vim.g.fugitive_no_maps = 1
    end,
    event = { "BufReadPost", "BufNewFile" },
    cmd = {
      "Git",
      "Ggrep",
      "GMove",
      "GDelete",
      "Gspilt",
      "Gstatus",
      "Gwrite",
      "Gread",
      "Gdiffsplit",
      "Gedit",
    },
    dependencies = "tpope/vim-rhubarb",
  },
  -- https://github.com/sam4llis/nvim-lua-gf
  -- https://github.com/notomo/curstr.nvim/blob/master/doc/curstr.nvim.txt
  -- { 'tpope/vim-apathy' }
  -- tools and integrations
  --
  -- https://neovimcraft.com/plugin/otavioschwanck/tmux-awesome-manager.nvim
  -- https://www.reddit.com/r/neovim/comments/1bempth/neovim_project_management_with_tmux_zoxide_fzf/
  { "jbyuki/quickmath.nvim", cmd = "Quickmath" },
  { "michaelb/sniprun", build = "bash install.sh", cmd = { "SnipRun", "SnipInfo" } },
  { "milisims/nvim-luaref", event = "VeryLazy" },

  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = { "folke/snacks.nvim" },
    keys = {
      {
        "<leader>\\",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      --   {
      --     -- Open in the current working directory
      --     "<leader>cw",
      --     "<cmd>Yazi cwd<cr>",
      --     desc = "Open the file manager in nvim's working directory",
      --   },
      --   {
      --     "<c-up>",
      --     "<cmd>Yazi toggle<cr>",
      --     desc = "Resume the last yazi session",
      --   },
      -- },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
    -- additional lazy config to defer loading is not really needed...
    config = function()
      -- optional setup call to override plugin options
      -- alternatively you can set options with vim.g.grug_far = { ... }
      require("grug-far").setup({
        -- options, see Configuration section below
        -- there are no required options atm
      })
    end,
  },
  {
    "chrisgrieser/nvim-rip-substitute",
    cmd = "RipSubstitute",
    keys = {
      {
        "<leader>fs",
        function()
          require("rip-substitute").sub()
        end,
        mode = { "n", "x" },
        desc = " rip substitute",
      },
    },
  },
  { "windwp/nvim-spectre", cmd = "Spectre" },
  { "WaylonWalker/Telegraph.nvim", cmd = "Telegraph" },
  { "OXY2DEV/patterns.nvim" },
  {
    "bennypowers/nvim-regexplainer",
    cmd = { "RegexplainerShow", "RegexplainerToggle" },
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
  },
  -- { 'rmagatti/auto-session', event = 'VimEnter' },
  { "wakatime/vim-wakatime", enabled = false, event = "VeryLazy" },
  { "LunarVim/bigfile.nvim" },
  -- https://github.com/miversen33/netman.nvim
  {
    "glacambre/firenvim",
    build = ":call firenvim#install(0)",
    init = function()
      require("configs.firenvim__init")
    end,
  },
  { "lucamot/chrome-remote.nvim", event = "VeryLazy" },
  { "lucamot/chrome-dev-console.nvim", dependencies = { "lucamot/chrome-remote.nvim" } },
  { "altermo/nxwm", event = "VeryLazy", enabled = false },
  {
    "nvim-neotest/neotest",
    cmd = { "Neotest", "NeotestSummary", "NeotestNearest", "NeotestAttach" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-python",
      "rouge8/neotest-rust",
      "akinsho/neotest-go",
      "nvim-neotest/nvim-nio",
      "nvim-treesitter/nvim-treesitter",
      {
        "nvim-neotest/neotest-vim-test",
        dependencies = { "vim-test/vim-test", cmd = { "Test", "TestNearest", "TestFile" } },
      },
    },
  },

  { "smjonas/inc-rename.nvim" },
  -- quickfix file renamer
  {
    "gabrielpoca/replacer.nvim",
    opts = { rename_files = false },
    keys = {
      {
        "<leader>h",
        function()
          require("replacer").run()
        end,
        desc = "run replacer.nvim",
      },
    },
  },
  {
    "qpkorr/vim-renamer",
    init = function()
      vim.g.RenamerShowHiddenEnabled = true
    end,
  },
  { "cjodo/convert.nvim", dependencies = { "MunifTanjim/nui.nvim" } },
  {
    "jamestthompson3/nvim-remote-containers",
    cmd = {
      "BuildImage",
      "AttachToContainer",
      "StartImage",
      "ComposeUp",
      "ComposeDown",
      "ComposeDestroy",
    },
  },
  -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-visits.md
  { "LeonHeidelbach/trailblazer.nvim", enabled = false },
  { "kelly-lin/ranger.nvim", lazy = true },
  { "lambdalisue/suda.vim", event = "VeryLazy" },
  { "skywind3000/asynctasks.vim", event = "VeryLazy", dependencies = "skywind3000/asyncrun.vim" },
  { "aymericbeaumet/vim-symlink", event = "VeryLazy", dependencies = "moll/vim-bbye" },
  -- https://github.com/krady21/compiler-explorer.nvim
  {
    "t-troebst/perfanno.nvim",
    cmd = { "PerfLoadFlat", "PerfLoadCallGraph", "PerfLoadFlameGraph" },
  },
  { "chrisgrieser/nvim-genghis", event = "VeryLazy" },
  { "echasnovski/mini.test", lazy = true },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({})
    end,
  },
  -- curl https://til.hashrocket.com/api/developer_posts.json?username=doriankarter | jq
  -- https://github.com/nmiguel/jqscratch.nvim/tree/master
  {
    "cenk1cenk2/jq.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "grapp-dev/nui-components.nvim",
    },
  },
  {
    "gennaro-tedesco/nvim-jqx",
    event = { "BufReadPost" },
    ft = { "json", "yaml" },
    cmd = { "JqxList", "JqxQuery" },
    init = function()
      local jqx = require("nvim-jqx.config")
      jqx.geometry.border = "single"
      jqx.geometry.width = 0.7

      jqx.query_key = "X" -- keypress to query jq on keys
      jqx.sort = false -- show the json keys as they appear instead of sorting them alphabetically
      jqx.show_legend = true -- show key queried as first line in the jqx floating window
      jqx.use_quickfix = false -- if you prefer the location list
    end,
    -- Try it out directly with nvim examples/test.json -c JqxList.
    -- JqxList	populate the quickfix window with json keys
    -- JqxList string	populate the quickfix window with string values
    -- JqxQuery	executes a generic jq query in the current file
    -- <CR>	go to key location in file
    -- X	query values of key under cursor
    -- <Esc>	close floating window
    -- Why not automatically formatting your json files as you open them? Set up the autogroup
    -- local jqx = vim.api.nvim_create_augroup("Jqx", {})
    -- vim.api.nvim_clear_autocmds({ group = jqx })
    -- vim.api.nvim_create_autocmd("BufWinEnter", {
    -- pattern = { "*.json", "*.yaml" },
    -- desc = "preview json and yaml files on open",
    -- group = jqx,
    -- callback = function()
    -- vim.cmd.JqxList()
    -- end,
    -- })
  },
  { "yochem/jq-playground.nvim", opts = { cmd = { "gojq" } } },
  {
    "linrongbin16/fzfx.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "junegunn/fzf",
        -- optional for the 'fzf' command
        build = function()
          vim.fn["fzf#install"]()
        end,
      },
    },
    config = function()
      require("fzfx").setup()
    end,
  },
  { "npxbr/glow.nvim", cmd = "Glow" },
  -- { "NTBBloodbath/rest.nvim", cmd = { "RESTRunLast", "RESTRun", "RESTPreview" } },
  { "dbeniamine/cheat.sh-vim", cmd = "Cheat" },
  { "potamides/pantran.nvim", cmd = "Pantran" },
  { "sidebar-nvim/sidebar.nvim", cmd = { "SidebarNvimOpen", "SidebarNvimToggle" } },
  { "nvimtools/hydra.nvim", event = "VeryLazy" }, -- anuvyklack
  { "NvChad/nvim-colorizer.lua", event = { "BufReadPost", "BufNewFile" } },
  { "nvim-colortils/colortils.nvim", cmd = "Colortils", event = { "BufReadPost", "BufNewFile" } },
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = "leetcode.nvim" ~= vim.fn.argv()[1],
    opts = {
      arg = "leetcode.nvim",
    },
  },
  { "xeluxee/competitest.nvim", cmd = "CompetiTestRun", dependencies = "MunifTanjim/nui.nvim" },
  {
    -- A lua profiler for neovim that is discovered thanks to https://www.reddit.com/r/neovim/comments/xicxox/comment/ip2hprd
    "stevearc/profile.nvim",
    cond = function()
      return vim.env.NVIM_PROFILE ~= nil
    end,
  },
  { "sQVe/sort.nvim" },
  -- https://github.com/mbbill/undotree
  {
    "kevinhwang91/nvim-fundo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      local default_cfg = {
        -- archives_dir = {
        --   description = [[The directory to store the archives]],
        --   default = vim.fn.stdpath('cache') .. path.separator .. 'fundo',
        -- },
        -- limit_archives_size = {
        --   description = [[Limit the archives directory size, unit is MB(megabyte), elder files will be
        -- removed based on their modified time]],
        --   default = 512,
        -- },
      }
      require("fundo").install()
    end,
  },
  -- https://github.com/nfrid/due.nvim
  -- https://github.com/huantrinh1802/m_taskwarrior_d.nvim
  -- { "ribelo/taskwarrior.nvim" },
  -- {
  --   'mawkler/demicolon.nvim',
  --   -- keys = { ';', ',', 't', 'f', 'T', 'F', ']', '[', ']d', '[d' }, -- Uncomment this to lazy load
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --     'nvim-treesitter/nvim-treesitter-textobjects',
  --   },
  --   opts = {}
  -- },
  {
    "tools-life/taskwiki",
    cmd = { "TW", "TWSync" },
    build = "pip3 install --upgrade git+git://github.com/tbabej/tasklib@develop",
    dependencies = {
      {
        "vimwiki/vimwiki",
        branch = "dev",
        init = function()
          vim.g.vimwiki_filetypes = { "vimwiki", "markdown", "pandoc" }
          vim.g.vimwiki_global_ext = 0
          vim.g.vimwiki_key_mappings = { all_maps = 0 }
          -- vim.cmd([[let g:vimwiki_key_mappings = { 'all_maps': 0, }]])
        end,
      },
      "powerman/vim-plugin-AnsiEsc",
      "farseer90718/vim-taskwarrior",
      "preservim/tagbar",
    },
  },
  -- https://www.reddit.com/r/neovim/comments/1awiy1t/neovim_timetracking_system_using_timewarrior/
  {
    "mthbernardes/codeexplain.nvim",
    cmd = "CodeExplain",
    build = function()
      -- pip install -r langchain==0.0.177 llama-cpp-python==0.1.48 Pygments==2.15.1 pynvim==0.4.3
      vim.cmd([[silent UpdateRemotePlugins]])
    end,
  },
  -- https://github.com/wylie102/duckdb.yazi
  {
    "kndndrj/nvim-dbee",
    dependencies = { "MunifTanjim/nui.nvim" },
    build = function()
      -- Install tries to automatically detect the install method.
      -- if it fails, try calling it with one of these parameters: "curl", "wget", "bitsadmin", "go"
      require("dbee").install()
    end,
  },
  { "letieu/graphql.nvim" },
  -- https://github.com/mei28/luminate.nvim
  {
    "kndndrj/nvim-projector",
    event = { "VeryLazy" },
    dependencies = { "MunifTanjim/nui.nvim", "kndndrj/projector-neotest", "nvim-neotest/neotest" },
  },
  { "Shatur/neovim-session-manager", dependencies = "nvim-lua/plenary.nvim" },
  --
  -- filetypes
  --
  { "AndrewRadev/id3.vim", ft = "mp3" },
  { "susensio/magic-bang.nvim", event = "BufNewFile", cmd = "Bang" },
  { "ray-x/go.nvim", dependencies = { "ray-x/guihua.lua" }, ft = "go" },
  {
    "llllvvuu/nvim-js-actions",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
        },
        command = "nnoremap <buffer> gta "
          .. ":lua require('nvim-js-actions').js_arrow_fn.toggle()<CR>",
        -- can also do `require('nvim-js-actions/js-arrow-fn').toggle()`
      })
    end,
  },
  -- for rendering panda dataframes in dap using visidata
  -- https://github.com/Willem-J-an/visidata.nvim
  {
    "ten3roberts/qf.nvim",
    -- Unlike :cnext and :cprev, :Qnext and :Qprev will not navigate to valid entries which contain file names, as well as wrapping.
    -- :Qsave, :Qload:Qbelow, :Qabove, :Lbelow, Labove, etc will navigate to the next or previous entry relative to the cursor.
    -- However, unlike :cabove it will cross buffer boundaries.
  },
  {
    "maskudo/devdocs.nvim",
    lazy = false,
    enabled = true,
    cmd = { "DevDocs" },
    dependencies = { "folke/snacks.nvim" },
  },
  -- https://github.com/fredrikaverpil/godoc.nvim
  -- https://github.com/fredrikaverpil/pydoc.nvim
  -- https://github.com/Zeioth/markmap.nvim
  { "AckslD/nvim-FeMaco.lua", ft = { "markdown", "pandoc" } },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons", opts = {} },
  },
  {
    "lukas-reineke/headlines.nvim",
    enabled = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "markdown", "pandoc", "pandoc.markdown", "markdown.pandoc" },
  },
  { "njhoffman/markpan.nvim", enabled = false },
  -- "martinlroth/vim-acpi-asl"                # ACPI ASL
  -- "pearofducks/ansible-vim"                 # Ansible 2.x
  -- "sheerun/apiblueprint.vim"                # API Blueprint
  -- "mityu/vim-applescript"                   # AppleScript
  -- "sudar/vim-arduino-syntax"                # Arduino
  -- "asciidoc/vim-asciidoc"                   # AsciiDoc
  -- "aliou/bats.vim"                          # BATS
  -- "bazelbuild/vim-bazel"                    # Bazel
  -- "google/vim-maktaba"                      # Bazel
  -- "jwalton512/vim-blade"                    # Blade templates
  -- "bfontaine/Brewfile.vim"                  # Brewfile
  -- "vim-jp/vim-cpp"                          # C++
  -- "octol/vim-cpp-enhanced-highlight"        # C++
  -- "OrangeT/vim-csharp"                      # C#
  -- "OmniSharp/omnisharp-vim"                 # C#
  -- "isobit/vim-caddyfile"                    # Caddyfile
  -- "nastevens/vim-cargo-make"                # Cargo Make (Rust cargo extension)
  -- "mhinz/vim-crates"                        # Cargo.toml (Rust)
  -- "hellerve/carp-vim"                       # Carp
  -- "vadv/vim-chef"                           # Chef
  -- "mtscout6/vim-cjsx"                       # CJSX (JSX equivalent in CoffeeScript)
  -- "guns/vim-clojure-static"                 # Clojure
  -- "tpope/vim-fireplace"                     # Clojure
  -- "guns/vim-clojure-highlight"              # Clojure
  -- "pboettch/vim-cmake-syntax"               # Cmake
  -- "vhdirk/vim-cmake"                        # Cmake
  -- "kchmck/vim-coffee-script"                # CoffeScript
  -- "elubow/cql-vim"                          # Cassandra CQL
  -- "victoredwardocallaghan/cryptol.vim"      # Cryptol
  -- "vim-crystal/vim-crystal"                 # Crystal
  -- "hail2u/vim-css3-syntax"                  # CSS
  -- "chrisbra/csv.vim"                        # CSV
  -- "tpope/vim-cucumber"                      # Cucumber
  -- "mgrabovsky/vim-cuesheet"                 # Cue
  -- "jjaderberg/vim-syntax-cipher"            # Cypher
  -- "JesseKPhillips/d.vim"                    # D Lang
  -- "mlr-msft/vim-loves-dafny"                # Dafny
  -- "dart-lang/dart-vim-plugin"               # Dart
  -- "vmchale/dhall-vim"                       # Dhall
  -- "ekalinin/Dockerfile.vim"                 # Dockerfile
  -- "nastevens/vim-duckscript"                # Duckscript
  -- "elixir-editors/vim-elixir"               # Elixir
  -- "yalesov/vim-emblem"				      # Emblem
  -- "vim-erlang/vim-erlang-runtime"           # Erlang
  -- "vim-scripts/ferm.vim"                    # Ferm
  -- "georgewitteman/vim-fish"                 # Fish
  -- "dcharbon/vim-flatbuffers"                # Flatbuffers
  -- "kblin/vim-fountain"                      # Fountain
  -- "calviken/vim-gdscript3"                  # GDScript 3
  -- "tikhomirov/vim-glsl"                     # OpenGL Shading Language
  -- "gleam-lang/gleam.vim"                    # Gleam
  -- "maelvls/gmpl.vim"                        # GMPL
  -- "vim-scripts/gnuplot-syntax-highlighting" # GNUPlot
  -- "fatih/vim-go"                            # Go
  -- "tfnico/vim-gradle"                       # Gradle
  -- "jparise/vim-graphql"                     # GraphQL
  -- "hhvm/vim-hack"                           # Hack
  -- "sheerun/vim-haml"                        # Haml
  -- "mustache/vim-mustache-handlebars"        # Handlebars
  -- "CH-DanReif/haproxy.vim"                  # HAProxy
  -- "neovimhaskell/haskell-vim"               # Haskel
  -- "yaymukund/vim-haxe"                      # Haxe
  -- "b4b4r07/vim-hcl"                         # HCL
  -- "towolf/vim-helm"                         # Helm Templates
  -- "zebradil/hive.vim"                       # Hive
  -- "othree/html5.vim"                        # HTML5
  -- "mboughaba/i3config.vim"                  # i3
  -- "chutzpah/icalendar.vim"                  # icalendar
  -- "idris-hackers/idris-vim"                 # Idris
  -- "HiPhish/info.vim"                        # Info
  -- "vmchale/ion-vim"                         # Ion
  -- "jez/vim-ispc"                            # ISPC
  -- "pangloss/vim-javascript"                 # Javascript
  -- "briancollins/vim-jst"                    # JST
  -- "maxmellon/vim-jsx-pretty"                # JSX
  -- "martinda/Jenkinsfile-vim-syntax"         # Jenkins
  -- "lepture/vim-jinja"                       # Jinja
  -- "elzr/vim-json"                           # Json
  -- "GutenYe/json5.vim"                       # Json5
  -- "JuliaEditorSupport/julia-vim"            # Julia
  -- "udalov/kotlin-vim"                       # Kotlin
  -- "lervag/vimtex"                           # Latex
  -- "xuhdev/vim-latex-live-preview"           # Latex
  -- "ledger/vim-ledger"                       # Ledger
  -- "groenewege/vim-less"                     # Less
  -- "sersorrel/vim-lilypond"                  # Lilypond
  -- "gkz/vim-ls"                              # LiveScript
  -- "MTDL9/vim-log-highlighting"              # Log
  -- "tbastos/vim-lua"                         # Lua
  -- "jstrater/mpvim"                          # Macports
  -- "sophacles/vim-bundle-mako"               # Mako
  -- "plasticboy/vim-markdown"                 # Markdown
  -- "rhysd/vim-gfm-syntax"                    # Markdown (github)
  -- "voldikss/vim-mma"                        # Mathematica
  -- "daeyun/vim-matlab"                       # Matlab
  -- "jxnblk/vim-mdx-js"                       # MDX
  -- "stewy33/mercury-vim"                     # Mercury
  -- "leafo/moonscript-vim"                    # MoonScript
  -- "chr4/nginx.vim"                          # Nginx
  -- "zah/nim.vim"                             # Nim
  -- "LnL7/vim-nix"                            # Nix
  -- "b4winckler/vim-objc"                     # Objective-C
  -- "ocaml/vim-ocaml"                         # OCaml
  -- "McSinyx/vim-octave"                      # Octave
  -- "mcnelson/vim-pawn"                       # Pawn
  -- "vim-pandoc/vim-pandoc"                   # Pandoc
  -- "vim-pandoc/vim-pandoc-syntax"            # Pandoc
  -- "vim-perl/vim-perl"                       # PERL
  -- "lifepillar/pgsql.vim"                    # PostgreSQL
  -- "StanAngeloff/php.vim"                    # PHP
  -- "aklt/plantuml-syntax"                    # PlantUML
  -- "jakwings/vim-pony"                       # Ponylang
  -- "PProvost/vim-ps1"                        # PowerShell
  -- "adimit/prolog.vim"                       # Prolog
  -- "uarun/vim-protobuf"                      # Protocol Buffers
  -- "digitaltoad/vim-pug"                     # Pug template
  -- "rodjek/vim-puppet"                       # Puppet
  -- "purescript-contrib/purescript-vim"       # PureScript
  -- "vim-python/python-syntax"                # Python
  -- "Vimjas/vim-python-pep8-indent"           # Python
  -- "artoj/qmake-syntax-vim"                  # QMake
  -- "peterhoeg/vim-qml"                       # QML
  -- "jalvesaq/Nvim-R"                         # R
  -- "wlangstroth/vim-racket"                  # Racket
  -- "jneen/ragel.vim"                         # Ragel
  -- "Raku/vim-raku"                           # Raku
  -- "IN3D/vim-raml"                           # RAML
  -- "adamclerk/vim-razor"                     # Razor view engine
  -- "reasonml-editor/vim-reason-plus"         # Reason
  -- "keith/rspec.vim"                         # RSpec
  -- "marshallward/vim-restructuredtext"       # reStructuredText
  -- "vim-ruby/vim-ruby"                       # Ruby
  -- "rust-lang/rust.vim"                      # Rust
  -- "arzg/vim-rust-syntax-ext"                # Rust
  -- "derekwyatt/vim-sbt"                      # SBT
  -- "derekwyatt/vim-scala"                    # Scala
  -- "cakebaker/scss-syntax.vim"               # SCSS
  -- "arzg/vim-sh"                             # Shell
  -- "slim-template/vim-slim"                  # Slim
  -- "slime-lang/vim-slime-syntax"             # Slime
  -- "jez/vim-better-sml"                      # SML
  -- "bohlender/vim-smt2"                      # SMT-LIB2
  -- "tomlion/vim-solidity"                    # Solidity
  -- "tpope/vim-dotenv"                        # SQl
  -- "tpope/vim-dadbod"                        # SQl
  -- "kristijanhusak/vim-dadbod-completion"    # SQl
  -- "kristijanhusak/vim-dadbod-ui"            # SQl
  -- "cappyzawa/starlark.vim"                  # Starlark
  -- "hhsnopek/vim-sugarss"                    # Sugarss
  -- "wavded/vim-stylus"                       # Stylus
  -- "leafOfTree/vim-svelte-plugin"            # Svelte
  -- "jasonshell/vim-svg-indent"               # SVG
  -- "vim-scripts/svg.vim"                     # SVG
  -- "keith/swift.vim"                         # Swift
  -- "wgwoods/vim-systemd-syntax"              # Systemd
  -- "baskerville/vim-sxhkdrc"                 # SXHKD (bspwm)
  -- "hashivim/vim-terraform"                  # Terraform
  -- "timcharper/textile.vim"                  # Textile
  -- "solarnz/thrift.vim"                      # Thrift
  -- "ericpruitt/tmux.vim"                     # Tmux
  -- "wellbredgrapefruit/tomdoc.vim"           # TomDoc
  -- "cespare/vim-toml"                        # TOML
  -- "c-cube/vim-tptp"                         # TPTP
  -- "lumiliet/vim-twig"                       # Twig
  -- "HerringtonDarkholme/yats.vim"            # TypeScript
  -- "ollykel/v-vim"                           # V
  -- "arrufat/vala.vim"                        # Vala
  -- "vim-scripts/vbnet.vim"                   # VB.NET
  -- "smerrill/vcl-vim-plugin"                 # VCL
  -- "lepture/vim-velocity"                    # Velocity
  -- "vifm/vifm.vim"                           # vifm
  -- "suoto/vim-hdl"                           # VHDL
  -- "posva/vim-vue"                           # Vue
  -- "amal-khailtash/vim-xdc-syntax"           # XDC
  -- "vim-scripts/XSLT-syntax"                 # XSL
  -- "amadeus/vim-xml"                         # XML
  -- "stephpy/vim-yaml"                        # YAML
  -- "nathanalderson/yang.vim"                 # YANG
  -- "sheerun/vim-yardoc"                      # YARD Documentation
  -- "xwsoul/vim-zephir"                       # Zephir
  -- "ziglang/zig.vim"                         # Zig
  -- "zinit-zsh/zinit-vim-syntax"              # Zinit
  -- Plug 'martinda/Jenkinsfile-vim-syntax', { 'for': ['Jenkinsfile', 'groovy'] }
  -- Plug 'jvirtanen/vim-hcl', { 'for': ['nomad', 'hcl'] }
  -- KcPlug8 'puremourning/vimspector', {'on': '<Plug>VimspectorContinue'}  " Debugger
  -- KcPlugCoc 'neoclide/coc.nvim', {'branch': 'release'} " coc-nvim, for language server
  -- KcPlugCoc 'antoinemadec/coc-fzf', {'branch': 'release'} " Use FZF instead of coc.nvim built-in fuzzy finder
  -- KcPlugCoc 'kamilcuk/vim-lsp-cxx-highlight', { 'for': ['c', 'cpp'], 'dir': plugdir.'kamilcuk-vim-lsp-cxx-highlight'}
  -- " KcPlugCoc 'stefantb/vim-lsp-cxx-highlight', {'for': ['c', 'cpp'], 'dir': plugdir.'stefantb-vim-lsp-cxx-highlight'}
  -- Plug 'mrk21/yaml-vim', { 'for': [ 'yml', 'yaml' ] }
  -- Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
  -- hail2u/vim-css3-syntax	CSS3 syntax support to vim's built-in syntax/css.vim
  -- othree/csscomplete.vim	Updated built-in CSS complete with latest standards
  -- groenewege/vim-less	Syntax for LESS
  -- iloginow/vim-stylus	Syntax, indentation and autocomplete for Stylus
  -- mustache/vim-mustache-handlebars	Mustache and handlebars syntax
  -- digitaltoad/vim-pug	Pug (formerly Jade) syntax and indentation
  -- othree/html5.vim	HTML5 omnicomplete and syntax
  -- plasticboy/vim-markdown	Markdown syntax highlighting
  -- rhysd/vim-gfm-syntax	GitHub Flavored Markdown syntax highlight extension
  -- pangloss/vim-javascript	Enhanced Javascript syntax
  -- HerringtonDarkholme/yats.vim	Advanced TypeScript Syntax Highlighting
  -- MaxMEllon/vim-jsx-pretty	React JSX syntax pretty highlighting
  -- leafOfTree/vim-svelte-plugin	Syntax and indent plugin for Svelte
  -- heavenshell/vim-jsdoc	Generate JSDoc to your JavaScript code
  -- moll/vim-node	Superb development with Node.js
  -- posva/vim-vue	Syntax Highlight for Vue.js components
  -- fatih/vim-go	Go development
  -- vim-python/python-syntax	Enhanced version of the original Python syntax
  -- Vimjas/vim-python-pep8-indent	A nicer Python indentation style
  -- vim-scripts/python_match.vim	Extend the % motion for Python files
  -- StanAngeloff/php.vim	Up-to-date PHP syntax file (5.3 – 7.1 support)
  -- keith/swift.vim	Swift support
  -- rust-lang/rust.vim	Rust support
  -- vim-jp/syntax-vim-ex	Improved Vim syntax highlighting
  -- chrisbra/csv.vim	Handling column separated data
  -- tpope/vim-git	Git runtime files
  -- MTDL9/vim-log-highlighting	Syntax highlighting for generic log files
  -- cespare/vim-toml	Syntax for TOML
  -- mboughaba/i3config.vim	i3 window manager config syntax
  -- dag/vim-fish	Fish shell edit support
  -- jstrater/mpvim	Macports portfile configuration files
  -- robbles/logtash.vim	Highlights logstash configuration files
  -- IN3D/vim-raml	Syntax and language settings for RAML
  -- towolf/vim-helm	Syntax for Helm templates (yaml + gotmpl + sprig)
  { "iamcco/markdown-preview.nvim", build = "cd app && yarn install", cmd = "MarkdownPreview" },
  -- https://github.com/kiyoon/jupynium.nvim
  { "vuki656/package-info.nvim", dependencies = "MunifTanjim/nui.nvim", ft = "json" },
  { "serenevoid/kiwi.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "herringtondarkholme/yats.vim", ft = "typescript", lazy = lz_syn },
  -- https://github.com/AndrewRadev/inline_edit.vim
  { "njhoffman/vim-liquid", ft = "liquid", lazy = lz_syn },
  -- { 'moll/vim-node', ft = { 'javascript' }, lazy = lz_syn },
  { "bfrg/vim-jq", ft = "jq", lazy = lz_syn },
  -- { 'maxmellon/vim-jsx-pretty', ft = { 'javascript', 'jsx', 'javascriptreact' }, lazy = lz_syn },
  { "yuezk/vim-js", ft = { "javascript", "jsx", "javascriptreact" }, lazy = lz_syn },
  { "zdharma-continuum/zinit-vim-syntax", ft = "zsh", lazy = lz_syn },
  { "wgwoods/vim-systemd-syntax", ft = "systemd", lazy = lz_syn },
  { "aliou/bats.vim", ft = "bats", lazy = lz_syn },
  { "alx741/vim-hindent", ft = "haskell", lazy = lz_syn },
  { "cakebaker/scss-syntax.vim", ft = "scss", lazy = lz_syn },
  { "chr4/nginx.vim", ft = "nginx", lazy = lz_syn },
  { "ekalinin/dockerfile.vim", ft = "dockerfile", lazy = lz_syn },
  { "elzr/vim-json", ft = "json", lazy = lz_syn },
  { "ericpruitt/tmux.vim", ft = "tmux", lazy = lz_syn },
  { "euclidianace/betterlua.vim", ft = "lua", lazy = lz_syn },
  { "gisphm/vim-gitignore", ft = "gitignore", lazy = lz_syn },
  { "glench/vim-jinja2-syntax", ft = "jinja", lazy = lz_syn },
  { "gutenye/json5.vim", ft = "json5", lazy = lz_syn },
  { "jparise/vim-graphql", ft = "graphql", lazy = lz_syn },
  { "kchmck/vim-coffee-script", ft = "coffee", lazy = lz_syn },
  { "lifepillar/pgsql.vim", ft = "pgsql", lazy = lz_syn },
  { "lnl7/vim-nix", ft = "nix", lazy = lz_syn },
  { "neoclide/jsonc.vim", ft = "jsonc", lazy = lz_syn },
  { "neovimhaskell/haskell-vim", ft = "haskell", lazy = lz_syn },
  { "octol/vim-cpp-enhanced-highlight", ft = "cpp", lazy = lz_syn },
  { "pearofducks/ansible-vim", ft = "ansible", lazy = lz_syn },
  { "potatoesmaster/i3-vim-syntax", ft = "i3", lazy = lz_syn },
  { "rodjek/vim-puppet", ft = "puppet", lazy = lz_syn },
  { "stanangeloff/php.vim", ft = "php", lazy = lz_syn },
  { "tbastos/vim-lua", ft = "lua", lazy = lz_syn },
  { "tikhomirov/vim-glsl", ft = "glsl", lazy = lz_syn },
  { "vim-utils/vim-man", ft = "man", lazy = lz_syn },
  { "vim-crystal/vim-crystal", ft = "crystal", lz_sym = lz_syn },
  { "vimwiki/vimwiki", ft = { "markdown", "vimwiki" }, lazy = lz_syn },
  { "raimon49/requirements.txt.vim", event = "VeryLazy", lazy = lz_syn },
  { "godlygeek/tabular", event = "VeryLazy", lazy = lz_syn },
  { "preservim/vim-markdown", commit = "df4be86", dependencies = { "godlygeek/tabular" } },
  { "mtdl9/vim-log-highlighting", ft = { "log", "LOG" }, event = { "BufReadPost", "BufNewFile" } },
  { "hashivim/vim-terraform", ft = "terraform", event = { "BufReadPost", "BufNewFile" } },
}

utils.apply_configs(plugins)
return plugins
