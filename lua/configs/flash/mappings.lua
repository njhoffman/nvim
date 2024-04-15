-- local is_jumping = require('flash.plugins.char').jumping
-- local is_search = require('flash.plugins.char').state.is_search()
-- local prompt_visible = require('flash.prompt').visible()
-- local is_visible = require('flash.plugins.char').state.visible
-- don't override ;, mappings if they exist

local actions = require('configs.flash.actions')

local setup_char_mappings = function()
  -- for _, key in ipairs({ ';', ',' }) do
  for _, key in ipairs({ ';', ':' }) do
    local existing = {
      n = vim.fn.maparg(key, 'n', false, false),
      -- x = vim.fn.maparg(key, 'x', false, false),
      o = vim.fn.maparg(key, 'o', false, false),
      s = vim.fn.maparg(key, 's', false, false),
    }
    vim.keymap.set(
      { 'n', 'o' }, -- {'x', 'n', 'o' },
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
      { remap = true, silent = true }
    )
  end
end

local pfx = 'g\\'

-- stylua:ignore
local setup_search_mappings = function()
  vim.keymap.set({ 'c' }, '<M-S>', function()
    require('flash').toggle()
  end, { noremap = true, silent = true, desc = '⚡toggle flash search' })

  -- or
  -- { "<c-s>", mode = { "c" }, function() require("flash").toggle_current_search() end, desc = "Toggle Current Flash Search" },
  -- i.e. dr<search>w   gcr<search>c

  vim.keymap.set({ 'o' }, 'r', function()
    require('flash').remote()
  end, { noremap = true, desc = '⚡remote flash operator' })

  -- r<match>u  r<search>D  rvaby (yank remote block)  rab<match>@a (apply macro)
  vim.keymap.set({ 'n' }, 'gr', function()
    local state = require('flash').jump({
      remote_op = { restore = false },
    })
    vim.api.nvim_create_autocmd('TextChanged', {
      once = true,
      buffer = vim.api.nvim_get_current_buf(),
      callback = function(ev)
        state:restore()
      end,
    })
  end, { noremap = true, silent = true, desc = '⚡remote flash command' })

  vim.keymap.set({ 'n', 'o', 'x' }, '\\', function()
    require('flash').jump()
  end, { noremap = true, silent = true, desc = '⚡flash jump' })

  vim.keymap.set({ 'n', 'o', 'x' }, 'g\\t', function()
    require('flash').treesitter()
  end, { noremap = true, silent = true, desc = '⚡flash treesitter' })

  vim.keymap.set(
    { 'n', 'x', 'o' },
    'g\\l',
    actions.jump_line,
    { noremap = true, silent = true, desc = '⚡flash jump to line' }
  )

  vim.keymap.set(
    { 'n', 'o', 'x' },
    'g\\w',
    actions.jump_start_words,
    { noremap = true, silent = true, desc = '⚡flash jump start words' }
  )

  vim.keymap.set(
    { 'n', 'o', 'x' },
    'g\\W',
    actions.jump_words,
    { noremap = true, silent = true, desc = '⚡flash jump full words' }
  )

  vim.keymap.set(
    { 'n', 'o', 'x' },
    'g\\e',
    actions.jump_diag,
    { noremap = true, silent = true, desc = '⚡flash jump diagnostics' }
  )

  vim.keymap.set({ 'n', 'o' }, 'g\\s', function()
    require('flash').treesitter_search()
  end, { noremap = true, silent = true, desc = '⚡flash treesitter search' })

  vim.keymap.set(
    { 'n', 'o', 'x' },
    'g\\S',
    actions.search_words_2char,
    { noremap = true, silent = true, desc = '⚡flash treesitter search 2chars' }
  )

  -- mapper.map({ 'n', 'x' }, 'rx', function()
  -- vim.keymap.set({ 'n', 'x' }, 'rx', function()
  --   M.swap_with({
  --     -- Customize the flash remote options for selecting the second range
  --   })
  -- end, {
  --   noremap = true,
  --   silent = true,
  --   desc = 'flash remote  exchange',
  -- })
end

local setup = function()
  setup_char_mappings()
  setup_search_mappings()
end

return { setup = setup }

-- Perform a remote yank: <esc> y r t <cr> e
-- type gc to start operator-pending mode
-- type r to start the flash's remote mode
-- jump to the line you wanna comment using flash's labels
-- type c to comment the line

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
-- end

-- One thing you could do, is run jump with remote_op.restore = false. This will return a state object.
-- Once that function returns, you will be at the remote location.

-- So now you could create a buffer local mapping <enter> for example that does state:restore() and deletes the mapping again.

-- This way you could do remotely what you want and eventually press <enter> to get back to your original position.

--
--
