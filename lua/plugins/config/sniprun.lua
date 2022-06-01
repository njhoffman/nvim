-- :SnipRun "OR :lua require'sniprun'.run()
-- "the first command is only a shorthand, you should configure the <Plug>SnipRun mapping
require "sniprun".setup(
  {
    selected_interpreters = {}, --# use those instead of the default for the current filetype
    repl_enable = {}, --# enable REPL-like behavior for the given interpreters
    repl_disable = {}, --# disable REPL-like behavior for the given interpreters
    interpreter_options = {
      --# interpreter-specific options, see docs / :SnipInfo <name>
      GFM_original = {
        use_on_filetypes = { "markdown.pandoc" } --# the 'use_on_filetypes' configuration key is
        --# available for every interpreter
      }
    },
    --# you can combo different display modes as desired
    display = {
      "Classic", --# display results in the command-line  area
      "VirtualTextOk" --# display ok results as virtual text (multiline is shortened)

      -- "VirtualTextErr",          --# display error results as virtual text
      -- "TempFloatingWindow",      --# display results in a floating window
      -- "LongTempFloatingWindow",  --# same as above, but only long results. To use with VirtualText__
      -- "Terminal",                --# display results in a vertical split
      -- "TerminalWithCode",        --# display results and code history in a vertical split
      -- "NvimNotify",              --# display with the nvim-notify plugin
      -- "Api"                      --# return output to a programming interface
    },
    display_options = {
      terminal_width = 45, --# change the terminal display option width
      notification_timeout = 5 --# timeout for nvim_notify output
    },
    --# You can use the same keys to customize whether a sniprun producing
    --# no output should display nothing or '(no output)'
    show_no_output = {
      "Classic",
      "TempFloatingWindow" --# implies LongTempFloatingWindow, which has no effect on its own
    },
    --# customize highlight groups (setting this overrides colorscheme)
    snipruncolors = {
      SniprunVirtualTextOk = { bg = "#66eeff", fg = "#000000", ctermbg = "Cyan", cterfg = "Black" },
      SniprunFloatingWinOk = { fg = "#66eeff", ctermfg = "Cyan" },
      SniprunVirtualTextErr = {
        bg = "#881515",
        fg = "#000000",
        ctermbg = "DarkRed",
        cterfg = "Black"
      },
      SniprunFloatingWinErr = { fg = "#881515", ctermfg = "DarkRed" }
    },
    --# miscellaneous compatibility/adjustement settings
    inline_messages = 0, --# inline_message (0/1) is a one-line way to display messages
    --# to workaround sniprun not being able to display anything

    borders = "single", --# display borders around floating windows
    --# possible values are 'none', 'single', 'double', or 'shadow'
    live_mode_toggle = "off" --# live mode toggle, see Usage - Running for more info
  }
)

-- All of sniprun functionalities:

-- Shorthand	Lua backend	<Plug> mapping
-- :SnipRun	lua require'sniprun'.run()	<Plug>SnipRun
-- (normal node)	lua require'sniprun'.run('n')	<Plug>SnipRunOperator
-- :'<,'>SnipRun (visual mode)	lua require'sniprun'.run('v')	<Plug>SnipRun
-- :SnipInfo	lua require'sniprun'.info()	<Plug>SnipInfo
-- :SnipReset	lua require'sniprun'.reset()	<Plug>SnipReset
-- :SnipReplMemoryClean	lua require'sniprun'.clear_repl()	<Plug>SnipReplMemoryClean
-- :SnipClose	lua require'sniprun.display'.close_all()	<Plug>SnipClose
-- :SnipLive	lua require'sniprun.live_mode'.toggle()	<Plug>SnipLive
-- heavy_multiplication_x	lua require'sniprun.api'.run_range(..)	heavy_multiplication_x
-- heavy_multiplication_x	lua require'sniprun.api'.run_string(..)	heavy_multiplication_x

-- Mappings & recommandations
-- Map the run command to a simple command such as <leader>ff (or just f in visual mode)

-- Check SnipInfo & :SnipInfo <interpreter_name> to learn any quirk or tips about the language you're interested in

-- The operator mapping allows you to combine movements with sniprun: with the suggested mapping, "<leader>f + j" will run sniprun on the current line + the line below.

-- (if you don't know what is the leader key you can find a short explanation here).

-- recommended mappings in lua
-- vim.api.nvim\_set\_keymap('v', 'f', '<Plug>SnipRun', {silent = true})
-- vim.api.nvim\_set\_keymap('n', '<leader>f', '<Plug>SnipRunOperator', {silent = true})
-- vim.api.nvim\_set\_keymap('n', '<leader>ff', '<Plug>SnipRun', {silent = true})
