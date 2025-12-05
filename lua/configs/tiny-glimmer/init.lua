local glimmer = require("tiny-glimmer")
-- https://github.com/rachartier/tiny-glimmer.nvim/issues/21

local cfg = {
  disable_warnings = false,
  refresh_interval_ms = 5,
  -- transparency_color = nil,
  transparency_color = "#000000",
  default_animation = {
    name = "fade",
    settings = {
      max_duration = 1000,
      min_duration = 1000,
      from_color = "DiffDelete",
      -- to_color = "Normal",
    },
  },
  presets = {
    pulsar = {
      enabled = false,
      -- on_event = { "WinEnter", "CmdlineLeave", "BufEnter" },
      on_events = {
        -- "CursorMoved",
        "CmdlineEnter",
        -- "WinEnter",
      },
      default_animation = {
        name = "fade",
        settings = {
          max_duration = 700,
          min_duration = 700,
          -- from_color = "TinyGlimmerPulsarFrom",
          -- to_color = "TinyGlimmerPulsarTo",
          from_color = "VisualAlt",
          -- to_color = "Normal",
          -- from_color = "DiffDelete",
          -- to_color = "Normal",
        },
      },
    },
  },
  support = {
    substitute = {
      enabled = true,
      default_animation = {
        name = "left_to_right",
        --   -- name = "bounce",
        settings = {
          -- max_duration = 350,
          -- min_duration = 350,
          -- min_progress = 0.85,
          -- chars_for_max_duration = 25,
          -- lingering_time = 50,
          max_duration = 600,
          min_duration = 600,
          lingering_time = 200,
          from_color = "TinyGlimmerSubFrom",
          -- to_color = "TinyGlimmerSubTo",
        },
      },
    },
  },
  overwrite = {
    auto_map = true,
    search = {
      enabled = false,
      -- next_mapping = { lhs = "n", rhs = "'Nn'[v:searchforward].'zv'" },
      -- -- Keys to navigate to the next match
      --  next_mapping = "n",
      --  -- Keys to navigate to the previous match
      --  prev_mapping = "N",
      default_animation = {
        name = "pulse",
        settings = {
          from_color = "TinyGlimmerSearchFrom",
          -- to_color = "TinyGlimmerSearchTo",
          max_duration = 600,
          min_duration = 400,
          -- pulse_count = 2,
          -- intensity = 1.2,
        },
      },
    },
    undo = {
      enabled = true,
      -- undo_mapping = "u",
      default_animation = {
        name = "fade",
        settings = {
          from_color = "TinyGlimmerDelete",
          max_duration = 500,
          min_duration = 500,
        },
      },
    },
    redo = {
      enabled = true,
      -- redo_mapping = "<c-r>",
      default_animation = {
        name = "fade",
        settings = {
          from_color = "TinyGlimmerAdd",
          max_duration = 500,
          min_duration = 500,
        },
      },
    },
    paste = {
      -- TODO: enable for other paste keys
      enabled = true,
      -- paste_mapping = has_yanky and { lhs = "p", rhs = "<Plug>(YankyPutAfter)" } or nil,
      -- Paste_mapping = has_yanky and { lhs = "P", rhs = "<Plug>(YankyPutBefore)" } or nil,      default_animation = {
      name = "reverse_fade",
      -- -- Keys to paste
      -- paste_mapping = "p",
      -- -- Keys to paste above the cursor
      -- Paste_mapping = "P",

      settings = {
        easing = "outBack",
        chars_for_max_duration = 10,
        max_duration = 400,
        min_duration = 300,
        from_color = "TinyGlimmerPasteFrom",
        -- to_color = "TinyGlimmerPasteTo",
      },
    },
    yank = {
      enabled = true,
      default_animation = {
        -- name = "bounce",
        name = "pulse",
        settings = {
          max_duration = 400,
          min_duration = 200,
          chars_for_max_duration = 15,
          pulse_count = 2,
          intensity = 0.8,
          from_color = "TinyGlimmerYankFrom",
          -- to_color = "TinyGlimmerYankTo",
        },
      },
    },
  },
  virt_text = {
    priority = 2048,
  },
  hijack_ft_disabled = {
    "alpha",
    "snacks_dashboard",
    "snacks_picker_input",
  },
}

glimmer.setup(cfg)
require("configs.tiny-glimmer.autocmds").setup()

-- Animate search results
-- vim.keymap.set("n", "n", function()
--   vim.cmd("normal! n")
--   local pos = vim.api.nvim_win_get_cursor(0)
--   glimmer.create_animation({
--     range = glimmer.get_cursor_range(),
--     duration = 400,
--     from_color = "IncSearch",
--     to_color = "Normal",
--     effect = "pulse",
--   })
-- end)
