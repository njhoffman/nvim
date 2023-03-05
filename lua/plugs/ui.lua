local utils = require("lazy-utils")

local plugins = {
  { dir = "~/git/which-key.nvim" },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      char = "│",
      filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },
  -- active indent guide and indent text objects
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPre", "BufNewFile" },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
    config = function(_, _opts)
      local opts = _opts or {}
      opts.symbol = "│" -- symbol = "▏"
      -- opts.draw = { animation = require("mini.indentscope").gen_animation.none() }
      opts.try_as_border = true
      require("mini.indentscope").setup(opts)
    end,
  },
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = function()
      -- don't use animate when scrolling with the mouse
      local mouse_scrolled = false
      for _, scroll in ipairs({ "Up", "Down" }) do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      local animate = require("mini.animate")
      local orig_scroll = {
        timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
        subscroll = animate.gen_subscroll.equal({
          predicate = function(total_scroll)
            if mouse_scrolled then
              mouse_scrolled = false
              return false
            end
            return total_scroll > 1
          end,
        }),
      }

      local is_many_wins = function(sizes_from, sizes_to)
        return vim.tbl_count(sizes_from) >= 3
      end
      return {
        scroll = { enable = false },
        cursor = { enable = false },
        resize = {
          -- Animate for 200 milliseconds with linear easing
          timing = animate.gen_timing.linear({ duration = 200, unit = "total" }),
          -- Animate only if there are at least 3 windows
          subresize = animate.gen_subscroll.equal({ predicate = is_many_wins }),
        },
        open = {
          enable = true,
          -- Animate for 400 milliseconds with linear easing
          timing = animate.gen_timing.linear({ duration = 400, unit = "total" }),
          -- Animate with wiping from nearest edge instead of default static one
          winconfig = animate.gen_winconfig.wipe({ direction = "from_edge" }),
          -- Make bigger windows more transparent
          winblend = animate.gen_winblend.linear({ from = 80, to = 100 }),
        },
        close = {
          -- Animate for 400 milliseconds with linear easing
          timing = animate.gen_timing.linear({ duration = 400, unit = "total" }),
          -- Animate with wiping to nearest edge instead of default static one
          winconfig = animate.gen_winconfig.wipe({ direction = "to_edge" }),
          -- Make bigger windows more transparent
          winblend = animate.gen_winblend.linear({ from = 100, to = 80 }),
        },
      }
    end,
    config = function(_, opts)
      require("mini.animate").setup(opts)
    end,
  },
  { "romainl/vim-qf", ft = "qf" },
  { "kevinhwang91/nvim-bqf", cmd = { "BqfEnable", "BqfToggle" }, ft = "qf" },
  {
    "sindrets/diffview.nvim",
    cmd = { "Diffview", "DiffviewLog", "DiffviewOpen", "DiffviewToggleFiles", "DiffviewFileHistory" },
  },
  { "nvim-colortils/colortils.nvim", cmd = "Colortils" },
  { "joeysino/vim-plugin-AnsiEsc", cmd = "AnsiEsc" },
  { "folke/zen-mode.nvim", cmd = "ZenMode" },
  { "tversteeg/registers.nvim", cmd = "Registers" },
  { "mbbill/undotree", cmd = { "UndotreeToggle", "UndotreeFocus", "UndotreeShow" } },
  { "folke/twilight.nvim", cmd = { "Twilight", "TwilightEnable" } },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        bottom_search = false,
        command_palette = false,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      timeout = 3000,
      background_colour = "#000000",
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    init = function()
      -- when noice is not enabled, install notify on VeryLazy
      local Util = require("lazy-utils")
      if not Util.is_loaded("noice.nvim") and false then
        Util.on_very_lazy(function()
          vim.notify = require("notify")
        end)
      end
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    cmd = { "UfoEnable", "UfoAttach", "UfoEnableFold" },
  },
  { "t-troebst/perfanno.nvim", cmd = { "PerfLoadFlat", "PerfLoadCallGraph", "PerfLoadFlameGraph" } },
  { "nacro90/numb.nvim", event = { "BufReadPost", "BufNewFile" } },
  { "ivyl/vim-bling", event = { "BufReadPost", "BufNewFile" } },
  { "romainl/vim-cool", event = { "BufReadPost", "BufNewFile" } },
  { "petertriho/nvim-scrollbar", event = { "BufReadPost", "BufNewFile" } },
  { "edluffy/specs.nvim", event = { "BufReadPost", "BufNewFile" } },
  { "RRethy/vim-illuminate", event = { "BufReadPost", "BufNewFile" }, dependencies = { "neovim/nvim-lspconfig" } },
  { "TaDaa/vimade", event = { "BufReadPost", "BufNewFile" }, cmd = { "VimadeBufDisable" } },
  { "goolord/alpha-nvim", event = "VimEnter", dependencies = "kyazdani42/nvim-web-devicons" },

  {
    "m4xshen/smartcolumn.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      colorcolumn = 120,
      disabled_filetypes = { "help", "text", "markdown" },
      custom_colorcolumn = {},
      limit_to_window = false,
      limit_to_line = false,
    },
  },
  {
    "stevearc/dressing.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
    opts = {
      input = {
        win_options = {
          winblend = 15,
        },
        select = {
          backend = { "nui", "telescope" },
          -- telescope = require('telescope.themes').get_ivy({...})
        },
      },
    },
  },
  {
    "phaazon/hop.nvim",
    branch = "v2",
    event = "VeryLazy",
  },
  { "kevinhwang91/nvim-hlslens", event = "VeryLazy" },
  { "RRethy/vim-hexokinase", event = "VeryLazy", build = "make hexokinase" },
  { "anuvyklack/hydra.nvim", event = "VeryLazy" },
  { "MunifTanjim/nui.nvim", event = "VeryLazy" },
  {
    "gelguy/wilder.nvim",
    enabled = false,
    dependencies = { { "romgrk/fzy-lua-native" } },
    -- {'nixprime/cpsm', run='UpdateRemotePlugins'}
    opt = true,
    event = { "CmdwinEnter", "CmdlineEnter" },
    run = function()
      vim.cmd([[packadd wilder.nvim]])
      vim.cmd([[silent UpdateRemotePlugins]])
    end,
  },
}

utils.apply_configs(plugins)
utils.print_stats("UI", plugins)
return plugins

--
-- { "edluffy/hologram.nvim", cond = os.getenv("KITTY_WINDOW_ID") ~= nil
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
-- ["nvim-tree.lua"] = { "kyazdani42/nvim-tree.lua" },
-- ["codewindow.nvim"] = { "gorbit99/codewindow.nvim" },
-- https://github.com/anuvyklack/windows.nvim
-- ["yank-history"] = {"yazgoo/yank-history"},
-- ["vim-mundo"] = { "simnalamburt/vim-mundo" },
-- https://github.com/gbprod/yanky.nvim
