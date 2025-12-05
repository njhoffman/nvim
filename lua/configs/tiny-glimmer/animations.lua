local animations = {
  simple_fade = {
    max_duration = 1000,
    chars_for_max_duration = 20,
    start_color = { r = 255, g = 0, b = 0 },
    end_color = { r = 0, g = 0, b = 255 },
    efect = function(self, progress, ease)
      local start = self.settings.start_color
      local finish = self.settings.end_color
      local r = math.floor(start.r + (finish.r - start.r) * progress)
      local g = math.floor(start.g + (finish.g - start.g) * progress)
      local b = math.floor(start.b + (finish.b - start.b) * progress)
      return string.format("#%02x%02x%02x", r, g, b), progress
    end,
  },
  breathing = {
    max_duration = 2000,
    chars_for_max_duration = 20,
    base_color = "#4EC9B0",
    effect = function(self, progress, ease)
      local oscillation = (math.sin(progress * math.pi * 2) + 1) / 2
      local brightness = math.floor(oscillation * 255)
      local color = string.format("#%02x%02x%02x", brightness, brightness, brightness)
      return color, progress
    end,
  },
  wave = {
    max_duration = 1000,
    chars_for_max_duration = 30,
    wave_color = "#FF6B6B",
    builder = function(self)
      return { wave_width = 0.2 }
    end,
    effect = function(self, progress, ease)
      local wave_pos = progress
      local wave_width = self.starter.wave_width
      local intensity = 0
      if progress >= wave_pos - wave_width and progress <= wave_pos + wave_width then
        local distance = math.abs(progress - wave_pos) / wave_width
        intensity = 1 - distance
      end
      local r = math.floor(255 * intensity)
      local g = math.floor(107 * intensity)
      local b = math.floor(107 * intensity)
      return string.format("#%02x%02x%02x", r, g, b), progress
    end,
  },
  gradient = {

    max_duration = 800,
    chars_for_max_duration = 20,
    colors = {
      { r = 255, g = 0, b = 0 },
      { r = 255, g = 255, b = 0 },
      { r = 0, g = 255, b = 0 },
      { r = 0, g = 0, b = 255 },
    },
    effect = function(self, progress, ease)
      local colors = self.settings.colors
      local segment_count = #colors - 1
      local segment = math.floor(progress * segment_count)
      segment = math.min(segment, segment_count - 1)
      local local_progress = (progress * segment_count) - segment
      local start = colors[segment + 1]
      local finish = colors[segment + 2]
      local r = math.floor(start.r + (finish.r - start.r) * local_progress)
      local g = math.floor(start.g + (finish.g - start.g) * local_progress)
      local b = math.floor(start.b + (finish.b - start.b) * local_progress)
      return string.format("#%02x%02x%02x", r, g, b), progress
    end,
  },

  sparkle = {
    max_duration = 1500,
    chars_for_max_duration = 25,
    base_color = { r = 255, g = 215, b = 0 },
    builder = function(self)
      math.randomseed(os.time())
      return { seed = math.random(1, 1000) }
    end,
    effect = function(self, progress, ease)
      local base = self.settings.base_color
      local sparkle = ((progress * 1000 + self.starter.seed) % 10) / 10
      local intensity = 0.5 + sparkle * 0.5
      local r = math.floor(base.r * intensity)
      local g = math.floor(base.g * intensity)
      local b = math.floor(base.b * intensity)
      return string.format("#%02x%02x%02x", r, g, b), progress
    end,
  },
  --
  -- Neon glow effect with pulsing intensity
  neon_glow = {
    max_duration = 800,
    chars_for_max_duration = 20,
    base_color = "#00FF00",
    intensity = 1.5,
    effect = function(self, progress, _ease)
      local hex = self.settings.base_color:gsub("#", "")
      local r = tonumber(hex:sub(1, 2), 16)
      local g = tonumber(hex:sub(3, 4), 16)
      local b = tonumber(hex:sub(5, 6), 16)
      local pulse = math.sin(progress * math.pi)
      local intensity = self.settings.intensity * pulse
      local glow_r = math.min(255, math.floor(r * intensity))
      local glow_g = math.min(255, math.floor(g * intensity))
      local glow_b = math.min(255, math.floor(b * intensity))
      return string.format("#%02x%02x%02x", glow_r, glow_g, glow_b), progress
    end,
  },
  -- Typewriter effect with color transition
  -- Uses builder to pre-parse colors once
  typewriter = {
    max_duration = 1200,
    chars_for_max_duration = 30,
    from_color = "#888888",
    to_color = "#FFFFFF",
    builder = function(self)
      local function hex_to_rgb(hex)
        local h = hex:gsub("#", "")
        return {
          r = tonumber(h:sub(1, 2), 16),
          g = tonumber(h:sub(3, 4), 16),
          b = tonumber(h:sub(5, 6), 16),
        }
      end
      return {
        initial = hex_to_rgb(self.settings.from_color),
        final = hex_to_rgb(self.settings.to_color),
      }
    end,
    effect = function(self, progress, _ease)
      local start = self.starter.initial
      local finish = self.starter.final
      local r = math.floor(start.r + (finish.r - start.r) * progress)
      local g = math.floor(start.g + (finish.g - start.g) * progress)
      local b = math.floor(start.b + (finish.b - start.b) * progress)
      return string.format("#%02x%02x%02x", r, g, b), progress
    end,
  },
  -- Fire effect with gradient and flicker
  fire = {
    max_duration = 1000,
    chars_for_max_duration = 25,
    effect = function(_self, progress, _ease)
      local colors = {
        { r = 255, g = 255, b = 100 },
        { r = 255, g = 150, b = 0 },
        { r = 255, g = 50, b = 0 },
        { r = 100, g = 0, b = 0 },
      }
      local flicker = (math.sin(progress * 50) + 1) / 2 * 0.2
      local segment_count = #colors - 1
      local segment = math.floor(progress * segment_count)
      segment = math.min(segment, segment_count - 1)
      local local_progress = (progress * segment_count) - segment + flicker
      local_progress = math.max(0, math.min(1, local_progress))
      local start = colors[segment + 1]
      local finish = colors[segment + 2]
      local r = math.floor(start.r + (finish.r - start.r) * local_progress)
      local g = math.floor(start.g + (finish.g - start.g) * local_progress)
      local b = math.floor(start.b + (finish.b - start.b) * local_progress)
      return string.format("#%02x%02x%02x", r, g, b), progress
    end,
  },
  matrix = {
    max_duration = 1500,
    chars_for_max_duration = 40,
    effect = function(_self, progress)
      local green_intensity = math.floor(255 * (1 - progress))
      return string.format("#00%02x00", green_intensity), progress
    end,
  },
  glitch = {
    max_duration = 600,
    chars_for_max_duration = 20,
    effect = function(_self, progress)
      local glitch_value = math.floor(progress * 100) % 3
      if glitch_value == 0 then
        return "#FF00FF", progress
      elseif glitch_value == 1 then
        return "#00FFFF", progress
      else
        return "#FFFF00", progress
      end
    end,
  },
  ocean = {
    max_duration = 2000,
    chars_for_max_duration = 50,
    effect = function(_self, progress)
      local wave = (math.sin(progress * math.pi * 4) + 1) / 2
      local blue = math.floor(100 + wave * 155)
      local green = math.floor(150 + wave * 105)
      return string.format("#00%02x%02x", green, blue), progress
    end,
  },
}

-- -- Use registered custom effects with helper functions
-- vim.keymap.set("n", "<leader>agn", function()
--   glimmer.cursor_line("neon_glow")
-- end, { desc = "Animate cursor line with neon glow effect" })

-- Auto-generate keymaps for all effects
-- for effect_name, _ in pairs(custom_effects) do
--   vim.keymap.set("n", "<leader>ae" .. effect_name:sub(1, 1), function()
--     glimmer.cursor_line(effect_name)
--   end, { desc = "Animate with " .. effect_name .. " effect" })
-- end
