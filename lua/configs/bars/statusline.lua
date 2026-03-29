--- bars.nvim statusline configuration.
--- Defines component templates and style layouts.

local project = require("bars.components.project")
local file_size = require("bars.components.file_size")
local cursor_position = require("bars.components.cursor_position")
local ascii = require("bars.components.ascii")
local line_count = require("bars.components.line_count")
local line_percentage = require("bars.components.line_percentage")
local scroll_bar = require("bars.components.scroll_bar")
local filetype = require("bars.components.filetype")
local encoding = require("bars.components.encoding")
local fileformat = require("bars.components.fileformat")
local search_count = require("bars.components.search_count")
local selection_count = require("bars.components.selection_count")
local misc_stats = require("bars.components.misc_stats")
local noice_mode = require("bars.components.noice_mode")
local git_diff = require("bars.components.git_diff")
local lsp_clients = require("bars.components.lsp_clients")
local hostname = require("bars.components.hostname")
local datetime = require("bars.components.datetime")
local spell = require("bars.components.spell")
local workdir = require("bars.components.workdir")
local dap = require("bars.components.dap")
local tabs = require("bars.components.tabs")

-------------------------------------------------------------------------------
-- Helpers
-------------------------------------------------------------------------------

local function min_width(w)
  return function(_, window)
    return vim.api.nvim_win_get_width(window) > w
  end
end

local function is_active_win(_, window)
  return window == vim.api.nvim_get_current_win()
end

--[[ Reusable configuration templates. ]]
---@type table<string, bars.statusline.component>
local TEMPLATES

TEMPLATES = {
  ---|fS

  ---@type bars.statusline.mode
  mode = {
    ---|fS "Mode configuration"

    kind = "mode",

    compact = function(_, window)
      if window ~= vim.api.nvim_get_current_win() then
        return true
      else
        return vim.api.nvim_win_get_width(window) < math.ceil(vim.o.columns * 0.5)
      end
    end,

    default = {
      padding_left = " ",
      padding_right = " ",
      corner_left = "▊ ",
      icon = " ",
      hl = "BarsSL_ModeNormal",
    },

    ["^n"] = { text = "Normal", hl = "BarsSL_ModeNormal" },
    ["^t"] = { text = "Terminal", hl = "BarsSL_ModeTerminal" },

    ["^v$"] = { icon = "󰸿 ", text = "Visual", hl = "BarsSL_ModeVisual" },
    ["^V$"] = { icon = "󰹀 ", text = "Visual", hl = "BarsSL_ModeVisual" },
    ["^\22$"] = { icon = "󰸽 ", text = "Visual", hl = "BarsSL_ModeVisual" },

    ["^s$"] = { icon = "󰕠 ", text = "Select", hl = "BarsSL_ModeSelect" },
    ["^S$"] = { icon = "󰕞 ", text = "Select", hl = "BarsSL_ModeSelect" },

    ["^i$"] = { icon = " ", text = "Insert", hl = "BarsSL_ModeInsert" },
    ["^ic$"] = { icon = " ", text = "Completion", hl = "BarsSL_ModeInsert" },
    ["^ix$"] = { text = "Insert", hl = "BarsSL_ModeInsert" },

    ["^R$"] = { icon = " ", text = "Replace", hl = "BarsSL_ModeReplace" },
    ["^Rc$"] = { icon = " ", text = "Completion", hl = "BarsSL_ModeReplace" },

    ["^c"] = { icon = " ", text = "Command", hl = "BarsSL_ModeCommand" },
    ["^r"] = { text = "Prompt", hl = "BarsSL_ModeNormal" },
    ["^%!"] = { icon = " ", text = "Shell", hl = "BarsSL_ModeCommand" },

    ---|fE
  },

  ---@type bars.statusline.bufname
  bufname = {
    ---|fS

    kind = "bufname",
    condition = function(_, win)
      return vim.api.nvim_win_get_width(win) >= 42
    end,

    max_len = 25,

    default = {
      padding_left = " ",
      padding_right = " ",
      icon = "",
      nomodifiable_icon_hl = "BarsFt1",
      nomodifiable_icon = "󰌾 ",
      icon_hl = {
        "BarsFt0", "BarsFt1", "BarsFt2",
        "BarsFt3", "BarsFt4", "BarsFt5", "BarsFt6",
      },
    },

    ["^$"] = {
      icon = "󰂵 ",
      text = "New file",
      hl = "BarsFt0",
    },

    ["^config"] = {
      icon = "󰒓 ",
      hl = "BarsFt6",
    },

    ---|fE
  },

  ---@type bars.statusline.diagnostics
  diagnostics = {
    ---|fS

    kind = "diagnostics",
    default_mode = 5,
    compact = true,
    auto_hide = true,

    padding_left = " ",
    padding_right = " ",

    empty_icon = "󰂓 ",
    empty_hl = "@comment",

    error_icon = "󰅙 ",
    error_hl = "DiagnosticError",

    warn_icon = "󰀦 ",
    warn_hl = "DiagnosticWarn",

    hint_icon = "󰁨 ",
    hint_hl = "DiagnosticHint",

    info_icon = "󰁤 ",
    info_hl = "DiagnosticInfo",

    ---|fE
  },

  ---@type bars.statusline.macro
  macro = {
    ---|fS

    kind = "macro",

    record_icon = "󰦚 ",
    exec_icon = "󰥠 ",

    record_hl = "@constant",
    exec_hl = "DiagnosticOk",

    ---|fE
  },

  ---@type bars.statusline.progress
  progress = {
    ---|fS

    kind = "progress",

    check = "lsp_loader_state",
    update_delay = 250,

    start = "󰐌 ",
    progress = { "󰋙 ", "󰫃 ", "󰫄 ", "󰫅 ", "󰫆 ", "󰫇 ", "󰫈 " },
    finish = "󰗠 ",

    start_hl = "@comment",
    progress_hl = {
      "BarsNormal4", "BarsNormal3", "BarsNormal3",
      "BarsNormal2", "BarsNormal2", "BarsNormal1", "BarsNormal1",
    },
    finish_hl = "DiagnosticOk",

    ---|fE
  },

  ---@type bars.statusline.branch
  git_branch = {
    ---|fS

    kind = "branch",
    condition = is_active_win,

    default = {
      padding_left = "  ",
      padding_right = " ",
      icon = " ",
      hl = "BarsSL_GitBranch",
    },

    ---|fE
  },

  ---@type bars.statusline.custom
  project = {
    ---|fS

    kind = "custom",

    condition = function()
      local ok = pcall(require, "project_nvim")
      return ok
    end,

    value = function(buffer, window)
      local text = project.value(buffer, window)
      if text == "" then
        return ""
      end
      return table.concat({
        "%#BarsSL_ProjectLeftSep#", "",
        "%#BarsSL_Project#", text,
        "%#BarsSL_ProjectRightSep#", "",
      })
    end,

    ---|fE
  },

  ---@type bars.statusline.custom
  file_size = {
    kind = "custom",
    value = function(buffer, window)
      local text = file_size.value(buffer, window)
      if text == "" then
        return ""
      end
      return "%#BarsSL_FileSize#" .. text
    end,
  },

  ---@type bars.statusline.custom
  cursor_position = {
    kind = "custom",
    value = function(buffer, window)
      return "%#BarsSL_Position#" .. cursor_position.value(buffer, window)
    end,
  },

  ---@type bars.statusline.custom
  ascii = {
    kind = "custom",
    value = function(buffer, window)
      return "%#BarsSL_Ascii#" .. ascii.value(buffer, window)
    end,
  },

  ---@type bars.statusline.custom
  line_count = {
    kind = "custom",
    condition = min_width(80),
    value = function(buffer, window)
      return line_count.value(buffer, window)
    end,
  },

  ---@type bars.statusline.custom
  misc_stats = {
    kind = "custom",
    condition = min_width(80),
    value = function(buffer, window)
      return "%#BarsSL_MiscStats#" .. misc_stats.value(buffer, window)
    end,
  },

  ---@type bars.statusline.custom
  filetype = {
    kind = "custom",
    condition = min_width(120),
    value = function(buffer, window)
      return "%#BarsSL_Filetype#" .. filetype.value(buffer, window)
    end,
  },

  ---@type bars.statusline.custom
  encoding = {
    kind = "custom",
    condition = min_width(120),
    value = function(buffer, window)
      local text = encoding.value(buffer, window)
      if text == "" then
        return ""
      end
      return "%#BarsSL_Filetype#" .. text
    end,
  },

  ---@type bars.statusline.custom
  fileformat = {
    kind = "custom",
    condition = min_width(120),
    value = function(buffer, window)
      return "%#BarsSL_Filetype#" .. fileformat.value(buffer, window)
    end,
  },

  ---@type bars.statusline.custom
  noice_mode = {
    kind = "custom",
    condition = function()
      if not package.loaded["noice"] then
        return false
      end
      local ok, has = pcall(function()
        return require("noice").api.status.mode.has()
      end)
      return ok and has
    end,
    value = noice_mode.value,
  },

  ---@type bars.statusline.custom
  git_diff_added = {
    kind = "custom",
    condition = min_width(110),
    value = function(buffer, window)
      local text = git_diff.added(buffer, window)
      if text == "" then
        return ""
      end
      return "%#BarsSL_GitDiffAdd#" .. text
    end,
  },

  ---@type bars.statusline.custom
  git_diff_changed = {
    kind = "custom",
    condition = min_width(110),
    value = function(buffer, window)
      local text = git_diff.changed(buffer, window)
      if text == "" then
        return ""
      end
      return "%#BarsSL_GitDiffChange#" .. text
    end,
  },

  ---@type bars.statusline.custom
  git_diff_removed = {
    kind = "custom",
    condition = min_width(110),
    value = function(buffer, window)
      local text = git_diff.removed(buffer, window)
      if text == "" then
        return ""
      end
      return "%#BarsSL_GitDiffRemove#" .. text
    end,
  },

  ---@type bars.statusline.custom
  search_count = {
    kind = "custom",
    condition = function()
      return (vim.api.nvim_get_option_value("cmdheight", {}) or 0) == 0
    end,
    value = function(buffer, window)
      local text = search_count.value(buffer, window)
      if text == "" then
        return ""
      end
      return "%#BarsSL_SearchCount#" .. text
    end,
  },

  ---@type bars.statusline.custom
  selection_count = {
    kind = "custom",
    value = function(buffer, window)
      local text = selection_count.value(buffer, window)
      if text == "" then
        return ""
      end
      return "%#BarsSL_ModeVisual#" .. text
    end,
  },

  ---@type bars.statusline.custom
  line_percentage = {
    kind = "custom",
    value = function(buffer, window)
      return "%#BarsSL_LinePct#" .. line_percentage.value(buffer, window)
    end,
  },

  ---@type bars.statusline.custom
  scroll_bar = {
    kind = "custom",
    value = function(buffer, window)
      return "%#BarsSL_ScrollBar#" .. scroll_bar.value(buffer, window)
    end,
  },

  ---@type bars.statusline.custom
  lsp_clients = {
    kind = "custom",
    condition = function(_, window)
      if window ~= vim.api.nvim_get_current_win() then
        return true
      end
      return vim.api.nvim_win_get_width(window) > math.ceil(vim.o.columns * 0.5)
    end,
    value = lsp_clients.value,
  },

  ---@type bars.statusline.custom
  hostname = {
    kind = "custom",
    value = function(buffer, window)
      return "%#BarsSL_Filetype#" .. hostname.value(buffer, window)
    end,
  },

  ---@type bars.statusline.custom
  datetime = {
    kind = "custom",
    value = function(buffer, window)
      return "%#BarsSL_Filetype#" .. datetime.value(buffer, window)
    end,
  },

  ---@type bars.statusline.custom
  spell = {
    kind = "custom",
    condition = function(_, window)
      return vim.wo[window].spell == true
    end,
    value = function(buffer, window)
      return "%#BarsSL_ModeCommand#" .. spell.value(buffer, window)
    end,
  },

  ---@type bars.statusline.custom
  workdir = {
    kind = "custom",
    value = function(buffer, window)
      return "%#BarsSL_Filetype#" .. workdir.value(buffer, window)
    end,
  },

  ---@type bars.statusline.custom
  dap = {
    kind = "custom",
    condition = function()
      return package.loaded["dap"] and require("dap").session() ~= nil
    end,
    value = function(buffer, window)
      return "%#BarsSL_ModeReplace#" .. dap.value(buffer, window)
    end,
  },

  ---@type bars.statusline.custom
  tabs = {
    kind = "custom",
    condition = function()
      return #vim.api.nvim_list_tabpages() > 1
    end,
    value = function(buffer, window)
      return "%#BarsSL_Filetype#" .. tabs.value(buffer, window)
    end,
  },

  ---@type bars.statusline.ruler
  ruler = {
    ---|fS

    kind = "ruler",
    mode = function()
      local mode = vim.api.nvim_get_mode().mode
      local visual_modes = { "v", "V", "\22" }
      return vim.list_contains(visual_modes, mode) and "visual" or "normal"
    end,

    ---@diagnostic disable: assign-type-mismatch
    default = function()
      ---|fS

      local hl = TEMPLATES.mode.default.hl
      local mode = vim.api.nvim_get_mode().mode
      local ignore = { "default", "min_width", "kind", "condition", "kind" }
      ---@type mode.opts
      local config = require("bars.utils").match(TEMPLATES.mode, mode, ignore)
      hl = config.hl or hl

      return {
        padding_left = " ",
        padding_right = " ",
        icon = "󰆤 ",
        separator = " 󰇛 ",
        hl = hl or "BarsRuler",
      }

      ---|fE
    end,

    visual = function()
      ---|fS

      local hl = TEMPLATES.mode.default.hl
      local mode = vim.api.nvim_get_mode().mode
      local ignore = { "default", "min_width", "kind", "condition", "kind" }
      ---@type mode.opts
      local config = require("bars.utils").match(TEMPLATES.mode, mode, ignore)
      hl = config.hl or hl

      return {
        padding_left = " ",
        padding_right = " ",
        icon = "󰆣 ",
        separator = " 󰇛 ",
        hl = hl or "BarsRuler",
      }

      ---|fE
    end,
    ---@diagnostic enable: assign-type-mismatch

    ---|fE
  },

  ---|fE
}

-------------------------------------------------------------------------------
-- Spacer components
-------------------------------------------------------------------------------

local spacer = {
  kind = "custom",
  value = function()
    return "%#BarsSL_ThinSep# "
  end,
}

-------------------------------------------------------------------------------
-- Style: slashed (feline replica with powerline separators)
-------------------------------------------------------------------------------

local slashed_components = {
  ---|fS "Slashed style"

  -- LEFT
  TEMPLATES.mode,
  TEMPLATES.project,
  vim.tbl_extend("force", TEMPLATES.bufname, {
    default = vim.tbl_extend("force", TEMPLATES.bufname.default, {
      hl = "BarsSL_FileInfo",
      corner_right = "",
      corner_right_hl = "BarsSL_FileInfoRightSep",
    }),
  }),
  spacer,
  TEMPLATES.file_size,
  spacer,
  TEMPLATES.cursor_position,
  spacer,
  TEMPLATES.ascii,
  spacer,
  TEMPLATES.line_count,
  { kind = "section", hl = "StatusLine" },
  TEMPLATES.diagnostics,
  TEMPLATES.macro,

  -- DIVIDER
  { kind = "empty", hl = "StatusLine" },

  -- RIGHT
  TEMPLATES.dap,
  TEMPLATES.spell,
  TEMPLATES.misc_stats,
  spacer,
  TEMPLATES.filetype,
  spacer,
  TEMPLATES.encoding,
  spacer,
  TEMPLATES.noice_mode,
  spacer,
  TEMPLATES.git_branch,
  TEMPLATES.git_diff_added,
  TEMPLATES.git_diff_changed,
  TEMPLATES.git_diff_removed,
  spacer,
  TEMPLATES.search_count,
  TEMPLATES.selection_count,
  spacer,
  TEMPLATES.line_percentage,
  spacer,
  TEMPLATES.scroll_bar,

  ---|fE
}

-------------------------------------------------------------------------------
-- Style: minimal (stripped-down, no separators)
-------------------------------------------------------------------------------

local minimal_components = {
  ---|fS "Minimal style"

  TEMPLATES.mode,
  TEMPLATES.bufname,
  { kind = "section", hl = "StatusLine" },
  TEMPLATES.diagnostics,
  TEMPLATES.macro,
  { kind = "empty", hl = "StatusLine" },
  TEMPLATES.git_branch,
  TEMPLATES.ruler,

  ---|fE
}

-------------------------------------------------------------------------------
-- Style: stealth (blends into default statusline)
-------------------------------------------------------------------------------

local stealth_components = {
  ---|fS "Stealth style"

  {
    kind = "custom",
    value = function(buffer, window)
      local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
      local map = { n = "NOR", i = "INS", v = "VIS", V = "VIS", ["\22"] = "VIS", c = "CMD", R = "REP", t = "TER" }
      return "%#StatusLine# " .. (map[mode] or mode) .. " "
    end,
  },
  {
    kind = "custom",
    value = function(buffer, window)
      local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buffer), ":t")
      if name == "" then
        name = "[No Name]"
      end
      local modified = vim.bo[buffer].modified and " [+]" or ""
      return "%#StatusLine# " .. name .. modified .. " "
    end,
  },
  { kind = "section", hl = "StatusLine" },
  TEMPLATES.diagnostics,
  { kind = "empty", hl = "StatusLine" },
  {
    kind = "custom",
    condition = is_active_win,
    value = function(buffer, window)
      local branch = vim.b[buffer].gitsigns_head or ""
      if branch == "" then
        return ""
      end
      return "%#StatusLine# " .. branch .. " "
    end,
  },
  {
    kind = "custom",
    value = function(buffer, window)
      local line, col
      vim.api.nvim_win_call(window, function()
        line = vim.fn.line(".")
        col = vim.fn.col(".")
      end)
      return "%#StatusLine# " .. line .. ":" .. col .. " "
    end,
  },

  ---|fE
}

-------------------------------------------------------------------------------
-- Style: bubble (rounded separators, elevated component backgrounds)
-------------------------------------------------------------------------------

local bubble_components = {
  ---|fS "Bubble style"

  vim.tbl_extend("force", TEMPLATES.mode, {
    default = vim.tbl_extend("force", TEMPLATES.mode.default, {
      corner_left = " ",
      corner_right = "",
      corner_left_hl = "BarsSL_BubbleModeSepL",
      corner_right_hl = "BarsSL_BubbleModeSepR",
    }),
  }),
  spacer,
  vim.tbl_extend("force", TEMPLATES.bufname, {
    default = vim.tbl_extend("force", TEMPLATES.bufname.default, {
      corner_left = "",
      corner_right = "",
      corner_left_hl = "BarsSL_BubbleBufSepL",
      corner_right_hl = "BarsSL_BubbleBufSepR",
      hl = "BarsSL_BubbleBuf",
    }),
  }),
  { kind = "section", hl = "StatusLine" },
  TEMPLATES.diagnostics,
  TEMPLATES.macro,
  { kind = "empty", hl = "StatusLine" },
  TEMPLATES.dap,
  vim.tbl_extend("force", TEMPLATES.git_branch, {
    default = vim.tbl_extend("force", TEMPLATES.git_branch.default, {
      corner_left = "",
      corner_right = "",
      corner_left_hl = "BarsSL_BubbleGitSepL",
      corner_right_hl = "BarsSL_BubbleGitSepR",
      hl = "BarsSL_BubbleGit",
    }),
  }),
  spacer,
  vim.tbl_extend("force", TEMPLATES.ruler, {
    default = function()
      return {
        padding_left = " ",
        padding_right = " ",
        icon = "󰆤 ",
        separator = ":",
        corner_left = "",
        corner_right = "",
        corner_left_hl = "BarsSL_BubbleRulerSepL",
        corner_right_hl = "BarsSL_BubbleRulerSepR",
        hl = "BarsSL_BubbleRuler",
      }
    end,
  }),

  ---|fE
}

-------------------------------------------------------------------------------
-- Style: rainbow (distinct hue per component)
-------------------------------------------------------------------------------

local rainbow_components = {
  ---|fS "Rainbow style"

  vim.tbl_extend("force", TEMPLATES.mode, {
    default = vim.tbl_extend("force", TEMPLATES.mode.default, {
      corner_left = "▊ ",
      hl = "BarsSL_RainbowMode",
    }),
    ["^n"] = { text = "Normal", hl = "BarsSL_RainbowMode" },
    ["^i$"] = { icon = " ", text = "Insert", hl = "BarsSL_RainbowInsert" },
    ["^v$"] = { icon = "󰸿 ", text = "Visual", hl = "BarsSL_RainbowVisual" },
    ["^V$"] = { icon = "󰹀 ", text = "Visual", hl = "BarsSL_RainbowVisual" },
    ["^c"] = { icon = " ", text = "Command", hl = "BarsSL_RainbowCommand" },
  }),
  spacer,
  TEMPLATES.bufname,
  spacer,
  TEMPLATES.file_size,
  spacer,
  TEMPLATES.cursor_position,
  { kind = "section", hl = "StatusLine" },
  TEMPLATES.diagnostics,
  TEMPLATES.macro,
  { kind = "empty", hl = "StatusLine" },
  {
    kind = "custom",
    condition = min_width(120),
    value = function(buffer, window)
      return "%#BarsSL_RainbowFt#" .. filetype.value(buffer, window)
    end,
  },
  spacer,
  {
    kind = "branch",
    condition = is_active_win,
    default = {
      padding_left = " ",
      padding_right = " ",
      icon = " ",
      hl = "BarsSL_RainbowGit",
    },
  },
  TEMPLATES.git_diff_added,
  TEMPLATES.git_diff_changed,
  TEMPLATES.git_diff_removed,
  spacer,
  {
    kind = "custom",
    value = function(buffer, window)
      return "%#BarsSL_RainbowPos#" .. line_percentage.value(buffer, window)
    end,
  },
  spacer,
  TEMPLATES.scroll_bar,

  ---|fE
}

-------------------------------------------------------------------------------
-- Style: pure (text-only, bold, no icons)
-------------------------------------------------------------------------------

local pure_components = {
  ---|fS "Pure style"

  {
    kind = "custom",
    value = function()
      local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
      local map = {
        n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE",
        ["\22"] = "V-BLOCK", c = "COMMAND", R = "REPLACE", t = "TERMINAL",
      }
      return "%#BarsSL_PureMode#" .. (map[mode] or mode)
    end,
  },
  spacer,
  {
    kind = "custom",
    value = function(buffer, window)
      local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buffer), ":t")
      if name == "" then
        name = "[No Name]"
      end
      local modified = vim.bo[buffer].modified and " [+]" or ""
      return "%#BarsSL_PurePath#" .. name .. modified
    end,
  },
  { kind = "section", hl = "StatusLine" },
  TEMPLATES.diagnostics,
  { kind = "empty", hl = "StatusLine" },
  {
    kind = "custom",
    condition = min_width(120),
    value = function(buffer, window)
      return "%#BarsSL_PureFt#" .. filetype.value(buffer, window)
    end,
  },
  spacer,
  {
    kind = "custom",
    condition = is_active_win,
    value = function(buffer, window)
      local branch = vim.b[buffer].gitsigns_head or ""
      if branch == "" then
        return ""
      end
      return "%#BarsSL_PureGit#" .. branch
    end,
  },
  spacer,
  {
    kind = "custom",
    value = function(buffer, window)
      return "%#BarsSL_PurePos#" .. cursor_position.value(buffer, window)
        .. " " .. line_percentage.value(buffer, window)
    end,
  },

  ---|fE
}

-------------------------------------------------------------------------------
-- Style: feline (replicates the feline.nvim statusline layout)
-------------------------------------------------------------------------------

local feline_components = {
  ---|fS "Feline style"

  -- LEFT
  TEMPLATES.mode,
  TEMPLATES.project,
  vim.tbl_extend("force", TEMPLATES.bufname, {
    default = vim.tbl_extend("force", TEMPLATES.bufname.default, {
      hl = "BarsSL_FileInfo",
      corner_right = "",
      corner_right_hl = "BarsSL_FileInfoRightSep",
    }),
  }),
  spacer,
  TEMPLATES.ascii,
  spacer,
  TEMPLATES.line_count,
  { kind = "section", hl = "StatusLine" },
  TEMPLATES.diagnostics,
  TEMPLATES.macro,

  -- DIVIDER
  { kind = "empty", hl = "StatusLine" },

  -- RIGHT
  TEMPLATES.dap,
  TEMPLATES.spell,
  TEMPLATES.misc_stats,
  spacer,
  TEMPLATES.filetype,
  spacer,
  TEMPLATES.noice_mode,
  spacer,
  TEMPLATES.git_branch,
  TEMPLATES.git_diff_added,
  TEMPLATES.git_diff_changed,
  TEMPLATES.git_diff_removed,
  spacer,
  TEMPLATES.search_count,
  TEMPLATES.selection_count,
  spacer,
  TEMPLATES.line_percentage,
  spacer,
  TEMPLATES.scroll_bar,

  ---|fE
}

-------------------------------------------------------------------------------
-- Export config table
-------------------------------------------------------------------------------

return {
  force_attach = {
    "%t%{exists('w:quickfix_title')? ' '.w:quickfix_title : ''} %=%-15(%l,%c%V%) %P",
  },

  ignore_filetypes = {},
  ignore_buftypes = {},

  default = {
    ---|fS "Default configuration (slashed)"
    components = slashed_components,
    ---|fE
  },

  minimal = {
    ---|fS "Minimal configuration"
    condition = false,
    components = minimal_components,
    ---|fE
  },

  stealth = {
    ---|fS "Stealth configuration"
    condition = false,
    components = stealth_components,
    ---|fE
  },

  bubble = {
    ---|fS "Bubble configuration"
    condition = false,
    components = bubble_components,
    ---|fE
  },

  rainbow = {
    ---|fS "Rainbow configuration"
    condition = false,
    components = rainbow_components,
    ---|fE
  },

  pure = {
    ---|fS "Pure configuration"
    condition = false,
    components = pure_components,
    ---|fE
  },

  feline = {
    ---|fS "Feline configuration (replicates feline.nvim layout)"
    condition = false,
    components = feline_components,
    highlights = function(c)
      local set = vim.api.nvim_set_hl
      -- Feline used blue fg for file info, not white-on-oceanblue.
      -- Override to match feline's default file_info style.
      set(0, "BarsSL_FelineFileInfo", { fg = c.blue, bold = true })
    end,
    ---|fE
  },

  help = {
    ---|fS "Help statusline"
    condition = function(buffer)
      return vim.bo[buffer].buftype == "help"
    end,
    components = {
      vim.tbl_extend("force", TEMPLATES.mode, { compact = true }),
      {
        kind = "ruler",
        default = {
          padding_left = " ",
          padding_right = " ",
          icon = " ",
          separator = " 󰇛 ",
          hl = "BarsFt0",
        },
      },
      { kind = "empty", hl = "StatusLine" },
      TEMPLATES.bufname,
    },
    ---|fE
  },

  quickfix = {
    ---|fS "Quickfix statusline"
    condition = function(buffer)
      return vim.bo[buffer].buftype == "quickfix"
    end,
    components = {
      {
        kind = "custom",
        value = function()
          return "%#BarsQuickfix# 󱌢 Quickfix "
        end,
      },
      { kind = "empty" },
      TEMPLATES.mode,
    },
    ---|fE
  },
}
