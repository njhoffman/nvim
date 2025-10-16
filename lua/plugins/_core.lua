local utils = require("utils.lazy")

local plugins = {
  {"folke/lazy.nvim", lazy = false},
  -- colorscheme components should load first
  {"folke/noice.nvim", event = "VeryLazy",},
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          -- vim.print = _G.dd -- Override print to use snacks for `:=` command
          Snacks.toggle({
            name = "Mini Animate",
            get = function()
              return not vim.g.minianimate_disable
            end,
            set = function(state)
              vim.g.minianimate_disable = not state
            end,
          }):map("<leader>ua")

          -- -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>_s")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>_w")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>_L")
          Snacks.toggle.diagnostics():map("<leader>_d")
          Snacks.toggle.line_number():map("<leader>_l")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>_c")
          Snacks.toggle.treesitter():map("<leader>_T")
          Snacks.toggle
            .option("background", { off = "light", on = "dark", name = "Dark Background" })
            :map("<leader>_b")
          Snacks.toggle.inlay_hints():map("<leader>_h")
        end,
      })
    end,
  },
  {
    "rktjmp/lush.nvim",
    dependencies = { "Iron-E/nvim-highlite" },
    priority = 1000,
    lazy = false,
    keys = {
      {
        "<Leader>cs",
        function()
          vim.api.nvim_exec_autocmds("User", { pattern = "ColorSchemeLoad" })
          require("telescope.builtin").colorscheme()
        end,
        noremap = true,
      },
    },
  },
  {
    "TaDaa/vimade",
    -- event = { "VimEnter" },
    lazy = false,
    enabled = false,
  },
  {
    "m4xshen/hardtime.nvim",
    enabled = false,
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  },
  -- https://github.com/VonHeikemen/searchbox.nvim
  {
    "njhoffman/nvim-notify.nvim",
    name = "nvim-notify",
    dir = "~/git/nvim-notify",
    event = { "VeryLazy" },
    -- "rcarriga/nvim-notify",
    -- lazy = false,
  },
  { "famiu/bufdelete.nvim" },
  { "nvim-tree/nvim-web-devicons", dependencies = { "DaikyXendo/nvim-material-icon" } },
  {
    "utilyre/barbecue.nvim",
    event = "VeryLazy",
    name = "barbecue",
    dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
  },
  { "b0o/incline.nvim", enabled = false, event = "VeryLazy" },
  {
    -- https://github.com/tamton-aquib/keys.nvim
    "njhoffman/what-key.nvim",
    dir = "~/git/what-key.nvim",
    -- name = "what-key",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  -- { 'freddiehaddad/feline.nvim', branch = 'main', event = 'VimEnter', lazy = false, },
}

utils.apply_configs(plugins)

return plugins
