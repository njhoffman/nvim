local full_opts = {
  on_open = function()
    vim.api.nvim_buf_set_var(0, "miniindentscope_disable", true)
    vim.api.nvim_buf_set_var(0, "indent_blankline_enabled", false)
  end,
  on_close = function()
    vim.api.nvim_buf_set_var(0, "miniindentscope_disable", false)
    vim.api.nvim_buf_set_var(0, "indent_blankline_enabled", true)
    vim.api.nvim_set_option_value("cursorline", true, { win = 0 })
  end,
  window = {
    backdrop = 0.85, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
    width = 120, -- width of the Zen window
    height = 1, -- height of the Zen window
    options = {
      signcolumn = "no", -- disable signcolumn
      number = false, -- disable number column
      relativenumber = false, -- disable relative numbers
      cursorline = false, -- disable cursorline
      cursorcolumn = false, -- disable cursor column
      foldcolumn = "0", -- disable fold column
      list = false, -- disable whitespace characters
    },
  },
  plugins = {
    options = {
      enabled = true,
      ruler = false, -- disables the ruler text in the cmd line area
      showcmd = false, -- disables the command in the last line of the screen
    },
    gitsigns = { enabled = true },
    tmux = { enabled = true },
    alacritty = {
      enabled = false,
      font = "9", -- font size
    },
    twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
  },
}

local min_opts =
  vim.tbl_deep_extend("force", full_opts, { plugins = { tmux = { enabled = false } } })
