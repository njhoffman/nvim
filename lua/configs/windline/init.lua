-- Windline configuration
-- Migrated from lualine configuration with same layout and colors

local windline = require("windline")

local state = _G.WindLine.state
local colors = require("configs.windline.colors")
local providers = require("configs.windline.providers")

-- ============================================================================
-- MODE COLOR MAPPING
-- ============================================================================
local colors_mode = {
  Normal = { colors.main.cyan, "bg" },
  Insert = { colors.main.green, "bg" },
  Visual = { colors.main.violet, "bg" },
  Replace = { colors.main.red, "bg" },
  Command = { colors.main.yellow, "bg" },
}
-- local function get_mode_color()
--   local mode = vim.fn.mode()
--   local mode_map = {
--     n = colors.main.cyan,
--     i = colors.main.green,
--     v = colors.main.violet,
--     V = colors.main.violet,
--     ["\22"] = colors.main.violet, -- CTRL-V
--     c = colors.main.yellow,
--     s = colors.main.magenta,
--     S = colors.main.magenta,
--     ["\19"] = colors.main.magenta, -- CTRL-S
--     R = colors.main.red,
--     r = colors.main.cyan,
--     ["!"] = colors.main.red,
--     t = colors.main.red,
--   }
--   return mode_map[mode] or colors.main.fg
-- end

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
-- COMPONENT DEFINITIONS
-- ============================================================================

local comps = {}

-- Mode indicator bar with icon
comps.mode_indicator = {
  name = "mode_indicator",
  hl_colors = colors_mode,
  hl = function()
    return state.mode[2]
  end,
  text = function()
    return "▊ "
    -- return {
    --   { { "▊ ", state.mode[2] } },
    --   -- { { " ", "" } },
    --   -- { { " ", state.mode[2] } },
    -- }
  end,
}

-- File icon and name with modified indicator
comps.file_info = {
  name = "file_info",
  hl_colors = {
    icon = { "blue", "bg" },
    filename = { "white", "bg" },
    modified = { "yellow", "bg" },
    sep = { "oceanblue", "bg" },
  },
  text = function()
    local filename = vim.fn.expand("%:t")
    if filename == "" then
      filename = "[No Name]"
    end
    local modified = vim.bo.modified and " ●" or ""

    return {
      { "", "sep" },
      { " ", "icon" },
      { "", "icon" },
      { filename, "filename" },
      { modified, "modified" },
      { " ", "default" },
    }
  end,
}

-- File size
comps.file_size = {
  name = "file_size",
  hl_colors = {
    sep = { "oceanblue", "bg" },
    text = { "fg", "bg" },
  },
  text = function()
    local size = vim.fn.getfsize(vim.fn.expand("%:p"))
    if size < 0 then
      return ""
    end
    local size_str
    if size < 1024 then
      size_str = string.format("%db", size)
    elseif size < 1024 * 1024 then
      size_str = string.format("%dk", math.floor(size / 1024))
    elseif size < 1024 * 1024 * 1024 then
      size_str = string.format("%dM", math.floor(size / (1024 * 1024)))
    else
      size_str = string.format("%dG", math.floor(size / (1024 * 1024 * 1024)))
    end
    return {
      { "", "sep" },
      { size_str .. "  ", "text" },
    }
  end,
}

-- Current position
comps.position = {
  name = "position",
  hl_colors = {
    sep = { "oceanblue", "bg" },
    text = { "fg", "bg" },
  },
  text = function()
    local line = vim.fn.line(".")
    local col = vim.fn.col(".")
    return {
      { "", "sep" },
      { string.format(" %d:%d  ", line, col), "text" },
    }
  end,
}

-- ASCII code of character under cursor
comps.ascii = {
  name = "ascii",
  width = 80,
  hl_colors = {
    sep = { "oceanblue", "bg" },
    text = { "ascii_fg", "bg" },
  },
  text = function()
    local ascii_val = providers.ascii()
    if ascii_val == "" then
      return ""
    end
    return {
      { "", "sep" },
      { " " .. ascii_val .. " ", "text" },
    }
  end,
}

-- Total lines with gear icon
comps.total_lines = {
  name = "total_lines",
  hl_colors = {
    icon = { "gray", "bg" },
    text = { "line_num", "bg" },
  },
  text = function()
    return {
      { "", "icon" },
      { " " .. tostring(vim.fn.line("$")), "text" },
    }
  end,
}

-- Misc stats
comps.misc_stats = {
  name = "misc_stats",
  width = 80,
  hl_colors = {
    text = { "misc_fg", "bg" },
  },
  text = function()
    local stats = providers.misc_stats()
    if stats == "" then
      return ""
    end
    return { { stats .. " ", "text" } }
  end,
}

-- Filetype
comps.filetype = {
  name = "filetype",
  width = 120,
  hl_colors = {
    text = { "filetype_fg", "bg" },
  },
  text = function()
    local ft = vim.bo.filetype
    if ft == "" then
      return ""
    end
    return { { ft .. "  ", "text" } }
  end,
}

-- Git branch
comps.git_branch = {
  name = "git_branch",
  hl_colors = {
    text = { "git_branch_fg", "bg", "bold" },
  },
  text = function()
    local branch = providers.git_branch()
    if branch == "" then
      return ""
    end
    return { { " " .. branch .. " ", "text" } }
  end,
}

-- Git diff stats
comps.git_diff = {
  name = "git_diff",
  width = 110,
  hl_colors = {
    added = { "git_added", "black" },
    changed = { "git_changed", "black" },
    removed = { "git_removed", "black" },
  },
  text = function()
    local added = providers.git_diff_added()
    local changed = providers.git_diff_changed()
    local removed = providers.git_diff_removed()

    local result = {}
    if added ~= "" then
      table.insert(result, { added, "added" })
    end
    if changed ~= "" then
      table.insert(result, { changed, "changed" })
    end
    if removed ~= "" then
      table.insert(result, { removed, "removed" })
    end
    return result
  end,
}

-- Search count
comps.search_count = {
  name = "search_count",
  hl_colors = {
    text = { "cyan", "black" },
  },
  text = function()
    if vim.api.nvim_get_option_value("cmdheight", { scope = "global" }) ~= 0 then
      return ""
    end
    local ok, result = pcall(vim.fn.searchcount)
    if ok and result.total > 0 then
      return { { string.format(" %d/%d ", result.current, result.total), "text" } }
    end
    return ""
  end,
}

-- Line percentage
comps.line_percentage = {
  name = "line_percentage",
  hl_colors = {
    text = { "line_pct", "bg" },
  },
  text = function()
    local cur = vim.fn.line(".")
    local total = vim.fn.line("$")
    local pct
    if total == 0 then
      pct = "0%"
    elseif cur == 1 then
      pct = "Top"
    elseif cur == total then
      pct = "Bot"
    else
      pct = string.format("%d%%", math.floor((cur / total) * 100))
    end
    return { { " " .. pct .. " ", "text" } }
  end,
}

-- Scroll bar
comps.scroll_bar = {
  name = "scroll_bar",
  hl_colors = {
    bar = { "skyblue", "bg", "bold" },
  },
  text = function()
    local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    if total_lines <= 1 then
      return { { "▁▁", "bar" } }
    end

    local chars = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
    local line_ratio = current_line / total_lines
    local index = math.max(1, math.min(#chars, math.ceil(line_ratio * #chars)))

    return { { string.rep(chars[index], 2), "bar" } }
  end,
}

-- Divider (spacer)
comps.space = function()
  return { " ", { "fg", "bg" } }
end

-- ============================================================================
-- STATUSLINE SETUP
-- ============================================================================

local default = {
  filetypes = { "default" },
  active = {
    -- comps.mode_indicator,
    comps.file_info,
    comps.file_size,
    comps.position,
    comps.ascii,
    comps.total_lines,
    { " %=", { "fg", "bg" } }, -- Divider to push right side
    comps.misc_stats,
    {
      function()
        local line = vim.fn.line(".")
        local col = vim.fn.col(".")
        return string.format("%d:%d  ", line, col)
      end,
      { "fg", "bg" },
    },
    comps.filetype,
    comps.git_branch,
    comps.git_diff,
    comps.search_count,
    {
      function()
        return tostring(vim.fn.line("$")) .. " "
      end,
      { "line_num", "bg" },
    },
    comps.line_percentage,
    comps.scroll_bar,
  },
  inactive = {
    { " ", { "gray", "bg" } },
    {
      function()
        return vim.fn.expand("%:t")
      end,
      { "gray", "bg" },
    },
    { " %=", { "gray", "bg" } },
    {
      function()
        return vim.fn.line(".") .. " "
      end,
      { "gray", "bg" },
    },
  },
}

windline.setup({
  colors_name = function(wl_colors)
    -- Register all custom colors for windline
    wl_colors.cyan = colors.main.cyan
    wl_colors.green = colors.main.green
    wl_colors.violet = colors.main.violet
    wl_colors.yellow = colors.main.yellow
    wl_colors.magenta = colors.main.magenta
    wl_colors.red = colors.main.red
    wl_colors.blue = colors.main.blue
    wl_colors.white = colors.main.white
    wl_colors.black = colors.main.black
    wl_colors.bg = colors.main.bg
    wl_colors.fg = colors.main.fg
    wl_colors.gray = colors.main.gray
    wl_colors.skyblue = colors.main.skyblue
    wl_colors.oceanblue = colors.main.oceanblue

    -- Custom colors for specific components
    wl_colors.ascii_fg = "#486088"
    wl_colors.line_num = "#1177a2"
    wl_colors.misc_fg = "#4488ff"
    wl_colors.filetype_fg = "#988088"
    wl_colors.git_branch_fg = "#3696c2"
    wl_colors.git_added = "#129A77"
    wl_colors.git_changed = "#6191f1"
    wl_colors.git_removed = "#8F313A"
    wl_colors.line_pct = "#4477aa"

    return wl_colors
  end,
  statuslines = { default },
})

-- ============================================================================
-- COMMANDS
-- ============================================================================
vim.api.nvim_create_user_command("WindlineRestart", function()
  package.loaded["configs.windline.init"] = nil
  package.loaded["configs.windline.providers"] = nil
  package.loaded["configs.windline.colors"] = nil
  require("configs.windline.init")
end, { desc = "Restart windline statusline" })

vim.opt.showcmdloc = "statusline"
