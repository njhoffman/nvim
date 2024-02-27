-- local is_jumping = require('flash.plugins.char').jumping
-- local is_search = require('flash.plugins.char').state.is_search()
-- local prompt_visible = require('flash.prompt').visible()
-- local is_visible = require('flash.plugins.char').state.visible
-- don't override ;, mappings if they exist

local actions = require('configs.flash.actions')

local setup_char_mappings = function()
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

-- stylua:ignore
local setup_search_mappings = function()
  -- mapper.map({ 'c' }, '<M-S>', function()

  vim.keymap.set({ 'c' }, '<M-S>', function()
    require('flash').toggle()
  end, { noremap = true, silent = true, desc = 'Toggle remote flash' })

  -- mapper.map({ 'n', 'o', 'x' }, '<leader>/', function()
  --   require('flash').jump()
  -- end, { noremap = true, silent = true, desc = ' Flash Jump' })

  -- mapper.map({ 'n', 'o', 'x' }, '<leader>?', function()
  --   require('flash').treesitter()
  -- end, { noremap = true, silent = true, desc = 'Flash Treesitter' })

  vim.keymap.set({ 'o' }, 'r', function()
    require('flash').remote()
  end, { noremap = true, silent = true, desc = 'remote flash' })

  vim.keymap.set(
    { 'o' },
    '<leader>so',
    actions.jump_line,
    { noremap = true, silent = true, desc = 'Flash jump to line op' }
  )

  vim.keymap.set({ 'n', 'o' }, '\\', function()
    require('flash').treesitter_search()
  end, { noremap = true, silent = true, desc = 'flash treesitter search' })

  -- mapper.map(
  vim.keymap.set(
    { 'n', 'x', 'o' },
    '<leader>sl',
    actions.jump_line,
    { noremap = true, silent = true, desc = 'flash to line' }
  )

  -- mapper.map(
  vim.keymap.set(
    { 'n', 'o', 'x' },
    '<leader>sw',
    actions.jump_start_words,
    { noremap = true, silent = true, desc = 'flash jump start words' }
  )

  vim.keymap.set(
    { 'n', 'o', 'x' },
    '<leader>ss',
    actions.search_words_2char,
    { noremap = true, silent = true, desc = 'flash treesitter search 2chars' }
  )
  vim.keymap.set(
    { 'n', 'o', 'x' },
    '<leader>sW',
    actions.jump_words,
    { noremap = true, silent = true, desc = 'flash jump full words' }
  )

  vim.keymap.set(
    { 'n', 'o', 'x' },
    '<leader>se',
    actions.jump_diag,
    { noremap = true, silent = true, desc = 'flash jump diagnostics' }
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

--
--
