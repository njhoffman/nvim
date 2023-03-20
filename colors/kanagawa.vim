" https://github.com/rebelot/kanagawa.nvim

" NOTE: If you enable compilation (default), make sure to run this command every time you make changes to your config.

" 1. Modify your config
" 2. Restart nvim
" 3. Run this command:
" :KanagawaCompile


lua << EOF
    local default_config = {
      compile = true,              -- enable compiling the colorscheme
      undercurl = true,            -- enable undercurls
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true},
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,         -- do not set background color
      dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
      terminalColors = true,       -- define vim.g.terminal_color_{0,17}
      colors = {                   -- add/modify theme and palette colors
          palette = {}
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      overrides = function(colors) -- add/modify highlights
          return {}
      end,
      theme = "wave",              -- Load "wave" theme when 'background' option is not set
      background = {               -- map the value of 'background' option to a theme
          dark = "wave",           -- try "dragon" !
          light = "lotus"
      },
    }

    require('kanagawa').setup(default_config)

    vim.schedule(function()
      vim.cmd("colorscheme kanagawa")
    end

EOF
