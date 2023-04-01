local utils = require("utils.lazy")

local plugins = {
  { "andrewferrier/debugprint.nvim", event = "VeryLazy" },
  {
    "chrisgrieser/nvim-recorder",
    opts = {},
    config = function()
      -- default values
      require("recorder").setup({
        -- Named registers where macros are saved. The first register is the default
        -- register/macro-slot used after startup.
        slots = { "a", "b" },

        -- default keymaps, see README for description what the commands do
        mapping = {
          startStopRecording = "q",
          playMacro = "Q",
          switchSlot = "<C-q>",
          editMacro = "cq",
          yankMacro = "yq", -- also decodes it for turning macros to mappings
          addBreakPoint = "##", -- ⚠️ this should be a string you don't use in insert mode during a macro
        },

        -- clears all macros-slots on startup
        clear = false,

        -- log level used for any notification, mostly relevant for nvim-notify
        -- (note that by default, nvim-notify does not show the levels trace and debug.)
        logLevel = vim.log.levels.INFO,

        -- if enabled, only essential or critical notifications are sent.
        -- If you do not use a plugin like nvim-notify, set this to `true`
        -- to remove otherwise annoying notifications.
        lessNotifications = false,

        -- experimental, see README
        dapSharedKeymaps = false,
      })
      -- -- indicates whether you are currently recording. Useful if you are using
      -- require("recorder").recordingStatus()
      -- -- displays non-empty macro-slots (registers) and indicates the selected ones.
      -- require("recorder").displaySlots()
      -- -- 💡 put the components in different status line segments so they have a different color
      -- Basics
      -- startStopRecording: Starts recording to the current macro slot (so you do not need to specify a register). Press again to end the recording.
      -- playMacro: Plays the macro in the current slot (without the need to specify a register).
      -- switchSlot: Cycles through the registers you specified in the configuration. Also show a notification with the slot and its content. (The currently selected slot can be seen in the status line component. )
      -- editMacro: Lets you modify the macro recorded in the active slot. (Be aware that these are the keystrokes in "encoded" form.)
      -- yankMacro: Copies the current macro in decoded form that can be used to create a mapping from it. Breakpoints are removed from the macro
      -- bulb For recursive macros (playing a macro inside a macro), you can still use the default command @a.
      --
      -- Macro Breakpoints
      -- nvim-recorder allows you to set breakpoints in your macros which can be helpful for debugging macros. Breakpoints are automatically ignored when you trigger the macro with a count.
      --
      -- During a recording, press the addBreakPoint key (default: ##) in normal mode.
      -- After a recording, use editMacro and add or remove the ## manually.
      --
      -- Using the playMacro key, the macro automatically stops at the next breakpoint. The next time you press playMacro, the next segment of the macro is played.
      -- Starting a new recording, editing a macro, yanking a macro, or switching macro slot all reset the sequence, meaning that playMacro starts from the beginning again.
      -- bulb You can do other things in between playing segments of the macro, like moving a few characters to the left or right. That way you can also use breakpoints to manually correct irregularities.
      --
      -- Ignoring Breakpoints
      -- When you play the macro with a count (for example 50Q), breakpoints are automatically ignored.
      -- bulb Add a count of 1 (1Q) to play a macro once and still ignore breakpoints.
      --
      -- Shared Keybindings with nvim-dap
      -- If you are using nvim-dap, you can use dapSharedKeymaps = true to set up the following shared keybindings:
      -- addBreakPoint maps to dap.toggle_breakpoint() outside a recording. During a recording, it adds a macro breakpoint instead.
      -- playMacro maps to dap.continue() if there is at least one dap-breakpoint. If there is no dap-breakpoint, plays the current macro-slot instead.
      -- Note that this feature is experimental, since the respective API from nvim-dap is non-public and can be changed without deprecation notice.
      --
    end,
  },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "chaoren/vim-wordmotion", event = { "BufReadPost", "BufNewFile" } },
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
}
utils.apply_configs(plugins)
return plugins

-- { "chentoast/marks.nvim" },
-- { "inkarkat/vim-UnconditionalPaste",
-- requires = "inkarkat/vim-ingo-library" },
