local pluginmap = require("plugins.pluginmap")
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

local packer_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.notify("Packer not detected, installing ...")
  packer_bootstrap = vim.fn.system(
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

local packerConfig = require("plugins.packer-config")

-- $ nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
return require("packer").startup(
  {
    function(use)
      use("wbthomason/packer.nvim")
      use("lewis6991/impatient.nvim")
      use("nathom/filetype.nvim")
      -- use {
      --   'yamatsum/nvim-nonicons',
      --   requires = { 'kyazdani42/nvim-web-devicons' }
      -- }
      pluginmap.load_plugins(use, load_config)

      -- Basic key mappings
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
      -- Integrations
      use(
        {
          "nvim-telescope/telescope.nvim",
          requires = {
            "kyazdani42/nvim-web-devicons",
            "nvim-lua/popup.nvim",
            "nvim-lua/plenary.nvim",
            "tami5/sqlite.lua",
            { "AckslD/nvim-neoclip.lua", requires = { "tami5/sqlite.lua", module = "sqlite" } },
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
            "LinArcX/telescope-changes.nvim",
            "GustavoKatel/telescope-asynctasks.nvim",
            "benfowler/telescope-luasnip.nvim",
            "camgraff/telescope-tmux.nvim",
            "LinArcX/telescope-ports.nvim",
            -- { "chip/telescope-code-fence.nvim", run = "luarocks --local install lunamark" },
            "keyvchan/telescope-find-pickers.nvim",
            "dhruvmanila/telescope-bookmarks.nvim",
            "gbrlsnchs/telescope-lsp-handlers.nvim",
            "nvim-telescope/telescope-dap.nvim",
            "nvim-telescope/telescope-frecency.nvim",
            "nvim-telescope/telescope-symbols.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
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
            {
              "nvim-telescope/telescope-rg.nvim",
              requires = {
                { "nvim-telescope/telescope-live-grep-args.nvim" }
              }
            },
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
      use("njhoffman/slimux")
      use("sefeng211/vim-pastebins")
      -- Visual Selection <C-U>PastebinPaste - <C-U>, PastebinPasteAll, PastebinPasteList
      vim.g.enabled_pastebin_service = "dpaste.org"

      -- ====================================
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
      -- use "AckslD/nvim-anywise-reg.lua"

      -- ====================================
      -- System utils
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
      -- use("ThePrimeagen/vim-apm") -- VimApmShutdown, VimAp, ~/apm.csvm

      -- use { "stevearc/stickybuf.nvim", config = function() require("plugins.configs.stickybuf") end }

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
      -- use "preservim/vim-pencil"

      -- ====================================
      -- Treesitter
      -- use({ "ikatyang/tree-sitter-markdown", requires = "nvim-treesitter" })
      -- use { 'mfussenegger/nvim-ts-hint-textobject', requires = 'nvim-treesitter',
      --   config = function()
      --     -- omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
      --     -- vnoremap <silent> m :lua require('tsht').nodes()<CR>
      --   end
      -- }

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

      -- Automatically set up your configuration after cloning packer.nvim
      -- Put this at the end after all plugins
      if packer_bootstrap then
        local ok, packer = pcall(require, "packer")
        if not ok then
          local msg = "calling module: packer, fail: " .. ok
          vim.notify(msg, "error", { title = "Packer Error" })
        else
          packer.sync()
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
