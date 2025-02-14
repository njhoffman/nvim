local glimmer = require("tiny-glimmer")

-- default_animation = "fade",
-- refresh_interval_ms = 6,

local cfg = {
  -- transparency_color = "#000000",
  -- transparency_color = nil,
  default_animation = "fade",
  presets = {
    pulsar = {
      enabled = true,
      on_event = { "WinEnter", "CmdlineLeave", "BufEnter" },
      default_animation = {
        name = "fade",
        settings = {
          max_duration = 1000,
          min_duration = 1000,
          from_color = "TinyGlimmerPulsarFrom",
          to_color = "TinyGlimmerPulsarTo",
          -- from_color = "Visual",
          -- to_color = "Normal",
          -- from_color = "DiffDelete",
          -- to_color = "Normal",
        },
      },
    },
  },
  {
    support = {
      substitute = {
        enabled = true,
        default_animation = {
          name = "fade",
          -- default_animation = "left_to_right",
          from_color = "TinyGlimmerSubFrom",
          to_color = "TinyGlimmerSubTo",
        },
      },
    },
  },
  overwrite = {
    search = {
      enabled = true,
      default_animation = "pulse",
      from_color = "TinyGlimmerSearchFrom",
      to_color = "TinyGlimmerSearchTo",
      max_duration = 600,
      min_duration = 400,
      chars_for_max_duration = 15,
      pulse_count = 2,
      intensity = 1.2,
    },
    undo = {
      enabled = true,
      default_animation = {
        name = "fade",
        settings = {
          from_color = "TinyGlimmerDelete",
          max_duration = 500,
          min_duration = 500,
        },
      },
      undo_mapping = "u",
    },
    redo = {
      enabled = true,
      default_animation = {
        name = "fade",
        settings = {
          from_color = "TinyGlimmerAdd",
          max_duration = 500,
          min_duration = 500,
        },
      },
      redo_mapping = "<c-r>",
    },
    paste = {
      enabled = true,
      default_animation = {
        name = "reverse_fade",
        settings = {
          easing = "outBack",
          chars_for_max_duration = 10,
          max_duration = 400,
          min_duration = 300,
          from_color = "TinyGlimmerPasteFrom",
          to_color = "TinyGlimmerPasteTo",
        },
      },
    },
  },
}

glimmer.setup(cfg)

local factory = require("tiny-glimmer.animation.factory")

local _manage_animation = factory._manage_animation
-- AnimationFactory:_manage_animation(animation_obj, buffer)
local namespace = require("tiny-glimmer.namespace")

local manage_animation = function(self, animation_obj, buffer)
  if not vim.api.nvim_buf_is_valid(buffer) then
    vim.dbglog("closing buffer", buffer, self.buffers)
    vim.api.nvim_buf_clear_namespace(0, namespace.tiny_glimmer_animation_ns, 0, -1)
    self.buffers[buffer] = nil
    vim.dbglog(self.buffers)
    -- self.buffers[buffer].animations[line_key]:stop()
  else
    _manage_animation(self, animation_obj, buffer)
  end
end

factory._manage_animation = manage_animation
