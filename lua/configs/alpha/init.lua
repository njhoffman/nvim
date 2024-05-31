local headers = require('configs.alpha.headers')
local utils = require('configs.alpha.utils')

-- vim.api.nvim_create_autocmd("User", {
--        pattern = "LazyVimStarted",
--        callback = function()
--          local stats = require("lazy").stats()
--          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
--          local pad_footer = string.rep(" ", 8)
--          starter.config.footer = pad_footer .. "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
--          pcall(starter.refresh)
--        end,
--      })

vim.keymap.set('n', '<C-CR>', '<cmd>Alpha<cr>', { nowait = true, desc = 'load alpha start screen' })
local header =
  { type = 'text', val = headers.big_header, opts = { position = 'center', hl = 'Type' } }

local my_unimpaired = {
  '[s ]s    prev/next spelling error',
  '[c ]c    prev/next Git change',
  '[d ]d    prev/next diagnostics',
  '[b ]b    prev/next buffer',
  '[z ]z    prev/next tab',
  '[f ]f    prev/next file',
  '[q ]q    prev/next quickfix list',
  '[l ]l    prev/next location list',
}

local vim_signature = {
  "mx dmx               toggle mark 'x'",
  'm, m. m- m<Space>    place/remove/delete all on current line/delete all buffer marks',
  "[` ]` [' ]'          jump to prev/next mark | start of a line with mark",
  '`[ `]                jump by alphabetical order to prev/next mark',
  "'[ ']                jump by alphabetical order to start of prev/next line having a mark",
  'm[0-9]               toggle the marker !@#$%^&*()',
  'm<S-[0-9]>           remove all markers of the same type',
  '[- ]- [= ]=          jump to prev line having a marker of the same type',
  'm<BS>                remove all markers',
}

local block1 = {
  type = 'group',
  val = utils.col(
    { my_unimpaired, vim_signature },
    {
      position = 'center',
      hl = { { 'Comment', 0, -1 }, { 'Title', 92, 97 }, { 'Title', 137, 154 } },
    }
  ),
  opts = {
    spacing = 0,
  },
}
local v = vim.version()
-- { api_compatible = 0, api_level = 12, api_prerelease = true, build = "gac1c23442", major = 0, minor = 10, patch = 0, prerelease = "dev" }
-- local version = 'v' .. vim.fn.join({ v.major, v.minor, v.patch }, '.') .. ' :' .. v.api_level
local v_full = vim.fn.matchstr(vim.api.nvim_command_output('version'), 'NVIM v\\zs[^\\n]*')
-- NVIM v0.10.0-dev-927+g21152f790
local version = 'v' .. v_full .. ' :' .. v.api_level
local load_time
if not vim.g.load_time then
  load_time = vim.fn.reltimestr(vim.fn.reltime(vim.g.start_time))
  load_time = '      VimEnter in ' .. string.sub(string.gsub(load_time, ' ', ''), 1, 5) .. 's'
else
  load_time = '⚡neovim loaded in ' .. vim.g.load_time .. 's'
end
-- TODO: 174 commits over 3 weeks from nightly

local stats = require('lazy').stats()
local plugins = ' Loaded ' .. stats.loaded .. ' out of ' .. stats.count .. ' plugins'
-- val = utils.col({ { version }, { plugins }, { load_time } })[1],
local footer = {
  type = 'text',
  val = { load_time, plugins, version },
  opts = {
    position = 'center',
    hl = 'Number',
  },
}

local opts = {
  layout = {
    { type = 'padding', val = 2 },
    header,
    -- { type = 'padding', val = 2 },
    -- block1,
    -- { type = 'padding', val = 2 },
    -- footer,
    -- { type = 'padding', val = 2 },
    -- block2,
    -- { type = 'padding', val = 2 },
    -- block3,
  },
  opts = {
    noautocmd = true,
    margin = 5,
  },
}

local dashboard = require('alpha.themes.dashboard')
--stylua: ignore
local buttons = {
  type = 'group',
  val = {
    { type = 'text', val = 'Quick links', opts = { hl = 'SpecialComment', position = 'center' } },
    { type = 'padding', val = 1 },
    dashboard.button('E', '  New file',       '<cmd>ene<CR>'),
    dashboard.button('f', '󰈞  Find file',      '<cmd>Telescope find_files<CR>'),
    dashboard.button('e', '󰊄  Live grep',      '<cmd>Telescope live_grep<CR>'),
    dashboard.button('c', '  Configuration',  '<cmd>Lazy<CR>'),
    dashboard.button('u', '  Update plugins', '<cmd>Lazy sync<CR>'),
    dashboard.button('q', '󰅚  Quit',           '<cmd>qa<CR>'),
  },
  position = 'center',
}

local section_mru = require('alpha.themes.theta').config.layout[4]
section_mru.val[3].val = function()
  return { require('alpha.themes.theta').mru(0, vim.fn.getcwd(), 5) }
end

local theme = require('alpha.themes.theta')
local config = theme.config

config.leader = ','
config.layout[4] = section_mru
config.layout[6] = buttons
config.layout[7] = { type = 'padding', val = 2 }
config.layout[8] = footer

require('alpha').setup(config)

-- config.layout[2] = header_color()
-- Disable folding on alpha buffer
-- vim.cmd([[
--   autocmd FileType alpha setlocal nofoldenable
--   augroup alpha_start
--   autocmd!
--   augroup END
--
-- ]])
-- local fortune = require("alpha.fortune")
-- dashboard.section.footer.val = fortune()
-- local dashboard = require("alpha.themes.dashboard")
-- dashboard.section.header.val = headers.big_header
-- dashboard.section.buttons.val = {
--   dashboard.button('e', '  > New file', ':ene <BAR> startinsert <CR>'),
--   dashboard.button('f', '󰈞  > Find file', ':cd $HOME/Workspace | Telescope find_files<CR>'),
--   dashboard.button('r', '  > Recent', ':Telescope oldfiles<CR>'),
--   dashboard.button('s', '  > Settings', ':e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>'),
--   dashboard.button('q', '󰅚  > Quit NVIM', ':qa<CR>'),
-- }
-- :center [{:icon "󰁯  "
--           :desc :Sessions
--           :key :s
--           :action #((. (require :telescope) :extensions :sesh :sesh))}
--          {:icon "  "
--           :desc "Recent files"
--           :key :r
--           :action "Telescope oldfiles"}
--          {:icon "󰈙  "
--           :desc "Find File"
--           :key :f
--           :action "Telescope find_files"}
--          {:icon "󰍉  "
--           :desc "Find Text"
--           :key :t
--           :action "Telescope live_grep"}
--          {:icon "󰂺  "
--           :desc "(WIP) mappings"
--           :key "?"
--           :action #(vim.notify "Guide is still WIP" :error)}
--          {:icon "  "
--           :desc "Assasinate a political figure"
--           :key :K
--           :action #(vim.notify :bang! :error)}
--          {:icon "  "
--           :desc "Check health"
--           :key :H
--           :action :checkhealth}]
-- :footer [(.. "Current Directory: " (vim.fn.getcwd))
--          ""
--          ""
--          ""
--          (.. "Loaded " (tostring (. (lazy.stats) :loaded))
--              " plugins in "
--              (tostring (math.floor (. (lazy.stats) :startuptime)))
--              :ms)]}}))

-- Set footer
--   NOTE: This is currently a feature in my fork of alpha-nvim (opened PR #21, will update snippet if added to main)
--   To see test this yourself, add the function as a dependecy in packer and uncomment the footer lines
--   ```init.lua
--   return require('packer').startup(function()
--       use 'wbthomason/packer.nvim'
--       use {
--           'goolord/alpha-nvim', branch = 'feature/startify-fortune',
--           requires = {'BlakeJC94/alpha-nvim-fortune'},
--           config = function() require("config.alpha") end
--       }
--   end)
--   ```
