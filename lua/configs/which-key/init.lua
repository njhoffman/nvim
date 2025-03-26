-- -- Show hydra mode for changing windows
-- require("which-key").show({
-- keys = "<c-w>",
-- loop = true, -- this will keep the popup open until you hit <esc>
-- })

local cfg = {
  debug = false, -- enable wk.log in the current directory
  preset = "modern", -- classic, modern, helix
  triggers = {
    { "<leader>", mode = { "n", "v" } },
    -- { "<auto>", mode = "nixsotc" },
  },
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
