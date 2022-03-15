local config = require("config")
local pluginmap = require("plugins.pluginmap")
local packerConfig = require("plugins.packer-config")

-- $ nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
return require("packer").startup(
  {
    function(use)
      use("wbthomason/packer.nvim")
      -- TODO: cp impatient.nvim ../impatient
      -- use {"lewis6991/impatient.nvim", rocks = "mpack"}

      local load_config = {skip = {"vista.vim"}, disable = {"options.nvim"}}

      pluginmap.load_plugins(use, load_config)

      -- Basic key mappings
      use("mhinz/vim-sayonara")
      use("moll/vim-bbye")
      use("ojroques/nvim-bufdel")
      use("tpope/vim-repeat")
      use("Konfekt/vim-alias")
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

      -- ====================================
      -- Integrations
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
          "nvim-telescope/telescope.nvim",
          requires = {
            "kyazdani42/nvim-web-devicons",
            "nvim-lua/popup.nvim",
            "nvim-lua/plenary.nvim",
            "tami5/sqlite.lua",
            {"AckslD/nvim-neoclip.lua", requires = {"tami5/sqlite.lua", module = "sqlite"}},
            {
              "lazytanuki/nvim-mapper",
              before = "telescope.nvim",
              config = function()
                require("nvim-mapper").setup({})
              end
            },
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

      -- ====================================
      -- Visual enhancements

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

      require("harpoon").setup(
        {
          menu = {
            width = vim.api.nvim_win_get_width(0) - 4
          }
        }
      )

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
      -- use "AckslD/nvim-anywise-reg.lua"

      -- ====================================
      -- System utils
      use("bchretien/vim-profiler")
      use("tweekmonster/startuptime.vim")
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
          "ncm2/float-preview.nvim",
          config = function()
            require("plugins.configs.float-preview")
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
            require("plugins.configs.nnn")
          end
        }
      )
      use("Yohannfra/Nvim-Switch-Buffer")

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

      -- ====================================
      -- Themes

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
