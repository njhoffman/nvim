local opts = { theme = 'default' }
local full_name = require('wf.static').full_name
local style = require('wf.config.style').new(vim.g[full_name .. '#theme'] or 'default')

local default_cfg = {
  title = nil,
  selector = 'which',
  text_insert_in_advance = '',
  key_group_dict = {},
  prefix_size = 7,
  sorter = require('wf.sorter').which,
  behavior = {
    skip_front_duplication = false,
    skip_back_duplication = false,
  },
  output_obj_which_mode_desc_format = function(match_obj)
    local desc = match_obj.text
    local front = desc:match('^%[[%l%u%d%s%-%.]+%]')
    if front == nil then
      if match_obj.type == 'group' then
        return { { match_obj.text, 'WFWhichDesc' }, { ' +', 'WFExpandable' } }
      else
        return { { match_obj.text, 'WFWhichDesc' } }
      end
    end
    local back = desc:sub(#front + 1)
    if match_obj.type == 'group' then
      return { { front, 'WFGroup' }, { back, 'WFWhichDesc' }, { ' +', 'WFExpandable' } }
    else
      return { { front, 'WFGroup' }, { back, 'WFWhichDesc' } }
    end
  end,
  style = style,
}

local cfg = vim.tbl_deep_extend('force', default_cfg, opts)
vim.dbglog('CFG', cfg)

require('wf').setup(cfg)

local which_key = require('wf.builtin.which_key')
local register = require('wf.builtin.register')
local bookmark = require('wf.builtin.bookmark')
local buffer = require('wf.builtin.buffer')
local mark = require('wf.builtin.mark')

if _G.__key_prefixes == nil then
  _G.__key_prefixes = { n = {}, i = {} }
end

-- Register
local keyopts = { noremap = true, silent = true, desc = '[wf.nvim] reg' }
vim.keymap.set('n', '<Leader>wfr', register(), keyopts)

-- Bookmark
keyopts.desc = '[wf.nvim] book'
local bookmark_opts = { nvim = '~/.config/nvim', zsh = '~/.zshrc' }
vim.keymap.set('n', '<Leader>wfB', bookmark(bookmark_opts), keyopts)

-- Buffer
keyopts.desc = '[wf.nvim] buf'
vim.keymap.set('n', '<Leader>wfb', buffer(), keyopts)

-- Which Key
keyopts.desc = '[wf.nvim] wk'
local wk_opts = { text_insert_in_advance = '<Leader>', key_group_dict = _G.__key_prefixes['n'] }
vim.keymap.set('n', '<Leader>', which_key(wk_opts), keyopts)

-- Mark
keyopts.desc = '[wf.nvim] mark'
-- keyopts.nowait = true
vim.keymap.set('n', '<Leader>wfm', mark(), keyopts)

-- wf.nvim post-load
-- set keymaps with `nowait` see `:h :map-nowait`
-- a timer to call a callback after a specified number of milliseconds.
-- local builtins = {
--   which_key = require('wf.builtin.which_key'),
--   register = require('wf.builtin.register'),
--   bookmark = require('wf.builtin.bookmark'),
--   buffer = require('wf.builtin.buffer'),
--   mark = require('wf.builtin.mark'),
-- }

-- ---@diagnostic disable: param-type-mismatch
-- local function timeout(ms, callback)
--   local uv = vim.loop
--   local timer = uv.new_timer()
--   local _callback = vim.schedule_wrap(function()
--     uv.timer_stop(timer)
--     uv.close(timer)
--     callback()
--   end)
--   uv.timer_start(timer, ms, 0, _callback)
-- end
--
-- timeout(100, function()
--   local keyopts = { noremap = true, silent = true, desc = '[wf.nvim] which-key /' }
--   vim.keymap.set('n', '<Leader>', builtins.which_key({ text_insert_in_advance = '<Leader>' }), keyopts)
-- end)
--
-- vim.api.nvim_create_autocmd({ 'BufEnter', 'BufAdd' }, {
--   group = vim.api.nvim_create_augroup('my_wf', { clear = true }),
--   callback = function()
--     local keyopts = { noremap = true, silent = true, desc = '[wf.nvim] which-key /', buffer = true }
--     timeout(100, function()
--       vim.keymap.set('n', '<Leader>', builtins.which_key({ text_insert_in_advance = '<Leader>' }), keyopts)
--     end)
--   end,
-- })
