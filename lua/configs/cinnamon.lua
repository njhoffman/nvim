if true then
  return false
end

-- qrs
local defaults = {
  default_keymaps = true, -- Create default keymaps.
  extra_keymaps = false, -- Create extra keymaps.
  extended_keymaps = false, -- Create extended keymaps.
  override_keymaps = false, -- The plugin keymaps will override any existing keymaps.

  -- OPTIONS:
  always_scroll = false, -- Scroll the cursor even when the window hasn't scrolled.
  centered = true, -- Keep cursor centered in window when using window scrolling.
  disabled = false, -- Disables the plugin.
  default_delay = 7, -- The default delay (in ms) between each line when scrolling.
  hide_cursor = false, -- Hide the cursor while scrolling. Requires enabling termguicolors!
  horizontal_scroll = true, -- Enable smooth horizontal scrolling when view shifts left or right.
  max_length = -1, -- Maximum length (in ms) of a command. The line delay will be
  -- re-calculated. Setting to -1 will disable this option.
  scroll_limit = 150, -- Max number of lines moved before scrolling is skipped. Setting
}

local cfg = {
  always_scroll = true,
  default_keymaps = false,
  extra_keymaps = false, -- Create extra keymaps.
  extended_keymaps = false, -- Create extended keymaps.
  override_keymaps = false, -- The plugin keymaps will override any existing keymaps.
  default_delay = 4,
  max_length = -1,
  scroll_limit = -1,
}

require('cinnamon').setup(cfg)

local map = require("mapper").map

-- DEFAULT_KEYMAPS:

-- Half-window movements:
-- vim.keymap.set({ 'n', 'x' }, '<C-u>', "<Cmd>lua Scroll('<C-u>', 1, 1)<CR>")
-- vim.keymap.set({ 'n', 'x' }, '<C-d>', "<Cmd>lua Scroll('<C-d>', 1, 1)<CR>")

-- Page movements:
-- vim.keymap.set({ 'n', 'x' }, '<C-b>', "<Cmd>lua Scroll('<C-b>', 1, 1)<CR>", { noremap = false })
-- vim.keymap.set({ 'n', 'x' }, '<C-f>', "<Cmd>lua Scroll('<C-f>', 1, 1)<CR>", { noremap = false })
map({ 'n', 'x' }, '<S-PageUp>', "<Cmd>lua Scroll('<C-b>', 1, 1)<CR>", { remap = true })
map({ 'n', 'x' }, '<S-PageDown>', "<Cmd>lua Scroll('<C-f>', 1, 1)<CR>", { remap = true })

-- EXTRA_KEYMAPS:

-- Start/end of file and line number movements:
-- vim.keymap.set({ 'n', 'x' }, 'gg', "<Cmd>lua Scroll('gg')<CR>")
-- vim.keymap.set({ 'n', 'x' }, 'G', "<Cmd>lua Scroll('G', 0, 1)<CR>")

-- Start/end of line:
map({ 'n' }, '0', "<Cmd>lua require('tabtree').next()<CR>")
map({ 'n' }, '9', "<Cmd>lua require('tabtree').previous()<CR>")
map({ 'x' }, '0', "<Cmd>lua Scroll('0')<CR>")
map({ 'n', 'x' }, '^', "<Cmd>lua Scroll('^')<CR>")
map({ 'n', 'x' }, '$', "<Cmd>lua Scroll('$', 0, 1)<CR>")

-- Paragraph movements:
map({ 'n', 'x' }, '{', "<Cmd>lua Scroll('{')<CR>")
map({ 'n', 'x' }, '}', "<Cmd>lua Scroll('}')<CR>")

-- Previous/next search result:
-- vim.keymap.set('n', 'n', [[<Cmd>lua Scroll('n', 1)]], { silent = true, remap = true })
-- vim.keymap.set('n', 'N', "<Cmd>lua Scroll('N', 1)<CR>")

local scroll = function(key, count)
  return function()
    _G.Scroll(key, count)
    -- require('cinnamon').scroll(key, count)
    vim.schedule(function()
      require('hlslens').start()
    end)
  end
end

map(
  'n',
  'n',
  [[<Cmd>execute('normal! ' . v:count1 . 'n') <bar> lua require('hlslens').start()<CR>]],
  { remap = true }
)
map(
  'n',
  'N',
  [[<Cmd>execute('normal! ' . v:count1 . 'N') <bar> lua require('hlslens').start()<CR>]],
  { remap = true }
)

-- vim.keymap.set('n', '*', "<Cmd>norm! *#<CR>") -- <Cmd>lua Scroll('*', 1)<CR>
map('n', '*', scroll('*', 1))
map('n', '#', "<Cmd>lua Scroll('#', 1)<CR>")
map('n', 'g*', "<Cmd>lua Scroll('g*', 1)<CR>")
map('n', 'g#', "<Cmd>lua Scroll('g#', 1)<CR>")

-- Previous/next cursor location:
map('n', '<C-o>', "<Cmd>lua Scroll('<C-o>', 1)<CR>")
map('n', '<C-i>', "<Cmd>lua Scroll('<C-i>', 1)<CR>")

-- Screen scrolling:
map('n', 'zz', "<Cmd>lua Scroll('zz', 0, 1)<CR>")
map('n', 'zt', "<Cmd>lua Scroll('zt', 0, 1)<CR>")
map('n', 'zb', "<Cmd>lua Scroll('zb', 0, 1)<CR>")
map('n', 'z.', "<Cmd>lua Scroll('z.', 0, 1)<CR>")
map('n', 'z<CR>', "<Cmd>lua Scroll('zt^', 0, 1)<CR>")
map('n', 'z-', "<Cmd>lua Scroll('z-', 0, 1)<CR>")
map('n', 'z^', "<Cmd>lua Scroll('z^', 0, 1)<CR>")
map('n', 'z+', "<Cmd>lua Scroll('z+', 0, 1)<CR>")
-- vim.keymap.set('n', '<C-y>', "<Cmd>lua Scroll('<C-y>', 0, 1)<CR>")
-- vim.keymap.set('n', '<C-e>', "<Cmd>lua Scroll('<C-e>', 0, 1)<CR>")

-- Horizontal screen scrolling:
map('n', 'zH', "<Cmd>lua Scroll('zH')<CR>")
map('n', 'zL', "<Cmd>lua Scroll('zL')<CR>")
map('n', 'zs', "<Cmd>lua Scroll('zs')<CR>")
map('n', 'ze', "<Cmd>lua Scroll('ze')<CR>")
map('n', 'zh', "<Cmd>lua Scroll('zh', 0, 1)<CR>")
map('n', 'zl', "<Cmd>lua Scroll('zl', 0, 1)<CR>")

-- EXTENDED_KEYMAPS:

-- Up/down movements:
map({ 'n', 'x' }, 'k', "<Cmd>lua Scroll('k', 0, 1)<CR>")
map({ 'n', 'x' }, 'j', "<Cmd>lua Scroll('j', 0, 1)<CR>")
map({ 'n', 'x' }, '<Up>', "<Cmd>lua Scroll('k', 0, 1)<CR>")
map({ 'n', 'x' }, '<Down>', "<Cmd>lua Scroll('j', 0, 1)<CR>")

-- Left/right movements:
map({ 'n', 'x' }, 'h', "<Cmd>lua Scroll('h', 0, 1)<CR>")
map({ 'n', 'x' }, 'l', "<Cmd>lua Scroll('l', 0, 1)<CR>")
map({ 'n', 'x' }, '<Left>', "<Cmd>lua Scroll('h', 0, 1)<CR>")
map({ 'n', 'x' }, '<Right>', "<Cmd>lua Scroll('l', 0, 1)<CR>")

-- SCROLL_WHEEL_KEYMAPS:

map({ 'n', 'x' }, '<ScrollWheelUp>', "<Cmd>lua Scroll('<ScrollWheelUp>')<CR>")
map({ 'n', 'x' }, '<ScrollWheelDown>', "<Cmd>lua Scroll('<ScrollWheelDown>')<CR>")

-- if !exists('g:smoothie_update_interval')
--   " Time (in milliseconds) between subsequent screen/cursor position updates.
--   " Lower value produces smoother animation.  Might be useful to increase it
--   " when running Vim over low-bandwidth/high-latency connections.
--   let g:smoothie_update_interval = 20
-- endif
--
-- if !exists('g:smoothie_speed_constant_factor')
--   " This value controls constant term of the velocity curve. Increasing this
--   " boosts primarily cursor speed at the end of animation.
--   let g:smoothie_speed_constant_factor = 10
-- endif
--
-- if !exists('g:smoothie_speed_linear_factor')
--   " This value controls linear term of the velocity curve. Increasing this
--   " boosts primarily cursor speed at the beginning of animation.
--   let g:smoothie_speed_linear_factor = 10
-- endif
--
-- if !exists('g:smoothie_speed_exponentiation_factor')
--   " This value controls exponent of the power function in the velocity curve.
--   " Generally should be less or equal to 1.0. Lower values produce longer but
--   " perceivably smoother animation.
--   let g:smoothie_speed_exponentiation_factor = 0.9
-- endif
--
-- qrs
-- LSP_KEYMAPS:

-- LSP go-to-definition:
-- vim.keymap.set('n', 'gd', "<Cmd>lua Scroll('definition')<CR>")
--
-- -- LSP go-to-declaration:
-- vim.keymap.set('n', 'gD', "<Cmd>lua Scroll('declaration')<CR>")
