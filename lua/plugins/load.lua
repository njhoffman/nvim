-- require"utils.bootstrap_packer"
-- local packer = require "packer"
local packer = require "packer"
local config = require "config"

-- vim._update_package_paths()

return packer.startup({
  function(use)
    use "wbthomason/packer.nvim"

    -- ====================================
    -- Basic key mappings
    use "aymericbeaumet/vim-symlink"
    use "blackCauldron7/surround.nvim"
    use "jkramer/vim-checkbox"
    use "lambdalisue/suda.vim"
    use "mhinz/vim-sayonara"
    use "moll/vim-bbye"
    use "tpope/vim-repeat"

    -- ====================================
    -- Project management
    use "airblade/vim-rooter"
    use "rmagatti/auto-session"
    use "tpope/vim-obsession"
    use "dhruvasagar/vim-prosession"
    use "wakatime/vim-wakatime" -- WakaTimeToday, WakaTimeApiKey, WakaTimeDebugEnable

    -- ====================================
    -- Treesitter
    if config.Treesitter.enabled ~= 0 and config.Treesitter.enabled ~= false then
      use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", requires = "nvim-lua/plenary.nvim" }
      use { "ikatyang/tree-sitter-markdown", requires = "nvim-treesitter" }
      use { "JoosepAlviste/nvim-ts-context-commentstring", requires = "nvim-treesitter" }
      use { "nvim-treesitter/nvim-treesitter-refactor", requires = "nvim-treesitter" }
      use { "nvim-treesitter/nvim-treesitter-textobjects", requires = "nvim-treesitter" }
      use { "nvim-treesitter/playground", requires = "nvim-treesitter" }
      use { "p00f/nvim-ts-rainbow", requires = "nvim-treesitter" }
      -- use { "romgrk/nvim-treesitter-context", requires = "nvim-treesitter" }
      use { "theHamsta/nvim-treesitter-pairs", requires = "nvim-treesitter" }
      use { "windwp/nvim-ts-autotag", requires = "nvim-treesitter" }
    end

    -- ====================================
    -- Syntax
    use "yuezk/vim-js"
    use "HerringtonDarkholme/yats.vim"
    use "maxmellon/vim-jsx-pretty"
    use "godlygeek/tabular"
    use "GutenYe/json5.vim"
    use "StanAngeloff/php.vim"
    use "andrewstuart/vim-kubernetes"
    use "arzg/vim-sh"
    use "chr4/nginx.vim"
    use "chrisbra/csv.vim"
    use "editorconfig/editorconfig-vim"
    use "ekalinin/Dockerfile.vim"
    use "elzr/vim-json"
    use "ericpruitt/tmux.vim"
    use "gisphm/vim-gitignore"
    use "hashivim/vim-terraform"
    use "jparise/vim-graphql"
    use "moll/vim-node"
    use "neoclide/jsonc.vim"
    use "npxbr/glow.nvim"
    use "pearofducks/ansible-vim"
    use "rodjek/vim-puppet"
    use "tpope/vim-git"
    use "wgwoods/vim-systemd-syntax"
    use "zinit-zsh/zinit-vim-syntax"
    use "LnL7/vim-nix"
    use "plasticboy/vim-markdown"
    use "bfrg/vim-jq"
    use "mtdl9/vim-log-highlighting"

    use "vim-pandoc/vim-pandoc-syntax"
    use "njhoffman/vim-liquid"
    use "PotatoesMaster/i3-vim-syntax"
    use "SidOfc/mkdx"

    -- use "tpope/vim-liquid"
    -- use { "xolox/vim-lua-ftplugin", requires = "xolox/vim-misc" }
    -- use "kchmck/vim-coffee-script"

    -- ====================================
    -- LSP, Autocomplete and snippets
    if config.LSP.enabled ~= 0 and config.LSP.enabled ~= false then
      use "neovim/nvim-lspconfig"
      use "kabouzeid/nvim-lspinstall"
      use "nvim-lua/lsp_extensions.nvim"
      use "onsails/lspkind-nvim"
      use "nvim-lua/lsp-status.nvim"
      use "folke/lsp-colors.nvim"
      use "folke/lua-dev.nvim"
      use "glepnir/lspsaga.nvim"
      use "hrsh7th/nvim-compe" -- event = "InsertEnter *"
      use "ido-nvim/core"
      use "kosayoda/nvim-lightbulb"
      use "ray-x/lsp_signature.nvim"
      use { "jose-elias-alvarez/nvim-lsp-ts-utils", requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" } }
      use { "jose-elias-alvarez/null-ls.nvim", requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" } }
      use { "tzachar/compe-tabnine", run = "./install.sh", requires = "hrsh7th/nvim-compe" }
      -- might have to: cd .local/share/nvim/site/pack/packer/start/compe-tabnine && ./install.sh
      -- snippets
      use "hrsh7th/vim-vsnip"
      use "rafamadriz/friendly-snippets"
      use "norcalli/snippets.nvim"
      use "xabikos/vscode-javascript"
      -- use { 'cstrap/python-snippets' }
      -- use { 'ylcnfrht/vscode-python-snippet-pack' }
      -- use { 'golang/vscode-go' }
      -- use { 'rust-lang/vscode-rust' }
    end

    -- ====================================
    -- DAP
    if config.DAP.enabled ~= 0 and config.DAP.enabled ~= false then
      use { "mfussenegger/nvim-dap" }
      use { "rcarriga/nvim-dap-ui", requires = { "theHamsta/nvim-dap-virtual-text", "mfussenegger/nvim-dap" } }
      use { "jbyuki/one-small-step-for-vimkind", requires = { "mfussenegger/nvim-dap" } }
      use { "mfussenegger/nvim-dap-python", requires = { "mfussenegger/nvim-dap" } }
    end

    -- ====================================
    -- Integrations
    use "AndrewRadev/id3.vim"
    use "preservim/vimux"
    use { "pwntester/octo.nvim", requires = "kyazdani42/nvim-web-devicons" }
    use { "skywind3000/asynctasks.vim", requires = "skywind3000/asyncrun.vim" }
    use { "vim-test/vim-test" }
    use { "urbainvaes/vim-ripple" }
    use { "vuki656/package-info.nvim" }
    use { "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } }
    use { "iamcco/markdown-preview.nvim", run = "cd app && yarn install" }

    use {
      "tpope/vim-fugitive",
      cmd = {
        "GBrowse",
        "GDelete",
        "GMove",
        "GRemove",
        "GRename",
        "Gblame",
        "Gdiff",
        "Gdiffsplit",
        "Gedit",
        "Gfetch",
        "Ggrep",
        "Git",
        "Glgrep",
        "Gpull",
        "Gpush",
        "Gread",
        "Gsplit",
        "Gstatus",
        "Gvdiffsplit",
        "Gwrite",
      },
      -- "Gvdiffsplit",
      -- { "TimUntersberger/neogit" },
      -- }
    }

    -- ====================================
    -- Pickers (telescope, fzf)
    use "matbme/JABS.nvim"
    use "Yohannfra/Nvim-Switch-Buffer"
    use { "camspiers/snap", rocks = { "fzy" } }
    use { "junegunn/fzf.vim", requires = { "junegunn/fzf", dir = "~/.fzf", run = "./install --all" } }
    use {
      "yuki-yano/fzf-preview.vim",
      dir = "~/.fzf",
      branch = "release/rpc",
      requires = { "junegunn/fzf", "ryanoasis/vim-devicons" },
    }
    use {
      "ibhagwan/fzf-lua",
      requires = { "vijaymarupudi/nvim-fzf", "kyazdani42/nvim-web-devicons" }, -- optional for icons
    }
    use {
      "lazytanuki/nvim-mapper",
      before = "nvim-telescope/telescope.nvim",
      config = function() require("nvim-mapper").setup {} end,
    }
    use {
      "nvim-telescope/telescope.nvim",
      requires = { "kyazdani42/nvim-web-devicons", "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
    }
    use { "dhruvmanila/telescope-bookmarks.nvim", requires = { "nvim-telescope/telescope.nvim" } }
    use { "cljoly/telescope-repo.nvim", requires = "nvim-telescope/telescope.nvim" }
    use { "rmagatti/session-lens", requires = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" } }
    use { "sudormrfbin/cheatsheet.nvim", requires = "nvim-telescope/telescope.nvim" }
    use { "nvim-telescope/telescope-dap.nvim", requires = { "mfussenegger/nvim-dap", "nvim-telescope/telescope.nvim" } }
    use { "nvim-telescope/telescope-frecency.nvim", requires = { "nvim-telescope/telescope.nvim", "tami5/sql.nvim" } }
    use { "nvim-telescope/telescope-fzf-native.nvim", requires = "nvim-telescope/telescope.nvim" }
    use { "nvim-telescope/telescope-fzy-native.nvim", requires = { "nvim-telescope/telescope.nvim", "Dkendal/fzy-vim" } }
    use { "nvim-telescope/telescope-github.nvim", requires = "nvim-telescope/telescope.nvim" }
    use { "nvim-telescope/telescope-media-files.nvim", requires = "nvim-telescope/telescope.nvim" }
    use { "nvim-telescope/telescope-node-modules.nvim", requires = "nvim-telescope/telescope.nvim" }
    -- use { "nvim-telescope/telescope-packer.nvim", requires = "nvim-telescope/telescope.nvim" }
    use { "chiefnoah/neuron-v2.vim", requires = "junegunn/fzf.vim" }
    use {
      "oberblastmeister/neuron.nvim", -- "njhoffman/neuron.nvim",
      branch = "unstable",
      requires = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    }
    use {
      "GustavoKatel/telescope-asynctasks.nvim",
      requires = { "skywind3000/asynctasks.vim", "nvim-telescope/telescope.nvim" },
    }
    -- FzyLsAg - list files using the silversearcher, respects .gitignore and .agignore and open it in the current buffer.
    -- FzyTag - list tags, open tag defintion in current buffer - a better :tselect.
    -- FzyWorkingTree - list all currently modified files and open in current buffer.
    -- FzyGem - list all gems, then list all files in the selected gem.
    -- FzyBuffer - fzy select :ls

    -- use { "nvim-telescope/telescope-project.nvim", requires = "nvim-telescope/telescope.nvim" }
    -- use { "fhill2/telescope-ultisnips.nvim", requires = "nvim-telescope/telescope.nvim" }

    -- ====================================
    -- Visual enhancements
    use "gerw/vim-HiLinkTrace"
    use "joeysino/vim-plugin-AnsiEsc"
    use { "RRethy/vim-hexokinase", run = "make hexokinase" }
    use "kevinhwang91/nvim-hlslens"
    use "Xuyuanp/scrollbar.nvim"
    use "TaDaa/vimade"
    use "romainl/vim-cool"
    use "Pocco81/TrueZen.nvim"
    use "folke/twilight.nvim"
    -- use "lukas-reineke/indent-blankline.nvim"

    -- ====================================
    -- Motion plugins
    use "psliwka/vim-smoothie"
    use "chaoren/vim-wordmotion"
    use "andymass/vim-matchup" -- event = "BufEnter" %, g%, [%, ]%, z% - i%, a%
    -- use "AckslD/nvim-anywise-reg.lua"

    -- ====================================
    -- Formatting utils
    use "junegunn/vim-easy-align"
    use "andrewradev/splitjoin.vim"
    use "folke/todo-comments.nvim"
    use "b3nj5m1n/kommentary"
    use "terryma/vim-multiple-cursors"
    use "dhruvasagar/vim-table-mode"
    use "nicwest/vim-camelsnek"
    use "mizlan/iswap.nvim"

    -- ====================================
    -- System utils
    -- Delete, Unlink, Move, Rename, Chmod, Mkdir, Cfind/locate, Lfind/locate, Wall, SudoWrite/Edit
    use "tpope/vim-eunuch"
    use "bchretien/vim-profiler"
    use "tweekmonster/startuptime.vim"
    use "qpkorr/vim-renamer"
    use { "famiu/nvim-reload", branch = "master" } -- experimental
    use "henriquehbr/nvim-startup.lua"
    -- vim-profiler.py nvim -n 10
    -- vim-profiler.py -n 5 nvim foo.cc -c ":exec ':normal ia' | :q\!"
    -- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

    -- ====================================
    -- Interface plugins

    use "akinsho/nvim-toggleterm.lua"
    use "folke/trouble.nvim"
    use "folke/which-key.nvim"
    use "glepnir/dashboard-nvim"
    use "kevinhwang91/nvim-bqf"
    use "ncm2/float-preview.nvim"
    use "simnalamburt/vim-mundo"
    use "sindrets/diffview.nvim"
    use "svermeulen/vim-yoink"
    use "tversteeg/registers.nvim"
    use "rcarriga/nvim-notify"
    use "voldikss/fzf-floaterm"
    use "voldikss/vim-floaterm"
    use "romgrk/fzy-lua-native"
    use "liuchengxu/vista.vim"
    use { "kyazdani42/nvim-tree.lua", requires = "kyazdani42/nvim-web-devicons" }
    use {
      "gelguy/wilder.nvim",
      rocks = { "luarocks-fetch-gitrec", "pcre2" },
      requires = { "romgrk/fzy-lua-native", "kyazdani42/nvim-web-devicons" }, -- , "nixprime/cpsm" },
    }
    -- use "preservim/vim-pencil"

    -- ====================================
    -- Themes
    use { "romgrk/barbar.nvim", requires = "romgrk/doom-one.vim" }
    use { "famiu/feline.nvim" }
    use {
      "rktjmp/lush.nvim",
      config = function()
        vim.cmd("colorscheme nord-nick")
        vim.cmd("source $HOME/.config/nvim/colors/barbar-colors.vim")
      end,
    }
  end,
  config = {
    profile = {
      enable = false,
      threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
    },
    display = {
      open_fn = function() return require("packer.util").float({ border = "single" }) end,
      keybindings = { -- Keybindings for the display window
        quit = "<esc>",
        toggle_info = "<CR>",
        diff = "d",
        prompt_revert = "r",
      },
    },
  },
})
-- ====================================
-- vim-sneak,
-- use 'terryma/vim-expand-region'
-- use 'windwp/vim-floaterm-repl'
-- use "mtth/scratch.vim"
-- use 'windwp/nvim-spectre'
-- use 'nacro90/numb.nvim'
-- use 'dyng/ctrlsf.vim'
-- use 'dstein64/nvim-scrollview'
-- use "tsuyoshicho/vim-efm-langserver-settings", -- auto config efm lsp
-- https://github.com/Yohannfra/Nvim-Switch-Buffer
-- use "gfanto/fzf-lsp.nvim"
-- use 'tools-life/taskwiki'
-- use "xarthurx/vim-taskwarrior"
-- use 'justinmk/vim-dirvish'
-- use "rafcamlet/nvim_luapad"
-- use "machakann/vim_sandwich",
-- use "windwp/nvim_autopairs",
-- use { "voldikss/LeaderF-floaterm", requires = "Yggdroot/LeaderF" }
-- use { "turbio/bracey.vim", run = "npm install_server" },
-- use "~/repos/friendly_snippets"
