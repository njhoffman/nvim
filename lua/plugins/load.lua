local config = require("config")
local pluginmap = require("plugins.pluginmap")
-- local logger = require("logger").initLogger("plugins")

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap =
    fn.system(
    {
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path
    }
  )
end
-- $ nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

local packerConfig = {
  log = {level = "info"}, -- The default print log level. One of: "trace", "debug", "info", "warn", "error", "fatal".
  profile = {
    enable = false,
    threshold = 1 -- the amount in ms that a plugins load time must be over for it to be included in the profile
  },
  compile_path = fn.stdpath("config") .. "/lua/packer_compiled.lua",
  display = {
    non_interactive = false, -- If true, disable display windows for all operations
    open_fn = function()
      return require("packer.util").float {border = "single"}
    end,
    -- open_cmd = '65vnew \\[packer\\]', -- An optional command to open a window for packer's display
    working_sym = "⟳", -- The symbol for a plugin being installed/updated
    error_sym = "✗", -- The symbol for a plugin with an error in installation/updating
    done_sym = "✓", -- The symbol for a plugin which has completed installation/updating
    removed_sym = "-", -- The symbol for an unused plugin which was removed
    moved_sym = "→", -- The symbol for a plugin which was moved (e.g. from opt to start)
    header_sym = "━", -- The symbol for the header line in packer's display
    show_all_info = true, -- Should packer show all update details automatically?
    prompt_border = "double", -- Border style of prompt popups.
    keybindings = {
      -- Keybindings for the display window
      quit = "<esc>",
      toggle_info = "<CR>",
      diff = "d",
      prompt_revert = "r"
    }
  }
}

return require("packer").startup(
  {
    function(use)
      use("wbthomason/packer.nvim")
      -- TODO: cp impatient.nvim ../impatient
      -- use {"lewis6991/impatient.nvim", rocks = "mpack"}

      local load_config = {skip = {"vista.vim"}, disable = {"options.nvim"}}

      pluginmap.load_plugins(use, load_config)

      -- Basic key mappings
      use("aymericbeaumet/vim-symlink")
      use("lambdalisue/suda.vim")
      use("mhinz/vim-sayonara")
      use("moll/vim-bbye")
      use("ojroques/nvim-bufdel")
      use("tpope/vim-repeat")
      use("Konfekt/vim-alias")
      use("tpope/vim-scriptease") -- use 'antoinemadec/FixCursorHold.nvim'
      use(
        {
          "meain/vim-printer",
          config = function()
            vim.cmd([[let g:vim_printer_print_below_keybinding = '<leader>/']])
            vim.cmd([[let g:vim_printer_print_above_keybinding = '<leader>?']])
          end
        }
      )
      -- ====================================
      -- Project management
      use("wakatime/vim-wakatime") -- WakaTimeToday, WakaTimeApiKey, WakaTimeDebugEnable

      use(
        {
          "windwp/nvim-projectconfig",
          config = function()
            -- I want to change my directory inside neovim and load project config.
            require("nvim-projectconfig").load_project_config()
            vim.cmd(
              [[
          augroup NvimProjectConfig
          autocmd!
          autocmd DirChanged * lua require('nvim-projectconfig').load_project_config()
          augroup end
        ]]
            )
          end
        }
      )
      -- https://github.com/goolord/alpha-nvim
      -- use "tpope/vim-obsession"
      -- use "dhruvasagar/vim-prosession"
      use(
        {
          "rmagatti/auto-session",
          config = function()
            require("plugins.configs.auto-session")
          end
        }
      )

      -- ====================================
      -- LSP, Autocomplete and snippets
      -- lua << EOF
      -- require"ntangle-lsp".setup {
      --   mappings = {
      --     ["K"] = require"ntangle-lsp".hover,
      --     ["gd"] = require"ntangle-lsp".definition,
      --   },
      -- }
      -- EOF
      use("ido-nvim/core")
      use("neovim/nvim-lspconfig")
      use(
        {
          -- https://github.com/kosayoda/nvim-lightbulb
          "weilbith/nvim-code-action-menu",
          cmd = "CodeActionMenu"
          -- vim.g.code_action_menu_show_details = false,
          -- vim.g.code_action_menu_show_diff = false
        }
      )
      use(
        {
          "williamboman/nvim-lsp-installer",
          requires = "neovim/nvim-lspconfig",
          config = function()
            require("plugins.configs.lsp-install")
          end
        }
      )
      use("nvim-lua/lsp_extensions.nvim")
      -- use({
      -- 	"nvim-lua/lsp-status.nvim",
      -- 	config = function()
      -- 		require("plugins.configs.lsp-status")
      -- 	end,
      -- })
      use(
        {
          "folke/lsp-colors.nvim",
          config = function()
            require("plugins.configs.lsp-colors")
          end
        }
      )

      use(
        {
          "glepnir/lspsaga.nvim",
          config = function()
            require("plugins.configs.lspsaga")
          end
        }
      )
      -- use "wellle/tmux-complete.vim"  not available for nvim-cmp yet
      use(
        {
          "hrsh7th/nvim-cmp",
          requires = {
            -- "lukas-reineke/cmp-rg",
            "lukas-reineke/cmp-under-comparator",
            "ray-x/cmp-treesitter",
            "f3fora/cmp-spell",
            "David-Kunz/cmp-npm",
            -- "uga-rosa/cmp-dictionary",
            "tamago324/cmp-zsh",
            "pontusk/cmp-vimwiki-tags",
            "jc-doyle/cmp-pandoc-references",
            {"tzachar/cmp-tabnine", run = "./install.sh"},
            {"petertriho/cmp-git", requires = "nvim-lua/plenary.nvim"},
            {"kristijanhusak/vim-dadbod-completion", requires = "tpope/vim-dadbod"},
            -- { "andersevenrud/compe-tmux" },
            "hrsh7th/cmp-emoji",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-calc",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline"
            -- 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
            -- 'L3MON4D3/LuaSnip' -- Snippets plugin
          },
          config = function()
            require("plugins.configs.nvim-cmp")
          end
        }
      )

      use(
        {
          "kosayoda/nvim-lightbulb",
          config = function()
            require("plugins.configs.nvim-lightbulb")
          end
        }
      )
      use(
        {
          "ray-x/lsp_signature.nvim",
          config = function()
            require("plugins.configs.lsp_signature")
          end
        }
      )
      use({"jose-elias-alvarez/nvim-lsp-ts-utils", requires = {"nvim-lua/plenary.nvim", "neovim/nvim-lspconfig"}})
      -- use({ "jose-elias-alvarez/null-ls.nvim", requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" } })
      -- use { "tzachar/compe-tabnine", run = "./install.sh", requires = "hrsh7th/nvim-compe" } -- might have to: cd .local/share/nvim/site/pack/packer/start/compe-tabnine && ./install.sh

      -- snippets
      -- use {'neovim/nvim-lspconfig', requires = 'mfussenegger/nvim-jdtls'}
      -- use 'hrsh7th/vim-vsnip'
      -- use 'hrsh7th/nvim-cmp'
      -- use 'hrsh7th/cmp-vsnip'
      -- use 'rafamadriz/friendly-snippets'
      -- use 'hrsh7th/cmp-nvim-lsp'
      -- use 'hrsh7th/cmp-buffer'
      -- use 'hrsh7th/cmp-path'
      -- use 'ray-x/cmp-treesitter'
      -- use 'f3fora/cmp-spell'

      use(
        {
          "hrsh7th/cmp-vsnip",
          after = "nvim-cmp",
          requires = {
            "hrsh7th/vim-vsnip",
            {"rafamadriz/friendly-snippets", after = "cmp-vsnip"},
            {"kitagry/vs-snippets", after = "cmp-vsnip"}

            -- { "norcalli/snippets.nvim", after="vim-vsnip" } ,
            -- { "xabikos/vscode-javascript" },
          }
        }
      )

      -- use { "hrsh7th/vim-vsnip", config = function() require("plugins.configs.vim-vsnip") end }
      -- use "honza/vim-snippets"
      -- use "SirVer/UltiSnips"
      -- use { 'cstrap/python-snippets' }
      -- use { 'ylcnfrht/vscode-python-snippet-pack' }
      -- use { 'golang/vscode-go' }
      -- use { 'rust-lang/vscode-rust' }

      -- ====================================
      -- Integrations
      use("AndrewRadev/id3.vim")
      use(
        {
          "preservim/vimux",
          config = function()
            require("plugins.configs.vimux")
          end
        }
      )
      use(
        {
          "dbeniamine/cheat.sh-vim",
          config = function()
            require("plugins.configs.cheat_sh-vim")
          end
        }
      )
      use(
        {
          "tools-life/taskwiki",
          requires = {
            {
              "vimwiki/vimwiki",
              branch = "dev",
              config = function()
                vim.g.vimwiki_global_ext = 0
                vim.cmd([[let g:vimwiki_key_mappings = { 'all_maps': 0, }]])
              end
            },
            "vim-plugin-AnsiEsc",
            "farseer90718/vim-taskwarrior",
            "preservim/tagbar"
          }
          -- TODO: also needs taskwarrior, tasklib, pip install --upgrade git+git://github.com/tbabej/tasklib@develop
        }
      )
      use(
        {
          "rafcamlet/nvim-luapad",
          config = function()
            require("plugins.configs.nvim-luapad")
          end
        }
      )
      use(
        {
          "michaelb/sniprun",
          run = "bash ./install.sh",
          config = function()
            require("plugins.configs.sniprun")
          end
        }
      )
      use("njhoffman/slimux")
      use(
        {
          "NTBBloodbath/rest.nvim",
          config = function()
            require("plugins.configs.rest-nvim")
          end
        }
      )
      use("sefeng211/vim-pastebins")
      -- Visual Selection <C-U>PastebinPaste - <C-U>, PastebinPasteAll, PastebinPasteList
      vim.g.enabled_pastebin_service = "dpaste.org"

      use("vim-test/vim-test")

      use(
        {
          "urbainvaes/vim-ripple",
          config = function()
            require("plugins.configs.vim-ripple")
          end
        }
      )
      use(
        {
          "vuki656/package-info.nvim",
          requires = "MunifTanjim/nui.nvim",
          config = function()
            require("plugins.configs.package-info")
          end
        }
      )

      use(
        {
          "pwntester/octo.nvim",
          requires = "kyazdani42/nvim-web-devicons",
          config = function()
            require("plugins.configs.octo")
          end
        }
      )
      use(
        {
          "skywind3000/asynctasks.vim",
          requires = "skywind3000/asyncrun.vim",
          config = function()
            require("plugins.configs.asynctasks")
          end
        }
      )
      use(
        {
          "iamcco/markdown-preview.nvim",
          run = "cd app && yarn install",
          config = function()
            require("plugins.configs.markdown-preview")
          end
        }
      )

      -- ====================================
      -- Visual enhancements
      use("romainl/vim-cool")
      use(
        {
          "phaazon/hop.nvim",
          branch = "v1", -- optional but strongly recommended
          config = function()
            -- you can configure Hop the way you like here; see :h hop-config
            require("hop").setup({keys = "etovxqpdygfblzhckisuran"})
            -- place this in one of your configuration file(s)
            -- place this in one of your configuration file(s)
            -- vim.api.nvim_set_keymap('n', '<M-;>', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
            -- vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
          end
        }
      )

      use("gerw/vim-HiLinkTrace")
      use(
        {
          "luukvbaal/stabilize.nvim",
          config = function()
            local default_options = {
              force = true, -- stabilize window even when current cursor position will be hidden behind new window
              forcemark = nil, -- set context mark to register on force event which can be jumped to with '<forcemark>
              ignore = {
                -- do not manage windows matching these file/buftypes
                filetype = {"help", "list", "Trouble", "notify"},
                buftype = {"terminal", "quickfix", "loclist"}
              }
            }
            require("stabilize").setup(default_options)
          end
        }
      )
      use(
        {
          "Pocco81/TrueZen.nvim",
          config = function()
            require("plugins.configs.truezen")
          end
        }
      )
      use(
        {
          "TaDaa/vimade",
          config = function()
            require("plugins.configs.vimade")
          end
        }
      )
      -- use { "dstein64/nvim-scrollview", config = function() require("plugins.configs.nvim-scrollview") end }

      use(
        {
          "folke/twilight.nvim",
          config = function()
            require("plugins.configs.twilight")
          end
        }
      )
      use(
        {
          "joeysino/vim-plugin-AnsiEsc",
          config = function()
            require("plugins.configs.vim_plugin_AnsiEsc")
          end
        }
      )
      use(
        {
          "kevinhwang91/nvim-hlslens",
          config = function()
            require("plugins.configs.nvim_hlslens")
          end
        }
      )
      use(
        {
          "RRethy/vim-hexokinase",
          run = "make hexokinase",
          config = function()
            require("plugins.configs.vim_hexokinase")
          end
        }
      )
      use(
        {
          "winston0410/range-highlight.nvim",
          requires = "winston0410/cmd-parser.nvim",
          config = function()
            require("plugins.configs.range-highlight")
          end
        }
      )
      -- use { "beauwilliams/focus.nvim", config = function() require("plugins.configs.focus") end }
      -- use "lukas-reineke/indent-blankline.nvim"
      -- https://github.com/simeji/winresizer
      -- use {
      --   "sunjon/Shade.nvim",
      --   config = function() require("plugins.configs.shade") end
      -- }

      -- ====================================
      -- Motion plugins
      -- use { "terryma/vim-multiple-cursors", config = function() require("plugins.configs.vim_multiple_cursors") end }
      use(
        {
          "abecodes/tabout.nvim",
          requires = {
            "nvim-treesitter/nvim-treesitter"
            -- "hrsh7th/nvim-compe",
          },
          config = function()
            require("plugins.configs.tabout")
          end
        }
      ) -- after = { "nvim-compe" },
      -- use { "blackCauldron7/surround.nvim", config = function() require("plugins.surround.lua")}
      -- use "AckslD/nvim-anywise-reg.lua"

      -- ====================================
      -- System utils
      -- Delete, Unlink, Move, Rename, Chmod, Mkdir, Cfind/locate, Lfind/locate, Wall, SudoWrite/Edit
      use("tpope/vim-eunuch")
      use("bchretien/vim-profiler")
      use("tweekmonster/startuptime.vim")
      use("qpkorr/vim-renamer")
      use("jamestthompson3/nvim-remote-containers")
      use(
        {
          "henriquehbr/nvim-startup.lua",
          config = function()
            require("plugins.configs.nvim_startup")
          end
        }
      )

      -- ====================================
      -- Interface plugins
      use("voldikss/fzf-floaterm")
      use("tpope/vim-dadbod")
      -- :DB sqlite:myfile.sqlite3 select count(*) from widgets
      -- :DB redis:/// CLIENT LIST
      -- :%DB mysql://root@localhost/bazquux
      -- :DB mongodb:///test < big_query.js

      use(
        {
          "kristijanhusak/vim-dadbod-ui",
          requires = "tpope/vim-dadbod",
          config = function()
            vim.g.db_ui_show_database_icon = 1
            vim.g.db_ui_use_nerd_fonts = 1
            -- let g:db_ui_table_helpers = {
            -- \ 	'postgresql': {
            -- \ 		'List': 'select * from {table} order by id asc'
            -- \ 	}
            -- \ }
          end
        }
      )
      -- let g:db_ui_env_variable_url = 'DATABASE_URL'
      -- let g:db_ui_env_variable_name = 'DATABASE_NAME'
      -- # .env
      -- DB_UI_DEV=...          # becomes the `dev` connection
      -- DB_UI_PRODUCTION=...   # becomes the `production` connection
      -- let g:db_ui_dotenv_variable_prefix = 'MYPREFIX_'
      -- let g:dbs = {
      -- \ 'dev': 'postgres://postgres:mypassword@localhost:5432/my-dev-db',
      -- \ 'staging': 'postgres://postgres:mypassword@localhost:5432/my-staging-db',
      -- \ 'wp': 'mysql://root@localhost/wp_awesome',
      -- \ }
      -- Just make sure to NOT COMMIT these. I suggest using project local vim config (:help exrc)

      use(
        {
          "nanotee/sqls.nvim",
          requires = {"neovim/nvim-lspconfig"},
          config = function()
            require("sqls").setup(
              {
                picker = "default" -- default, telescope, fzf,
              }
            )
          end
        }
      )
      -- use { "stevearc/stickybuf.nvim", config = function() require("plugins.configs.stickybuf") end }
      use("ThePrimeagen/vim-apm") -- VimApmShutdown, VimAp, ~/apm.csvm

      -- use "markonm/traces.vim"
      -- let g:traces_enabled             = get(g:, 'traces_enabled', 1)
      -- let g:traces_preserve_view_state = get(g:, 'traces_preserve_view_state')
      -- let g:traces_substitute_preview  = get(g:, 'traces_substitute_preview', 1)
      -- let g:traces_normal_preview      = get(g:, 'traces_normal_preview', 0)
      -- let g:traces_num_range_preview   = get(g:, 'traces_num_range_preview', 0)
      -- let g:traces_skip_modifiers      = get(g:, 'traces_skip_modifiers', 1)
      -- let g:traces_preview_window      = get(g:, 'traces_preview_window', '')
      -- let g:traces_abolish_integration = get(g:, 'traces_abolish_integration', 0)
      -- use { "jez/vim-superman" }
      -- use "camspiers/animate.vim"
      -- use {
      --   "camspiers/lens.vim",
      --   config = function()
      --     vim.cmd("let g:lens#disabled_filetypes = ['nerdtree', 'fzf', 'qf', 'mundo', 'mundodiff']")
      --     vim.cmd("let g:lens#disabled_buftypes = ['nofile']")
      --   end,
      -- }
      use(
        {
          "folke/todo-comments.nvim",
          config = function()
            require("plugins.configs.todo_comments")
          end
        }
      )
      use(
        {
          "folke/trouble.nvim",
          config = function()
            require("plugins.configs.trouble")
          end
        }
      )
      use(
        {
          "folke/which-key.nvim",
          config = function()
            require("plugins.configs.which_key")
          end
        }
      )
      use(
        {
          "goolord/alpha-nvim",
          requires = {"kyazdani42/nvim-web-devicons"},
          config = function()
            require("plugins.configs.alpha-nvim")
          end
        }
      )
      use(
        {
          "ncm2/float-preview.nvim",
          config = function()
            require("plugins.configs.float-preview")
          end
        }
      )
      use(
        {
          "kyazdani42/nvim-tree.lua",
          config = function()
            require("plugins.configs.nvim_tree")
          end
        }
      )
      use(
        {
          "simnalamburt/vim-mundo",
          config = function()
            require("plugins.configs.vim_mundo")
          end
        }
      )
      use(
        {
          "sindrets/diffview.nvim",
          config = function()
            require("plugins.configs.diffview")
          end
        }
      )
      use(
        {
          "tversteeg/registers.nvim",
          config = function()
            require("plugins.configs.registers")
          end
        }
      )
      use(
        {
          "voldikss/vim-floaterm",
          config = function()
            require("plugins.configs.vim-floaterm")
          end
        }
      )
      use(
        {
          "gelguy/wilder.nvim",
          rocks = {"luarocks-fetch-gitrec", "pcre2"},
          requires = {"romgrk/fzy-lua-native", "kyazdani42/nvim-web-devicons"},
          config = function()
            require("plugins.configs.wilder")
          end
        }
      )
      -- use "preservim/vim-pencil"

      -- ====================================
      -- Pickers (telescope, fzf)

      use(
        {
          "luukvbaal/nnn.nvim",
          config = function()
            --  NnnPicker ()-F mode), NnnExplorer (-P mode)

            -- Bind NnnExplorer/NnnPicker to toggle the plugin on/off in normal and terminal mode. The commands accept a path as optional argument. To always open nnn in the directory of the currently active buffer, use %:p:h as argument:
            -- tnoremap <C-A-n> <cmd>NnnExplorer<CR>
            -- nnoremap <C-A-n> <cmd>NnnExplorer %:p:h<CR>
            -- tnoremap <C-A-p> <cmd>NnnPicker<CR>
            -- nnoremap <C-A-p> <cmd>NnnPicker<CR>
            local builtin = require("nnn").builtin
            mappings = {
              {"<C-t>", builtin.open_in_tab}, -- open file(s) in tab
              {"<C-s>", builtin.open_in_split}, -- open file(s) in split
              {"<C-v>", builtin.open_in_vsplit}, -- open file(s) in vertical split
              {"<C-p>", builtin.open_in_preview}, -- open file in preview split keeping nnn focused
              {"<C-y>", builtin.copy_to_clipboard}, -- copy file(s) to clipboard
              {"<C-w>", builtin.cd_to_path}, -- cd to file directory
              {"<C-e>", builtin.populate_cmdline} -- populate cmdline (:) with file(s)
            }
            local cfg = {
              explorer = {
                cmd = "nnn -G", -- command overrride (-F1 flag is implied, -a flag is invalid!)
                width = 24, -- width of the vertical split
                side = "topleft", -- or "botright", location of the explorer window
                session = "", -- or "global" / "local" / "shared"
                tabs = true -- seperate nnn instance per tab
              },
              picker = {
                cmd = "tmux new-session nnn -Pp",
                style = {
                  border = "rounded",
                  width = 0.9, -- width in percentage of the viewport
                  height = 0.8, -- height in percentage of the viewport
                  xoffset = 0.5, -- xoffset in percentage
                  yoffset = 0.5 -- yoffset in percentage
                },
                session = "" -- or "global" / "local" / "shared"
              },
              auto_open = {
                setup = nil, -- or "explorer" / "picker", auto open on setup function
                tabpage = nil, -- or "explorer" / "picker", auto open when opening new tabpage
                empty = false, -- only auto open on empty buffer
                ft_ignore = {
                  -- dont auto open for these filetypes
                  "gitcommit"
                }
              },
              auto_close = false, -- close tabpage/nvim when nnn is last window
              replace_netrw = nil, -- or "explorer" / "picker"
              mappings = {}, -- table containing mappings, see below
              windownav = {
                -- window movement mappings to navigate out of nnn
                left = "<C-w>h",
                right = "<C-w>l"
              }
            }
            require("nnn").setup(config)
          end
        }
      )
      use("Yohannfra/Nvim-Switch-Buffer")
      use(
        {
          "matbme/JABS.nvim",
          config = function()
            require("plugins.configs.jabs")
          end
        }
      )

      -- NOTE: must be called before telescope, otherwise rg hangs on plenary job
      use(
        {
          "lazytanuki/nvim-mapper",
          config = function()
            require("nvim-mapper").setup({})
          end,
          before = "telescope.nvim"
        }
      )

      use(
        {
          "nvim-telescope/telescope.nvim",
          requires = {
            "kyazdani42/nvim-web-devicons",
            "nvim-lua/popup.nvim",
            "nvim-lua/plenary.nvim",
            "tami5/sqlite.lua",
            {"AckslD/nvim-neoclip.lua", requires = {"tami5/sqlite.lua", module = "sqlite"}},
            "ahmedkhalf/project.nvim",
            "lazytanuki/nvim-mapper",
            "skywind3000/asynctasks.vim",
            "sudormrfbin/cheatsheet.nvim",
            --
            "nvim-telescope/telescope-file-browser.nvim",
            "rmagatti/session-lens",
            "GustavoKatel/telescope-asynctasks.nvim",
            "camgraff/telescope-tmux.nvim",
            "dhruvmanila/telescope-bookmarks.nvim",
            "gbrlsnchs/telescope-lsp-handlers.nvim",
            "nvim-telescope/telescope-dap.nvim",
            "nvim-telescope/telescope-frecency.nvim",
            "nvim-telescope/telescope-symbols.nvim",
            {"nvim-telescope/telescope-fzf-native.nvim", run = "make"},
            "nvim-telescope/telescope-ghq.nvim",
            "nvim-telescope/telescope-github.nvim",
            "nvim-telescope/telescope-media-files.nvim",
            "nvim-telescope/telescope-packer.nvim",
            "nvim-telescope/telescope-z.nvim",
            --
            "nvim-telescope/telescope-arecibo.nvim",
            "nvim-telescope/telescope-node-modules.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            "nvim-telescope/telescope-hop.nvim",
            "nvim-telescope/telescope-rg.nvim",
            -- <c-a>: append env name, <cr>: append env value, <c-e>: edit env value
            "LinArcX/telescope-command-palette.nvim",
            "tamago324/telescope-openbrowser.nvim",
            "LinArcX/telescope-env.nvim",
            "crispgm/telescope-heading.nvim",
            "ElPiloto/telescope-vimwiki.nvim",
            "cljoly/telescope-repo.nvim",
            "elianiva/telescope-npm.nvim",
            "rlch/github-notifications.nvim",
            "frenchtoasters/telescope-kubectl.nvim"
            -- "nvim-telescope/telescope-vimspector",
            -- "benfowler/telescope-luasnip.nvim",
          },
          config = function()
            require("plugins.configs.telescope")
            require("plugins.configs.telescope-pickers")
          end
        }
      )

      use(
        {
          "~/git/telescope-extensions",
          -- "njhoffman/telescope-extensions",
          -- "~/projects/telescope-extensions",
          requires = {{"nvim-telescope/telescope.nvim"}},
          -- for arecibo websearch
          rocks = {"openssl", "lua-http-parser"},
          config = function()
            -- require"telescope".load_extension "context-pickers"
          end
        }
      )

      -- ====================================
      -- Treesitter
      -- use({ "ikatyang/tree-sitter-markdown", requires = "nvim-treesitter" })
      -- use { 'mfussenegger/nvim-ts-hint-textobject', requires = 'nvim-treesitter',
      --   config = function()
      --     -- omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
      --     -- vnoremap <silent> m :lua require('tsht').nodes()<CR>
      --   end
      -- }
      require "nvim-treesitter.configs".setup {autotag = {enable = true}}
      use {"romgrk/nvim-treesitter-context", requires = "nvim-treesitter"}

      -- https://github.com/willchao612/vim-diagon
      -- https://github.com/ArthurSonzogni/Diagon
      -- math: f(x) = 1 + x / (1 + x)
      -- sequence:
      --   Alice -> Bob: Hello Bob!
      --   Alice <- Bob: Hello Alice!
      -- tree:
      --   Linux
      --     Android
      --     Debian
      --       Ubuntu
      --   Fedora
      -- Graph Planar:
      --   if -> "then A" -> end
      --   if -> "then B" -> end
      --   end -> loop -> if
      -- DAG:
      --   socks -> shoes
      --   underwear -> shoes
      --   underwear -> pants
      --   pants -> shoes
      --   pants -> belt
      --   belt -> jacket
      --   shirt -> belt
      --   shirt -> tie
      --   tie -> jacket

      -- FlowCharts:
      --   if ("DO YOU UNDERSTAND FLOW CHARTS?")
      --     "GOOD!";
      --   else if ("OKAY, YOU SEE THE LINE LABELED 'YES'?") {
      --     if ("... AND YOU CAN SEE THE ONES LABELED 'NO'?") {
      --       "GOOD";
      --     } else {
      --       if ("BUT YOU JUST FOLLOWED THEM TWICE?")
      --         noop;
      --       else
      --         noop;
      --       "(THAT WASN'T A QUESTION)";
      --       "SCREW IT"
      --     }
      --   } else {
      --     if ("BUT YOU SEE THE ONES LABELED 'NO'?") {
      --       return "WAIT, WHAT?";
      --     } else {
      --       "LISTEN.";
      --       return "I HATE YOU";
      --     }
      --   }
      -- example mappings:
      -- noremap <Leader>D :Diagon<Space>
      -- noremap <Leader>dm :Diagon Math<CR>
      -- noremap <Leader>ds :Diagon Sequence<CR>
      -- noremap <Leader>dt :Diagon Tree<CR>

      -- https://github.com/jbyuki/venn.nvim
      -- set virtualedit=all or set ve=all. This will allow you to freely move the cursor in the buffer. (see help virtualedit).
      -- Enter in Visual Block mode using <C-v>. Select the region where the box should be.
      -- Invoke :VBox. This will draw a rectangle. In case, it has a width or a height of 1, it will draw a line.

      -- You can map :VBox commands to allow different ways of drawing lines.

      -- Use the following function in your neovim config to toggle drawing lines on HJKL directional keys to allow for faster creation of diagrams:

      -- -- venn.nvim: enable or disable keymappings
      -- function _G.Toggle_venn()
      --     local venn_enabled = vim.inspect(vim.b.venn_enabled)
      --     if venn_enabled == "nil" then
      --         vim.b.venn_enabled = true
      --         vim.cmd[[setlocal ve=all]]
      --         -- draw a line on HJKL keystokes
      --         vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
      --         vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
      --         vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
      --         vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
      --         -- draw a box by pressing "f" with visual selection
      --         vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})
      --     else
      --         vim.cmd[[setlocal ve=]]
      --         vim.cmd[[mapclear <buffer>]]
      --         vim.b.venn_enabled = nil
      --     end
      -- end
      -- -- toggle keymappings for venn using <leader>v
      -- vim.api.nvim_set_keymap('n', '<leader>v', ":lua Toggle_venn()<CR>", { noremap = true})

      use(
        {
          "oberblastmeister/neuron.nvim", -- "njhoffman/neuron.nvim",
          branch = "unstable",
          requires = {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim", {"nvim-telescope/telescope.nvim"}},
          config = function()
            require("plugins.configs.neuron")
          end
        }
      )

      -- use({
      --   "startup-nvim/startup.nvim",
      --   requires = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"},
      --   config = function()
      --     require"startup".setup()
      --     -- require"startup".setup({
      --     --   theme = "evil", -- evil, startify, dashboard
      --     --   section = {
      --     --     -- "text" -> text that will be displayed
      --     --     -- "mapping" -> create mappings for commands that can be used
      --     --     -- use mappings.execute_command on the commands to execute
      --     --     -- "oldfiles" -> display oldfiles (can be opened with mappings.open_file/open_file_split)
      --     --     type = "text", -- can be mappings or oldfiles
      --     --     oldfiles_directory = false, -- if the oldfiles of the current directory should be displayed
      --     --     align = "center", -- "center", "left" or "right"
      --     --     fold_section = false, -- whether to fold or not
      --     --     title = "title", -- title for the folded section
      --     --       -- if < 0 fraction of screen width
      --     --       -- if > 0 numbers of column
      --     --     margin = 5, -- the margin for left or right alignment
      --     --       -- type of content depends on `type`
      --     --       -- "text" -> a table with string or a function that requires a function that returns a table of strings
      --     --       -- "mapping" -> a table with tables in the format:
      --     --       -- {
      --     --       --   {<displayed_command_name>, <command>, <mapping>}
      --     --       --   {<displayed_command_name>, <command>, <mapping>}
      --     --       -- }
      --     --       -- e.g. {" Find File", "Telescope find_files", "<leader>ff" }
      --     --       -- "oldfiles" -> ""
      --     --       -- content = <content>
      --     --       -- highlight = "String", -- highlight group in which the section text should be highlighted
      --     --     default_color = "#FF0000", -- a hex color that gets used if you don't specify `highlight`
      --     --     oldfiles_amount = 5, -- the amount of oldfiles to be displayed
      --     --   }
      --     --   -- section_1 = <section> -- for the structure of a section see below
      --     --   --   section_2 = <section> -- as much sections as you like
      --     --   --   options = {
      --     --   --     mapping_keys = true, -- display mapping (e.g. <leader>ff)

      --     --   --     -- if < 0 fraction of screen width
      --     --   --     -- if > 0 numbers of column
      --     --   --     cursor_column = 0.5

      --     --   --       after = function() -- function that gets executed at the end
      --     --   --       <lua commands>
      --     --   --       end
      --     --   --       empty_lines_between_mappings = true, -- add an empty line between mapping/commands
      --     --   --     disable_statuslines = true -- disable status-, buffer- and tablines
      --     --   --       paddings = {1,2}, -- amount of empty lines before each section (must be equal to amount of sections)
      --     --   --   }
      --     --   --   mappings = {
      --     --   --     execute_command = "<CR>",
      --     --   --     open_file = "o",
      --     --   --     open_file_split = "<c-o>",
      --     --   --     open_section = "<TAB>",
      --     --   --     open_help = "?",
      --     --   --   },
      --     --   -- colors = {
      --     --   --   background = "#1f2227",
      --     --   --   folded_section = "#56b6c2", -- the color of folded sections
      --     --   --   -- this can also be changed with the `StartupFoldedSection` highlight group
      --     --   -- }
      --     --   -- parts = {"section_1", "section_2"} -- all sections in order
      --     -- })
      --   end
      -- })

      -- ====================================
      -- Themes
      use({"rktjmp/lush.nvim"})

      -- Automatically set up your configuration after cloning packer.nvim
      -- Put this at the end after all plugins
      if packer_bootstrap then
        local packer, err = pcall(require, "packer")
        if not packer then
          local msg = "calling module: packer, fail: " .. err
          vim.notify(msg, "error", {title = "Packer Error"})
        else
          local ok, err = packer.sync()
          if not ok then
            local msg = "calling packer.sync(), fail: " .. err
            vim.notify(msg, "error", {title = "Packer Error"})
          end
        end
      end
    end,
    config = packerConfig
  }
)
-- ====================================

-- https://github.com/mattboehm/vim-unstack
-- https://github.com/mattn/vim-gist
-- https://github.com/skanehira/gh.vim
-- use "jpalardy/vim-slime"
-- use { "Tastyep/structlog.nvim" }
-- https://github.com/norcalli/nvim-terminal.lua
-- { "TimUntersberger/neogit" },
-- use 'terryma/vim-expand-region'
-- use 'windwp/vim-floaterm-repl'
-- use "mtth/scratch.vim"
-- use 'windwp/nvim-spectre'
-- use 'nacro90/numb.nvim'
-- use 'dyng/ctrlsf.vim'
-- use "tsuyoshicho/vim-efm-langserver-settings", -- auto config efm lsp
-- https://github.com/Yohannfra/Nvim-Switch-Buffer
-- use 'tools-life/taskwiki'
-- use "xarthurx/vim-taskwarrior"
-- use 'justinmk/vim-dirvish'
-- use "machakann/vim_sandwich",
-- use { "voldikss/LeaderF-floaterm", requires = "Yggdroot/LeaderF" }
-- use { "turbio/bracey.vim", run = "npm install_server" },
-- use "~/repos/friendly_snippets"
