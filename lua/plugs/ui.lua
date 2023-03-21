local utils = require("lazy-utils")

local plugins = {
  {
    "folke/which-key.nvim",
    -- dir = "~/git/which-key.nvim",
  },
  {
    "sidebar-nvim/sidebar.nvim",
    event = "VimEnter",
    config = function()
      -- SidebarNvimToggle: Open/Close the view
      -- SidebarNvimClose: Close if open, otherwise no-op
      -- SidebarNvimOpen: Open if closed, otherwise no-op
      -- SidebarNvimUpdate: Immediately update the view and the sections
      -- SidebarNvimResize size: Resize the view width to size, size is a number
      -- SidebarNvimFocus: Move the cursor to the sidebar window
      local defaults = {
        disable_default_keybindings = 0,
        bindings = nil,
        open = false,
        side = "left",
        initial_width = 35,
        hide_statusline = false,
        update_interval = 1000,
        sections = { "datetime", "git", "diagnostics" },
        section_separator = { "", "-----", "" },
        section_title_separator = { "" },
        containers = {
          attach_shell = "/bin/sh",
          show_all = true,
          interval = 5000,
        },
        datetime = { format = "%a %b %d, %H:%M", clocks = { { name = "local" } } },
        todos = { ignored_paths = { "~" } },
      }

      local config = {
        side = "right",
        -- sections = { "datetime", "git", "diagnostics", "todos", "containers", "buffers", "files", "symbols" },
        sections = { "diagnostics", "todos", "buffers", "containers" },
        bindings = {
          ["q"] = function()
            require("sidebar-nvim").close()
          end,
        },
      }
      require("sidebar-nvim").setup(config)
    end,
  },
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
    "echasnovski/mini.move",
    config = function()
      local default_cfg = {
        mappings = {
          left = "<M-h>",
          right = "<M-l>",
          down = "<M-j>",
          up = "<M-k>",
          line_left = "<M-h>",
          line_right = "<M-l>",
          line_down = "<M-j>",
          line_up = "<M-k>",
        },
        options = {
          reindent_linewise = true,
        },
      }
      vim.cmd([[
        function! s:Map(...) abort
          let [mode, head, rhs; rest] = a:000
          let flags = get(rest, 0, '') . (rhs =~# '^<Plug>' ? '' : '<script>')
          let tail = ''
          let keys = get(g:, mode.'remap', {})
          if type(keys) == type({}) && !empty(keys)
            while !empty(head) && len(keys)
              if has_key(keys, head)
                let head = keys[head]
                if empty(head)
                  let head = '<skip>'
                endif
                break
              endif
              let tail = matchstr(head, '<[^<>]*>$\|.$') . tail
              let head = substitute(head, '<[^<>]*>$\|.$', '', '')
            endwhile
          endif
          if head !=# '<skip>' && empty(maparg(head.tail, mode))
            return mode.'map ' . flags . ' ' . head.tail . ' ' . rhs
          endif
          return ''
        endfunction
        function! s:BlankUp() abort
          let cmd = 'put!=repeat(nr2char(10), v:count1)|silent '']+'
          if &modifiable
          let cmd .= '|silent! call repeat#set("\<Plug>(unimpaired-blank-up)", v:count1)'
          endif
          return cmd
        endfunction

        function! s:BlankDown() abort
          let cmd = 'put =repeat(nr2char(10), v:count1)|silent ''[-'
          if &modifiable
          let cmd .= '|silent! call repeat#set("\<Plug>(unimpaired-blank-down)", v:count1)'
          endif
          return cmd
        endfunction

        nnoremap <silent> <Plug>(unimpaired-blank-up)   :<C-U>exe <SID>BlankUp()<CR>
        nnoremap <silent> <Plug>(unimpaired-blank-down) :<C-U>exe <SID>BlankDown()<CR>

        nnoremap <silent> <Plug>unimpairedBlankUp   :<C-U>exe <SID>BlankUp()<CR>
        nnoremap <silent> <Plug>unimpairedBlankDown :<C-U>exe <SID>BlankDown()<CR>

        exe s:Map('n', '[<Space>', '<Plug>(unimpaired-blank-up)')
        exe s:Map('n', ']<Space>', '<Plug>(unimpaired-blank-down)')


        function! s:ExecMove(cmd) abort
          let old_fdm = &foldmethod
          if old_fdm !=# 'manual'
            let &foldmethod = 'manual'
          endif
          normal! m`
          silent! exe a:cmd
          norm! ``
          if old_fdm !=# 'manual'
            let &foldmethod = old_fdm
          endif
        endfunction

        function! s:Move(cmd, count, map) abort
          call s:ExecMove('move'.a:cmd.a:count)
          silent! call repeat#set("\<Plug>(unimpaired-move-".a:map.")", a:count)
        endfunction

        function! s:MoveSelectionUp(count) abort
          call s:ExecMove("'<,'>move'<--".a:count)
          silent! call repeat#set("\<Plug>(unimpaired-move-selection-up)", a:count)
        endfunction

        function! s:MoveSelectionDown(count) abort
          call s:ExecMove("'<,'>move'>+".a:count)
          silent! call repeat#set("\<Plug>(unimpaired-move-selection-down)", a:count)
        endfunction

        nnoremap <silent> <Plug>(unimpaired-move-up)            :<C-U>call <SID>Move('--',v:count1,'up')<CR>
        nnoremap <silent> <Plug>(unimpaired-move-down)          :<C-U>call <SID>Move('+',v:count1,'down')<CR>
        noremap  <silent> <Plug>(unimpaired-move-selection-up)   :<C-U>call <SID>MoveSelectionUp(v:count1)<CR>
        noremap  <silent> <Plug>(unimpaired-move-selection-down) :<C-U>call <SID>MoveSelectionDown(v:count1)<CR>
        nnoremap <silent> <Plug>unimpairedMoveUp            :<C-U>call <SID>Move('--',v:count1,'up')<CR>
        nnoremap <silent> <Plug>unimpairedMoveDown          :<C-U>call <SID>Move('+',v:count1,'down')<CR>
        noremap  <silent> <Plug>unimpairedMoveSelectionUp   :<C-U>call <SID>MoveSelectionUp(v:count1)<CR>
        noremap  <silent> <Plug>unimpairedMoveSelectionDown :<C-U>call <SID>MoveSelectionDown(v:count1)<CR>

        exe s:Map('n', '[e', '<Plug>(unimpaired-move-up)')
        exe s:Map('n', ']e', '<Plug>(unimpaired-move-down)')
        exe s:Map('x', '[e', '<Plug>(unimpaired-move-selection-up)')
        exe s:Map('x', ']e', '<Plug>(unimpaired-move-selection-down)')
    ]])

      -- return require("mini.move").setup({ mappings = {} })
    end,
  },
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    config = function()
      local animate = require("mini.animate")

      local is_many_wins = function(sizes_from, sizes_to)
        return vim.tbl_count(sizes_from) >= 3
      end
      local opts = {
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
      local cfg = {
        scroll = { enable = false },
        cursor = { enable = false },
        open = {
          enable = true,
          timing = animate.gen_timing.linear({ duration = 500, unit = "total" }),
          -- winconfig = animate.gen_winconfig.wipe({ direction = "from_edge" }),
          winblend = animate.gen_winblend.linear({ from = 70, to = 100 }),
        },
        close = {
          enable = true,
          -- Animate for 400 milliseconds with linear easing
          timing = animate.gen_timing.linear({ duration = 300, unit = "total" }),
          -- Animate with wiping to nearest edge instead of default static one
          -- winconfig = animate.gen_winconfig.wipe({ direction = "to_edge" }),
          -- Make bigger windows more transparent
          winblend = animate.gen_winblend.linear({ from = 100, to = 70 }),
        },
        resize = { enable = false },
      }
      require("mini.animate").setup(cfg)
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
  {
    "simnalamburt/vim-mundo",
    cmd = { "MundoToggle", "MundoShow", "MundoHide" },
    build = function()
      vim.cmd([[UpdateRemotePlugins]])
    end,
    config = function()
      vim.g.mundo_prefer_python3 = 1
      vim.g.mundo_width = 35
      vim.g.mundo_preview_height = 5
      vim.g.mundo_right = 1
      vim.g.mundo_help = 0
      vim.g.mundo_disable = 0
      vim.g.mundo_preview_bottom = 1
      vim.g.mundo_close_on_revert = 0
      vim.g.mundo_auto_preview = 1
      vim.g.mundo_playback_delay = 60
      -- vim.g.mundo_preview_statusline = nil
      -- vim.g.mundo_tree_statusline = nil
    end,
  },
  { "folke/twilight.nvim", cmd = { "Twilight", "TwilightEnable" } },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    cmd = { "UfoEnable", "UfoAttach", "UfoEnableFold" },
  },
  { "nacro90/numb.nvim", event = { "BufReadPost", "BufNewFile" } },
  { "t-troebst/perfanno.nvim", cmd = { "PerfLoadFlat", "PerfLoadCallGraph", "PerfLoadFlameGraph" } },

  { "ivyl/vim-bling", event = { "BufReadPost", "BufNewFile" } },
  { "romainl/vim-cool", event = { "BufReadPost", "BufNewFile" } },
  { "edluffy/specs.nvim", event = { "BufReadPost", "BufNewFile" } },

  { "petertriho/nvim-scrollbar", event = { "BufReadPost", "BufNewFile" } },
  { "RRethy/vim-illuminate", event = { "BufReadPost", "BufNewFile" }, dependencies = { "neovim/nvim-lspconfig" } },
  { "TaDaa/vimade", event = { "BufReadPost", "BufNewFile" }, cmd = { "VimadeBufDisable" } },
  { "kevinhwang91/nvim-hlslens", event = { "BufReadPost", "BufNewFile" } },
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
    config = function()
      require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
    end,
    branch = "v2",
    event = { "BufReadPost", "BufNewFile" },
  },
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
-- ["codewindow.nvim"] = { "gorbit99/codewindow.nvim" },
-- https://github.com/anuvyklack/windows.nvim
-- ["yank-history"] = {"yazgoo/yank-history"},
-- https://github.com/gbprod/yanky.nvim
