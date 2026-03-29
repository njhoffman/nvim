-- local is_jumping = require('flash.plugins.char').jumping
-- local is_search = require('flash.plugins.char').state.is_search()
-- local prompt_visible = require('flash.prompt').visible()
-- local is_visible = require('flash.plugins.char').state.visible
-- don't override ;, mappings if they exist

-- Perform a remote yank: <esc>yrt<cr>e
--  gc operator-pending mode  => r flash remote mode => jump => c

local actions = require("configs.flash.actions")

local setup_char_mappings = function()
  -- for _, key in ipairs({ ';', ',' }) do
  for _, key in ipairs({ ";", ":" }) do
    local existing = {
      n = vim.fn.maparg(key, "n", false, false),
      x = vim.fn.maparg(key, "x", false, false),
      o = vim.fn.maparg(key, "o", false, false),
      s = vim.fn.maparg(key, "s", false, false),
    }
    mapper.map({ "n", "o", "x" }, key, function()
      local Config = require("flash.config")
      local Repeat = require("flash.repeat")
      local char = require("flash.plugins.char")
      local state = char.state or {}

      local mode = vim.fn.mode()
      local exists = existing[mode]
      if mode == "v" or mode == "V" or mode == "" then
        exists = existing.x
      end
      local is_visible = state and state.visible

      if is_visible then
        char.jumping = true
        local autohide = Config.get("char").autohide
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
      elseif exists and exists ~= "" then
        vim.api.nvim_feedkeys(exists, "n", true)
      end
    end, { remap = true })
  end
end

-- 'ygw',
-- function()
--   require('flash').jump {
--     action = function(match, state)
--       vim.api.nvim_set_current_win(match.win)
--       vim.api.nvim_win_set_cursor(match.win, match.pos)
--       vim.cmd.norm { args = { 'yiw' }, bang = true }
--       state:restore()
--     end,
--   }
-- end,
local pfx = "g\\"

local keys = {
  op_remote_restore = { "r" },
  op_remote_norestore = { "R" },
  remote_restore = { "gr", "grr", pfx .. "r" },
  remote_norestore = { "grR", pfx .. "R" },
}
local mapper = require("mapper")
local map = function(modes, lhs, rhs, opts)
  lhs = type(lhs) == "table" and lhs or { lhs }
  for _, key in ipairs(lhs) do
    modes = type(modes) == "function" and modes(key)
      or type(modes) == "table" and modes
      or { modes }
    if type(key) == "string" and key ~= "" then
      for _, mode in ipairs(modes) do
        mapper.map(mode, key, rhs, opts)
      end
    end
  end
end

local setup_remote_mappings = function()
  -- i.e. dr<search>w   gcr<search>c
  -- { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
  -- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  -- gr<match>u  gr<search>D  grvaby (yank remote block)  grab<match>@a (apply macro)

  map({ "o" }, keys.op_remote_restore, function()
    require("flash").remote({ restore = true })
  end, { desc = "⚡remote flash operator" })

  map({ "o" }, keys.op_remote_norestore, function()
    require("flash").remote({ restore = false })
  end, { desc = "⚡remote flash operator (norestore)" })

  map({ "n" }, keys.remote_restore, function()
    local state = require("flash").jump({
      remote_op = { restore = true },
    })
    vim.api.nvim_create_autocmd("TextChanged", {
      once = true,
      buffer = vim.api.nvim_get_current_buf(),
      callback = function(ev)
        state:restore()
      end,
    })
  end, { desc = "⚡remote flash command" })

  map({ "n" }, keys.remote_norestore, function()
    local state = require("flash").jump({
      remote_op = { restore = false },
    })
  end, { desc = "⚡remote flash no restore" })
end

-- stylua:ignore
local setup_search_mappings = function()
  map({ "c" }, "<C-\\>", function()
    require("flash.plugins.search").toggle_current_search()
  end, {
    desc = "⚡toggle flash current search",
  })

  map({ "n", "o", "x" }, "\\", function()
    require("flash").jump()
  end, { desc = "⚡flash jump" })

  map({ "n", "o", "x" }, pfx .. "s", function()
    require("flash").jump()
  end, { desc = "⚡flash jump" })

  map({ "n", "o", "x" }, pfx .. "S", function()
    require("flash").treesitter()
  end, { desc = "⚡flash jump treesitter" })

  map(
    { "n", "x", "o" },
    pfx .. "l",
    actions.jump_line,
    { desc = "⚡flash jump to line" }
  )

  map(
    { "n", "o", "x" },
    pfx .. "w",
    actions.jump_start_words,
    { desc = "⚡flash jump start words" }
  )

  map(
    { "n", "o", "x" },
    pfx .. "W",
    actions.jump_words,
    { desc = "⚡flash jump full words" }
  )

  map({"x", "o"}, "v", function()
    require("flash").treesitter({
      actions = {
        ["v"] = "next",
        ["V"] = "prev"
      }
    })
  end, { desc = "Treesitter incremental selection" })


  map(
    { "n", "o", "x" },
    pfx .. "e",
    actions.jump_diag,
    { desc = "⚡flash jump diagnostics" }
  )

  map({ "o", "x" }, pfx .. "v", function()
    require("flash").treesitter_search()
  end, { desc = "⚡flash treesitter range" })

  map(
    { "n", "o", "x" },
    pfx .. "c",
    actions.search_words_2char,
    { desc = "⚡flash search 2chars" }
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
  -- setup_char_mappings()
  setup_remote_mappings()
  setup_search_mappings()
end

return { setup = setup }
