local utils = require("utils.lazy")
local lz_syn = false

-- NOTE: generate new plugins from https://github.com/ellisonleao/nvim-plugin-template
-- https://github.com/meznaric/key-analyzer.nvim?tab=readme-ov-file
-- https://github.com/kovidgoyal/kitty/pull/7681
-- https://github.com/folke/snacks.nvim/blob/main/lua/snacks/debug.lua

local plugins = {
  { "stevearc/dressing.nvim", dependencies = "MunifTanjim/nui.nvim", event = "VeryLazy" },
  -- display window manager: https://github.com/altermo/nwm
  { "3rd/image.nvim", enabled = false, event = "VeryLazy", dependencies = "nvim-treesitter" },

  -- https://gist.github.com/GnikDroy/62556534324f9dc9192f7bba5a88cc43
  { "goolord/alpha-nvim", event = "VimEnter", dependencies = "nvim-web-devicons" },

  { "tamton-aquib/zone.nvim", enabled = false },
  -- https://github.com/romgrk/barbar.nvim/pull/540
  -- { 'akinsho/bufferline.nvim', version = '*', dependencies = 'nvim-tree/nvim-web-devicons' },
  {
    "romgrk/barbar.nvim",
    -- branch = 'fix-telescope-insert',
    lazy = false,
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    event = "VimEnter",
    dependencies = "nvim-web-devicons",
  },
  { "declancm/cinnamon.nvim", event = "VeryLazy" },
  { "karb94/neoscroll.nvim", event = "VeryLazy" },
  {
    "00sapo/visual.nvim",
    enabled = false,
    dependencies = { "nvim-treesitter", "nvim-various-textobjs", "nvim-treesitter-textobjects" },
    event = "VeryLazy",
  },
  {
    "Makaze/watch.nvim",
    cmd = { "WatchStart", "WatchStop", "WatchFile" },
  },
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
  {
    "tummetott/reticle.nvim",
    enabled = false,
    lazy = false,
    event = { "BufReadPre", "BufNewFile" },
    -- reticle messes up with Neo-tree cursorline in search mode
    opts = {
      always = { cursorline = { "neo-tree" } },
      on_startup = { cursorline = true, cursorcolumn = false },
      never = {
        cursorline = { "qf", "noice", "navbuddy" },
        cursorcolumn = { "qf", "noice", "navbuddy" },
      },
    },
  },
  {
    "chrishrb/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { "nvim-lua/plenary.nvim" },

    -- you can specify also another config if you want
    config = function()
      require("gx").setup({
        open_browser_app = "xdg-open", -- specify your browser app; default for macOS is "open", Linux "xdg-open" and Windows "powershell.exe"
        -- open_browser_args = { '--background' }, -- specify any arguments, such as --background for macOS' "open".
        handlers = {
          plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
          github = true, -- open github issues
          brewfile = true, -- open Homebrew formulaes and casks
          package_json = true, -- open dependencies from package.json
          search = true, -- search the web/selection on the web if nothing else is found
          go = true, -- open pkg.go.dev from an import statement (uses treesitter)
          jira = { -- custom handler to open Jira tickets (these have higher precedence than builtin handlers)
            name = "jira", -- set name of handler
            handle = function(mode, line, _)
              local ticket = require("gx.helper").find(line, mode, "(%u+-%d+)")
              if ticket and #ticket < 20 then
                return "http://jira.company.com/browse/" .. ticket
              end
            end,
          },
          rust = { -- custom handler to open rust's cargo packages
            name = "rust", -- set name of handler
            filetype = { "toml" }, -- you can also set the required filetype for this handler
            filename = "Cargo.toml", -- or the necessary filename
            handle = function(mode, line, _)
              local crate = require("gx.helper").find(line, mode, "(%w+)%s-=%s")

              if crate then
                return "https://crates.io/crates/" .. crate
              end
            end,
          },
        },
        handler_options = {
          search_engine = "google", -- you can select between google, bing, duckduckgo, and ecosia
          -- search_engine = 'https://search.brave.com/search?q=', -- or you can pass in a custom search engine
          select_for_search = false, -- if your cursor is e.g. on a link, the pattern for the link AND for the word will always match. This disables this behaviour for default so that the link is opened without the select option for the word AND link

          git_remotes = { "upstream", "origin" }, -- list of git remotes to search for git issue linking, in priority
          -- git_remotes = function(fname) -- you can also pass in a function
          --   if fname:match('myproject') then
          --     return { 'mygit' }
          --   end
          --   return { 'upstream', 'origin' }
          -- end,
          --
          git_remote_push = false, -- use the push url for git issue linking,
          -- git_remote_push = function(fname) -- you can also pass in a function
          --   return fname:match('myproject')
          -- end,
        },
      })
    end,
  },
  {
    "rmagatti/gx-extended.nvim",
    config = function()
      -- package.json - gx when cursor is under an npm dependency, navigates to https://www.npmjs.com/package/[packageName]
      -- plugins.lua - In packer.nvim's convention plugins.lua file, gx when cursor is under a plugin dependency, navigates to https://github.com/[user/org]/[repo]
      -- *.tf - In a terraform file, gx when cursor is under a terraform resource definition navigates to https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/[resourceName]
      -- * - In any file, gx navigates to no-protocol-urls like google.com, docs.google.com, etc.
      require("gx-extended").setup({
        extensions = {
          { -- match github repos in lazy.nvim plugin specs
            patterns = { "*/plugins/**/*.lua" },
            name = "neovim plugins",
            match_to_url = function(line_string)
              local line = string.match(line_string, "[\"|'].*/.*[\"|']")
              local repo = vim.split(line, ":")[1]:gsub("[\"|']", "")
              local url = "https://github.com/" .. repo
              return line and repo and url or nil
            end,
          },
        },
      })
    end,
  },
  {
    "OXY2DEV/helpview.nvim",
    lazy = false, -- ft = "help",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "monaqa/dial.nvim",
    event = { "VeryLazy" },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  { "tris203/hawtkeys.nvim", event = { "VeryLazy" } },
  { "nvzone/showkeys", cmd = "ShowkeysToggle" },
  {
    "stevearc/conform.nvim",
    lazy = false,
    -- event = { 'BufWritePre' },
    cmd = { "ConformInfo" },
    init = function()
      -- If you want the formatexpr, here is the place to set it
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
  { "echasnovski/mini.trailspace", event = "VeryLazy" },

  {
    "nmac427/guess-indent.nvim",
    event = "BufReadPre",
    opts = require("configs.guess-indent__opts"),
  },
  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPre", "BufNewFile" },
    init = require("configs.mini-indentscope__init"),
    enabled = true,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    enabled = true,
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local cfg = {
        chunk = {
          enable = true,
          priority = 5,
          use_treesitter = true,
          chars = {
            horizontal_line = "─",
            vertical_line = "│",
            left_top = "┌",
            left_bottom = "└",
            right_arrow = "─",
          },
          style = {
            { fg = "#005678", bg = "#001018" },
            -- { fg = "#007698", bg = "#000000" },
            { fg = "#4056a7", bg = "#000000" },
          },
          -- style} = { { fg = "#806d9c" }, { fg = "#c21f30" } },
          textobject = "",
          max_file_size = 1024 * 1024,
          error_sign = true,
          -- animation related
          duration = 200,
          delay = 200,
        },
      }

      require("hlchunk").setup(cfg)
    end,
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
    dependencies = "kevinhwang91/promise-async",
    cmd = { "UfoEnable", "UfoAttach", "UfoEnableFold" },
    enabled = true,
    -- event = { 'BufReadPost', 'InsertEnter' },
    event = { "UIEnter" },
  },
  {
    -- https://github.com/luckasRanarison/tailwind-tools.nvim
    "laytan/tailwind-sorter.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
    build = "cd formatter && npm i && npm run build",
    config = function()
      require("tailwind-sorter").setup({
        on_save_enabled = true, -- If `true`, automatically enables on save sorting.
        node_path = "/home/nicholas/.asdf/shims/node",
      })
    end,
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
  {
    "robitx/gp.nvim",
    config = function()
      local conf = {
        -- For customization, refer to Install > Configuration in the Documentation/Readme
      }
      require("gp").setup(conf)

      -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
    end,
  },

  { "BlackLight/nvim-http" },
  -- https://github.com/oysandvik94/curl.nvim
  {
    "oysandvik94/curl.nvim",
    cmd = { "CurlOpen" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    --     config = function()
    -- " A buffer that is scoped to the current working directory
    -- :CurlOpen
    --
    -- " A global buffer that will be the same for all Neovim instances
    -- :CurlOpen global
    --
    -- " Create or open a new collection with the given scope
    -- :CurlOpen collection global {any_name}
    -- :CurlOpen collection scoped {any_name}
    --
    -- " Open a picker to select a collection
    -- :CurlCollection global
    -- :CurlCollection scoped
    -- local curl = require("curl")
    -- curl.setup({})
    --
    -- vim.keymap.set("n", "<leader>cc", function()
    --     curl.open_curl_tab()
    -- end, { desc = "Open a curl tab scoped to the current working directory" })
    --
    -- vim.keymap.set("n", "<leader>co", function()
    --     curl.open_global_tab()
    -- end, { desc = "Open a curl tab with gloabl scope" })
    --
    -- -- These commands will prompt you for a name for your collection
    -- vim.keymap.set("n", "<leader>csc", function()
    --       curl.create_scoped_collection()
    -- end, { desc = "Create or open a collection with a name from user input" })
    --
    -- vim.keymap.set("n", "<leader>cgc", function()
    --       curl.create_global_collection()
    -- end, { desc = "Create or open a global collection with a name from user input" })
    --
    -- vim.keymap.set("n", "<leader>fsc", function()
    --       curl.pick_scoped_collection()
    -- end, { desc = "Choose a scoped collection and open it" })
    --
    -- vim.keymap.set("n", "<leader>fgc", function()
    --       curl.pick_global_collection()
    -- end, { desc = "Choose a global collection and open it" })
  },
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
    keys = {
      { "<leader>sv", "<cmd>TWValues<cr>", desc = "Show tailwind CSS values" },
    },
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
  {
    "winston0410/range-highlight.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = "winston0410/cmd-parser.nvim",
  },
  -- { 'petertriho/nvim-scrollbar', event = { 'BufReadPost', 'BufNewFile' } },
  {
    "dstein64/nvim-scrollview",
    -- `conflicts`    git merge conflicts
    -- `cursor`       cursor position
    -- `diagnostics`  errors, warnings, info, and hints via |vim.diagnostic|
    -- `folds`        closed folds
    -- `loclist`      items on the location list
    -- `marks`
    -- `quickfix`     items on the quickfix list
    -- `search`
    -- `spell`        spell check items when the |'spell'| option is enabled
    -- `textwidth`    line lengths exceeding the value of the |'textwidth'| option, when non-zero
    -- `trail`        trailing whitespace, when the |'list'| option is enabled and the |'listchars'| option includes "trail"
    config = function()
      -- TODO: winblend_gui for floating windows
      -- shape = { head = "▲", body = "█", tail = "▼" },
      -- `simple`     Top position reflects the window's top line number relative to the document's
      --              line count. The height reflects the size of the window relative to the document's
      --              line count. Mouse drag may be unresponsive when there are closed folds.
      -- `virtual`    Position and height like `simple`, but line numbers and document line count are updated
      --              to virtual counterparts that account for closed folds. The top position reflects the
      --              window's top virtual line number relative to the document's virtual line count.
      --              The height reflects the size of the window relative to the document's virtual
      --              line count. Works slower than `simple` mode.
      -- `proper`     Position and height like 'virtual', but diff filler and virtual text lines are also
      --              considered. Works slower than `virtual` mode.
      -- `auto`       'Proper' when having few buffer lines and luajit, else `virtual` mode is used.
      require("scrollview").setup({
        excluded_filetypes = {
          "WhichKey",
          "TelescopePrompt",
          "chatgpt-input",
          "cmp_docs",
          "cmp_menu",
          "lazy",
          "neoai-input",
          "nerdtree",
          "noice",
          "notify",
          "prompt",
        },
        signs_max_per_row = 2,
        -- text = "┆", "▁", "", "", " ", ﹘‐ ‑ ‒ – — ― ‖ ‗﹉ ﹊ ﹋ ﹌ ﹍ ﹎ ﹏
        cursor_symbol = "•",
        search_symbol = { vim.fn.nr2char(0x2261) }, -- { "-", "= ", vim.fn.nr2char(0x2261) },
        diagnostics_error_symbol = { "" }, -- { "-", "= " },
        diagnostics_warn_symbol = { "—" }, -- { "-", "= " },
        winblend_gui = 30,
        current_only = false,
        -- base = "right", -- left, right, buffer
        -- column = 80,
        -- zindex = 40,
        floating_windows = true,
        signs_on_startup = {
          "conflicts",
          "cursor",
          "diagnostics",
          -- 'folds',
          -- 'loclist',
          -- 'marks',
          -- 'quickfix',
          "search",
          -- 'spell',
          -- 'textwidth',
          -- 'trail',
          -- 'all'
        },
        diagnostics_severities = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.ERROR },
      })
    end,
  },
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
  { "Bekaboo/deadcolumn.nvim", event = { "VimEnter" } },
  -- treesitter
  -- https://github.com/ziontee113/query-secretary
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
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
      -- "RRethy/nvim-treesitter-textsubjects",
      "HiPhish/nvim-ts-rainbow2",
      "jbyuki/tree-sitter-ntangle",
      { "sustech-data/wildfire.nvim", enabled = false },
      "nvim-lua/plenary.nvim",
      { "ThePrimeagen/refactoring.nvim", dependencies = { { "nvim-lua/plenary.nvim" } } },
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/playground",
      { "nvim-treesitter/nvim-treesitter-context" },
      "windwp/nvim-ts-autotag",
      { "ziontee113/query-secretary", keys = { "<leader><BS>" } },
    },
  },
  { "echasnovski/mini.ai", event = { "VeryLazy" }, dependencies = { "echasnovski/mini.extra" } },
  { "chrisgrieser/nvim-various-textobjs", event = { "VeryLazy" } },
  { "stevearc/aerial.nvim", event = { "VeryLazy" }, dependencies = { "nvim-treesitter" } },
  -- motion
  { "rainbowhxch/accelerated-jk.nvim", enabled = false, event = "VeryLazy" },
  { "abecodes/tabout.nvim", event = { "InsertEnter" } },
  { "roobert/tabtree.nvim", event = { "BufReadPost", "BufNewFile" } },
  { "Weissle/easy-action" },
  { "gbprod/stay-in-place.nvim" },
  {
    "cbochs/portal.nvim",
    -- Optional dependencies
    enabled = false,
    dependencies = {
      "cbochs/grapple.nvim",
      "ThePrimeagen/harpoon",
      -- require("portal").setup({
      --     ---@type "debug" | "info" | "warn" | "error"
      --     log_level = "warn",
      --
      --     ---The base filter applied to every search.
      --     ---@type Portal.SearchPredicate | nil
      --     filter = nil,
      --
      --     ---The maximum number of results for any search.
      --     ---@type integer | nil
      --     max_results = nil,
      --
      --     ---The maximum number of items that can be searched.
      --     ---@type integer
      --     lookback = 100,
      --
      --     ---An ordered list of keys for labelling portals.
      --     ---Labels will be applied in order, or to match slotted results.
      --     ---@type string[]
      --     labels = { "j", "k", "h", "l" },
      --
      --     ---Select the first portal when there is only one result.
      --     select_first = false,
      --
      --     ---Keys used for exiting portal selection. Disable with [{key}] = false
      --     ---to `false`.
      --     ---@type table<string, boolean>
      --     escape = {
      --         ["<esc>"] = true,
      --     },
      --
      --     ---The raw window options used for the portal window
      --     window_options = {
      --         relative = "cursor",
      --         width = 80,
      --         height = 3,
      --         col = 2,
      --         focusable = false,
      --         border = "single",
      --         noautocmd = true,
      --     },
      -- })
    },
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
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
  },
  -- movement highlighters
  -- https://github.com/tzachar/local-highlight.nvim
  -- https://github.com/jjshoots/betterf.nvim/tree/main
  { "smoka7/hop.nvim", event = { "BufReadPost", "BufNewFile" } },
  { "folke/flash.nvim", event = "VeryLazy" },
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
  },
  -- cursor
  -- { "gen740/SmoothCursor.nvim", event = { "BufReadPost", "BufNewFile" } },
  {
    "sphamba/smear-cursor.nvim",
    cond = vim.g.neovide == nil,
  },
  {
    "rasulomaroff/reactive.nvim",
    enabled = true,
    dependencies = { "sphamba/smear-cursor.nvim" },
  },
  {
    "echasnovski/mini.animate",
    cond = vim.g.neovide == nil,
    event = "VeryLazy",
  },
  -- { 'otavioschwanck/cool-substitute.nvim' },
  -- matching

  {
    "andymass/vim-matchup",
    lazy = false,
    init = function()
      vim.g.matchup_text_obj_linewise_operators = { "c", "d", "y" }
      vim.g.loaded_matchit = 1
      vim.g.disable_virtual_text = 1
      -- disable virtual text highlighting virtual end of blocks for langs without markers

      vim.g.matchup_enabled = 1 -- enable/disable plugin entirely
      vim.g.matchup_matchparen_enabled = 1
      vim.g.matchup_motion_enabled = 1
      vim.g.matchup_text_obj_enabled = 1
      vim.g.matchup_surround_enabled = 1 -- adds ds% and cs%

      vim.g.matchup_delim_noskips = 1 -- matching between strings and constants (0 always, 1 no words, 2 never)
      vim.g.matchup_delim_stopline = 2000 -- 1500  (# of lines to search for motions/text objects)

      vim.g.matchup_matchparen_pumvisible = 0
      -- 1 (show matching even when pum-completion is visible)
      vim.g.matchup_matchparen_offscreen = {} -- method = popup, status, status_minimal, empty dict to disable

      vim.g.matchup_motion_override_Npercent = 0 -- enable vim default {count}%
      vim.g.matchup_matchparen_timeout = 150 -- 300
      vim.g.matchup_matchparen_insert_timeout = 30 -- 60
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_deferred_fade_time = 0 -- 0 (ms match will disappear after no movement)
      vim.g.matchup_matchparen_deferred_show_delay = 50 -- 50 (time between cursor stop moving and match check)
      vim.g.matchup_matchparen_deferred_hide_delay = 700 -- 700 (hide stale matches after n seconds of cursor movement)
      vim.g.matchup_matchparen_hi_surround_always = 1
      vim.g.matchup_matchparen_stopline = 2000 -- (# of lines to search for highlighting only)
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
  {
    -- "Wansmer/treesj",
    "njhoffman/treesj",
    -- dir = "~/git/treesj",
    event = { "VeryLazy" },
    dependencies = { "nvim-treesitter" },
  },
  -- surround
  { "echasnovski/mini.surround", event = { "VeryLazy" } },
  -- traversal/swapping
  { "mizlan/iswap.nvim", event = { "BufReadPost", "BufNewFile" } },
  { "ziontee113/SelectEase", enabled = true, event = "VeryLazy" },
  { "chrisgrieser/nvim-spider", event = "VeryLazy" },
  { "echasnovski/mini.move", event = "VeryLazy" },
  -- alignment
  { "echasnovski/mini.align", event = "VeryLazy" },
  { "dhruvasagar/vim-table-mode", event = "VeryLazy", ft = { "markdown", "pandoc", "vimwiki" } },
  { "echasnovski/mini.doc", version = false, event = "VeryLazy" },
  { "echasnovski/mini.bracketed", event = "VeryLazy" },
  { "jkramer/vim-checkbox", event = "VeryLazy", ft = { "markdown", "pandoc", "vimwiki" } },
  -- formatting
  { "ckolkey/ts-node-action", dependencies = { "nvim-treesitter" } },
  { "johmsalas/text-case.nvim", event = "VeryLazy" },
  { "echasnovski/mini.operators", version = false },
  { "echasnovski/mini.jump", version = false },
  { "echasnovski/mini.jump2d", version = false },

  {
    -- https://www.reddit.com/r/neovim/comments/1bq0cxy/minidiff_work_with_diff_hunks_interactively/
    "echasnovski/mini.comment",
    -- keep this for operator  (dgc, dgb, cgc) and visual functions
    event = "VeryLazy",
    opts = {
      mappings = {
        --   -- Toggle comment (like `gcip` - comment inner paragraph) for both Normal and Visual modes
        comment = "", -- gc
        comment_line = "", -- gcc
        comment_visual = "gc", -- gc
        --   -- Define 'comment' textobject (like `dgc` - delete whole comment block)
        --   -- Works also in Visual mode if mapping differs from `comment_visual`
        text_object = "gc",
      },
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring()
            or vim.bo.commentstring
        end,
      },
    },
  },
  -- keep this for block functions
  { "numToStr/Comment.nvim", event = "VeryLazy" },
  {
    "andrewferrier/debugprint.nvim",
    event = "VeryLazy",
  },
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
  { "smjonas/live-command.nvim", event = "VeryLazy" }, -- branch = 'remote',
  { "Konfekt/vim-alias", event = "VeryLazy" },
  --
  -- pickers
  --
  -- https://github.com/axkirillov/easypick.nvim
  -- https://github.com/adoyle-h/telescope-extension-maker.nvim
  -- https://github.com/adoyle-h/ad-telescope-extensions.nvim
  -- https://github.com/otavioschwanck/telescope-alternate.nvim
  -- https://github.com/lpoto/telescope-tasks.nvim
  -- "moevis/smartjump.nvim",
  -- "nvim-telescope/telescope-vimspector",
  -- "benfowler/telescope-luasnip.nvim",
  { "echasnovski/mini.fuzzy", event = "VeryLazy" },
  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  { "echasnovski/mini.files", version = false },
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    cmd = { "Neotree" },
    event = "VimEnter",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-web-devicons", "MunifTanjim/nui.nvim" },
  },
  {
    "moyiz/git-dev.nvim",
    event = "VeryLazy",
    opts = {},
  },
  { "neo451/feed.nvim", enabled = false },
  -- Lazy
  {
    "2kabhishek/nerdy.nvim",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Nerdy",
    -- Running the python scripts/generator.py command will automatically fetch new icons from source and update the icons.
  },
  {
    -- 'njhoffman/telescope.nvim',
    "nvim-telescope/telescope.nvim",
    dir = "/home/nicholas/git/telescope.nvim",
    cmd = "Telescope",
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
      {
        "lalitmee/browse.nvim",
        config = function()
          -- require('browse.devdocs').search_with_filetype()
          -- require('browse.mdn').search()
          require("browse").setup({
            -- search provider you want to use
            provider = "google", -- duckduckgo, bing
            -- either pass it here or just pass the table to the functions
            -- see below for more
            bookmarks = {},
            icons = {
              bookmark_alias = "->", -- if you have nerd fonts, you can set this to ""
              bookmarks_prompt = "", -- if you have nerd fonts, you can set this to "󰂺 "
              grouped_bookmarks = "->", -- if you have nerd fonts, you can set this to 
            },
          })
          -- local bookmarks = {
          --   ["github"] = {
          --       ["name"] = "search github from neovim",
          --       ["code_search"] = "https://github.com/search?q=%s&type=code",
          --       ["repo_search"] = "https://github.com/search?q=%s&type=repositories",
          --       ["issues_search"] = "https://github.com/search?q=%s&type=issues",
          --       ["pulls_search"] = "https://github.com/search?q=%s&type=pullrequests",
          --   },
          -- }
          -- local bookmarks = {
          --   "https://github.com/search?q=%s&type=code",
          --   "https://github.com/search?q=%s&type=repositories",
          -- }
          -- local bookmarks = {
          --   "https://github.com/hoob3rt/lualine.nvim",
          --   "https://github.com/neovim/neovim",
          --   "https://neovim.discourse.group/",
          --   "https://github.com/nvim-telescope/telescope.nvim",
          --   "https://github.com/rockerBOO/awesome-neovim",
          -- }

          --   function command(name, rhs, opts)
          --     opts = opts or {}
          --     vim.api.nvim_create_user_command(name, rhs, opts)
          --   end

          --   command('InputSearch', function()
          --     browse.input_search()
          --   end, {})

          --   -- this will open telescope using dropdown theme with all the available options
          --   -- in which `browse.nvim` can be used
          --   command('Browse', function()
          --     browse.browse({ bookmarks = bookmarks })
          --   end)

          --   command('Bookmarks', function()
          --     browse.open_bookmarks({ bookmarks = bookmarks })
          --   end)

          --   command('DevdocsSearch', function()
          --     browse.devdocs.search()
          --   end)

          --   command('DevdocsFiletypeSearch', function()
          --     browse.devdocs.search_with_filetype()
          --   end)

          --   command('MdnSearch', function()
          --     browse.mdn.search()
          --   end)
        end,
      },
      {
        "isak102/telescope-git-file-history.nvim",
        dependencies = { "tpope/vim-fugitive" },
      },
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
      {
        -- https://github.com/ptdewey/yankbank-nvim
        -- https://github.com/mistricky/codesnap.nvim
        "gbprod/yanky.nvim",
        -- keys = {
        --   {
        --     '<leader>p',
        --     function()
        --       require('telescope').extensions.yank_history.yank_history({})
        --     end,
        --     desc = 'Open Yank History',
        --   },
        --   { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yank text' },
        --   { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, desc = 'Put yanked text after cursor' },
        --   { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put yanked text before cursor' },
        --   { 'gp', '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' }, desc = 'Put yanked text after selection' },
        --   { 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' }, desc = 'Put yanked text before selection' },
        --   { '<c-p>', '<Plug>(YankyPreviousEntry)', desc = 'Select previous entry through yank history' },
        --   { '<c-n>', '<Plug>(YankyNextEntry)', desc = 'Select next entry through yank history' },
        --   { ']p', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put indented after cursor (linewise)' },
        --   { '[p', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put indented before cursor (linewise)' },
        --   { ']P', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put indented after cursor (linewise)' },
        --   { '[P', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put indented before cursor (linewise)' },
        --   { '>p', '<Plug>(YankyPutIndentAfterShiftRight)', desc = 'Put and indent right' },
        --   { '<p', '<Plug>(YankyPutIndentAfterShiftLeft)', desc = 'Put and indent left' },
        --   { '>P', '<Plug>(YankyPutIndentBeforeShiftRight)', desc = 'Put before and indent right' },
        --   { '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)', desc = 'Put before and indent left' },
        --   { '=p', '<Plug>(YankyPutAfterFilter)', desc = 'Put after applying a filter' },
        --   { '=P', '<Plug>(YankyPutBeforeFilter)', desc = 'Put before applying a filter' },
        -- },
      },
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
      {
        "luckasRanarison/nvim-devdocs",
        enabled = false,
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-treesitter/nvim-treesitter",
        },
        -- run = 'DevdocsFetch',
        opts = {
          dir_path = vim.fn.stdpath("data") .. "/devdocs", -- installation directory
          telescope = {}, -- passed to the telescope picker
          telescope_alt = {}, -- when searching globally without preview
          float_win = { -- passed to nvim_open_win(), see :h api-floatwin
            relative = "editor",
            height = 25,
            width = 100,
            border = "rounded",
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
  {
    "ray-x/forgit.nvim",
    config = function()
      require("forgit").setup({
        debug = false, -- enable debug logging default path is ~/.cache/nvim/forgit.log
        diff_pager = "delta", -- you can use `diff`,         `diff-so-fancy`
        diff_cmd = "", -- you can use `DiffviewOpen`, `Gvdiffsplit` or `!git diff`, auto if not set
        fugitive = false, -- git fugitive installed?
        abbreviate = false, -- abvreviate some of the commands e.g. gps -> git push
        git_alias = true, -- git command extensions see: Git command alias
        show_result = "quickfix", -- show cmd result in quickfix or notify
        shell_mode = true, -- set to true if you using zsh/bash and can not run forgit commands
        height_ratio = 0.6, -- height ratio of floating window when split horizontally
        cmds_list = {}, -- additional commands to show in Forgit command list
        width_ratio = 0.6, -- width ratio of floating window when split vertically
      })
    end,
  },

  -- https://www.reddit.com/r/neovim/comments/1broo6b/my_git_github_workflow_an_efficient_yet_messy/
  { "rbong/vim-flog", cmd = { "Flog", "Flogsplit" } },
  { "ThePrimeagen/git-worktree.nvim", event = "VeryLazy" },
  { "napisani/nvim-github-codesearch", cmd = "GithubSearch", build = "make" },
  { "akinsho/git-conflict.nvim", version = "*", lazy = false },
  { "pwntester/octo.nvim", cmd = "Octo", dependencies = "nvim-web-devicons" },
  { "kdheepak/lazygit.nvim", cmd = "LazyGit" },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    dependencies = "nvim-lua/plenary.nvim",
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
  {
    "michaelb/sniprun",
    build = "bash install.sh",
    cmd = { "SnipRun", "SnipInfo" },
  },
  { "milisims/nvim-luaref", event = "VeryLazy" },
  -- https://github.com/MagicDuck/grug-far.nvim
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
      vim.g.firenvim_config = {
        globalSettings = {
          -- alt = "all",
          -- ['<C-w>'] = 'noop',
          -- ['<C-n>'] = 'default'
          ignoreKeys = {
            all = { "<C-->" },
            normal = { "<C-1>", "<C-2>" },
          },
        },
        localSettings = {
          [".*"] = {
            -- cmdline = "neovim",
            content = "text", -- text, html
            priority = 0,
            -- selector = 'textarea:not([readonly], [aria-readonly]), div[role="textbox"]',
            takeover = "never",
            -- `always`, `empty`, `never`, `nonempty` or `once`.
          },
        },
      }
      -- vim.api.nvim_create_autocmd({ "UIEnter" }, {
      --   callback = function(event)
      --     local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
      --     if client ~= nil and client.name == "Firenvim" then
      --       vim.o.laststatus = 0
      --     end
      --   end,
      -- })

      -- ### Interacting with the page
      -- You can execute javascript in the page by using `firenvim#eval_js`. The code has to be a valid javascript expression (NOT a statement). You can provide the name of a function that should be executed with the result of the expression. Note that some pages prevent evaluating JavaScript with their [CSP](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP) and this can't be worked around. Here's an example:
      -- vim.fn['firenvim#eval_js']('alert("Hello World!")', 'MyFunction')
      -- A function named `firenvim#press_keys()` will allow you to send key events to the underlying input field by taking a list of vim-like keys (e.g. `a`, `<CR>`, `<Space>`…) as argument. Note that this only "triggers" an event, it does not add text to the input field. For example if you'd like firenvim to send `<CR>` to the webpage when you press `<CR>` in the editor, you can use the following mapping which is useful with chat apps:
      -- vim.api.nvim_create_autocmd({'BufEnter', {
      --     pattern = "riot.im_*",
      --     command = [[inoremap <CR> <Esc>:w<CR>:call firenvim#press_keys("<LT>CR>")<CR>ggdGa]],
      -- })
      -- Depending on how large the edited buffer is, this could be a little slow. This more sophisticated approach will throttle writes:
      -- vim.api.nvim_create_autocmd({'TextChanged', 'TextChangedI'}, {
      --     callback = function(e)
      --       if vim.g.timer_started == true then
      --         return
      --       end
      --       vim.g.timer_started = true
      --       vim.fn.timer_start(10000, function()
      --         vim.g.timer_started = false
      --         vim.cmd('silent write')
      --       end)
      --     end
      --   })
    end,
  },
  { "lucamot/chrome-remote.nvim", event = "VeryLazy" },
  {
    "lucamot/chrome-dev-console.nvim",
    dependencies = { "lucamot/chrome-remote.nvim" },
  },
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

  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup({
        -- the name of the command
        cmd_name = "RenameInc",
        -- cmd_name = "IncRename",
        -- the highlight group used for highlighting the identifier's new name
        hl_group = "Substitute",
        -- whether an empty new name should be previewed; if false the command preview will be cancelled instead
        preview_empty_name = false,
        -- whether to display a `Renamed m instances in n files` message after a rename operation
        show_message = true,
        -- whether to save the "IncRename" command in the commandline history (set to false to prevent issues with
        -- navigating to older entries that may arise due to the behavior of command preview)
        save_in_cmdline_history = true,
        -- the type of the external input buffer to use (the only supported value is currently "dressing")
        input_buffer_type = nil,
        -- callback to run after renaming, receives the result table (from LSP handler) as an argument
        post_hook = nil,
      })
    end,
  },
  { "filipdutescu/renamer.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
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
  {
    "chrisbra/unicode.vim",
    cmd = {
      "Digraphs",
      "UnicodeSearch",
      "UnicodeName",
      "UnicodeTable",
      "DownloadUnicode",
      "UnicodeCache",
    },
  },
  {
    "simonefranza/nvim-conv",
    cmd = {
      "ConvBin",
      "ConvDec",
      "ConvHex",
      "ConvOct",
      "ConvFarenheit",
      "ConvCelsius",
      "ConvStr",
      "ConvBytes",
      "ConvMetricImperial",
      "ConvDataTransRate",
      "ConvColor",
      "ConvSetPrecision",
    },
  },
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
  {
    "chrisgrieser/nvim-genghis",
    dependencies = { "stevearc/dressing.nvim", "nvim-cmp", "hrsh7th/cmp-omni" },
    config = function()
      -- default config
      require("genghis").setup({
        backdrop = {
          enabled = true,
          blend = 50,
        },
        -- default is ` "trash" ` on Mac/Windows, and `{ "gio", "trash" }` on Linux
        trashCmd = "trash",
      })
      -- .createNewFile: Create a new file.
      -- .duplicateFile: Duplicate the current file.
      -- .moveSelectionToNewFile: Prompts for a new file name and moves the current selection to that new file. (Note that this is a Visual Line mode command, the selection is moved linewise.)
      -- .renameFile: Rename the current file.
      -- .moveAndRenameFile: Move and Rename the current file. Keeps the old name if the new path ends with /. Works like the Unix mv command.
      -- .moveToFolderInCwd: Move the current file to an existing folder in the current working directory.
      -- .copyFilename: Copy the file name.
      -- .copyFilepath: Copy the absolute file path.
      -- .copyFilepathWithTilde: Copy the absolute file path, replacing the home directory with ~.
      -- .copyRelativePath: Copy the relative file path.
      -- .copyDirectoryPath: Copy the absolute directory path.
      -- .copyRelativeDirectoryPath: Copy the relative directory path.
      -- .chmodx: Makes current file executable. Equivalent to chmod +x.
      -- .trashFile: Move the current file to the trash location.
      vim.cmd.cabbrev("Chmodx Genghis chmodx")
      vim.cmd.cabbrev("New Genghis createNewFile")
      vim.cmd.cabbrev("Rename Genghis moveAndRename")
      vim.cmd.cabbrev("Files Genghis")
      vim.cmd.cabbrev("F Genghis")
      vim.cmd.cabbrev("F Genghis")
      vim.cmd.cabbrev("Fdupe Genghis duplicateFile")
      vim.cmd.cabbrev("Fnew Genghis createNewFile")
      vim.cmd.cabbrev("Fren Genghis moveAndRename")
      vim.cmd.cabbrev("Fdel Genghis trashFile")
    end,
  },

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
  {
    "cenk1cenk2/jq.nvim",
    dependencies = {
      -- https://github.com/nvim-lua/plenary.nvim
      "nvim-lua/plenary.nvim",
      -- https://github.com/MunifTanjim/nui.nvim
      "MunifTanjim/nui.nvim",
      -- https://github.com/grapp-dev/nui-components.nvim
      "grapp-dev/nui-components.nvim",
    },
    config = function()
      local defaults = {
        log_level = vim.log.levels.INFO,
        debounce = 25,
        commands = {
          { command = "jq", filetype = "json" },
          { command = "yq", filetype = "json" },
        },
        ui = {
          autoclose = true,
          border = "single",
          width = function(columns)
            if columns < 120 then
              return math.floor(columns * 0.95)
            end

            return 120
          end,
          height = function(lines)
            if lines < 36 then
              return math.floor(lines * 0.95)
            end

            return 36
          end,
          keymap = {
            close = "<Esc>",
            focus_next = "<Tab>",
            focus_prev = "<S-Tab>",
            focus_left = nil,
            focus_right = nil,
            focus_up = nil,
            focus_down = nil,
          },
        },
      }
      require("jq").setup(defaults)

      -- require("jq").run({
      --   --- you can pass additional options to configure the current instance
      --   -- if you want to toggle from the memory
      --   toggle = true,
      --   -- commands for the instance else it will use the default
      --   -- the default command would be the first one in the table
      --   commands = {
      --     {
      --       -- command to be run
      --       command = "jq",
      --       -- filetype of the output
      --       filetype = "json",
      --       -- hidden arguments that will not be shown in the ui
      --       arguments = "-r",
      --     },
      --   },
      --   -- arguments to start with in the ui
      --   arguments = "",
      --   -- query to start with, if not provided it will use the default
      --   query = ".",
      -- })
      -- require("jq").run({
      --   filename = "test.json",
      --   lines = { "lines", "i", "obtained", "from", "somewhere" }
      -- })
    end,
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
  {
    "yochem/jq-playground.nvim",
    config = function()
      local cfg = {
        cmd = { "jq" }, -- gojq, jaq
        output_window = {
          split_direction = "right",
          width = nil,
          height = nil,
        },
        query_window = {
          split_direction = "bottom",
          width = nil,
          height = 0.3,
        },
        disable_default_keymap = false,
      }
      -- -- start the playground
      -- vim.keymap.set("n", "<leader>jq", vim.cmd.JqPlayground)
      --
      -- -- when in the query window, run the jq query
      -- vim.keymap.set("n", "R", "<Plug>(JqPlaygroundRunQuery)")
      -- :JqPlayground sample.json
      -- Some random tips that you may find useful while using this plugin.
      --
      -- If you have a saved jq program that you want to load into the filter window, then run:
      --
      -- :r path/to/some/query.jq
      -- If you want to save the current query or output json, navigate to that buffer and run:
      --
      -- :w path/to/save/query.jq
      -- " or:
      -- :w path/to/save/output.json
      -- Start the JQ editor from the command line without loading the input file:
      --
      -- $ nvim +'JqPlayground input.json'
      -- $ # or put this in your bashrc:
      -- $ jqplay() { nvim +"JqPlayground $1"; }
    end,
    opts = {
      cmd = { "gojq" },
    },
  },
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

    -- specify version to avoid break changes
    -- version = 'v5.*',

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
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    -- event = { "InsertEnter" },
    -- config = true,
  },
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
  {
    "sQVe/sort.nvim",
    -- Optional setup for overriding defaults.
    config = function()
      require("sort").setup({
        {
          -- List of delimiters, in descending order of priority, to automatically sort on.
          delimiters = {
            ",",
            "|",
            ";",
            ":",
            "s", -- Space
            "t", -- Tab
          },
        },
        -- Input configuration here.
        -- Refer to the configuration section below for options.
      })
      -- vim.cmd([[
      --   nnoremap <silent> go <Cmd>Sort<CR>
      --   vnoremap <silent> go <Esc><Cmd>Sort<CR>
      --   ]])
    end,
  },
  -- {
  --   "simnalamburt/vim-mundo",
  --   cmd = { "MundoToggle", "MundoShow", "MundoHide" },
  --   build = function()
  --     vim.cmd([[UpdateRemotePlugins]])
  --   end,
  --   init = function()
  --     vim.g.mundo_prefer_python3 = 1
  --     vim.g.mundo_width = 35
  --     vim.g.mundo_preview_height = 10
  --     vim.g.mundo_right = 1
  --     vim.g.mundo_help = 0
  --     vim.g.mundo_disable = 0
  --     vim.g.mundo_preview_bottom = 1
  --     vim.g.mundo_close_on_revert = 0
  --     vim.g.mundo_auto_preview = 1
  --     vim.g.mundo_playback_delay = 60
  --     -- vim.g.mundo_preview_statusline = nil
  --     -- vim.g.mundo_tree_statusline = nil
  --   end,
  -- },
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

  {
    "fnune/recall.nvim",
    version = "*",
    config = function()
      local recall = require("recall")
      recall.setup({
        -- sign = "",
        -- sign_highlight = "@comment.note",
        sign = "",
        sign_highlight = "RecallMark",
        telescope = {
          autoload = true,
          mappings = {
            unmark_selected_entry = {
              normal = "dd",
              insert = "<M-d>",
            },
          },
        },

        wshada = vim.fn.has("nvim-0.10") == 0,
      })
      -- Using commands:
      vim.keymap.set("n", "mm", recall.toggle, { noremap = true, silent = true })
      vim.keymap.set("n", "mn", recall.goto_next, { noremap = true, silent = true })
      vim.keymap.set("n", "mp", recall.goto_prev, { noremap = true, silent = true })
      vim.keymap.set("n", "mc", recall.clear, { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>.", ":Telescope recall<CR>", { noremap = true, silent = true })
      -- -- In your Neovim configuration:
      -- vim.opt.exrc = true
      -- vim.opt.secure = true
      --
      -- -- /path/to/your/project/.nvim.lua:
      -- vim.opt.shadafile = ".vim/project.shada"
      --
      -- -- Optionally, in the project's .gitignore or ~/.config/git/ignore:
      -- .vim
    end,
  },
  -- https://github.com/otavioschwanck/arrow.nvim
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
  {
    "kndndrj/nvim-dbee",
    dependencies = { "MunifTanjim/nui.nvim" },
    build = function()
      -- Install tries to automatically detect the install method.
      -- if it fails, try calling it with one of these parameters: "curl", "wget", "bitsadmin", "go"
      require("dbee").install()
    end,
  },
  {
    "letieu/graphql.nvim",
    -- keys = {
    --   { "<leader>gg", function() require("graphql").open() end, desc = "graphql - Open" },
    --   { "<leader>gq", function() require("graphql").close() end },
    --   { "<leader>gr", function() require("graphql").run() end }
    -- },
  },
  -- https://github.com/mei28/luminate.nvim
  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
  },
  {
    "tzachar/highlight-undo.nvim",
    enabled = false,
    event = { "VeryLazy" },
  },
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
  {
    "susensio/magic-bang.nvim",
    ft = "sh",
    opts = { automatic = true, command = true, executable = true, default = "/bin/bash" },
  },
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
  -- https://github.com/Zeioth/markmap.nvim
  { "AckslD/nvim-FeMaco.lua", ft = { "markdown", "pandoc" } },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      -- "nvim-tree/nvim-web-devicons",
      "echasnovski/mini.icons",
    }, -- if you prefer nvim-web-devicons
    opts = {},
  },
  {
    "lukas-reineke/headlines.nvim",
    enabled = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "markdown", "pandoc", "pandoc.markdown", "markdown.pandoc" },
  },
  { "njhoffman/markpan.nvim", enabled = false },

  { "elkasztano/nushell-syntax-vim", ft = "nu", lazy = lz_syn },
  { "iamcco/markdown-preview.nvim", build = "cd app && yarn install", cmd = "MarkdownPreview" },
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
  {
    "mtdl9/vim-log-highlighting",
    ft = { "log", "LOG" },
    event = { "BufReadPost", "BufNewFile" },
    lazy = lz_syn,
  },
  {
    "hashivim/vim-terraform",
    ft = "terraform",
    event = { "BufReadPost", "BufNewFile" },
    lazy = lz_syn,
  },
  { "raimon49/requirements.txt.vim", event = "VeryLazy", lazy = lz_syn },
  { "godlygeek/tabular", event = "VeryLazy", lazy = lz_syn },
  { "preservim/vim-markdown", commit = "df4be86", dependencies = { "godlygeek/tabular" } },
}

utils.apply_configs(plugins)
return plugins
