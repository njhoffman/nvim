--  vim.g.vimade = {
--    enabletreesitter = 1,
--    basegroups = {
--      "Search",
--      "SignColumn",
--      "v2hexokinase", "LineNr",
--      "CursorLine",
--      "CursorLineNr",
--      "DiffAdd",
--      "DiffChange",
--      "DiffDelete",
--      "DiffText",
--      "FoldColumn",
--      "Whitespace"
--    },
--    rowbufsize = 15,
--    colbufsize = 15,
--    fadelevel = 0.7,
--    signsretentionperiod = 1000,
--    fadepriority = 50,
--    enablesigns = 1,
--    enablefocusfading = 1
-- --  }

-- TODO: have separate fade level for focus events

-- 'cmp_menu',
-- 'dap-log',
-- 'dap-repl',
-- 'dapui_console',
-- 'dapui_stacks',
-- 'dapui_breakpoints',
-- 'dapui_scopes',
-- 'dapui_watches',
-- 'CompetiTest',
-- 'SidebarNvim',
-- 'Trouble',
-- 'aerial',
-- 'tablegen',
-- 'nerdtree',
-- 'neo-tree',
-- 'noice',
-- 'Mundo',
-- 'NvimTree',
-- 'MundoDiff',
local Fade = require("vimade.style.fade").Fade
local direction = require("vimade.style.value.direction")
local ease = require("vimade.style.value.ease")
local animate = require("vimade.style.value.animate")

local fade1 = Fade({
  value = animate.Number({
    start = 1,
    to = 0.2,
  }),
})

local fade2 = Fade({
  value = animate.Number({
    start = 1,
    to = 0.2,
    direction = direction.IN_OUT,
    ease = ease.OUT_BOUNCE,
    duration = 1000,
    delay = 100,
  }),
})

local EXCLUDE_NAMES = { "LineNr", "LineNrBelow", "LineNrAbove", "WinSeparator", "EndOfBuffer" }
local NO_VISIBILITY_NAMES = { "LineNr", "LineNrBelow", "LineNrAbove", "EndOfBuffer" }
local LOW_VISIBILITY_NAMES = { "WinSeparator" }

local Default = require("vimade.recipe.default").Default({ animate = true })
local Minimalist = require("vimade.recipe.minimalist").Minimalist({ animate = false })

local vimade = require("vimade")
vimade.setup({
  style = Minimalist.style,
  fadelevel = function(style, _)
    if style.win.buf_opts.syntax == "neo-tree" then
      return 0.8
    else
      return 0.5
    end
  end,
  blocklist = {
    only_behind_float_windows = function(win, current)
      -- current can be nil
      if (win.win_config.relative == "") and (current and current.win_config.relative ~= "") then
        return false
      end
      return true
    end,
    buf_opts = {
      buftype = {
        "prompt",
        "terminal",
      },
      -- filetype = {
      --   "CompetiTest",
      --   "Mundo",
      --   "MundoDiff",
      --   "NvimTree",
      --   "SidebarNvim",
      --   "Trouble",
      --   "aerial",
      --   "cmp_menu",
      --   "dap-log",
      --   "dap-repl",
      --   "dapui_breakpoints",
      --   "dapui_console",
      --   "dapui_scopes",
      --   "dapui_stacks",
      --   "dapui_watches",
      --   "neo-tree",
      --   "nerdtree",
      --   "noice",
      --   "tablegen",
      -- },
    },
    win_config = { relative = true },
  },
  link = {},
  groupdiff = 1,
  groupscrollbind = 0,
  enablefocusfading = 1,
  normalid = "",
  normalncid = "",
  nohlcheck = 1,
})

-- vim.g.vimade = {
--   -- running = 0,
--   basebg = "#041026",
--   basegroups = {
--     "Conceal",
--     -- "ColorColumn",
--     "CursorLine",
--     "CursorLineNr",
--     "CursorColumn",
--     "LineNr",
--     "DiffAdd",
--     "DiffChange",
--     "DiffDelete",
--     "DiffText",
--     "EndOfBuffer",
--     "FoldColumn",
--     "Folded",
--     "NonText",
--     -- 'MiniIndentscopeSymbol',
--     -- 'IblScope',
--     -- 'IblIndent',
--     -- 'IblWhitespace',
--     -- '@ibl.scope.char.1',
--     -- '@ibl.indent.char.1',
--     -- '@ibl.whitespace.char.1',
--     -- 'Search',
--     "SignColumn",
--     -- 'Scrollbar',
--     -- 'ScrollView',
--     "SpecialKey",
--     -- 'StatusLine',
--     "WinBar",
--     "WinSeparator",
--     "Whitespace",
--     "VirtualText",
--     "barbecue_basename",
--     "barbecue_normal",
--     "barbecue_context",
--   },
--   checkinterval = 100,
--   detecttermcolors = 1,
--   enablebasegroups = 1,
--   enablefocusfading = 1,
--   enablesigns = 0,
--   enabletreesitter = 1,
--   fadelevel = 0.5,
--   fadepriority = 100,
--   groupdiff = 1,
--   groupscrollbind = 1,
--   signspriority = 31,
--   signsretentionperiod = 4000,
--   usecursorhold = 0,
-- }
--
-- vim.api.nvim_create_augroup("VimadeEvents", { clear = true })
-- vim.api.nvim_create_autocmd({ "FocusLost", "WinLeave" }, {
--   group = "VimadeEvents",
--   callback = function(ev)
--     local winid = vim.fn.bufwinid(ev.buf)
--     vim.api.nvim_set_option_value("colorcolumn", "0", { win = winid })
--   end,
-- })
--
-- -- vim.cmd('VimadeFadeActive')
-- vim.api.nvim_create_autocmd({ "FocusGained", "WinEnter" }, {
--   group = "VimadeEvents",
--   callback = function(ev)
--     local winid = vim.fn.bufwinid(ev.buf)
--     vim.api.nvim_set_option_value("colorcolumn", "+1", { win = winid })
--   end,
-- })

-- vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufWinLeave' }, {
--   group = 'VimadeEvents',
--   callback = function(ev)
--     local state = {
--       bufnr = ev.buf,
--       winnr = vim.fn.bufwinnr(ev.buf),
--       ft = vim.api.nvim_buf_get_option(ev.buf, 'filetype'),
--       buftype = vim.api.nvim_buf_get_option(ev.buf, 'buftype'),
--       bufname = vim.api.nvim_buf_get_name(ev.buf),
--     }
--     local wininfo = vim.fn.getwininfo(state.winnr)
--     vim.dbglog(ev.event .. ':' .. state.bufnr .. ' ' .. state.buftype .. ' ' .. state.ft)
--   end,
-- })

-- vim.cmd([[
--  " window instead of bufer fading
--  augroup SemiDimPerWin
--  au!
--  au WinLeave * call OnWinLeave()
--  au WinEnter * call OnWinEnter()
--  au! TextChangedI,TextChanged * call UpdateBufferAsync()
--  augroup END

--   function! OnWinEnter ()
--       VimadeFadeActive
--       VimadeWinDisable
--   endfunction
--   function! OnWinLeave ()
--       VimadeWinEnable
--   endfunction

--  function! UpdateBufferAsync ()
--      if exists('g:update_vimade')
--          return
--      endif
--      let g:update_vimade = timer_start(1, 'DoUpdateBuffer') "change the timer value from 1 to whatever to help with performance
--  endfunction

--  function! DoUpdateBuffer (w)
--      unlet g:update_vimade
--      call vimade#BufDisable()
--      call vimade#BufEnable()
--  endfunction

-- ]])
-- print(vim.inspect(vim.g.vimade.fadelevel))
