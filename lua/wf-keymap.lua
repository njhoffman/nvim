---@diagnostic disable: param-type-mismatch

local uv = vim.loop
local which_key = require('wf.builtin.which_key')
local register = require('wf.builtin.register')
local bookmark = require('wf.builtin.bookmark')
local buffer = require('wf.builtin.buffer')
local mark = require('wf.builtin.mark')

-- local test = require("wf.builtin.test")
-- local sql = require("sql")

-- Below is an example of using keys_group_dict.
-- keys_group_dict is a list of prefix patterns. Keys with that pattern can be grouped together when displayed.

if _G.__key_prefixes == nil then
  _G.__key_prefixes = { n = {}, i = {} }
end

local key_group_dict = _G.__key_prefixes['n']

local function timeout(ms, callback)
  local timer = uv.new_timer()
  local callback0
  local function _2_()
    uv.timer_stop(timer)
    uv.close(timer)
    return callback()
  end
  callback0 = vim.schedule_wrap(_2_)
  return uv.timer_start(timer, ms, 0, callback0)
end

local setup_global = function(opts)
  local wk_opts = { key_group_dict = _G.__key_prefixes['n'] }
  local keyopts = { noremap = true, silent = true }

  -- Register
  keyopts.desc = '[wf.nvim] reg'
  vim.keymap.set('n', '<Leader>wfr', register(wk_opts), keyopts)

  -- Bookmark
  keyopts.desc = '[wf.nvim] book'
  vim.keymap.set('n', '<Leader>wfb', bookmark(opts.bookmark_dirs, wk_opts), keyopts)

  -- Buffer
  keyopts.desc = '[wf.nvim] buf'
  vim.keymap.set('n', '<Leader>wfB', buffer(wk_opts), keyopts)

  -- Mark
  keyopts.desc = '[wf.nvim] mark'
  -- keyopts.nowait = true
  vim.keymap.set('n', '<Leader>wfm', mark(wk_opts), keyopts)

  -- Which Key
  keyopts.desc = '[wf.nvim] whichkey'
  wk_opts.text_insert_in_advance = ''
  -- wk_opts.text_insert_in_advance = ''
  vim.keymap.set('n', '<Leader>wfk', which_key(wk_opts), keyopts)
  vim.keymap.set('n', '<F2>', which_key(wk_opts), keyopts)
  -- timeout(100, function()
  --   vim.keymap.set( 'n', "'",
  --     mark({ text_insert_in_advance = "'" }),
  --     { noremap = true, silent = true, nowait = true, desc = '[wf.nvim] mark' }
  --   )
  -- end)
end

local setup_aucmd = function()
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufAdd' }, {
    group = vim.api.nvim_create_augroup('my_wf', { clear = true }),
    callback = function()
      timeout(100, function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<Space>', '', {
          callback = which_key({ text_insert_in_advance = '<Space>', key_group_dict = key_group_dict }),
          noremap = true,
          silent = true,
          desc = 'which-key space [buf]',
          nowait = true,
        })
        vim.api.nvim_buf_set_keymap(0, 'n', 's', '', {
          callback = which_key({ text_insert_in_advance = 's', key_group_dict = key_group_dict }),
          noremap = true,
          silent = true,
          desc = 'which-key s [buf]',
          nowait = true,
        })
        vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>', '', {
          callback = which_key({ text_insert_in_advance = '<Leader>', key_group_dict = key_group_dict }),
          noremap = true,
          silent = true,
          desc = 'which-key / [buf]',
          nowait = true,
        })
      end)
    end,
  })

  local ns = vim.api.nvim_create_namespace('mhoge')
  vim.api.nvim_set_keymap('n', '<Space>wf', '', {
    callback = function()
      local conf_ = {
        width = 100,
        relative = 'editor',
        anchor = 'NW',
        style = 'minimal',
        border = 'rounded',
        title = 'Hoge',
        title_pos = 'center',
      }
      local conf = vim.fn.extend(conf_, {
        height = 1,
        row = 10,
        col = 10,
      })
      local buf = vim.api.nvim_create_buf(false, true)
      local win = vim.api.nvim_open_win(buf, true, conf)
      vim.api.nvim_buf_set_option(buf, 'buftype', 'prompt')
      vim.fn.prompt_setprompt(buf, 'Hoge> ')
      vim.api.nvim_buf_add_highlight(0, ns, 'TODO', 0, 0, 4)
      print(vim.inspect(vim.api.nvim_win_get_config(win)))
    end,
    noremap = true,
    silent = true,
    desc = 'test',
    nowait = true,
  })

  local input = require('wf.input').input
  vim.keymap.set('n', '<Space>k', input, { noremap = true, desc = 'test' })

  vim.keymap.set('n', '<Space>K', function()
    vim.schedule_wrap(function()
      vim.cmd('startinsert')
    end)()
    vim.schedule_wrap(function()
      vim.cmd('stopinsert')
    end)()
    vim.schedule_wrap(function()
      vim.cmd('startinsert')
    end)()
  end, { noremap = true, desc = 'test' })
end

local which_keys = function()
  vim.api.nvim_set_keymap('n', '<Space>', '', {
    callback = which_key({
      text_insert_in_advance = '<Space>',
      key_group_dict = key_group_dict,
    }),
    noremap = true,
    silent = true,
    desc = 'which-key space',
    nowait = true,
  })
  vim.api.nvim_set_keymap('n', 's', '', {
    callback = which_key({
      text_insert_in_advance = 's',
      key_group_dict = key_group_dict,
    }),
    noremap = true,
    silent = true,
    desc = 'which-key s',
    nowait = true,
  })
  vim.api.nvim_set_keymap('n', '<Leader>', '', {
    callback = which_key({
      text_insert_in_advance = '<Leader>',
      key_group_dict = key_group_dict,
    }),
    noremap = true,
    silent = true,
    desc = 'which-key /',
    nowait = true,
  })
  -- wf.prefix_set(
  --   'n',
  --   '<Space>',
  --   which_key({ text_insert_in_advance = '<Space>', key_group_dict = key_group_dict }),
  --   { noremap = true, silent = true, desc = 'which-key space' }
  -- )
  -- wf.prefix_set(
  --   'n',
  --   's',
  --   which_key({ text_insert_in_advance = 's', key_group_dict = key_group_dict }),
  --   { noremap = true, silent = true, desc = 'which-key `s`' }
  -- )
  -- wf.prefix_set(
  --   'n',
  --   '<Leader>',
  --   which_key({ text_insert_in_advance = '<Leader>', key_group_dict = key_group_dict }),
  --   { noremap = true, silent = true, desc = 'which-key `/`' }
  -- )
end

-- stylua: ignore
return {
  timeout = timeout,
  setup_aucmd = setup_aucmd,
  setup_global = setup_global,
  which_keys = which_keys,
}

---- utility function for setting keymaps
---------------------------------------
-- local function nmaps(prefix, desc, tbl)
--   local sign = "["..name.."]"
--   table.insert(_G.__key_prefixes["n"], prefix, sign)
--   local set = function(key, cmd, desc, opt)
--     local _opt = opt or {}
--     _opt["desc"] = desc..sign
--     _opt["noremap"] = true
--     vim.keymap.set("n", prefix .. key, cmd, _opt)
--   end
--   for _, v in ipairs(tbl)  do
--     set(unpack tbl)
--   end
-- end
--
--
-- -- set keymap for each plugins
-- ---------------------------------------
-- -- lambdalisue/fern.vim
-- nmaps("<space>n", "fern",
-- {{"p", "<cmd>Fern . -drawer -toggle<cr>", "open fern on a current working directory"},
--  {"d", "<cmd>Fern %:h -drawer -toggle<cr>", "open fern on a parent directory of a current buffer"}})
--
-- -- nvim-telescope/telescope.nvim
-- nmaps("<space>t", "telescope"
-- {{"f", "<cmd>Telescope find_files<cr>", "find files"},
--  {"g", "<cmd>Telescope live_grep<cr>", "live grep"},
--  {"b", "<cmd>Telescope buffers<cr>", "buffers"},
--  {"h", "<cmd>Telescope help_tags<cr>", "help tags"},
--  {"t", "<cmd>Telescope<cr>", "telescope"},
--  {"o", "<cmd>Telescope oldfiles<cr>", "old files"},
--  {"r", "<cmd>Telescope file_browser<cr>", "file_browser"}})
--
