local utils = require("histories.utils")
local view = require("histories.changes.view")

local get_change_list = function(bufnr)
  return vim.fn.getchangelist(bufnr or vim.api.nvim_get_current_buf()) or {}
end

local get_items = function(bufnr, unique)
  local changelist = get_change_list(bufnr)
  return utils.process_list(changelist[1] or {}, changelist[2] or 0, unique)
end

local is_popup = function(winnr)
  return vim.tbl_get(vim.api.nvim_win_get_config(winnr), "relative") ~= ""
end

local watch_changes = function(opts)
  local timer = vim.loop.new_timer()
  local last = { hash = 0, idx = -1 }
  if timer then
    timer:start(
      0,
      1000,
      vim.schedule_wrap(function()
        local winnr = vim.api.nvim_get_current_win()
        local bufnr = vim.api.nvim_win_get_buf(winnr)
        if is_popup(winnr) then
          return false
        end
        local changes, change_idx, hash_id = get_items(bufnr, opts.unique)
        if hash_id ~= last.hash or change_idx ~= last.idx then
          view.load(changes, change_idx, opts)
          last = { hash = hash_id, idx = change_idx }
        end
      end)
    )
  end
end

local set_keys = function()
  -- https://github.com/pogyomo/submode.nvim
  local mappings = {
    ["g;"] = "next",
    ["g,"] = "prev",
    ["<esc>"] = "close",
  }

  for key, action in pairs(mappings) do
    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      key,
      string.format(':lua require("histories.changes.actions").%s()<CR>', action),
      { noremap = true, silent = true }
    )
  end
end

-- local close = function()
--   view.close()
-- end

local start = function(opts)
  opts = opts
    or {
      watch = false,
      setkeys = false,
      unique = false,
      notify = {
        lines_before = 8,
        lines_after = 3,
      },
    }

  if opts.setkeys then
    set_keys()
  end
  if opts.watch then
    watch_changes(opts)
  else
    local changes, _, curr_idx = get_items(nil, opts.unique)
    view.load(changes, curr_idx, opts)
  end
end

-- start({ watch = true })

return { start = start }
