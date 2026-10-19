local utils = require("utils.lazy")
local lz_syn = false

-- https://github.com/alex-popov-tech/store.nvim
-- https://github.com/nvzone/floaterm
-- https://github.com/bngarren/checkmate.nvim
-- https://github.com/oribarilan/lensline.nvim
-- https://github.com/bennypowers/nvim-regexplainer/releases/tag/v1.1.0
-- https://github.com/zerochae/endpoint.nvim
-- NOTE: generate new plugins from https://github.com/ellisonleao/nvim-plugin-template
-- https://github.com/meznaric/key-analyzer.nvim?tab=readme-ov-file
-- https://github.com/kovidgoyal/kitty/pull/7681
-- https://github.com/folke/snacks.nvim/blob/main/lua/snacks/debug.lua

local plugins = {
  {
    dir = vim.fn.expand("~/git/hover.nvim"),
    config = function()
      require("configs.hover")
    end,
    cmd = { "Hover", "HoverCursor", "HoverSticky", "HoverInspect", "HoverClose" },
  },
  -- https://gist.github.com/GnikDroy/62556534324f9dc9192f7bba5a88cc43
  { "dundalek/bloat.nvim", cmd = "Bloat" },
  { "Wansmer/sibling-swap.nvim" },
  {
    "saxon1964/neovim-tips",
    version = "*", -- Only update on tagged releases
    lazy = true, -- Load only when keybinds are triggered
    dependencies = {
      "MunifTanjim/nui.nvim",
      -- OPTIONAL: Choose your preferred markdown renderer (or omit for raw markdown)
      "MeanderingProgrammer/render-markdown.nvim", -- Clean rendering
      -- OR: "OXY2DEV/markview.nvim", -- Rich rendering with advanced features
    },
    opts = {
      -- IMPORTANT: Daily tip DOES NOT WORK with lazy = true
      -- Reason: lazy = true loads plugin only when keybinds are triggered,
      --         but daily_tip needs plugin loaded at startup
      -- Solution: Keep daily_tip = 0 here, or use Option 2 below for daily tips
      daily_tip = 0, -- 0 = off, 1 = once per day, 2 = every startup
      -- Other optional settings...
      bookmark_symbol = "🌟 ",
    },
    keys = {
      { "<leader>ito", ":NeovimTips<CR>", desc = "Neovim tips" },
      { "<leader>itb", ":NeovimTipsBookmarks<CR>", desc = "Bookmarked tips" },
      { "<leader>itr", ":NeovimTipsRandom<CR>", desc = "Show random tip" },
      { "<leader>ite", ":NeovimTipsEdit<CR>", desc = "Edit your tips" },
      { "<leader>ita", ":NeovimTipsAdd<CR>", desc = "Add your tip" },
      { "<leader>itp", ":NeovimTipsPdf<CR>", desc = "Open tips PDF" },
    },
  },
  {
    "danymat/neogen",
    config = function()
      require("neogen").setup({
        enabled = true,
        input_after_comment = true, -- (default: true) automatic jump (with insert mode) on inserted annotation
        -- jump_map = "<C-e>"       -- (DROPPED SUPPORT, see [here](#cycle-between-annotations) !) The keymap in order to jump in the annotation fields (in insert mode)
      })

      local map = require("mapper").map
      map(
        "n",
        "g@@",
        ":lua require('neogen').generate()<CR>",
        { desc = "neogen annotation for func" }
      )
      map(
        "n",
        "g@%",
        ":lua require('neogen').generate({ type = 'file' })<CR>",
        { desc = "neogen annotation for file" }
      )
      map(
        "n",
        "<Leader>@@",
        ":lua require('neogen').generate()<CR>",
        { desc = "neogen annotation for func" }
      )
      map(
        "n",
        "<Leader>@f",
        ":lua require('neogen').generate({ type = 'file' })<CR>",
        { desc = "neogen annotation for file" }
      )
      map(
        "n",
        "<Leader>@c",
        ":lua require('neogen').generate({ type = 'class' })<CR>",
        { desc = "neogen annotation for class" }
      )
      map(
        "n",
        "<Leader>@t",
        ":lua require('neogen').generate({ type = 'type' })<CR>",
        { desc = "neogen annotation for type" }
      )
    end,
  },

  { "goolord/alpha-nvim", event = "VimEnter", dependencies = "nvim-web-devicons" },
  {
    "Dronakurl/injectme.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    -- This is for lazy load and more performance on startup only
    cmd = { "InjectmeToggle", "InjectmeSave", "InjectmeInfo", "InjectmeLeave" },
  },
  { "tamton-aquib/zone.nvim", enabled = false },
  -- https://github.com/romgrk/barbar.nvim/pull/540
  -- { 'akinsho/bufferline.nvim', version = '*', dependencies = 'nvim-tree/nvim-web-devicons' },
  { "jrop/u.nvim", lazy = true },
  {
    "romgrk/barbar.nvim",
    -- branch = 'fix-telescope-insert',
    init = function()
      vim.g.barbar_auto_setup = false
      vim.cmd([[
function! s:h (name, ...)
  let fg = ''
  let bg = ''
  let attr = ''
  let sp = ''

  if type(a:1) == 3
    let fg   = get(a:1, 0, '')
    let bg   = get(a:1, 1, '')
    let attr = get(a:1, 2, '')
    let sp   = get(a:1, 3, '')
  else
    let fg   = get(a:000, 0, '')
    let bg   = get(a:000, 1, '')
    let attr = get(a:000, 2, '')
    let sp   = get(a:000, 3, '')
  end

  let has_props = v:false

  let cmd = 'hi! ' . a:name
  if !empty(fg) && fg != 'none'
    let cmd .= ' guifg=' . fg
    let has_props = v:true
  end
  if !empty(bg) && bg != 'none'
    let cmd .= ' guibg=' . bg
    let has_props = v:true
  end
  if !empty(attr) && attr != 'none'
    let cmd .= ' gui=' . attr
    let has_props = v:true
  end
  if !empty(sp) && sp != 'none'
    let cmd .= ' guisp=' . sp
    let has_props = v:true
  end
  execute 'hi! clear ' a:name
  if has_props
    execute cmd
  end
endfunc

" }}}
" Colors                                                                     {{{

let s:base0      = '#1b2229'
let s:base1      = '#1c1f24'
let s:base2      = '#202328'
let s:base3      = '#23272e'
let s:base4      = '#3f444a'
let s:base5      = '#5B6268'
let s:base6      = '#73797e'
let s:base7      = '#9ca0a4'
let s:base8      = '#b1b1b1'
let s:base9      = '#e6e6e6'

let s:grey       = s:base4
let s:red        = '#ff6c6b'
let s:orange     = '#da8548'
let s:green      = '#98be65'
let s:teal       = '#4db5bd'
let s:yellow     = '#ECBE7B'
let s:blue       = '#51afef'
let s:dark_blue  = '#2257A0'
let s:magenta    = '#c678dd'
let s:violet     = '#a9a1e1'
let s:cyan       = '#46D9FF'
let s:dark_cyan  = '#5699AF'
let s:white      = '#efefef'

let s:green_alt  = '#799033'

let s:bg             = '#181c24'
let s:bg_alt         = '#21242b'
let s:bg_highlight   = '#2E323C'
let s:bg_popup       = '#3E4556'
let s:bg_widget      = s:bg
let s:bg_statusline  = s:bg_popup
let s:bg_selection   = s:dark_blue
let s:bg_highlighted = '#4A4A45'

let s:fg           = '#bbc2cf'
let s:fg_alt       = '#5B6268'
let s:fg_popup     = '#D1D6DF'
let s:fg_widget    = s:fg
let s:fg_conceal   = s:base4
let s:fg_subtle    = s:base7
let s:fg_separator = s:base4

let s:bg_current = s:dark_blue
let s:bg_visible = s:bg
let s:bg_other   = s:base1

call s:h('TabLine',             s:base9, s:bg_alt,     '')
call s:h('TabLineSel',          s:blue,  s:bg_current, 'bold')
call s:h('TabLineFill',         'none',  s:bg_other,   'bold')

call s:h('BufferCurrent',       s:base9,          s:bg_current,  'none')
call s:h('BufferCurrentIndex',  s:base6,          s:bg_current,  'none')
call s:h('BufferCurrentMod',    s:yellow,         s:bg_current,  'none')
call s:h('BufferCurrentSign',   s:blue,           s:bg_current,  'none')
call s:h('BufferCurrentTarget', s:red,            s:bg_current,  'bold')

call s:h('BufferVisible',       s:base7,          s:bg_visible,  'none')
call s:h('BufferVisibleIndex',  s:base9,          s:bg_visible,  'none')
call s:h('BufferVisibleMod',    s:yellow,         s:bg_visible,  'none')
call s:h('BufferVisibleSign',   s:base4,          s:bg_visible,  'none')
call s:h('BufferVisibleTarget', s:red,            s:bg_visible,  'bold')

call s:h('BufferInactive',       s:base6,          s:bg_other,    'none')
call s:h('BufferInactiveIndex',  s:base6,          s:bg_other,    'none')
call s:h('BufferInactiveMod',    s:yellow,         s:bg_other,    'none')
call s:h('BufferInactiveSign',   s:base4,          s:bg_other,    'none')
call s:h('BufferInactiveTarget', s:red,            s:bg_other,    'bold')

call s:h('BufferTabpages',       s:blue,           s:bg_statusline, 'bold')
call s:h('BufferTabpageFill',    s:base4,          s:bg_other,    'bold')
call s:h('BufferOffset',         s:base6,          s:bg,          'bold')
call s:h('BufferScrollArrow',    s:base8,          s:bg_other,       'bold')

]])
    end,
    event = "VimEnter",
    dependencies = "nvim-web-devicons",
  },
  { "declancm/cinnamon.nvim", event = "VeryLazy", enabled = false },
  { "karb94/neoscroll.nvim", event = "VeryLazy", enabled = false },

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
  -- add this to the file where you setup your other plugins:
  {
    "monkoose/neocodeium",
    event = "VeryLazy",
    -- config = function()
    --   local neocodeium = require("neocodeium")
    --   neocodeium.setup()
    --   vim.keymap.set("i", "<A-f>", neocodeium.accept)
    -- end,
  },
  {
    "nvim-lualine/lualine.nvim",
    enabled = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  { "windwp/windline.nvim", enabled = false },
  { "alexpasmantier/tv.nvim" },
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
    "mizlan/iswap.nvim",
    event = "VeryLazy",
  },
  {
    "chrishrb/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "OXY2DEV/helpview.nvim",
    ft = "help",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
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

  {
    "alex-popov-tech/store.nvim",
    dependencies = {
      "OXY2DEV/markview.nvim", -- optional, for pretty readme preview / help window
    },
    cmd = "Store",
    keys = {
      { "<leader>i/", "<cmd>Store<cr>", desc = "Open Plugin Store" },
    },
    opts = {
      -- optional configuration here
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
    -- not BufReadPre: loading ibl inside it changes the current buffer (E201)
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "njhoffman/hlchunk.nvim",
    dir = "~/git/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
  },
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
  {
    "m00qek/baleia.nvim",
    lazy = false,
    config = function()
      vim.g.baleia = require("baleia").setup({})

      -- Command to colorize the current buffer
      vim.api.nvim_create_user_command("BaleiaColorize", function()
        vim.g.baleia.once(vim.api.nvim_get_current_buf())
      end, { bang = true })

      -- Command to show logs
      vim.api.nvim_create_user_command("BaleiaLogs", vim.g.baleia.logger.show, { bang = true })
      vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
        pattern = "*.txt",
        callback = function()
          vim.g.baleia.automatically(vim.api.nvim_get_current_buf())
        end,
      })
    end,
  },
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
    "aaronik/treewalker.nvim",
    config = function()
      require("treewalker").setup({
        -- Whether to briefly highlight the node after jumping to it
        highlight = true,

        -- How long should above highlight last (in ms)
        highlight_duration = 250,

        -- The color of the above highlight. Must be a valid vim highlight group.
        -- (see :h highlight-group for options)
        highlight_group = "CursorLine",

        -- Whether to create a visual selection after a movement to a node.
        -- If true, highlight is disabled and a visual selection is made in
        -- its place.
        select = false,

        -- Whether to use vim.notify to warn when there are missing parsers or incorrect options
        notifications = true,

        -- Whether the plugin adds movements to the jumplist -- true | false | 'left'
        --  true: All movements more than 1 line are added to the jumplist. This is the default,
        --        and is meant to cover most use cases. It's modeled on how { and } natively add
        --        to the jumplist.
        --  false: Treewalker does not add to the jumplist at all
        --  "left": Treewalker only adds :Treewalker Left to the jumplist. This is usually the most
        --          likely one to be confusing, so it has its own mode.
        jumplist = true,
      })

      -- stylua: ignore start
      -- TODO: create plugin that has persistent mode
      -- movement
      local map = require("mapper").map
      map({ "n", "v" }, "<S-Up>",    "<cmd>Treewalker Up<cr>")
      map({ "n", "v" }, "<S-Down>",  "<cmd>Treewalker Down<cr>")
      map({ "n", "v" }, "<S-Left>",  "<cmd>Treewalker Left<cr>")
      map({ "n", "v" }, "<S-Right>", "<cmd>Treewalker Right<cr>")

      -- swapping
      map('n', '<M-C-Up>',    '<cmd>Treewalker SwapUp<cr>')
      map('n', '<M-C-Down>',  '<cmd>Treewalker SwapDown<cr>')
      map('n', '<M-C-Left>',  '<cmd>Treewalker SwapLeft<cr>')
      map('n', '<M-C-Right>', '<cmd>Treewalker SwapRight<cr>')
    end,
  },

  {
    "olimorris/codecompanion.nvim",
    enabled = true,
    init = function()
      require("configs.codecompanion.extensions.notify-noice").init()
    end,
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hakonharnes/img-clip.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/codecompanion-history.nvim",
      -- {
      --   "Davidyz/VectorCode",
      --   -- pipx install git+https://github.com/Davidyz/VectorCode
      --   build = "pipx upgrade vectorcode", -- If you used pipx to install the CLI
      --   -- pipx install chromadb==0.6.3
      --   -- build = "uv tool upgrade vectorcode",
      --   -- pipx install --force "vectorcode[lsp,mcp]"
      --   -- pipx inject vectorcode vectorcode[lsp] --force
      --   -- uv tool install vectorcode[lsp,mcp]
      --   -- mkdir -p ~/.local/share/vectorcode/chromadb
      --   dependencies = { "nvim-lua/plenary.nvim" },
      -- },

      {
        -- :PackageUI - Opens the interface, auto-detects your project type
        -- Type to search packages from the appropriate registry
        -- Navigate with j/k, Tab between components
        -- Press Enter to browse available versions
        -- Press 'i' to install your chosen version
        -- Press 'u' on installed packages to uninstall
        -- View real-time dependency info and update notifications
        "MonsieurTib/package-ui.nvim",
        config = function()
          require("package-ui").setup()
        end,
      },
      {
        "ravitemer/mcphub.nvim",
        event = "VeryLazy",
        build = "npm install -g mcp-hub@latest",
      },
      {
        "yetone/avante.nvim",
        -- build from source: `make BUILD_FROM_SOURCE=true, must add this setting
        build = function()
          return "make BUILD_FROM_SOURCE=true"
        end,
        event = "VeryLazy",
        version = false, -- Never set this value to "*"! Never!
        dependencies = {
          "nvim-lua/plenary.nvim",
          "MunifTanjim/nui.nvim",
          --- The below dependencies are optional,
          "nvim-mini/mini.pick", -- for file_selector provider mini.pick
          "njhoffman/nvim-cmp", -- autocompletion for avante commands and mentions
          "ibhagwan/fzf-lua", -- for file_selector provider fzf
          "stevearc/dressing.nvim", -- for input provider dressing
          "folke/snacks.nvim", -- for input provider snacks
          "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
          "zbirenbaum/copilot.lua", -- for providers='copilot'
          -- required: avante's :Avante command parser
          { "ColinKennedy/mega.cmdparse", dependencies = { "ColinKennedy/mega.logging" } },
        },
      },
    },
  },
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
  { "rest-nvim/rest.nvim", ft = "http", cmd = "Rest" },
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
    "njhoffman/nvim-hlslens",
    dir = "~/git/nvim-hlslens",
    event = { "VimEnter" },
    enabled = true,
    init = function()
      -- cannot use my utility, as the value of IncSearch needs to be retrieved dynamically
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = "CurSearch" })
          if not ok then
            return
          end
          local value = hl["bg"]
          if not value then
            return
          end
          local reversed = string.format("#%06x", value)

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
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
      { "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false } },
      -- { "metiulekm/nvim-treesitter-endwise" },
      -- "theHamsta/nvim-treesitter-pairs",
      "jbyuki/tree-sitter-ntangle",
      { "sustech-data/wildfire.nvim", enabled = false },
      "nvim-lua/plenary.nvim",
      { "ThePrimeagen/refactoring.nvim", dependencies = "nvim-lua/plenary.nvim" },
      "windwp/nvim-ts-autotag",
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
  { "jake-stewart/multicursor.nvim", enabled = true },
  -- movement highlighters
  -- https://github.com/tzachar/local-highlight.nvim
  -- https://github.com/jjshoots/betterf.nvim/tree/main
  { "smoka7/hop.nvim", event = { "BufReadPost", "BufNewFile" } },
  { "folke/flash.nvim", event = "VeryLazy" },
  { "s1n7ax/nvim-window-picker", name = "window-picker", event = "VeryLazy", version = "2.*" },

  { "XXiaoA/atone.nvim", event = "VeryLazy" },

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
      require("configs.vim-matchup__init")()
    end,
  },
  -- pairs
  -- { 'windwp/nvim-autopairs', event = 'InsertEnter', enabled = false, dependencies = { 'nvim-cmp' } },
  {
    -- "njhoffman/ultimate-autopair.nvim",
    "altermo/ultimate-autopair.nvim",
    -- dir = "~/git/ultimate-autopair.nvim",
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
  -- { "mizlan/iswap.nvim", event = { "BufReadPost", "BufNewFile" } },
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
  {
    "andrewferrier/debugprint.nvim",
    event = "VeryLazy",
    dependencies = {
      "echasnovski/mini.hipatterns", -- Optional: Needed for line highlighting ('fine-grained' hipatterns plugin)
      "nvim-telescope/telescope.nvim", -- Optional: If you want to use the `:Debugprint search` command with telescope.nvim
      "folke/snacks.nvim", -- Optional: If you want to use the `:Debugprint search` command with snacks.nvim
    },
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
  -- https://github.com/chentoast/live.nvim/tree/master
  { "Konfekt/vim-alias", event = "VeryLazy" },
  --
  -- pickers
  -- https://github.com/dmtrKovalenko/fff.nvim
  -- https://www.reddit.com/r/neovim/comments/1maz9uf/announcing_fffnvim_the_file_picker_youve_been/
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
    cmd = { "Neotree" },
    event = "VimEnter",
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
      "Zane-/cder.nvim",
      "Zane-/howdoi.nvim",
      -- "benfowler/telescope-luasnip.nvim",
      "camgraff/telescope-tmux.nvim",
      "cljoly/telescope-repo.nvim",
      "crispgm/telescope-heading.nvim",
      "jonarrien/telescope-cmdline.nvim",
      "elianiva/telescope-npm.nvim",
      "frenchtoasters/telescope-kubectl.nvim",
      "nvim-web-devicons",
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

  -- https://www.reddit.com/r/neovim/comments/1nplde4/using_vimdiff_as_a_git_mergetool/
  -- https://www.reddit.com/r/neovim/comments/1broo6b/my_git_github_workflow_an_efficient_yet_messy/
  { "rbong/vim-flog", cmd = { "Flog", "Flogsplit" } },
  { "ThePrimeagen/git-worktree.nvim", event = "VeryLazy" },
  { "napisani/nvim-github-codesearch", cmd = "GithubSearch", build = "make" },
  { "akinsho/git-conflict.nvim", lazy = false },
  { "pwntester/octo.nvim", cmd = "Octo", dependencies = "nvim-web-devicons" },
  { "kdheepak/lazygit.nvim", cmd = "LazyGit" },
  { "lewis6991/gitsigns.nvim", event = "BufReadPost", dependencies = "nvim-lua/plenary.nvim" },
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
      require("configs.firenvim__init")()
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
    enabled = false,
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
  { "rachartier/tiny-glimmer.nvim", event = "VeryLazy" },
  {
    "DeaconDesperado/colortils.nvim",
    branch = "fix-gradient",
    cmd = "Colortils",
    event = { "BufReadPost", "BufNewFile" },
  },
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
  {
    "jiaoshijie/undotree",
    init = function()
      vim.api.nvim_create_user_command("Undotree", function(opts)
        local args = opts.fargs
        local cmd = args[1]

        if cmd == "toggle" then
          require("undotree").toggle()
        elseif cmd == "open" then
          require("undotree").open()
        elseif cmd == "close" then
          require("undotree").close()
        else
          vim.notify("Invalid subcommand: " .. (cmd or ""), vim.log.levels.ERROR)
        end
      end, {
        nargs = 1,
        complete = function(_, line)
          local subcommands = { "toggle", "open", "close" }
          local input = vim.split(line, "%s+")
          local prefix = input[#input]

          return vim.tbl_filter(function(cmd)
            return vim.startswith(cmd, prefix)
          end, subcommands)
        end,
        desc = "Undotree command with subcommands: toggle, open, close",
      })
    end,

    opts = {
      float_diff = true, -- using float window previews diff, set this `true` will disable layout option
      layout = "left_bottom", -- "left_bottom", "left_left_bottom"
      position = "left", -- "right", "bottom"
      ignore_filetype = {
        "undotree",
        "undotreeDiff",
        "qf",
      },
      window = {
        winblend = 30,
        border = "rounded", -- The string values are the same as those described in 'winborder'.
      },
      keymaps = {
        move_next = "j",
        move_prev = "k",
        move2parent = "gj",
        move_change_next = "J",
        move_change_prev = "K",
        action_enter = "<cr>",
        enter_diffbuf = "p",
        quit = "q",
      },
    },
    keys = { -- load the plugin only when using it's keybinding:
      { "<leader>ut", "<cmd>lua require('undotree').toggle()<cr>" },
    },
  },
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
      require("fundo").setup({})
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
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    enabled = false,
    ft = { "org" },
    config = function()
      -- Setup orgmode
      require("orgmode").setup({
        org_agenda_files = "~/orgfiles/**/*",
        org_default_notes_file = "~/orgfiles/refile.org",
      })

      -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
      -- add ~org~ to ignore_install
      -- require('nvim-treesitter.configs').setup({
      --   ensure_installed = 'all',
      --   ignore_install = { 'org' },
      -- })
    end,
  },
  { "jceb/vim-orgmode", ft = "org", lazy = lz_syn },
  { "gaoDean/autolist.nvim", ft = { "markdown", "text", "tex", "plaintex", "norg" } },
  {
    "lukas-reineke/headlines.nvim",
    enabled = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "markdown", "pandoc", "pandoc.markdown", "markdown.pandoc" },
  },
  { "njhoffman/markpan.nvim", enabled = false },
  { "iamcco/markdown-preview.nvim", build = "cd app && yarn install", cmd = "MarkdownPreview" },
  -- https://github.com/kiyoon/jupynium.nvim
  { "vuki656/package-info.nvim", dependencies = "MunifTanjim/nui.nvim", ft = "json" },
  { "serenevoid/kiwi.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  -- https://github.com/AndrewRadev/inline_edit.vim
  { "zdharma-continuum/zinit-vim-syntax", ft = "zsh", lazy = lz_syn },
  { "aliou/bats.vim", ft = "bats", lazy = lz_syn },
  { "kchmck/vim-coffee-script", ft = "coffee", lazy = lz_syn },
  { "lifepillar/pgsql.vim", ft = "pgsql", lazy = lz_syn },
  { "pearofducks/ansible-vim", ft = "ansible", lazy = lz_syn },
  { "potatoesmaster/i3-vim-syntax", ft = "i3", lazy = lz_syn },
  { "rodjek/vim-puppet", ft = "puppet", lazy = lz_syn },
  { "vim-crystal/vim-crystal", ft = "crystal", lazy = lz_syn },
  { "raimon49/requirements.txt.vim", event = "VeryLazy", lazy = lz_syn },
  { "ericpruitt/tmux.vim", ft = "tmux", lazy = lz_syn },
}

utils.apply_configs(plugins)
return plugins
