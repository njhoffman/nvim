if vim.g.neovide then
  -- vim.opt.linespace = 0
  -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
  -- vim.g.neovide_transparency = 0.0
  -- vim.g.transparency = 0.0

  -- Helper function for transparency formatting
  -- local alpha = function()
  --   return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
  -- end

  -- let g:neovide_transparency=0.7
  -- function! ChangeTransparency(delta)
  --   let g:neovide_transparency = g:neovide_transparency + a:delta
  --   endfunction
  --   noremap <expr><D-]> ChangeTransparency(0.1)
  --   noremap <expr><D-[> ChangeTransparency(-0.1)
  -- -- vim.g.neovide_fullscreen = true
  -- vim.g.neovide_background_color = '#0f1117' .. alpha()
  -- --
  -- vim.g.neovide_floating_blur_amount_x = 2.0
  -- vim.g.neovide_floating_shadow = true
  -- vim.g.neovide_floating_z_height = 10
  -- vim.g.neovide_light_angle_degrees = 45
  -- vim.g.neovide_light_radius = 5
  local scale_factor = 0.8
  vim.g.neovide_padding_top = 1
  vim.g.neovide_padding_bottom = 1
  vim.g.neovide_padding_right = 1
  vim.g.neovide_padding_left = 1

  vim.g.neovide_underline_stroke_scale = 1.0
  vim.g.neovide_floating_blur_amount_x = 5.0
  vim.g.neovide_floating_blur_amount_y = 5.0
  vim.g.neovide_floating_corner_radius = 0.5
  vim.g.neovide_floating_shadow = false
  vim.g.neovide_input_use_logo = true
  vim.g.neovide_no_idle = true
  vim.g.neovide_opacity = 100
  vim.g.neovide_profiler = false
  vim.g.neovide_scale_factor = scale_factor
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_refresh_rate = 75
  vim.g.neovide_scroll_animation_length = 0.06
  vim.g.neovide_theme = "dark"
  -- vim.g.neovide_input_macos_option_key_is_meta = 'only_left'

  vim.g.neovide_cursor_animation_length = 0.08
  vim.g.neovide_cursor_trail_size = 0.8
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_animate_in_insert_mode = true
  vim.g.neovide_cursor_animate_command_line = true
  vim.g.neovide_cursor_unfocused_outline_width = 0.125
  vim.g.neovide_cursor_vfx_mode = "" -- railgun, torpedo, pixiedust, sonicboom, ripple, wireframe
  vim.g.neovide_cursor_vfx_opacity = 200.0
  vim.g.neovide_cursor_vfx_particle_lifetime = 1.2
  vim.g.neovide_cursor_vfx_particle_density = 7.0
  vim.g.neovide_cursor_vfx_particle_phase = 1.5
  vim.g.neovide_cursor_vfx_particle_curl = 1.0
  vim.g.neovide_cursor_vfx_particle_speed = 10.0

  vim.g.gui_font_default_size = 8

  local font = {
    -- family = "JetBrainsMono Nerd Font Mono",
    -- family = "SauceCodePro Nerd Font Mono",
    family = "Maple Mono NF",
    size = 10,
    width = 0,
  }

  function font:sync(self)
    vim.o.guifont = string.format(
      "%s" .. ":h%s" .. ":w%s" .. "%s",
      font.family,
      font.size, -- :h (height)
      font.width, -- :w (width)
      ""
    )
    vim.o.linespace = self.linespace or 0
  end

  vim.defer_fn(function()
    vim.cmd("hi Normal guibg=#02000a")
  end, 5000)

  -- font:sync()

  -- vim.o.guifont = { "Maple Mono NF:h10" }
  -- vim.g.gui_font_face = "Fira Code Retina"
  -- family = "JetBrainsMono Nerd Font Mono", linespace = -3, size = 16, width = -2,  -- letter spacing: neovide/neovide#1227
  -- vim.opt.guifont = "FiraCode Nerd Font:h8" -- text below applies for VimScript
  vim.opt.guifont = "Hack Nerd Font Mono:h8" -- text below applies for VimScript
  -- vim.opt.guifont = "DejaVuSansMono Nerd Font:h12" -- text below applies for VimScript
  -- vim.opt.guifont = 'DejaVuSansMono Nerd Font:h10' -- text below applies for VimScript
  -- vim.opt.guifont = { "Font name", ":size" }

  -- RefreshGuiFont = function()
  --   vim.opt.guifont = string.format("%s:h%s", vim.g.gui_font_face, vim.g.gui_font_size)
  -- end

  -- Hack
  --
  -- ResizeGuiFont = function(delta)
  --   vim.g.gui_font_size = vim.g.gui_font_size + delta
  --   RefreshGuiFont()
  -- end
  --
  local map = require("mapper").map

  map("n", "<C-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.05<CR>", { nowait = true })
  map("n", "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.05<CR>", { nowait = true })
  map("n", "<C-0>", ":lua vim.g.neovide_scale_factor = " .. scale_factor .. "<CR>", { nowait = true })

  map("v", "<C-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.05<CR>", { nowait = true })
  map("v", "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.05<CR>", { nowait = true })
  map("v", "<C-0>", ":lua vim.g.neovide_scale_factor = " .. scale_factor .. "<CR>")

  -- vim.api.nvim_set_keymap("n", "<C-=>", ":lua vim.g.neovide_scale_factor = math.min(vim.g.neovide_scale_factor + 0.1,  1.0)<CR>", { silent = true })
  -- vim.api.nvim_set_keymap("n", "<C-->", ":lua vim.g.neovide_scale_factor = math.max(vim.g.neovide_scale_factor - 0.1,  0.1)<CR>", { silent = true })
  -- vim.api.nvim_set_keymap("n", "<C-+>", ":lua vim.g.neovide_transparency = math.min(vim.g.neovide_transparency + 0.05, 1.0)<CR>", { silent = true })
  -- vim.api.nvim_set_keymap("n", "<C-_>", ":lua vim.g.neovide_transparency = math.max(vim.g.neovide_transparency - 0.05, 0.0)<CR>", { silent = true })
  -- vim.api.nvim_set_keymap("n", "<C-0>", ":lua vim.g.neovide_scale_factor = 0.5<CR>", { silent = true })
  -- vim.api.nvim_set_keymap("n", "<C-)>", ":lua vim.g.neovide_transparency = 0.9<CR>", { silent = true })
end
