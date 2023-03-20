local utils = require("lazy-utils")

local plugins = {
  { "andrewferrier/debugprint.nvim", event = "VeryLazy" },

  { "tpope/vim-repeat", event = "VeryLazy" },
  {
    "abecodes/tabout.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter", "nvim-cmp" },
    config = function()
      require("tabout").setup({
        tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = true, -- shift content if tab out is not possible
        act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
        default_shift_tab = "<C-d>", -- reverse shift default action,
        enable_backwards = true, -- well ...
        completion = true, -- if the tabkey is used in a completion pum
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = "`", close = "`" },
          { open = "(", close = ")" },
          { open = "[", close = "]" },
          { open = "{", close = "}" },
        },
        ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
        exclude = {}, -- tabout will ignore these filetypes
      })
    end,
  },
  {
    "ziontee113/SelectEase",
    event = "VeryLazy",
    config = function()
      local select_ease = require("SelectEase")

      -- For more language support check the `Queries` section
      local lua_query = [[
            ;; query
            ((identifier) @cap)
            ("string_content" @cap)
            ((true) @cap)
            ((false) @cap)
        ]]
      local python_query = [[
            ;; query
            ((identifier) @cap)
            ((string) @cap)
        ]]

      local queries = {
        lua = lua_query,
        python = python_query,
      }

      vim.keymap.set({ "n", "s", "i" }, "<C-A-k>", function()
        select_ease.select_node({
          queries = queries,
          direction = "previous",
          vertical_drill_jump = true,
          -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
          fallback = function()
            -- if there's no target, this function will be called
            select_ease.select_node({ queries = queries, direction = "previous" })
          end,
        })
      end, {})
      vim.keymap.set({ "n", "s", "i" }, "<C-A-j>", function()
        select_ease.select_node({
          queries = queries,
          direction = "next",
          vertical_drill_jump = true,
          -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
          fallback = function()
            -- if there's no target, this function will be called
            select_ease.select_node({ queries = queries, direction = "next" })
          end,
        })
      end, {})

      vim.keymap.set({ "n", "s", "i" }, "<C-A-h>", function()
        select_ease.select_node({
          queries = queries,
          direction = "previous",
          -- current_line_only = true,
          -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
        })
      end, {})
      vim.keymap.set({ "n", "s", "i" }, "<C-A-l>", function()
        select_ease.select_node({
          queries = queries,
          direction = "next",
          -- current_line_only = true,
          -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
        })
      end, {})

      -- -- previous / next node that matches query
      -- vim.keymap.set({ "n", "s", "i" }, "<C-A-p>", function()
      --   select_ease.select_node({ queries = queries, direction = "previous" })
      -- end, {})
      -- vim.keymap.set({ "n", "s", "i" }, "<C-A-n>", function()
      --   select_ease.select_node({ queries = queries, direction = "next" })
      -- end, {})

      -- Swap Nodes
      vim.keymap.set({ "n", "s", "i" }, "<M-C-K>", function()
        select_ease.swap_nodes({
          queries = queries,
          direction = "previous",
          vertical_drill_jump = true,
          -- swap_in_place option. Default behavior is cursor will jump to target after the swap
          -- jump_to_target_after_swap = false --> this will keep cursor in place after the swap
        })
      end, {})
      vim.keymap.set({ "n", "s", "i" }, "<M-C-J>", function()
        select_ease.swap_nodes({
          queries = queries,
          direction = "next",
          vertical_drill_jump = true,
        })
      end, {})
      vim.keymap.set({ "n", "s", "i" }, "<M-C-P>", function()
        select_ease.swap_nodes({
          queries = queries,
          direction = "previous",
          -- current_line_only = true,
        })
      end, {})
      vim.keymap.set({ "n", "s", "i" }, "<M-C-L>", function()
        select_ease.swap_nodes({
          queries = queries,
          direction = "next",
          -- current_line_only = true,
        })
      end, {})
      -- vim.keymap.set({ "n", "s", "i" }, "<C-A-S-p>", function()
      --   select_ease.swap_nodes({ queries = queries, direction = "previous" })
      -- end, {})
      -- vim.keymap.set({ "n", "s", "i" }, "<C-A-S-n>", function()
      --   select_ease.swap_nodes({ queries = queries, direction = "next" })
      -- end, {})
    end,
  },
  { "chaoren/vim-wordmotion", event = "VeryLazy", enabled = false },
  { "Konfekt/vim-alias", event = "VeryLazy" },
  {
    "gbprod/substitute.nvim",
    event = "VeryLazy",
    config = function()
      local cfg = {
        on_substitute = nil,
        yank_substituted_text = false,
        range = {
          prefix = "s",
          prompt_current_text = false,
          confirm = false,
          complete_word = false,
          motion1 = false,
          motion2 = false,
          suffix = "",
        },
        exchange = {
          motion = false,
        },
      }
      return require("substitute").setup(cfg)
    end,
  },
  { "smjonas/live-command.nvim", cmd = { "Reg", "Norm" }, event = "VeryLazy" },
  {
    "chrisgrieser/nvim-various-textobjs",
    config = function()
      require("various-textobjs").setup({ useDefaultKeymaps = true })
    end,
  },
  {
    "cbochs/portal.nvim",
    event = "VeryLazy",
    dependencies = { "cbochs/grapple.nvim" },
    config = function()
      vim.keymap.set("n", "<C-o>", "<cmd>Portal jumplist backward<cr>")
      vim.keymap.set("n", "<C-i>", "<cmd>Portal jumplist forward<cr>")
    end,
  },
  { "echasnovski/mini.comment", version = false },
  { "echasnovski/mini.doc", version = false },
  { "echasnovski/mini.bracketed", event = "VeryLazy", version = false },
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    version = false,
    config = function()
      local vim_surround_setup = function()
        -- local default_cfg = {
        --   custom_surroundings = nil,
        --   highlight_duration = 500,
        --   mappings = {
        --     add = "sa", -- Add surrounding in Normal and Visual modes
        --     delete = "sd", -- Delete surrounding
        --     find = "sf", -- Find surrounding (to the right)
        --     find_left = "sF", -- Find surrounding (to the left)
        --     highlight = "sh", -- Highlight surrounding
        --     replace = "sr", -- Replace surrounding
        --     update_n_lines = "sn", -- Update `n_lines`
        --
        --     suffix_last = "l", -- Suffix to search with "prev" method
        --     suffix_next = "n", -- Suffix to search with "next" method
        --   },
        --   n_lines = 20,
        --   respect_selection_type = false,
        --   search_method = "cover",
        -- }
        --
        -- local vim_surround = {
        --   mappings = {
        --     add = "ys",
        --     delete = "ds",
        --     find = "",
        --     find_left = "",
        --     highlight = "",
        --     replace = "cs",
        --     update_n_lines = "",
        --
        --     -- Add this only if you don't want to use extended mappings
        --     suffix_last = "",
        --     suffix_next = "",
        --   },
        --   search_method = "cover_or_next",
        -- }
        --
        -- -- Remap adding surrounding to Visual mode selection
        -- vim.keymap.del("x", "ys")
        -- vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
        --
        -- -- Make special mapping for "add surrounding for line"
        -- vim.keymap.set("n", "yss", "ys_", { remap = true })
      end
      local cfg = {
        mappings = {
          add = "s", -- Add surrounding in Normal and Visual modes
          delete = "ds", -- Add surrounding in Normal and Visual modes
          change = "cs", -- Add surrounding in Normal and Visual modes
        },
        search_method = "cover_or_next",
      }
      require("mini.surround").setup(cfg)
    end,
  },
  { "psliwka/vim-smoothie", commit = "10fd0aa", event = "VeryLazy" }, -- f2aaab1
  { dir = "~/git/clever-f.vim" }, -- rhysd/clever-f.vim
  { "AckslD/nvim-FeMaco.lua", ft = { "markdown", "pandoc" } },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    cmd = "MarkdownPreview",
    ft = { "markdown", "pandoc" },
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      -- vim.g.mkdp_browser = 'safari'
    end,
  },
  -- { "chentoast/marks.nvim" },
}
--   { "inkarkat/vim-UnconditionalPaste",
--   requires = "inkarkat/vim-ingo-library" },

utils.apply_configs(plugins)
utils.print_stats("Motion", plugins)
return plugins
