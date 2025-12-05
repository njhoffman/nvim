-- Lualine configuration
-- Completely rewritten based on proper lualine documentation
-- Migrated from feline with correct component structure

local colors = require("configs.lualine.colors")
local providers = require("configs.lualine.providers")

local separators = {
  -- stylua: ignore
  separators = {
    circle     = "●",
    block      = "█",
    bar_fill   = "▊",
    bar_thin   = "┃",
    bar_thin_2 = "│",
    left = {
      round_thin     = "",
      round_fill     = "",
      point_thin     = "",
      point_fill     = "",
      slantup_thin   = " ",
      slantup_fill   = "",
      slantdown_thin = " ",
      slantdown_fill = "",

    },
    right = {
      round_thin     = "",
      round_fill     = "",
      point_thin     = "",
      point_fill     = "",
      slantdown_thin = " ",
      slantdown_fill = "",
      slantup_thin   = " ",
      slantup_fill   = "",
    },
  },

  -- ▊  nvim   init.lua  2.38k   1:1   0x2D                  Top ▁▁
}

-- ============================================================================
-- MODE COLOR MAPPING
-- ============================================================================
local function get_mode_color()
  local mode = vim.fn.mode()
  local mode_map = {
    n = colors.main.cyan,
    i = colors.main.green,
    v = colors.main.violet,
    V = colors.main.violet,
    ["\22"] = colors.main.violet, -- CTRL-V
    c = colors.main.yellow,
    s = colors.main.magenta,
    S = colors.main.magenta,
    ["\19"] = colors.main.magenta, -- CTRL-S
    R = colors.main.red,
    r = colors.main.cyan,
    ["!"] = colors.main.red,
    t = colors.main.red,
  }
  return mode_map[mode] or colors.main.fg
end

-- ============================================================================
-- CUSTOM THEME
-- ============================================================================
local custom_theme = {
  normal = {
    a = { fg = colors.main.cyan, bg = colors.main.bg, gui = "bold" },
    b = { fg = colors.main.white, bg = colors.main.oceanblue, gui = "bold" },
    c = { fg = colors.main.fg, bg = colors.main.bg },
  },
  insert = {
    a = { fg = colors.main.green, bg = colors.main.bg, gui = "bold" },
    b = { fg = colors.main.white, bg = colors.main.oceanblue, gui = "bold" },
    c = { fg = colors.main.fg, bg = colors.main.bg },
  },
  visual = {
    a = { fg = colors.main.violet, bg = colors.main.bg, gui = "bold" },
    b = { fg = colors.main.white, bg = colors.main.oceanblue, gui = "bold" },
    c = { fg = colors.main.fg, bg = colors.main.bg },
  },
  replace = {
    a = { fg = colors.main.red, bg = colors.main.bg, gui = "bold" },
    b = { fg = colors.main.white, bg = colors.main.oceanblue, gui = "bold" },
    c = { fg = colors.main.fg, bg = colors.main.bg },
  },
  command = {
    a = { fg = colors.main.yellow, bg = colors.main.bg, gui = "bold" },
    b = { fg = colors.main.white, bg = colors.main.oceanblue, gui = "bold" },
    c = { fg = colors.main.fg, bg = colors.main.bg },
  },
  inactive = {
    a = { fg = colors.main.gray, bg = colors.main.bg },
    b = { fg = colors.main.gray, bg = colors.main.bg },
    c = { fg = colors.main.gray, bg = colors.main.bg },
  },
}

-- ============================================================================
-- CONDITIONS
-- ============================================================================
local conditions = {
  wide_window = function()
    return vim.api.nvim_win_get_width(0) > 80
  end,
  very_wide_window = function()
    return vim.api.nvim_win_get_width(0) > 110
  end,
  extra_wide_window = function()
    return vim.api.nvim_get_option_value("columns", { scope = "global" }) > 120
  end,
  cmdheight_zero = function()
    return vim.api.nvim_get_option("cmdheight") == 0
  end,
  search_active = function()
    return vim.fn.searchcount().total > 0
  end,
  noice_mode_active = function()
    local ok, noice = pcall(require, "noice")
    return ok and noice.api.status.mode.has()
  end,
}

-- ============================================================================
-- LUALINE SETUP
-- ============================================================================
require("lualine").setup({
  options = {
    theme = custom_theme,
    component_separators = "",
    section_separators = "",
    disabled_filetypes = {
      statusline = {
        "NvimTree",
        "fugitive",
        "fugitiveblame",
        "help",
        "neo-tree",
        "packer",
        "qf",
        "query",
        "spectre_panel",
        "startify",
        "Telescope",
        "tablegen",
        "tsplayground",
      },
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 100,
      tabline = 1000,
      winbar = 1000,
    },
  },

  sections = {
    -- ========================================================================
    -- LEFT SIDE: ▊  nvim   scratch.md ●  646b   8:1   0x258A 22
    -- ========================================================================
    lualine_a = {
      -- Mode indicator bar ▊ (0x258a)
      {
        function()
          return "▊"
        end,
        color = function()
          return { fg = get_mode_color(), gui = "bold" }
        end,
        padding = { left = 0, right = 1 },
      },
      -- Neovim icon  (0xe26b)
      {
        function()
          return ""
        end,
        color = function()
          return { fg = get_mode_color(), gui = "bold" }
        end,
        padding = { left = 0, right = 1 },
      },
      -- Separator  (0xe0ba)
      {
        function()
          return ""
        end,
        color = { fg = colors.main.oceanblue, bg = colors.main.bg },
        padding = { left = 0, right = 1 },
      },
    },

    lualine_b = {},

    -- ========================================================================
    -- LEFT CENTER: File info with icons and stats
    -- ========================================================================
    lualine_c = {
      -- File icon  (0xf43a)
      {
        function()
          return ""
        end,
        color = { fg = colors.main.blue },
        padding = { left = 0, right = 0 },
      },
      -- Filename
      {
        "filename",
        path = 0,
        symbols = {
          modified = "",
          readonly = " ",
          unnamed = "[No Name]",
        },
        color = { fg = colors.main.white },
        padding = { left = 0, right = 0 },
      },
      -- Modified indicator ● (0x25cf)
      {
        function()
          return vim.bo.modified and " ●" or ""
        end,
        color = { fg = colors.main.yellow },
        padding = { left = 0, right = 1 },
      },
      -- Separator  (0xe0bf)
      {
        function()
          return ""
        end,
        color = { fg = colors.main.oceanblue },
        padding = { left = 0, right = 0 },
      },
      -- File size (646b format)
      {
        function()
          local size = vim.fn.getfsize(vim.fn.expand("%:p"))
          if size < 0 then
            return ""
          end
          if size < 1024 then
            return string.format("%db", size)
          elseif size < 1024 * 1024 then
            return string.format("%dk", math.floor(size / 1024))
          elseif size < 1024 * 1024 * 1024 then
            return string.format("%dM", math.floor(size / (1024 * 1024)))
          else
            return string.format("%dG", math.floor(size / (1024 * 1024 * 1024)))
          end
        end,
        padding = { left = 0, right = 2 },
      },
      -- Separator  (0xe0bd)
      {
        function()
          return ""
        end,
        color = { fg = colors.main.oceanblue },
        padding = { left = 0, right = 1 },
      },
      -- Location (line:column) - updates on CursorMoved
      {
        function()
          local line = vim.fn.line(".")
          local col = vim.fn.col(".")
          return string.format("%d:%d", line, col)
        end,
        padding = { left = 0, right = 2 },
      },
      -- Separator  (0xe0bd)
      {
        function()
          return ""
        end,
        color = { fg = colors.main.oceanblue },
        padding = { left = 0, right = 1 },
      },
      -- ASCII hex code of character under cursor
      {
        providers.ascii,
        color = { fg = "#486088" },
        cond = conditions.wide_window,
        padding = { left = 0, right = 1 },
      },
      -- Gear icon  (0xf457)
      {
        function()
          return ""
        end,
        color = { fg = colors.main.gray },
        padding = { left = 0, right = 1 },
      },
      -- Total lines
      {
        function()
          return tostring(vim.fn.line("$"))
        end,
        color = { fg = "#1177a2" },
        padding = { left = 0, right = 1 },
      },
    },

    -- ========================================================================
    -- RIGHT SIDE: Empty
    -- ========================================================================
    lualine_x = {},

    -- ========================================================================
    -- RIGHT CENTER: 27:78   markdown  22 36% ▃▃
    -- ========================================================================
    lualine_y = {
      -- Misc stats (notification counts)
      {
        providers.misc_stats,
        color = { fg = "#4488ff" },
        cond = conditions.wide_window,
        padding = { left = 1, right = 1 },
      },
      -- Line:column position
      {
        function()
          local line = vim.fn.line(".")
          local col = vim.fn.col(".")
          return string.format("%d:%d", line, col)
        end,
        padding = { left = 1, right = 2 },
      },
      -- Filetype
      {
        "filetype",
        colored = false,
        icon_only = false,
        color = { fg = "#988088" },
        cond = conditions.extra_wide_window,
        padding = { left = 1, right = 1 },
      },
      -- Noice mode indicator
      {
        providers.noice_mode,
        color = function()
          return { fg = get_mode_color(), bg = colors.main.base }
        end,
        cond = conditions.noice_mode_active,
        padding = { left = 1, right = 1 },
      },
      -- Git branch
      {
        providers.git_branch,
        icon = "",
        color = { fg = "#3696c2", gui = "bold" },
        padding = { left = 1, right = 1 },
      },
      -- Git diff added
      {
        providers.git_diff_added,
        color = { fg = "#129A77", bg = colors.main.black },
        cond = conditions.very_wide_window,
        padding = 0,
      },
      -- Git diff changed
      {
        providers.git_diff_changed,
        color = { fg = "#6191f1", bg = colors.main.black },
        cond = conditions.very_wide_window,
        padding = 0,
      },
      -- Git diff removed
      {
        providers.git_diff_removed,
        color = { fg = "#8F313A", bg = colors.main.black },
        cond = conditions.very_wide_window,
        padding = 0,
      },
      -- Search count
      {
        "searchcount",
        color = { fg = colors.main.cyan, bg = colors.main.black },
        cond = function()
          return conditions.cmdheight_zero() and conditions.search_active()
        end,
        padding = { left = 1, right = 1 },
      },
    },

    -- ========================================================================
    -- RIGHT END: Total lines, percentage, scroll bar
    -- ========================================================================
    lualine_z = {
      -- Total line count
      {
        function()
          return tostring(vim.fn.line("$"))
        end,
        color = { fg = "#1177a2" },
        padding = { left = 1, right = 1 },
      },
      -- Percentage through buffer
      {
        function()
          local cur = vim.fn.line(".")
          local total = vim.fn.line("$")
          if total == 0 then
            return "0%"
          elseif cur == 1 then
            return "Top"
          elseif cur == total then
            return "Bot"
          else
            return string.format("%d%%", math.floor((cur / total) * 100))
          end
        end,
        color = { fg = "#4477aa", bg = colors.main.bg },
        padding = { left = 0, right = 1 },
      },
      -- Scroll bar indicator ▃▃ (0x2583)
      {
        function()
          local current_line = vim.fn.line(".")
          local total_lines = vim.fn.line("$")
          if total_lines <= 1 then
            return "▁▁"
          end

          local chars = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
          local line_ratio = current_line / total_lines
          local index = math.max(1, math.min(#chars, math.ceil(line_ratio * #chars)))

          return string.rep(chars[index], 2)
        end,
        color = { fg = colors.main.skyblue, gui = "bold" },
        padding = { left = 1, right = 0 },
      },
    },
  },

  -- ========================================================================
  -- INACTIVE SECTIONS
  -- ========================================================================
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },

  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
})

-- ============================================================================
-- COMMANDS
-- ============================================================================
vim.api.nvim_create_user_command("LualineRestart", function()
  -- Reload modules
  package.loaded["configs.lualine.init"] = nil
  package.loaded["configs.lualine.providers"] = nil
  package.loaded["configs.lualine.colors"] = nil

  -- Reload lualine
  require("configs.lualine.init")
end, { desc = "Restart lualine statusline" })

-- Set showcmdloc for statusline
vim.opt.showcmdloc = "statusline"
