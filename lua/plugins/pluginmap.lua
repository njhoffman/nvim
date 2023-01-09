local M = {}

M.skipped_plugins = {
  ["nvim-bufdel"] = { "ojroques/nvim-bufdel" },
  ["vista.vim"] = { "liuchengxu/vista.vim" },
  ["neo-tree"] = {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", "MunifTanjim/nui.nvim" },
  },
}

M.mapping_plugins = {
  ["debugprint"] = { "andrewferrier/debugprint.nvim" },
  ["vim-repeat"] = { "tpope/vim-repeat" },
  ["vim-alias"] = { "Konfekt/vim-alias" },
}

M.treesitter_plugins = {
  ["nvim-treesitter"] = { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", requires = "nvim-lua/plenary.nvim" },
  ["nvim-treesitter-context"] = { "romgrk/nvim-treesitter-context", requires = "nvim-treesitter" },
  ["nvim-treesitter-endwise"] = { "RRethy/nvim-treesitter-endwise" },
  ["nvim-treesitter-pairs"] = { "theHamsta/nvim-treesitter-pairs", requires = "nvim-treesitter" },
  ["nvim-treesitter-refactor"] = { "nvim-treesitter/nvim-treesitter-refactor", requires = "nvim-treesitter" },
  ["nvim-treesitter-textobjects"] = { "nvim-treesitter/nvim-treesitter-textobjects", requires = "nvim-treesitter" },
  ["nvim-treesitter-textsubjects"] = { "RRethy/nvim-treesitter-textsubjects", requires = "nvim-treesitter" },
  ["nvim-ts-autotag"] = { "windwp/nvim-ts-autotag", requires = "nvim-treesitter" },
  ["nvim-ts-context-commentstring"] = { "JoosepAlviste/nvim-ts-context-commentstring", requires = "nvim-treesitter" },
  ["nvim-ts-rainbow"] = { "p00f/nvim-ts-rainbow", requires = "nvim-treesitter" },
  ["playground"] = { "nvim-treesitter/playground", requires = "nvim-treesitter" },
  ["tree-sitter-ntangle"] = { "jbyuki/tree-sitter-ntangle" },
}

M.dap_plugins = {
  ["dap-install"] = { "Pocco81/DAPInstall.nvim" },
  ["nvim-dap"] = { "mfussenegger/nvim-dap" },
  ["nvim-dap-ui"] = {
    "rcarriga/nvim-dap-ui",
    requires = { "theHamsta/nvim-dap-virtual-text", "mfussenegger/nvim-dap" },
  },
  ["one-small-step-for-vimkind"] = { "jbyuki/one-small-step-for-vimkind", requires = "mfussenegger/nvim-dap" },
  ["nvim-dap-python"] = { "mfussenegger/nvim-dap-python", requires = "mfussenegger/nvim-dap" },
  ["dash.nvim"] = { "jbyuki/dash.nvim", requires = "jbyuki/ntangle.nvim" },
}

M.picker_plugins = {
  ["cybu.nvim"] = { "ghillb/cybu.nvim" },
  ["legendary.nvim"] = { "mrjones2014/legendary.nvim" },
  ["nvim-spotify"] = { "KadoBOT/nvim-spotify", requires = "nvim-telescope/telescope.nvim", run = "make" },
  ["tmuxjump.vim"] = { "shivamashtikar/tmuxjump.vim", requires = "nvim-telescope/telescope.nvim" },
}

M.motion_plugins = {
  ["substitute.nvim"] = { "gbprod/substitute.nvim" },
  -- ["vim-UnconditionalPaste"] = {
  --   "inkarkat/vim-UnconditionalPaste",
  --   requires = "inkarkat/vim-ingo-library",
  -- },
  ["bufjump.nvim"] = { "kwkarlwang/bufjump.nvim" },
  ["vim-matchup"] = { "andymass/vim-matchup" },
  ["vim-wordmotion"] = { "chaoren/vim-wordmotion" },
  ["vim-smoothie"] = { "psliwka/vim-smoothie", commit = "10fd0aa" }, -- f2aaab1
  ["vim-searchsavy"] = { "idbrii/vim-searchsavvy" },
  ["clever-f"] = { "~/git/clever-f.vim" }, -- rhysd/clever-f.vim
  ["nvim-femaco.lua"] = { "AckslD/nvim-FeMaco.lua" },
  ["markdown-preview.nvim"] = { "iamcco/markdown-preview.nvim", run = "cd app && yarn install" },
  ["neuron.nvim"] = {
    "njhoffman/neuron.nvim",
    requires = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  -- ["vim-sandwhich"] = {"machakann/vim-sandwich"},
  -- ["marks.nvim"]            = { "chentoast/marks.nvim" },
  -- ["neuron-v2.vim"]         = { "chiefnoah/neuron-v2.vim" },
}

M.format_plugins = {
  -- ["kommentary"]      = { "b3nj5m1n/kommentary" },
  ["Comment.nvim"] = { "numToStr/Comment.nvim" },
  ["inc-rename.nvim"] = { "smjonas/inc-rename.nvim" },
  ["nvim-autopairs"] = { "windwp/nvim-autopairs" }, -- jiangmiao/auto-pairs
  ["nvim-surround"] = { "kylechui/nvim-surround" },
  ["escape.nvim"] = { "m-gail/escape.nvim" },
  ["splitjoin.vim"] = { "andrewradev/splitjoin.vim" }, --  https://github.com/FooSoft/vim-argwrap
  ["nvim-trevJ"] = { "AckslD/nvim-trevJ.lua" },
  ["vim-easy-align"] = { "~/git/vim-easy-align" }, -- { "junegunn/vim-easy-align" }, -- tommcdo/vim-lion
  ["vim-table-mode"] = { "dhruvasagar/vim-table-mode" },
  ["dial.nvim"] = { "monaqa/dial.nvim" },
  ["iswap.nvim"] = { "mizlan/iswap.nvim" },
  ["text-case.nvim"] = { "johmsalas/text-case.nvim" },
  ["vim-camelsnek"] = { "nicwest/vim-camelsnek" },
  ["vim-checkbox"] = { "jkramer/vim-checkbox" },
  ["vim-sort-motion"] = { "christoomey/vim-sort-motion" },
  ["telekasten.nvim"] = { "renerocksai/telekasten.nvim", requires = { "renerocksai/calendar-vim" } },
  -- https://github.com/Furkanzmc/zettelkasten.nvim
  -- https://github.com/phaazon/mind.nvim
  -- https://github.com/mickael-menu/zk-nvim
}

M.syntax_plugins = {
  ["BetterLua.vim"] = { "euclidianace/betterlua.vim" },
  ["Dockerfile.vim"] = { "ekalinin/dockerfile.vim" },
  ["alchemist.vim"] = { "slashmili/alchemist.vim" },
  ["ansible-vim"] = { "pearofducks/ansible-vim" },
  ["bat.vim"] = { "jamespwilliams/bat.vim" },
  ["bats.vim"] = { "aliou/bats.vim" },
  ["conflict-marker.vim"] = { "rhysd/conflict-marker.vim" },
  ["dash.vim"] = { "rizzatti/dash.vim" },
  ["editorconfig-vim"] = { "editorconfig/editorconfig-vim" },
  ["elm-vim"] = { "elmcast/elm-vim" },
  ["emmet-vim"] = { "mattn/emmet-vim" },
  ["glow.nvim"] = { "npxbr/glow.nvim" },
  ["haskell-vim"] = { "neovimhaskell/haskell-vim" },
  ["i3-vim-syntax"] = { "potatoesmaster/i3-vim-syntax" },
  ["jshint.vim"] = { "vim-scripts/jshint.vim" },
  ["json5.vim"] = { "gutenye/json5.vim" },
  ["jsonc.vim"] = { "neoclide/jsonc.vim" },
  ["mkdx"] = { "SidOfc/mkdx" },
  ["nginx.vim"] = { "chr4/nginx.vim" },
  ["pgsql.vim"] = { "lifepillar/pgsql.vim" },
  ["php.vim"] = { "stanangeloff/php.vim" },
  ["requirements.txt.vim"] = { "raimon49/requirements.txt.vim" },
  ["scss-syntax.vim"] = { "cakebaker/scss-syntax.vim" },
  ["tabular"] = { "godlygeek/tabular" },
  ["tmux.vim"] = { "ericpruitt/tmux.vim" },
  ["vim-autoprefixer"] = { "Ioannis-Kapoulas/vim-autoprefixer" },
  ["vim-coffee-script"] = { "kchmck/vim-coffee-script" },
  ["vim-cpp-enhanced-highlight"] = { "octol/vim-cpp-enhanced-highlight" },
  ["vim-elixir"] = { "elixir-lang/vim-elixir" },
  ["vim-fireplace"] = { "tpope/vim-fireplace" },
  ["vim-git"] = { "tpope/vim-git" },
  ["vim-gitignore"] = { "gisphm/vim-gitignore" },
  ["vim-glsl"] = { "tikhomirov/vim-glsl" },
  ["vim-graphql"] = { "jparise/vim-graphql" },
  ["vim-hindent"] = { "alx741/vim-hindent" },
  ["vim-jinja2-syntax"] = { "glench/vim-jinja2-syntax" },
  ["vim-jq"] = { "bfrg/vim-jq" },
  ["vim-js"] = { "yuezk/vim-js" },
  ["vim-jsbeautify"] = { "maksimr/vim-jsbeautify" },
  ["vim-json"] = { "elzr/vim-json" },
  ["vim-jsx-pretty"] = { "maxmellon/vim-jsx-pretty" },
  ["vim-kubernetes"] = { "andrewstuart/vim-kubernetes" },
  ["vim-liquid"] = { "njhoffman/vim-liquid" },
  ["vim-log-highlighting"] = { "mtdl9/vim-log-highlighting" },
  ["vim-lua"] = { "tbastos/vim-lua" },
  ["vim-man"] = { "njhoffman/vim-man" }, -- {"vim-utils/vim-man"},
  ["vim-nix"] = { "lnl7/vim-nix" },
  ["vim-node"] = { "moll/vim-node" },
  ["vim-pandoc-syntax"] = { "vim-pandoc/vim-pandoc-syntax" },
  ["vim-puppet"] = { "rodjek/vim-puppet" },
  ["vim-salve"] = { "tpope/vim-salve" },
  ["vim-systemd-syntax"] = { "wgwoods/vim-systemd-syntax" },
  ["vim-terraform"] = { "hashivim/vim-terraform" },
  ["yats.vim"] = { "herringtondarkholme/yats.vim" },
  ["zinit-vim-syntax"] = { "zdharma-continuum/zinit-vim-syntax" },
  -- use "kchmck/vim-coffee-script"
  -- use "plasticboy/vim-markdown"
  -- use "tpope/vim-liquid"
  -- use "xolox/vim-lua-inspect"
  -- use { "xolox/vim-lua-ftplugin", requires = "xolox/vim-misc" }
}

M.telescope_plugins = {
  ["sqlite"] = { "tami5/sqlite.lua" },
  ["nvim-web-devicons"] = { "kyazdani42/nvim-web-devicons" },
  ["telescope.nvim"] = {
    "~/git/telescope.nvim",
    -- "njhoffman/telescope.nvim",
    -- "nvim-telescope/telescope.nvim",
    requires = {
      "kyazdani42/nvim-web-devicons",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
    },
  },
  ["nvim-neoclip.lua"] = { "AckslD/nvim-neoclip.lua", requires = { "tami5/sqlite.lua", module = "sqlite" } },
  ["cheatsheet.nvim"] = { "sudormrfbin/cheatsheet.nvim" },
  ["dir-telescope.nvim"] = { "princejoogie/dir-telescope.nvim" },
  ["telescope-arecibo.nvim"] = { "nvim-telescope/telescope-arecibo.nvim" },
  ["telescope-asynctasks.nvim"] = {
    "GustavoKatel/telescope-asynctasks.nvim",
    requires = "skywind3000/asynctasks.vim",
  },
  ["telescope-bookmarks.nvim"] = { "dhruvmanila/telescope-bookmarks.nvim" },
  ["telescope-command-palette.nvim"] = { "LinArcX/telescope-command-palette.nvim" },
  ["telescope-dap.nvim"] = { "nvim-telescope/telescope-dap.nvim" },
  ["telescope-file-browser.nvim"] = { "nvim-telescope/telescope-file-browser.nvim" },
  ["telescope-frecency.nvim"] = { "nvim-telescope/telescope-frecency.nvim", requires = { "tami5/sqlite.lua" } },
  ["telescope-fzf-native.nvim"] = { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
  ["telescope-ghq.nvim"] = { "nvim-telescope/telescope-ghq.nvim" },
  ["telescope-makefile"] = { "ptethng/telescope-makefile" },
  ["telescope-github.nvim"] = { "nvim-telescope/telescope-github.nvim" },
  ["telescope-heading.nvim"] = { "crispgm/telescope-heading.nvim" },
  ["telescope-hop.nvim"] = { "nvim-telescope/telescope-hop.nvim" },
  ["telescope-kubectl.nvim"] = { "frenchtoasters/telescope-kubectl.nvim" },
  ["telescope-media-files.nvim"] = { "nvim-telescope/telescope-media-files.nvim" },
  ["telescope-node-modules.nvim"] = { "nvim-telescope/telescope-node-modules.nvim" },
  ["telescope-npm.nvim"] = { "elianiva/telescope-npm.nvim" },
  ["telescope-color-names.nvim"] = { "nat-418/telescope-color-names.nvim" },
  ["telescope-openbrowser.nvim"] = { "tamago324/telescope-openbrowser.nvim" },
  ["telescope-packer.nvim"] = { "nvim-telescope/telescope-packer.nvim" },
  ["telescope-repo.nvim"] = { "cljoly/telescope-repo.nvim" },
  ["telescope-rg.nvim"] = {
    "nvim-telescope/telescope-rg.nvim",
    requires = { "nvim-telescope/telescope-live-grep-args.nvim" },
  },
  ["telescope-symbols.nvim"] = { "nvim-telescope/telescope-symbols.nvim" },
  ["telescope-ui-select.nvim"] = { "nvim-telescope/telescope-ui-select.nvim" },
  ["telescope-vimwiki.nvim"] = { "ElPiloto/telescope-vimwiki.nvim" },
  ["telescope-z.nvim"] = { "nvim-telescope/telescope-z.nvim" },
  ["session-lens"] = { "rmagatti/session-lens" },
  ["telescope-changes.nvim"] = { "LinArcX/telescope-changes.nvim" },
  ["telescope-luasnip.nvim"] = { "benfowler/telescope-luasnip.nvim" },
  ["telescope-tmux.nvim"] = { "camgraff/telescope-tmux.nvim" },
  ["telescope-ports.nvim"] = { "LinArcX/telescope-ports.nvim" },
  ["github-notifications.nvim"] = { "rlch/github-notifications.nvim" },
  ["cder.nvim"] = { "Zane-/cder.nvim" },
  ["howdoi.nvim"] = { "Zane-/howdoi.nvim" },
  -- {"chip/telescope-code-fence.nvim", run = "luarocks --local install lunamark" },
  -- "keyvchan/telescope-find-pickers.nvim",
  -- "LinArcX/telescope-env.nvim",
  -- "moevis/smartjump.nvim",
  -- "nvim-telescope/telescope-vimspector",
  -- "benfowler/telescope-luasnip.nvim",
}

M.completion_plugins = {
  ["nvim-cmp"] = { "hrsh7th/nvim-cmp" },
  ["cmp-nvim-lsp-document-symbol"] = { "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp" },
  ["cmp-emoji"] = { "hrsh7th/cmp-emoji", after = "nvim-cmp" },
  ["cmp-nvim-lua"] = { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
  ["cmp-nvim-lsp"] = { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
  ["cmp-cmdline-history"] = { "dmitmel/cmp-cmdline-history", after = "nvim-cmp" },
  ["cmp-calc"] = { "hrsh7th/cmp-calc", after = "nvim-cmp" },
  -- ["cmp-omni"] = { "hrsh7th/cmp-omni", after = "nvim-cmp" },
  ["cmp-cmdline"] = { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
  ["cmp-fuzzy-path"] = {
    "tzachar/cmp-fuzzy-path",
    requires = { "hrsh7th/nvim-cmp", "tzachar/fuzzy.nvim" },
  },
  ["cmp-fuzzy-buffer"] = {
    "tzachar/cmp-fuzzy-buffer",
    requires = { "hrsh7th/nvim-cmp", "tzachar/fuzzy.nvim" },
  },
  ["cmp_luasnip"] = {
    "saadparwaiz1/cmp_luasnip",
    after = "nvim-cmp",
    requires = "L3MON4D3/LuaSnip",
  },
  ["cmp-nvim-lsp-signature-help"] = { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" },
  ["cmp-treesitter"] = { "ray-x/cmp-treesitter", after = "nvim-cmp" },
  ["cmp-spell"] = { "f3fora/cmp-spell", after = "nvim-cmp" },
  ["cmp-npm"] = { "David-Kunz/cmp-npm", after = "nvim-cmp" },
  ["cmp-vimwiki-tags"] = { "pontusk/cmp-vimwiki-tags", after = "nvim-cmp" },
  ["cmp-pandoc-references"] = { "jc-doyle/cmp-pandoc-references", after = "nvim-cmp" },
  ["cmp-git"] = {
    "petertriho/cmp-git",
    requires = "nvim-lua/plenary.nvim",
    after = "nvim-cmp",
  },
  ["cmp-tmux"] = { "andersevenrud/cmp-tmux", after = "nvim-cmp" },
  ["LuaSnip"] = { "L3MON4D3/LuaSnip" },
  ["LuaSnip-snippets.nvim"] = { "molleweide/LuaSnip-snippets.nvim" },
  ["friendly-snippets"] = { "rafamadriz/friendly-snippets" },
  ["vim-snippets"] = { "honza/vim-snippets" },
  ["vs-snippets"] = { "kitagry/vs-snippets" },
  ["nvim-luaref"] = { "milisims/nvim-luaref" },
  ["luv-vimdocs"] = { "nanotee/luv-vimdocs" },
  ["vscode-es7-javascript-react-snippets"] = {
    "dsznajder/vscode-es7-javascript-react-snippets",
    run = "yarn install --frozen-lockfile && yarn compile",
  },
  -- ["cmp-tabnine"] = { "tzachar/cmp-tabnine", run = "./install.sh", after = "nvim-cmp" },
}

M.ui_plugins = {
  ["aerial.nvim"] = { "stevearc/aerial.nvim" },
  ["nui.nvim"] = { "MunifTanjim/nui.nvim" },
  ["dressing-nvim"] = { "stevearc/dressing.nvim", requires = "MunifTanjim/nui.nvim" },
  ["nvim-hlslens"] = { "kevinhwang91/nvim-hlslens" },
  ["nvim-notify"] = { "~/git/nvim-notify" },
  ["nvim-scrollbar"] = { "petertriho/nvim-scrollbar" },
  ["specs.nvim"] = { "edluffy/specs.nvim" },
  ["stabilize.nvim"] = { "luukvbaal/stabilize.nvim" },
  ["todo-comments.nvim"] = { "robertgzr/todo-comments.nvim" }, -- folke/todo-comments
  ["twilight.nvim"] = { "folke/twilight.nvim" },
  ["vim-HiLinkTrace"] = { "gerw/vim-HiLinkTrace" },
  ["vim-bling"] = { "ivyl/vim-bling" },
  ["vim-cool"] = { "romainl/vim-cool" },
  ["nvim-colorizer"] = { "norcalli/nvim-colorizer.lua" },
  ["vim-plugin-AnsiEsc"] = { "joeysino/vim-plugin-AnsiEsc" },
  ["vimade"] = { "TaDaa/vimade" },
  ["which-key.nvim"] = { "~/git/which-key.nvim" },
  -- ["which-key.nvim"]     = { "folke/which-key.nvim" },
  ["zen-mode.nvim"] = { "folke/zen-mode.nvim" },
  ["hop.nvim"] = { "phaazon/hop.nvim" },

  ["nvim-nonicons"] = {
    "yamatsum/nvim-nonicons",
    requires = { "kyazdani42/nvim-web-devicons", "yamatsum/nonicons" },
    cond = os.getenv("KITTY_WINDOW_ID") ~= nil,
  },
  ["hologram.nvim"] = { "edluffy/hologram.nvim", cond = os.getenv("KITTY_WINDOW_ID") ~= nil },
  ["tabout.nvim"] = {
    "abecodes/tabout.nvim",
    wants = { "nvim-treesitter" }, -- or require if not used so far
    after = { "nvim-cmp" }, -- if a completion plugin is using tabs load it before
    config = function()
      require("plugins.configs.tabout")
    end,
  },
  -- ["nvim-highlight-colors"] = { "brenoprata10/nvim-highlight-color" },
  -- ["vim-hexokinase"]     = { "RRethy/vim-hexokinase", run = "make hexokinase" },
  -- ["startup.nvim"] = {
  --   use = {"startup-nvim/startup.nvim", requires = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"}}
  -- },
  -- ["icon-picker.nvim"] = { "ziontee113/icon-picker.nvim"}
  -- ["vim-visual-multi"] = { "mg979/vim-visual-multi" },
  -- ["wilder.nvim"] = {
  --   "gelguy/wilder.nvim",
  --   rocks = { "luarocks-fetch-gitrec", "pcre2" },
  --   requires = { "romgrk/fzy-lua-native", "kyazdani42/nvim-web-devicons" }
  -- }
}

M.project_plugins = {
  ["auto-session"] = { "rmagatti/auto-session" },
  -- ["competitest.nvim"] = { "xeluxee/competitest.nvim", requires = "MunifTanjim/nui.nvim" },
  ["cpbooster.vim"] = { "searleser97/cpbooster.vim" },
  ["gitsigns.nvim"] = { "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } },
  ["octo.nvim"] = { "pwntester/octo.nvim", requires = "kyazdani42/nvim-web-devicons" },
  ["vim-flog"] = { "rbong/vim-flog" },
  ["vim-fugitive"] = { "tpope/vim-fugitive" },
  ["vim-rhubarb"] = { "tpope/vim-rhubarb" },
  ["vim-wakatime"] = { "wakatime/vim-wakatime" },
}

M.interface_plugins = {
  ["numb.nvim"] = { "nacro90/numb.nvim" },
  ["goto-preview"] = { "rmagatti/goto-preview" },
  ["alpha-nvim"] = { "goolord/alpha-nvim", requires = "kyazdani42/nvim-web-devicons" },
  ["diffview.nvim"] = { "sindrets/diffview.nvim" },
  ["live-command.nvim"] = { "smjonas/live-command.nvim" },
  ["nvim-bqf"] = { "kevinhwang91/nvim-bqf" },
  ["nvim-tree.lua"] = { "kyazdani42/nvim-tree.lua" },
  ["nvim-ufo"] = { "kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async" },
  ["perfanno.nvim"] = { "t-troebst/perfanno.nvim" },
  ["quickmath.nvim"] = { "jbyuki/quickmath.nvim" },
  ["registers.nvim"] = { "tversteeg/registers.nvim" },
  ["vim-floaterm"] = { "voldikss/vim-floaterm" },
  ["undotree"] = { "mbbill/undotree" },
  ["vim-qf"] = { "romainl/vim-qf" },
  ["vim-yoink"] = { "svermeulen/vim-yoink" },
  -- ["codewindow.nvim"] = { "gorbit99/codewindow.nvim" },
  -- https://github.com/anuvyklack/windows.nvim
  -- ["yank-history"] = {"yazgoo/yank-history"},
  -- ["vim-mundo"] = { "simnalamburt/vim-mundo" },
}

M.integration_plugins = {
  ["asynctasks.vim"] = { "skywind3000/asynctasks.vim", requires = "skywind3000/asyncrun.vim" },
  ["tasks.nvim"] = { "GustavoKatel/tasks.nvim" },
  ["pantran.nvim"] = { "potamides/pantran.nvim" },
  ["colortils.nvim"] = { "nvim-colortils/colortils.nvim" },
  -- https://github.com/uga-rosa/ccc.nvim
  ["cheat.sh-vim"] = { "dbeniamine/cheat.sh-vim" },
  ["go.nvim"] = { "ray-x/go.nvim", requires = "ray-x/guihua.lua" },
  ["id3.vim"] = { "AndrewRadev/id3.vim" }, -- "AndrewRadev/id3.vim"
  ["nvim-magic"] = {
    "jameshiew/nvim-magic",
    requires = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
  },
  ["sniprun"] = { "michaelb/sniprun", run = "bash ./install.sh" },
  ["package-info.nvim"] = { "vuki656/package-info.nvim", requires = "MunifTanjim/nui.nvim" },
  ["vim-ripple"] = { "urbainvaes/vim-ripple" },
  ["vim-test"] = { "vim-test/vim-test" },
  ["rest.nvim"] = { "NTBBloodbath/rest.nvim" },
  ["lazygit.nvim"] = { "kdheepak/lazygit.nvim" },
  -- ["tmux.nvim"] = { "aserowy/tmux.nvim" },
  ["Telegraph.nvim"] = { "WaylonWalker/Telegraph.nvim" },
  ["nvim-regexplainer"] = {
    "bennypowers/nvim-regexplainer",
    requires = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
  },
}

M.sysutil_plugins = {
  -- ["structlog"] = { "Tastyep/structlog.nvim" },
  ["vim-renamer"] = { "qpkorr/vim-renamer" },
  ["nvim-remote-containers"] = { "jamestthompson3/nvim-remote-containers" },
  ["suda.vim"] = { "lambdalisue/suda.vim" },
  ["vim-symlink"] = { "aymericbeaumet/vim-symlink" },
  ["vim-profiler"] = { "bchretien/vim-profiler" },
  ["startuptime.vim"] = { "tweekmonster/startuptime.vim" },
  ["plenary.nvim"] = { "nvim-lua/plenary.nvim" },
}

M.lsp_plugins = {
  ["nvim-lspconfig"] = { "neovim/nvim-lspconfig" },
  ["mason.nvim"] = {
    "williamboman/mason.nvim",
    requires = {
      "neovim/nvim-lspconfig",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
  },
  -- use("rust-lang/rust.vim")
  --  use("simrat39/rust-tools.nvim") -- additional rust goodies, mostly lsp related
  ["nvim-navic"] = { "SmiteshP/nvim-navic" },
  ["zk-nvim"] = { "mickael-menu/zk-nvim" },
  ["schemastore.nvim"] = { "b0o/schemastore.nvim" }, -- for jsonls
  ["fidget.nvim"] = { "~/git/fidget.nvim" }, -- "j-hui/fidget.nvim"
  ["nvim-lint"] = { "mfussenegger/nvim-lint" },
  ["null-ls.nvim"] = {
    "jose-elias-alvarez/null-ls.nvim",
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1110
    commit = "76d0573fc159839a9c4e62a0ac4f1046845cdd50",
    requires = "nvim-lua/plenary.nvim",
  },
  ["neodev.nvim"] = { "folke/neodev.nvim" },
  ["lsp-colors.nvim"] = { "folke/lsp-colors.nvim" },
  ["nvim-lightbulb"] = { "kosayoda/nvim-lightbulb" },
  ["lsp_signature.nvim"] = { "ray-x/lsp_signature.nvim" },
  ["lspsaga.nvim"] = { "tami5/lspsaga.nvim" },
  ["nvim-code-action-menu"] = { "weilbith/nvim-code-action-menu", cmd = "CodeActionMenu" },
  -- ["nvim-lsp-installer"]    = { "williamboman/nvim-lsp-installer", requires = "neovim/nvim-lspconfig" },
  ["trouble.nvim"] = { "folke/trouble.nvim" },
  ["ntangle-lsp.nvim"] = {
    "jbyuki/ntangle-lsp.nvim",
    requires = { "jbyuki/ntangle-ts.nvim", "neovim/nvim-lspconfig" },
  },
  ["sqls.nvim"] = { "nanotee/sqls.nvim", after = "nvim-lspconfig" },
}

M.theme_plugins = {
  ["lush.nvim"] = { "rktjmp/lush.nvim" },
  ["feline.nvim"] = { "feline-nvim/feline.nvim" },
  ["barbar"] = { "romgrk/barbar.nvim" },
}

M.check_require_exists = function(fname)
  local res = pcall(require, fname)
  return res
end

local uv = require("luv")
M.check_path_exists = function(path)
  return not vim.tbl_isempty(uv.fs_stat(path) or {})
end

M.split_env = function(env_name, sep)
  if sep == nil then
    sep = "%s"
  end
  local env_table = {}
  for str in string.gmatch(env_name, "{[^" .. sep .. "]+}") do
    table.insert(env_table, str)
  end
  return env_table
end

M.concat_array = function(a, b)
  return table.move(b, 1, #b, #a + 1, a)
end

M.stats = {
  skipped = 0,
  disabled = 0,
  loaded = 0,
  lazy_loaded = 0,
  local_loaded = 0,
  fork_loaded = 0,
  config_loaded = 0,
}

M.load_config = function(fname)
  -- print("CONFIG ", fname)
  M.stats.config_loaded = M.stats.config_loaded + 1
  vim.import(fname)
end

M.plugin_config = function(name)
  local check_require = false
  name = name:gsub("[\\.]+", "-")
  local fname = "plugins.config." .. string.lower(name)
  local fpath = vim.fn.stdpath("config") .. "/lua/plugins/config/" .. string.lower(name) .. ".lua"
  local config = nil

  -- print('checking ' .. fname .. ' - ' .. fpath)
  if check_require then
    if M.check_require_exists(fname) then
      config = M.load_config(fname)
      -- else print("config not found: " .. fname)
    end
  else
    if M.check_path_exists(fpath) then
      config = M.load_config(fname)
      -- else print("config not found: " .. fpath)
    end
  end
  return config
end

M.load_plugins = function(use, load_config)
  local env_lazy = os.getenv("NVIM_PLUGINS_LAZY")
  local env_disable = os.getenv("NVIM_PLUGINS_DISABLE")
  local env_skip = os.getenv("NVIM_PLUGINS_SKIP")

  -- local lazy = M.concat_array(env_lazy, load_config.lazy)
  -- local disable = M.concat_array(env_disable, load_config.disable)
  -- local skip = M.concat_array(env_skip, load_config.skip)

  local all_plugins = {
    M.theme_plugins,
    M.completion_plugins,
    M.mapping_plugins,
    M.dap_plugins,
    M.format_plugins,
    M.integration_plugins,
    M.interface_plugins,
    M.motion_plugins,
    M.picker_plugins,
    M.project_plugins,
    M.syntax_plugins,
    M.sysutil_plugins,
    M.telescope_plugins,
    M.treesitter_plugins,
    M.ui_plugins,
    M.lsp_plugins,
  }

  for _, plugin_set in pairs(all_plugins) do
    for name, plugin in pairs(plugin_set) do
      -- print(vim.inspect(plugin_item))
      if type(plugin) == "string" then
        plugin = { plugin }
      end

      local plugin_config = plugin.config or M.plugin_config(name)

      if plugin_config ~= nil then
        plugin.config = plugin_config
      end

      M.stats.loaded = M.stats.loaded + 1
      use(plugin)
    end
  end

  return M.stats
end

return M

-- use {
--   'myusername/example',        -- The plugin location string
--   -- The following keys are all optional
--   disable = boolean,           -- Mark a plugin as inactive
--   as = string,                 -- Specifies an alias under which to install the plugin
--   installer = function,        -- Specifies custom installer. See "custom installers" below.
--   updater = function,          -- Specifies custom updater. See "custom installers" below.
--   after = string or list,      -- Specifies plugins to load before this plugin. See "sequencing" below
--   rtp = string,                -- Specifies a subdirectory of the plugin to add to runtimepath.
--   opt = boolean,               -- Manually marks a plugin as optional.
--   branch = string,             -- Specifies a git branch to use
--   tag = string,                -- Specifies a git tag to use
--   commit = string,             -- Specifies a git commit to use
--   lock = boolean,              -- Skip updating this plugin in updates/syncs. Still cleans.
--   run = string, function, or table, -- Post-update/install hook. See "update/install hooks".
--   requires = string or list,   -- Specifies plugin dependencies. See "dependencies".
--   rocks = string or list,      -- Specifies Luarocks dependencies for the plugin
--   config = string or function, -- Specifies code to run after this plugin is loaded.
--   -- The setup key implies opt = true
--   setup = string or function,  -- Specifies code to run before this plugin is loaded.
--   -- The following keys all imply lazy-loading and imply opt = true
--   cmd = string or list,        -- Specifies commands which load this plugin. Can be an autocmd pattern.
--   ft = string or list,         -- Specifies filetypes which load this plugin.
--   keys = string or list,       -- Specifies maps which load this plugin. See "Keybindings".
--   event = string or list,      -- Specifies autocommand events which load this plugin.
--   fn = string or list          -- Specifies functions which load this plugin.
--   cond = string, function, or list of strings/functions,   -- Specifies a conditional test to load this plugin
--   module = string or list      -- Specifies Lua module names for require. When requiring a string which starts
--                                -- with one of these module names, the plugin will be loaded.
--   module_pattern = string/list -- Specifies Lua pattern of Lua module names for require. When
--   requiring a string which matches one of these patterns, the plugin will be loaded.
-- }
