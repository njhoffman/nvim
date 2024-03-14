if vim.g.neovide then
  vim.opt.guifont = 'DejaVuSansMono Nerd Font:h8' -- text below applies for VimScript
  -- vim.opt.guifont = { "Font name", ":size" }

  -- desktop
  -- vim.g.neovide_scale_factor=1.0
  --  laptop
  vim.g.neovide_scale_factor = 0.8

  -- vim.opt.linespace = 0
  -- vim.g.neovide_padding_top = 0
  -- vim.g.neovide_padding_bottom = 0
  -- vim.g.neovide_padding_right = 0
  -- vim.g.neovide_padding_left = 0

  -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
  -- vim.g.neovide_transparency = 0.0
  -- vim.g.transparency = 0.0

  -- Helper function for transparency formatting
  local alpha = function()
    return string.format('%x', math.floor(255 * vim.g.transparency or 0.8))
  end

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
  --
  vim.g.neovide_underline_stroke_scale = 1.0
  vim.g.neovide_profiler = false
  vim.g.neovide_cursor_animation_length = 0.13
  vim.g.neovide_cursor_trail_size = 0.8
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_animate_in_insert_mode = true
  vim.g.neovide_cursor_animate_command_line = true
  vim.g.neovide_cursor_unfocused_outline_width = 0.125
  vim.g.neovide_cursor_vfx_mode = '' -- railgun, torpedo, pixiedust, sonicboom, ripple, wireframe
  vim.g.neovide_cursor_vfx_opacity = 200.0
  vim.g.neovide_cursor_vfx_particle_lifetime = 1.2
  vim.g.neovide_cursor_vfx_particle_density = 7.0
  vim.g.neovide_cursor_vfx_particle_phase = 1.5
  vim.g.neovide_cursor_vfx_particle_curl = 1.0
  vim.g.neovide_cursor_vfx_particle_speed = 10.0
end

-- if vim.g.neovide == true then
--   vim.api.nvim_set_keymap(
--     'n',
--     '<C-=>',
--     ':lua vim.g.neovide_scale_factor = math.min(vim.g.neovide_scale_factor + 0.1,  1.0)<CR>',
--     { silent = true }
--   )
--   vim.api.nvim_set_keymap(
--     'n',
--     '<C-->',
--     ':lua vim.g.neovide_scale_factor = math.max(vim.g.neovide_scale_factor - 0.1,  0.1)<CR>',
--     { silent = true }
--   )
--   vim.api.nvim_set_keymap(
--     'n',
--     '<C-+>',
--     ':lua vim.g.neovide_transparency = math.min(vim.g.neovide_transparency + 0.05, 1.0)<CR>',
--     { silent = true }
--   )
--   vim.api.nvim_set_keymap(
--     'n',
--     '<C-_>',
--     ':lua vim.g.neovide_transparency = math.max(vim.g.neovide_transparency - 0.05, 0.0)<CR>',
--     { silent = true }
--   )
--   vim.api.nvim_set_keymap(
--     'n',
--     '<C-0>',
--     ':lua vim.g.neovide_scale_factor = 0.5<CR>',
--     { silent = true }
--   )
--   vim.api.nvim_set_keymap(
--     'n',
--     '<C-)>',
--     ':lua vim.g.neovide_transparency = 0.9<CR>',
--     { silent = true }
--   )
-- end
-- vim.g.gui_font_default_size = 12
-- vim.g.gui_font_size = vim.g.gui_font_default_size
-- vim.g.gui_font_face = 'Fira Code Retina'
--
-- RefreshGuiFont = function()
--   vim.opt.guifont = string.format('%s:h%s', vim.g.gui_font_face, vim.g.gui_font_size)
-- end
--
-- ResizeGuiFont = function(delta)
--   vim.g.gui_font_size = vim.g.gui_font_size + delta
--   RefreshGuiFont()
-- end
--
-- ResetGuiFont = function()
--   vim.g.gui_font_size = vim.g.gui_font_default_size
--   RefreshGuiFont()
-- end
--
-- -- Call function on startup to set default value
-- ResetGuiFont()
--
-- -- Keymaps
--
-- local opts = { noremap = true, silent = true }
--
-- vim.keymap.set({ 'n', 'i' }, '<C-+>', function()
--   ResizeGuiFont(1)
-- end, opts)
-- vim.keymap.set({ 'n', 'i' }, '<C-->', function()
--   ResizeGuiFont(-1)
-- end, opts)
-- vim.keymap.set({ 'n', 'i' }, '<C-BS>', function()
--   ResetGuiFont()
-- end, opts)
