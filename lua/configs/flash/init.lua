local cfg = {
  modes = {
    search = { enabled = false },
    char = {
      search = { wrap = false },
      highlight = { backdrop = false },
      jump = { register = false },
      -- autohide = function(motion)
      --   -- autohide flash when the operator is `y` or `d`
      --   return vim.fn.mode(true):find('no') and (vim.v.operator == 'y' or vim.v.operator == 'd')
      -- end,
      enabled = true,
      -- char_actions = function()
      --   return {
      --     [';'] = 'next', -- set to `right` to always go right
      --     [','] = 'prev', -- set to `left` to always go left
      --   }
      -- end,
    },
  },
}

require('flash').setup(cfg)

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

-- require("flash").jump({continue = true})
-- -- don't override ;, mappings if they exist
-- for _, key in ipairs({ ";", "," }) do
--   local mapping = vim.fn.maparg(key, "n", false, false)
--   if keys[key] == key and mapping ~= "" then
--     keys[key] = nil
--   end
-- end
--
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
