require("barbar").setup({
  auto_hide = 1,
  -- insert_at_end = false,
  -- insert_at_start = false,
  -- hide = { inactive = true },
  highlight_alternate = true,
  highlights = {
    fill = {
      fg = { attribute = "fg", highlight = "TabLine" }, -- change to this
      bg = { attribute = "bg", highlight = "TabLine" },
    },
  },
  icons = {
    -- diagnostics = {
    --   [vim.diagnostic.severity.ERROR] = { enabled = true, icon = '' },
    -- },

    -- separator = { left = '▎' },
    -- right = { " " },

    separator = { left = "▎", right = "" },
    -- If true, add an additional separator at the end of the buffer list
    separator_at_end = true,

    preset = "default",
    pinned = {
      button = "",
      filename = true,
      separator = { right = " " },
    },
    alternate = { filetype = { custom_colors = true, enabled = true } },
  },
})

-- mini.sessions
--  vim.opt.sessionoptions:append 'globals'
--  require'mini.sessions'.setup {
--    hooks = {
--      pre = {
--        write = function() vim.api.nvim_exec_autocmds('User', {pattern = 'SessionSavePre'}) end,
--      },
--    },
--  }
--

local apply_highlights = function()
  -- Color palette
  local palette = {
    base4 = "#3f444a",
    base5 = "#5B6268",
    base6 = "#73797e",
    base7 = "#9ca0a4",
    base8 = "#b1b1b1",
    base9 = "#e6e6e6",
    red = "#ff6c6b",
    yellow = "#ECBE7B",
    blue = "#51afef",
    bg = "#282c34",
    bg_alternate = "#162343",
    bg_current = "#003d79",
    bg_visible = "#282c34",
    bg_other = "#1c1f24",
    bg_statusline = "#3E4556",
    diff_info_fg = "#73797e",
    diff_info_bg0 = "#202328",
  }

  local highlights = {
    -- BufferCurrent = { fg = palette.base9, bg = palette.bg_current, style = "" },
    -- BufferCurrentIndex = { fg = palette.base6, bg = palette.bg_current, style = "" },
    -- BufferCurrentMod = { fg = palette.yellow, bg = palette.bg_current, style = "" },
    -- BufferCurrentSign = { fg = palette.blue, bg = palette.bg_current, style = "" },
    -- BufferCurrentTarget = { fg = palette.red, bg = palette.bg_current, style = "bold" },

    -- BufferVisible = { fg = palette.base7, bg = palette.bg_visible, style = "" },
    -- BufferVisibleIndex = { fg = palette.base9, bg = palette.bg_visible, style = "" },
    -- BufferVisibleMod = { fg = palette.yellow, bg = palette.bg_visible, style = "" },
    -- BufferVisibleSign = { fg = palette.base4, bg = palette.bg_visible, style = "" },
    -- BufferVisibleTarget = { fg = palette.red, bg = palette.bg_visible, style = "bold" },

    -- BufferAlternate = { fg = palette.base6, bg = palette.bg_alternate, style = "" },
    -- BufferAlternateIndex = { fg = palette.base6, bg = palette.bg_alternate, style = "" },
    -- BufferAlternateMod = { fg = palette.yellow, bg = palette.bg_alternate, style = "" },
    -- BufferAlternateSign = { fg = palette.base4, bg = palette.bg_alternate, style = "" },
    -- BufferAlternateTarget = { fg = palette.red, bg = palette.bg_alternate, style = "bold" },

    -- BufferInactive = { fg = palette.base6, bg = palette.bg_other, style = "" },
    -- BufferInactiveIndex = { fg = palette.base6, bg = palette.bg_other, style = "" },
    -- BufferInactiveMod = { fg = palette.yellow, bg = palette.bg_other, style = "" },
    -- BufferInactiveSign = { fg = palette.base4, bg = palette.bg_other, style = "" },
    -- BufferInactiveTarget = { fg = palette.red, bg = palette.bg_other, style = "bold" },

    -- BufferTabpages = { fg = palette.blue, bg = palette.bg_statusline, style = "bold" },
    -- BufferTabpageFill = { fg = palette.base4, bg = palette.bg_other, style = "bold" },
    -- BufferOffset = { fg = palette.base6, bg = palette.bg, style = "bold" },
    -- BufferScrollArrow = { fg = palette.base8, bg = palette.bg_other, style = "bold" },

    -- BufferPart = { fg = palette.diff_info_fg, bg = palette.diff_info_bg0, style = "bold" },
  }

  -- Apply highlights using vim.api.nvim_set_hl
  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, {
      fg = opts.fg,
      bg = opts.bg,
      bold = opts.style == "bold",
      -- Add more style options if needed
    })
  end

  local set = vim.api.nvim_set_hl
  -- -- Barbar
  -- set(0, "TabLine", { bg = "none" })
  -- set(0, "TabLineFill", { bg = "none" })
  -- set(0, "TabLineSel", { bg = "none" })
  -- set(0, "BufferTabpages", { fg = "#51afef", bg = "#3e4556", bold = true })
  -- set(0, "BufferTabpagesFill", { fg = "#3f444a", bg = "#1c1f24", bold = true })
  -- set(0, "BufferDefaultCurrent", { bg = "#003d79", bold = true })
  -- set(0, "BufferCurrentError", { bg = "#003d79" })
  -- set(0, "BufferDefaultCurrentError", { bg = "#003d79" })
  -- set(0, "BufferDefaultCurrent", { bg = "#003d79", bold = true })
  -- set(0, "BufferDefaultCurrentIndex", { bg = "#003d79" })
  -- set(0, "BufferDefaultCurrentIcon", { fg = "#a8c0f0", bg = "#003d79", bold = true })
  -- set(0, "BufferDefaultCurrentMod", { fg = "#ecbe7b", bg = "#003d79", bold = true })
  -- set(0, "BufferDefaultCurrentSign", { fg = "#51afff", bg = "#003d79" })

  -- set(0, "BufferCurrent", { bg = "#003d79", bold = true })
  -- set(0, "BufferCurrentIndex", { bg = "#003d79" })
  -- set(0, "BufferCurrentIcon", { fg = "#a8c0f0", bg = "#003d79", bold = true })
  -- set(0, "BufferCurrentMod", { fg = "#ecbe7b", bg = "#003d79", bold = true })

  -- set(0, "BufferCurrentSign", { fg = "#51afff", bg = "#003d79" })
  -- set(0, "BufferAlternate", { bg = "#162343" })
  -- set(0, "BufferAlternateMod", { bg = "#162343", fg = "#988881" })
  -- set(0, "BufferAlternateIcon", { bg = "#162343", fg = "#3a5677" })
end

apply_highlights()

-- vim.opt.sessionoptions:append("globals")
-- vim.api.nvim_create_user_command("Mksession", function(attr)
--   vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
--   -- Neovim 0.8<=
--   vim.cmd.mksession({ bang = attr.bang, args = attr.fargs })
-- end, { bang = true, complete = "file", nargs = "?" })
