local default_cfg = {
  type = 'default', -- Cursor movement calculation method, choose "default", "exp" (exponential) or "matrix".

  cursor = '', -- Cursor shape (requires Nerd Font). Disabled in fancy mode.
  texthl = 'SmoothCursor', -- Highlight group. Default is { bg = nil, fg = "#FFD400" }. Disabled in fancy mode.
  linehl = nil, -- Highlights the line under the cursor, similar to 'cursorline'. "CursorLine" is recommended. Disabled in fancy mode.

  fancy = {
    enable = false, -- enable fancy mode
    head = { cursor = '▷', texthl = 'SmoothCursor', linehl = nil }, -- false to disable fancy head
    body = {
      { cursor = '', texthl = 'SmoothCursorRed' },
      { cursor = '', texthl = 'SmoothCursorOrange' },
      { cursor = '●', texthl = 'SmoothCursorYellow' },
      { cursor = '●', texthl = 'SmoothCursorGreen' },
      { cursor = '•', texthl = 'SmoothCursorAqua' },
      { cursor = '.', texthl = 'SmoothCursorBlue' },
      { cursor = '.', texthl = 'SmoothCursorPurple' },
    },
    tail = { cursor = nil, texthl = 'SmoothCursor' }, -- false to disable fancy tail
  },

  matrix = { -- Loaded when 'type' is set to "matrix"
    head = {
      -- Picks a random character from this list for the cursor text
      cursor = require('smoothcursor.matrix_chars'),
      -- Picks a random highlight from this list for the cursor text
      texthl = {
        'SmoothCursor',
      },
      linehl = nil, -- No line highlight for the head
    },
    body = {
      length = 6, -- Specifies the length of the cursor body
      -- Picks a random character from this list for the cursor body text
      cursor = require('smoothcursor.matrix_chars'),
      -- Picks a random highlight from this list for each segment of the cursor body
      texthl = {
        'SmoothCursorGreen',
      },
    },
    tail = {
      -- Picks a random character from this list for the cursor tail (if any)
      cursor = nil,
      -- Picks a random highlight from this list for the cursor tail
      texthl = {
        'SmoothCursor',
      },
    },
    unstop = false, -- Determines if the cursor should stop or not (false means it will stop)
  },

  autostart = true, -- Automatically start SmoothCursor
  always_redraw = true, -- Redraw the screen on each update
  flyin_effect = nil, -- Choose "bottom" or "top" for flying effect
  speed = 25, -- Max speed is 100 to stick with your current position
  intervals = 35, -- Update intervals in milliseconds
  priority = 10, -- Set marker priority
  timeout = 2000, -- Timeout for animations in milliseconds
  threshold = 3, -- Animate only if cursor moves more than this many lines
  disable_float_win = false, -- Disable in floating windows
  enabled_filetypes = nil, -- Enable only for specific file types, e.g., { "lua", "vim" }
  disabled_filetypes = nil, -- Disable for these file types, ignored if enabled_filetypes is set. e.g., { "TelescopePrompt", "NvimTree" }
}

local fancy_default = {
  enable = true,
  head = { cursor = '▷', texthl = 'SmoothCursor', linehl = nil }, -- false to disable fancy head
  body = { --  ●   • .
    { cursor = '', texthl = 'SmoothCursorRed' },
    { cursor = '', texthl = 'SmoothCursorOrange' },
    { cursor = '●', texthl = 'SmoothCursorYellow' },
    { cursor = '●', texthl = 'SmoothCursorGreen' },
    { cursor = '•', texthl = 'SmoothCursorAqua' },
    { cursor = '.', texthl = 'SmoothCursorBlue' },
    { cursor = '.', texthl = 'SmoothCursorPurple' },
  },
  tail = { cursor = nil, texthl = 'SmoothCursor' }, -- false to disable fancy tail
}
local fancy_1 = {
  enable = true,
  head = {
    cursor = '▷', -- ▷ ◆
    texthl = 'SmoothCursor',
    linehl = nil,
  }, -- false to disable fancy head
  body = {
    { cursor = '', texthl = 'SmoothCursorRed' },
    { cursor = '•', texthl = 'SmoothCursorOrange' },
    { cursor = '•', texthl = 'SmoothCursorYellow' },
    { cursor = '•', texthl = 'SmoothCursorGreen' },
    { cursor = '.', texthl = 'SmoothCursorAqua' },
    { cursor = '.', texthl = 'SmoothCursorBlue' },
    { cursor = '.', texthl = 'SmoothCursorPurple' },
  },
  tail = { cursor = nil, texthl = 'SmoothCursor' }, -- false to disable fancy tail
}

-- stylua: ignore
local cfg = {

  type = 'exp', -- Cursor movement calculation method, choose "default", "exp" (exponential) or "matrix".
  fancy             = fancy_1,
  threshold         = 3,     -- Animate only if cursor moves more than this many lines
  disable_float_win = true, -- Disable in floating windows
  -- TODO: configure flyin effect with different colors and transparency
  -- flyin_effect      = 'bottom',   -- Choose "bottom" or "top" for flying effect
  speed             = 45,    -- Max speed is 100 to stick with your current position
  intervals         = 35,    -- Update intervals in milliseconds
  cursor            = '▷',   -- Cursor shape (requires Nerd Font). Disabled in fancy mode.
  --  ▷
 disabled_filetypes = { "TelescopePrompt", "NvimTree", 'qf' }
}
require('smoothcursor').setup(cfg)

  --         ﲵ       嶺 淪 ▷   輪 ﯖ  
  -- 濾      礪 閭 驪 麗 ﱵ 隷   •   ● ●  
-- stylua: ignore
local icons = {
  ['n'] = '▷', --    ◆ ﮜ ▷
  ['v'] = '',
  ['V'] = '',
  [''] ='礪',
  ['R'] = '',
  ['i'] = '',
  ['s'] = '',
  ['S'] = '',
  ['c'] = '',
  ['C'] = '',
  ['*'] = '',
}

local colors = {
  -- ['n'] = { fg = '#fa4842', bold = true },
  ['n'] = { fg = '#0081ca', bold = true },
  ['v'] = { fg = '#8f41fa', bold = true },
  ['V'] = { fg = '#8f41fa', bold = true },
  [''] = { fg = '#8f41fa', bold = true },
  ['R'] = { fg = '#fa4842', bold = true },
  ['s'] = { fg = '#0f61ba', bold = true },
  ['S'] = { fg = '#0f61ba', bold = true },
  ['c'] = { fg = '#8f216a', bold = true },
  ['C'] = { fg = '#8f216a', bold = true },
  ['i'] = { fg = '#00afaf', bold = true },
  ['*'] = { fg = '#fa4842', bold = true },
  -- ! C C R S V c i n r s t v
}

vim.api.nvim_create_autocmd({ 'ModeChanged' }, {
  callback = function()
    local set_mode = function(icon, opts)
      vim.api.nvim_set_hl(0, 'SmoothCursor', {
        fg = opts.fg or nil,
        bg = opts.bg or nil,
        sp = opts.sp or nil,
        bold = opts.bold or nil,
        italic = opts.italic or nil,
        style = opts.style or nil,
        link = opts.link or nil,
      })
      vim.fn.sign_define('smoothcursor', { text = icon })
    end
    local current_mode = vim.fn.mode()
    if type(icons[current_mode]) ~= 'nil' then
      set_mode(icons[current_mode], colors[current_mode])
    else
      vim.dbglog('mode no icon: ' .. current_mode, vim.fn.mode())
      set_mode(icons['*'], colors['*'])
    end
  end,
})
