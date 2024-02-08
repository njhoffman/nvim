-- let s:shade_hl_defaults = {
--     \   'gui'     : ['NONE', '#777777' , 'NONE']
--     \ , 'cterm256': ['NONE', '242'     , 'NONE']
--     \ , 'cterm'   : ['NONE', 'grey'    , 'NONE']
-- vimade_3670    xxx ctermfg=146 guifg=#264e8e

local cfg = {
  search = {
    exclude = {
      'notify',
      'cmp_menu',
      'noice',
      'flash_prompt',
      function(win)
        -- exclude non-focusable windows
        return not vim.api.nvim_win_get_config(win).focusable
      end,
    },
  },
  highlight = {
    -- show a backdrop with hl FlashBackdrop
    backdrop = true,
    -- Highlight the search matches
    matches = true,
    -- extmark priority
    priority = 5000,
    groups = {
      match = 'FlashMatch',
      current = 'FlashCurrent',
      backdrop = 'FlashBackdrop',
      label = 'FlashLabel',
    },
  },
  jump = {
    -- save location in the jumplist
    jumplist = true,
    -- jump position
    pos = 'start', ---@type "start" | "end" | "range"
    -- add pattern to search history
    history = false,
    -- add pattern to search register
    register = false,
    -- clear highlight after jump
    nohlsearch = true,
    -- automatically jump when there is only one match
    autojump = true,
    -- You can force inclusive/exclusive jumps by setting the
    -- `inclusive` option. By default it will be automatically
    -- set based on the mode.
    inclusive = nil, ---@type boolean?
    -- jump position offset. Not used for range jumps.
    -- 0: default
    -- 1: when pos == "end" and pos < current position
    offset = nil, ---@type number
  },
  label = {
    -- allow uppercase labels
    uppercase = false,
    -- add any labels with the correct case here, that you want to exclude
    exclude = '',
    -- add a label for the first match in the current window.
    -- you can always jump to the first match with `<CR>`
    current = true,
    -- show the label after the match
    after = true, ---@type boolean|number[]
    -- show the label before the match
    before = false, ---@type boolean|number[]
    -- position of the label extmark
    style = 'overlay', ---@type "eol" | "overlay" | "right_align" | "inline"
    -- flash tries to re-use labels that were already assigned to a position,
    -- when typing more characters. By default only lower-case labels are re-used.
    reuse = 'lowercase', ---@type "lowercase" | "all" | "none"
    -- for the current window, label targets closer to the cursor first
    distance = true,
    -- minimum pattern length to show labels
    -- Ignored for custom labelers.
    min_pattern_length = 0,
    -- Enable this to use rainbow colors to highlight labels
    -- Can be useful for visualizing Treesitter ranges.
    rainbow = {
      enabled = false,
      -- number between 1 and 9
      shade = 5,
    },
  },
  prompt = {
    enabled = true,
    prefix = { { '⚡', 'FlashPromptIcon' } },
    win_config = {
      row = 15,
      col = (vim.o.columns / 2) - 15,
      width = 30,
      height = 1,
      border = 'rounded',
      relative = 'editor',
      zindex = 1000,
    },
  },
  modes = {
    search = { enabled = false },
    prompt = { enabled = true },
    remote = {
      remote_op = {
        -- restore window views and cursor position after doing a remote operation
        restore = true,
        -- For `jump.pos = "range"`, this setting is ignored.
        -- `true`: always enter a new motion when doing a remote operation
        -- `false`: use the window's cursor position and jump target
        -- `nil`: act as `true` for remote windows, `false` for the current window
        motion = true,
      },
    },
    char = {
      enabled = true,
      -- keys = { "f", "F", "t", "T", ";", "" },
      -- keys = { 'f', 'F', 't', 'T', ';', ',' },
      keys = { 'f', 'F', 't', 'T', ';', ':' },
      search = { wrap = false },
      highlight = { backdrop = true },
      jump = { history = true, register = false, nohlsearch = true },
      jump_labels = false,
      multi_line = true,
      config = function(opts)
        -- -- autohide flash when in operator-pending mode
        opts.autohide = opts.autohide or (vim.fn.mode(true):find('no') and vim.v.operator == 'y')

        -- disable jump labels when not enabled, when using a count,
        -- or when recording/executing registers
        opts.jump_labels = opts.jump_labels
          and vim.v.count == 0
          and vim.fn.reg_executing() == ''
          and vim.fn.reg_recording() == ''
        -- Show jump labels only in operator-pending mode
        -- opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find('o')
      end,
      autohide = function(motion)
        -- autohide flash when the operator is `y` or `d`
        return vim.fn.mode(true):find('no') and (vim.v.operator == 'y' or vim.v.operator == 'd')
      end,
      char_actions = function(motion)
        return {
          [';'] = 'next', -- set to `right` to always go right
          [':'] = 'prev', -- set to `left` to always go left
          -- clever-f style
          [motion:lower()] = 'next',
          [motion:upper()] = 'prev',
          -- jump2d style: same case goes next, opposite case goes prev
          -- [motion] = "next",
          -- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
        }
      end,
    },
  },
  -- treesitter = {
  --   labels = 'abcdefghijklmnopqrstuvwxyz',
  --   jump = { pos = 'range' },
  --   search = { incremental = false },
  --   label = { before = true, after = true, style = 'inline' },
  --   highlight = {
  --     backdrop = false,
  --     matches = false,
  --   },
  -- },
  -- treesitter_search = {
  --   jump = { pos = 'range' },
  --   search = { multi_window = true, wrap = true, incremental = false },
  --   remote_op = { restore = true },
  --   label = { before = true, after = true, style = 'inline' },
  -- },
}

require('flash').setup(cfg)

-- local is_jumping = require('flash.plugins.char').jumping
-- local is_search = require('flash.plugins.char').state.is_search()
-- local prompt_visible = require('flash.prompt').visible()
-- local is_visible = require('flash.plugins.char').state.visible
-- don't override ;, mappings if they exist
for _, key in ipairs({ ';', ':' }) do
  local existing = {
    n = vim.fn.maparg(key, 'n', false, false),
    -- x = vim.fn.maparg(key, 'x', false, false),
    o = vim.fn.maparg(key, 'o', false, false),
    s = vim.fn.maparg(key, 's', false, false),
  }
  vim.keymap.set(
    {
      'n', --[[ 'x', ]]
      'o',
    },
    key,
    function()
      local Config = require('flash.config')
      local Repeat = require('flash.repeat')
      local char = require('flash.plugins.char')
      local state = char.state or {}

      local mode = vim.fn.mode()
      local is_visible = state and state.visible

      if is_visible then
        char.jumping = true
        local autohide = Config.get('char').autohide
        if Repeat.is_repeat then
          char.jump_labels = false -- never show jump labels when repeating
          char.state:jump({ count = vim.v.count1 })
          char.state:show()
        else
          char.jump(key)
        end
        vim.schedule(function()
          char.jumping = false
          if char.state and autohide then
            char.state:hide()
          end
        end)
      elseif existing[mode] and existing[mode] ~= '' then
        vim.api.nvim_feedkeys(existing[mode], mode, true)
      end
    end,
    {
      remap = true,
      silent = true,
    }
  )
end

-- for _, key in ipairs({ "f", "F", "t", "T", ";", "," }) do
--   if keys[key] then

-- Flash telescope
-- opts = function(_, opts)
--   if not Util.has("flash.nvim") then
--     return
--   end
--   local function flash(prompt_bufnr)
--     require("flash").jump({
--       pattern = "^",
--       label = { after = { 0, 0 } },
--       search = {
--         mode = "search",
--         exclude = {
--           function(win)
--             return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
--           end,
--         },
--       },
--       action = function(match)
--         local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
--         picker:set_selection(match.pos[1] - 1)
--       end,
--     })
--   end
--   opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
--     mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
--   })
-- end,

-- Perform a remote yank: <esc> y r t <cr> e
-- type gc to start operator-pending mode
-- type r to start the flash's remote mode
-- jump to the line you wanna comment using flash's labels
-- type c to comment the line

-- keys = {
--   {
--     "s",
--     mode = { "n", "x", "o" },
--     function()
--       -- default options: exact mode, multi window, all directions, with a backdrop
--       require("flash").jump({ multi_window = false })
--     end,
--     desc = "Flash",
--   },
--   {
--     "S",
--     mode = { "n", "o", "x" },
--     function()
--       require("flash").treesitter()
--     end,
--     desc = "Flash Treesitter",
--   },
--   {
--     "r",
--     mode = "o",
--     function()
--       require("flash").remote()
--     end,
--     desc = "Remote Flash",
--   },
-- },

-- search full words
-- require('flash').jump({
--   pattern = '.', -- initialize pattern with any char
--   search = {
--     mode = function(pattern)
--       -- remove leading dot
--       if pattern:sub(1, 1) == '.' then
--         pattern = pattern:sub(2)
--       end
--       -- return word pattern and proper skip pattern
--       return ([[\<%s\w*\>]]):format(pattern), ([[\<%s]]):format(pattern)
--     end,
--   },
--   -- select the range
--   jump = { pos = 'range' },
-- })

-- require("flash").jump({continue = true})
-- for _, key in ipairs({ "f", "F", "t", "T", ";", "," }) do
--   if keys[key] then
--     vim.keymap.set({ "n", "x", "o" }, keys[key], function()
--       M.jumping = true
--       local autohide = Config.get("char").autohide
--       if Repeat.is_repeat then
--         M.jump_labels = false -- never show jump labels when repeating
--         M.state:jump({ count = vim.v.count1 })
--         M.state:show()
--       else
--         M.jump(key)
--       end
--       vim.schedule(function()
--         M.jumping = false
--         if M.state and autohide then
--           M.state:hide()
--         end
--       end)
--     end, {
--       silent = true,
--     })
--   end
-- end
--
-- vim.api.nvim_create_autocmd({ "BufLeave", "CursorMoved", "InsertEnter" }, {
--   group = vim.api.nvim_create_augroup("flash_char", { clear = true }),
--   callback = function(event)
--     local hide = event.event == "InsertEnter" or not M.jumping
--     if hide and M.state then
--       M.state:hide()
--     end
--   end,
-- })
--
-- vim.on_key(function(key)
--   if M.state and key == Util.ESC and (vim.fn.mode() == "n" or vim.fn.mode() == "v") then
--     M.state:hide()
--   end
-- end)
-- end

-- require("flash").jump({
--   action = function(match, state)
--     vim.api.nvim_win_call(match.win, function()
--       vim.api.nvim_win_set_cursor(match.win, match.pos)
--       vim.diagnostic.open_float()
--     end)
--     state:restore()
--   end,
-- })
--
-- -- More advanced example that also highlights diagnostics:
-- require("flash").jump({
--   matcher = function(win)
--     ---@param diag Diagnostic
--     return vim.tbl_map(function(diag)
--       return {
--         pos = { diag.lnum + 1, diag.col },
--         end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
--       }
--     end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
--   end,
--   action = function(match, state)
--     vim.api.nvim_win_call(match.win, function()
--       vim.api.nvim_win_set_cursor(match.win, match.pos)
--       vim.diagnostic.open_float()
--     end)
--     state:restore()
--   end,
-- })

-- Swap between two ranges using rx<motion1><flash><motion2> or v<motion1>rx<flash><motion2>
--
-- local swap_with = function(opts, ma, mb)
--   local function helper(start, finish, op)
--     vim.api.nvim_win_set_cursor(0, start)
--     vim.cmd "normal! v"
--     vim.api.nvim_win_set_cursor(0, finish)
--     vim.api.nvim_feedkeys(op or "p", "ni", false)
--   end
--
--   local reg = vim.fn.getreg '"'
--   vim.api.nvim_feedkeys("`" .. ma .. "v`" .. mb .. "y", "n", false)
--   local start, finish = vim.api.nvim_buf_get_mark(0, ma), vim.api.nvim_buf_get_mark(0, mb)
--
--   _G.__remote_op_opfunc = function() helper(vim.api.nvim_buf_get_mark(0, "["), vim.api.nvim_buf_get_mark(0, "]")) end
--   vim.go.operatorfunc = "v:lua.__remote_op_opfunc"
--   vim.api.nvim_feedkeys("g@", "n", false)
--   require("flash").remote(vim.tbl_deep_extend("force", {
--     remote = {
--       on_restore = vim.schedule_wrap(function()
--         helper(start, finish)
--         vim.fn.setreg('"', reg)
--       end),
--     },
--   }, opts))
-- end
-- M.swap_with = function(opts)
--   local v = vim.api.nvim_get_mode().mode:lower() == "v"
--   if v then
--     swap_with(opts, "<", ">")
--   else
--     _G.__remote_op_opfunc = function() swap_with(opts, v and "<" or "[", v and ">" or "]") end
--     vim.go.operatorfunc = "v:lua.__remote_op_opfunc"
--     vim.api.nvim_feedkeys("g@", "n", false)
--   end
-- end
--
-- -- Add keymapping
--   {
--     "rx",
--     mode = { "x", "n" },
--     desc = "Remote Exchange",
--     function()
--       M.swap_with {
--         -- Customize the flash remote options for selecting the second range
--       }
--     end,
--   },
