local alpha = require("alpha")

-- Set header
local header = {
  "                                                     ",
  "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
  "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
  "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
  "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
  "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
  "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
  "                                                     ",
}

local big_header = {
  "                                                                                                ",
  "                                                                                                ",
  "                                                                                                ",
  "                                                                                                ",
  "                                                                                                ",
  "         -╲         '-                                                                          ",
  "       -' :╲        │ '-                                                                        ",
  "     -'   : ╲       │   '-                          │MMM│                                       ",
  "   -'·    :  ╲      │     '-                        │WWW│                                       ",
  "  '.-.·   :   ╲     │       │                                                                   ",
  "  │. .-·  :    ╲    │       │    MMM=         =MMM  │MMM│  │M│  +===+   +====+                  ",
  "  │ . .-· :     ╲   │       │    ╲HHB`       'BHH╱  │HHH│  │H│╲╱sMMMs╲_╱sMMMMs╲                 ",
  "  │. . .-·;      ╲  │       │     ╲HHH╲     ╱HHH╱   │HHH│  │HBBWWWWWHMMMHWWWW:B╲                ",
  "  │ . . .-│       ╲ │       │      ╲HHH╲   ╱HHH╱    │HHH│  │HK╱     ╲KYK╱    ╲KH│               ",
  "  │. . . .│╲       ╲│       │       ╲HHH╲ ╱HHH╱     │HHH│  │H│       │H│      │H│               ",
  "  │ . . . │ ╲       ;-      │        ╲HHHVHHH╱      │HHH│  │H│       │H│      │H│               ",
  "  │. . . .│  ╲      :·-     │         ╲HHHHH╱       │HHH│  │H│       │H│      │H│               ",
  "  │ . . . │   ╲     : .-    │          ╲HHH╱        │HHH│  │H│       │H│      │H│               ",
  "  │. . . .│    ╲    :. .-   │           ╲W╱         │WWW│  │W│       │W│      │W│               ",
  "  `- . . .│     ╲   : . .- -'                                                                   ",
  "    `- . .│      ╲  :. ..-'                                                                     ",
  "      `-. │       ╲ :..-'                                                                       ",
  "         `│        ╲;-'                                                                         ",
  "                                                                                                ",
  "                                                                                                ",
}
local dashboard = require("alpha.themes.dashboard")

-- Set header
dashboard.section.header.val = big_header
-- Set menu,
dashboard.section.buttons.val = {
  dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("f", "  > Find file", ":cd $HOME/Workspace | Telescope find_files<CR>"),
  dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
  dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
  dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
}

                -- :center [{:icon "  "
                --           :desc :Sessions
                --           :key :s
                --           :action #((. (require :telescope) :extensions :sesh :sesh))}
                --          {:icon "  "
                --           :desc "Recent files"
                --           :key :r
                --           :action "Telescope oldfiles"}
                --          {:icon "  "
                --           :desc "Find File"
                --           :key :f
                --           :action "Telescope find_files"}
                --          {:icon "  "
                --           :desc "Find Text"
                --           :key :t
                --           :action "Telescope live_grep"}
                --          {:icon "  "
                --           :desc "(WIP) mappings"
                --           :key "?"
                --           :action #(vim.notify "Guide is still WIP" :error)}
                --          {:icon "  "
                --           :desc "Assasinate a political figure"
                --           :key :K
                --           :action #(vim.notify :bang! :error)}
                --          {:icon "  "
                --           :desc "Check health"
                --           :key :H
                --           :action :checkhealth}]
                -- :footer [(.. "Current Directory: " (vim.fn.getcwd))
                --          ""
                --          ""
                --          ""
                --          (.. "Loaded " (tostring (. (lazy.stats) :loaded))
                --              " plugins in "
                --              (tostring (math.floor (. (lazy.stats) :startuptime)))
                --              :ms)]}}))

-- Set footer
--   NOTE: This is currently a feature in my fork of alpha-nvim (opened PR #21, will update snippet if added to main)
--   To see test this yourself, add the function as a dependecy in packer and uncomment the footer lines
--   ```init.lua
--   return require('packer').startup(function()
--       use 'wbthomason/packer.nvim'
--       use {
--           'goolord/alpha-nvim', branch = 'feature/startify-fortune',
--           requires = {'BlakeJC94/alpha-nvim-fortune'},
--           config = function() require("config.alpha") end
--       }
--   end)
--   ```
-- local fortune = require("alpha.fortune")
-- dashboard.section.footer.val = fortune()

-- Send config to alpha
alpha.setup(dashboard.opts)

-- Disable folding on alpha buffer
vim.cmd([[
  autocmd FileType alpha setlocal nofoldenable
  augroup alpha_start
  autocmd!
  augroup END

]])
