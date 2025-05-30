vim.fn.sign_define("smoothcursor_v", { text = " " })
vim.fn.sign_define("smoothcursor_V", { text = "" })
vim.fn.sign_define("smoothcursor_i", { text = "" })
vim.fn.sign_define("smoothcursor_�", { text = "" })
vim.fn.sign_define("smoothcursor_R", { text = "󰊄" })

local fancy_1 = {
  enable = true,
  head = {
    cursor = "▷", -- ▷ ◆  • • • . . .
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

  tail = false,
  -- tail = { cursor = nil, texthl = "SmoothCursor" }, -- false to disable fancy tail
}


-- stylua: ignore
local cfg = {
  type              = 'exp', -- Cursor movement calculation method, choose "default", "exp" (exponential) or "matrix".
  always_redraw     = true, -- (true) always redraw screen on update
  fancy             = fancy_1,
  threshold         = 5,     -- (3) Animate only if cursor moves more than this many lines
  flyin_effect      = 'bottom',   -- Choose "bottom" or "top" for flying effect
  speed             = 60,    -- (25) Max speed is 100 to stick with your current position
  priority          = 6,              -- Set marker priority
  intervals         = 25,    -- (35) Update intervals in milliseconds
  cursor            = '▷',   --  ▷ Cursor shape (requires Nerd Font). Disabled in fancy mode.
  timeout           = 2000,  -- (3000) timeout for animations
  disable_float_win = true,  -- Disable in floating windows
  disabled_filetypes = {
    "TelescopePrompt",
    "NvimTree",
    'qf',
    'noice',
  },
  show_last_positions = "",
  -- show_last_positions = "leave",
}

require("smoothcursor").setup(cfg)
require("configs.smoothcursor.mode-changed")
