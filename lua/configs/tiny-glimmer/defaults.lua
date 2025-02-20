local utils = require("tiny-glimmer.utils")
local hl_visual_bg = utils.int_to_hex(utils.get_highlight("Visual").bg)
local hl_normal_bg = utils.int_to_hex(utils.get_highlight("Normal").bg)

local keymaps = {
  "rachartier/tiny-glimmer.nvim",
  event = "VeryLazy",
  keys = {
    {
      "n",
      function()
        require("tiny-glimmer").search_next()
      end,
      { noremap = true, silent = true },
    },
    {
      "N",
      function()
        require("tiny-glimmer").search_prev()
      end,
      { noremap = true, silent = true },
    },
    {
      "p",
      function()
        require("tiny-glimmer").paste()
      end,
      { noremap = true, silent = true },
    },
    {
      "P",
      function()
        require("tiny-glimmer").Paste()
      end,
      { noremap = true, silent = true },
    },
    {
      "*",
      function()
        require("tiny-glimmer").search_under_cursor()
      end,
      { noremap = true, silent = true },
    },
  },
  opts = {},
}

local defaults = {
  enabled = true,
  disable_warnings = true,

  overwrite = {
    auto_map = true,
    search = {
      enabled = false,
      default_animation = "pulse",

      next_mapping = "nzzzv",
      prev_mapping = "Nzzzv",
    },
    paste = {
      enabled = true,
      default_animation = "reverse_fade",

      paste_mapping = "p",
      Paste_mapping = "P",
    },
    undo = {
      enabled = false,

      default_animation = {
        name = "fade",

        settings = {
          from_color = "DiffDelete",

          max_duration = 500,
          min_duration = 500,
        },
      },
      undo_mapping = "u",
    },
    redo = {
      enabled = false,

      default_animation = {
        name = "fade",

        settings = {
          from_color = "DiffAdd",

          max_duration = 500,
          min_duration = 500,
        },
      },

      redo_mapping = "<c-r>",
    },
  },

  support = {
    substitute = {
      enabled = false,
      default_animation = "fade",
    },
  },

  presets = {
    pulsar = {
      enabled = false,

      on_event = { "WinEnter", "CmdlineLeave", "BufEnter" },
      default_animation = {
        name = "fade",

        settings = {
          max_duration = 1000,
          min_duration = 1000,

          from_color = "DiffDelete",
          to_color = "Normal",
        },
      },
    },
  },
  default_animation = "fade",
  refresh_interval_ms = 6,
  transparency_color = nil,
  animations = {
    fade = {
      max_duration = 400,
      min_duration = 300,
      easing = "outQuad",
      chars_for_max_duration = 10,
      from_color = hl_visual_bg,
      to_color = hl_normal_bg,
    },
    reverse_fade = {
      max_duration = 380,
      min_duration = 300,
      easing = "outBack",
      chars_for_max_duration = 10,
      from_color = hl_visual_bg,
      to_color = hl_normal_bg,
    },
    bounce = {
      max_duration = 500,
      min_duration = 400,
      chars_for_max_duration = 20,
      oscillation_count = 1,
      from_color = hl_visual_bg,
      to_color = hl_normal_bg,
    },
    left_to_right = {
      max_duration = 350,
      min_duration = 350,
      min_progress = 0.85,
      chars_for_max_duration = 25,
      lingering_time = 50,
      from_color = hl_visual_bg,
      to_color = hl_normal_bg,
    },
    pulse = {
      max_duration = 600,
      min_duration = 400,
      chars_for_max_duration = 15,
      pulse_count = 2,
      intensity = 1.2,
      from_color = hl_visual_bg,
      to_color = hl_normal_bg,
    },
    rainbow = {
      max_duration = 600,
      min_duration = 350,
      chars_for_max_duration = 20,
    },
    custom = {
      max_duration = 350,
      min_duration = 200,
      chars_for_max_duration = 40,
      color = hl_visual_bg,

      --- Custom effect function
      --- @param self table The effect object
      --- @param progress number The progress of the animation [0, 1]
      ---
      --- Should return a color and a progress value
      --- that represents how much of the animation should be drawn
      effect = function(self, progress)
        return self.settings.color, progress
      end,
    },
  },
  virt_text = {
    priority = 2048,
  },
}
