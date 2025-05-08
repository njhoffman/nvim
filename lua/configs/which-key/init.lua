-- -- Show hydra mode for changing windows
-- require("which-key").show({
-- keys = "<c-w>",
-- loop = true, -- this will keep the popup open until you hit <esc>
-- })

local cfg = {
  debug = false, -- enable wk.log in the current directory
  presets = {
    operators = true, -- adds help for operators like d, y, ...
    motions = true, -- adds help for motions
    text_objects = true, -- help for text objects triggered after entering an operator
    windows = true, -- default bindings on <c-w>
    nav = true, -- misc bindings to work with windows
    z = true, -- bindings for folds, spelling and others prefixed with z
    g = true, -- bindings for prefixed with g
  },
  preset = "helix", -- classic, modern, helix
  delay = function(ctx)
    return ctx.plugin and 0 or 200
  end,
  triggers = {
    { "<leader>", mode = { "n", "v" } },
    -- { "<auto>", mode = "nxso" },
    -- { "<auto>", mode = "nixsotc" },
  },
  -- Start hidden and wait for a key to be pressed before showing the popup
  -- Only used by enabled xo mapping modes.
  ---@param ctx { mode: string, operator: string }
  defer = function(ctx)
    return ctx.mode == "V" or ctx.mode == "<C-V>"
  end,
  keys = {
    scroll_down = "<C-f>", -- binding to scroll down inside the popup
    scroll_up = "<C-b>", -- binding to scroll up inside the popup
  },
  win = {
    no_overlap = true,
    -- width = 1,
    -- height = { min = 4, max = 25 },
    -- col = 0,
    -- row = math.huge,
    -- border = "none",
    padding = { 0, 1 }, -- extra window padding [top/bottom, right/left]
    title = true,
    title_pos = "center",
    zindex = 1000,
    bo = {},
    wo = {
      winblend = 10,
    },
  },
  sort = {
    function(item)
      return item.group and 0 or 1
    end,
  },
  expand = 1, -- expand groups when <= n mappings
  replace = {
    key = {
      function(key)
        return require("which-key.view").format(key)
      end,
      -- { "<Space>", "SPC" },
    },
    desc = {
      { "<Plug>%(?(.*)%)?", "%1" },
      { "^%+", "" },
      { "<[cC]md>", "" },
      { "<[cC][rR]>", "" },
      { "<[sS]ilent>", "" },
      { "^lua%s+", "" },
      { "^call%s+", "" },
      { "^:%s*", "" },
    },
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
    ellipsis = "…",
    -- set to false to disable all mapping icons,
    -- both those explicitly added in a mapping
    -- and those from rules
    mappings = true,
    --- See `lua/which-key/icons.lua` for more details
    --- Set to `false` to disable keymap icons from rules
    ---@type wk.IconRule[]|false
    rules = {},
    -- use the highlights from mini.icons
    -- When `false`, it will use `WhichKeyIcon` instead
    colors = true,
    -- used by key format
    keys = {
      Up = " ",
      Down = " ",
      Left = " ",
      Right = " ",
      C = "󰘴 ",
      M = "󰘵 ",
      D = "󰘳 ",
      S = "󰘶 ",
      CR = "󰌑 ",
      Esc = "󱊷 ",
      ScrollWheelDown = "󱕐 ",
      ScrollWheelUp = "󱕑 ",
      NL = "󰌑 ",
      BS = "󰁮",
      Space = "󱁐 ",
      Tab = "󰌒 ",
      F1 = "󱊫",
      F2 = "󱊬",
      F3 = "󱊭",
      F4 = "󱊮",
      F5 = "󱊯",
      F6 = "󱊰",
      F7 = "󱊱",
      F8 = "󱊲",
      F9 = "󱊳",
      F10 = "󱊴",
      F11 = "󱊵",
      F12 = "󱊶",
    },
  },
  -- expand = function(node)
  --   return not node.desc -- expand all nodes without a description
  -- end,
  -- delay = function(ctx)
  --   return ctx.plugin and 0 or 200
  -- end,
  -- defer = function(ctx)
  --   return ctx.mode == "V" or ctx.mode == "<C-V>"
  -- end,
  -- filter = function(mapping)
  --   return true
  -- end,
}

require("which-key").setup(cfg)
