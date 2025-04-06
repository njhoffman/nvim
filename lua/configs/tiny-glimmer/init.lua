local glimmer = require("tiny-glimmer")
-- https://github.com/rachartier/tiny-glimmer.nvim/issues/21

local cfg = {
  disable_warnings = false,
  refresh_interval_ms = 1,
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
      enabled = true,
      on_event = { "WinEnter", "CmdlineLeave", "BufEnter" },
      default_animation = {
        name = "fade",
        settings = {
          max_duration = 1000,
          min_duration = 1000,
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
    search = {
      enabled = false,
      -- next_mapping = { lhs = "n", rhs = "'Nn'[v:searchforward].'zv'" },
      default_animation = {
        name = "pulse",
        settings = {
          from_color = "TinyGlimmerSearchFrom",
          to_color = "TinyGlimmerSearchTo",
          max_duration = 600,
          min_duration = 400,
          -- pulse_count = 2,
          -- intensity = 1.2,
        },
      },
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
      -- undo_mapping = "u",
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
      -- redo_mapping = "<c-r>",
    },
    paste = {
      enabled = true,
      -- paste_mapping = has_yanky and { lhs = "p", rhs = "<Plug>(YankyPutAfter)" } or nil,
      -- Paste_mapping = has_yanky and { lhs = "P", rhs = "<Plug>(YankyPutBefore)" } or nil,      default_animation = {
      name = "reverse_fade",
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
}

glimmer.setup(cfg)

local view_buffers = function()
  local buffers = require("tiny-glimmer.animation.factory").instance.buffers
  local empty = {}
  for bufnr, bufobj in pairs(buffers) do
    if bufobj.animations == {} and bufobj.named_animations == {} then
      table.insert(empty, bufnr)
    else
      vim.dbglog(bufnr, bufobj)
    end
  end
  vim.dbglog(empty)
end

local namespace = require("tiny-glimmer.namespace").tiny_glimmer_animation_ns
local animation = require("tiny-glimmer.glimmer_animation")
local orig_cleanup = vim.fn.deepcopy(animation.cleanup)
animation.cleanup = function(self)
  -- self.active = false
  if not vim.api.nvim_buf_is_valid(self.buffer) or not vim.api.nvim_buf_is_loaded(self.buffer) then
    vim.dbglog("buffer not valid", self.buffer)
    vim.api.nvim_buf_clear_namespace(0, namespace, self.range.start_line, self.range.end_line + 1)
    self.reserved_ids = {}
  end

  for _, id in ipairs(self.reserved_ids) do
    vim.api.nvim_buf_del_extmark(self.buffer, namespace, id)
  end

  orig_cleanup(self)
end

-- require('tiny-glimmer').enable()  -- Enable animations
-- require('tiny-glimmer').disable() -- Disable animations
-- require('tiny-glimmer').toggle()  -- Toggle animations
-- -- require('tiny-glimmer').change_hl('fade', { from_color = '#FF0000', to_color = '#0000FF' })
-- -- require('tiny-glimmer').change_hl('all', { from_color = '#FF0000', to_color = '#0000FF' })
-- -- require('tiny-glimmer').change_hl({'fade', 'pulse'}, { from_color = '#FF0000', to_color = '#0000FF' })
-- require('tiny-glimmer').change_hl(animation_name, hl)

-- -- When overwrite.search.enabled is true
-- require('tiny-glimmer').search_next() -- Same as `n`
-- require('tiny-glimmer').search_prev() -- Same as `N`
-- require('tiny-glimmer').search_under_cursor() -- Same as `*`

-- -- When overwrite.paste.enabled is true
-- require('tiny-glimmer').paste() -- Same as `p`
-- require('tiny-glimmer').Paste() -- Same as `P`

-- -- Undo operations (requires undo.enabled = true)
-- require('tiny-glimmer').undo()   -- Undo changes
-- require('tiny-glimmer').redo()   -- Redo changes
