local fancy_1 = {
  enable = true,
  head = {
    cursor = "▷", -- ▷ ◆
    texthl = "SmoothCursor",
    linehl = nil,
  }, -- false to disable fancy head
  body = {
    { cursor = "", texthl = "SmoothCursorRed" },
    { cursor = "•", texthl = "SmoothCursorOrange" },
    { cursor = "•", texthl = "SmoothCursorYellow" },
    { cursor = "•", texthl = "SmoothCursorGreen" },
    { cursor = ".", texthl = "SmoothCursorAqua" },
    { cursor = ".", texthl = "SmoothCursorBlue" },
    { cursor = ".", texthl = "SmoothCursorPurple" },
  },
  tail = { cursor = nil, texthl = "SmoothCursor" }, -- false to disable fancy tail
}

-- stylua: ignore
local cfg = {
  type              = 'exp', -- Cursor movement calculation method, choose "default", "exp" (exponential) or "matrix".
  always_redraw     = true, -- (true) always redraw screen on update
  fancy             = fancy_1,
  threshold         = 3,     -- (3) Animate only if cursor moves more than this many lines
  disable_float_win = true, -- Disable in floating windows
  -- TODO: configure flyin effect with different colors and transparency
  -- flyin_effect      = 'bottom',   -- Choose "bottom" or "top" for flying effect
  speed             = 25,    -- (25) Max speed is 100 to stick with your current position
  intervals         = 45,    -- (35) Update intervals in milliseconds
  cursor            = '▷',   --  ▷ Cursor shape (requires Nerd Font). Disabled in fancy mode.
  timeout           = 2000,  -- (3000) timeout for animations
  disabled_filetypes = { "TelescopePrompt", "NvimTree", 'qf', 'noice' }
}

require("smoothcursor").setup(cfg)
require("configs.smoothcursor.mode-changed")
