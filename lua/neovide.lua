if vim.g.neovide then
  -- vim.opt.guifont = 'DejaVuSansMono Nerd Font:h10' -- text below applies for VimScript
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
  -- vim.opt.guifont = 'DejaVuSansMono Nerd Font:h10' -- text below applies for VimScript

  -- map.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
  -- map.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
  -- map.set({ "n" , "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
  -- local function neovideScale(amount)
  --   local temp = vim.g.neovide_scale_factor + amount
  --   if temp < 0.5 then
  --     return
  --   end
  --   vim.g.neovide_scale_factor = temp
  -- end

  -- map("n", "<C-=>", function()
  --   neovideScale(0.1)
  -- end)

  -- map("n", "<C-->", function()
  --   neovideScale(-0.1)
  -- end)
  vim.cmd([[

  let s:guifontsize=10
  let s:guifont="Fira\\ Code\\ SemiBold"
  " set guifont=Fira\ Code\ SemiBold:h13
  set guifont=DejaVuSansMono\ Nerd\ Font:h10

" let g:neovide_refresh_rate=60
" let g:neovide_transparency=0.8
" let g:neovide_no_idle=v:false
" let g:neovide_fullscreen=v:false
" let g:neovide_cursor_animation_length=0.20
" let g:neovide_cursor_trail_length=0.5
" let g:neovide_cursor_antialiasing=v:true
" let g:neovide_cursor_vfx_mode = "ripple"

  function! AdjustFontSize(amount)
      let s:guifontsize = s:guifontsize + a:amount
      execute "set guifont=" .. s:guifont .. ":h" .. s:guifontsize
  endfunction

  nnoremap <C-+> <cmd>call AdjustFontSize(+1)<cr>
  nnoremap <C--> <cmd>call AdjustFontSize(-1)<cr>
]])
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
