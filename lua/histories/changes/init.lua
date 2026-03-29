local utils = require("histories.utils")
local view = require("histories.changes.view")

local get_change_list = function(bufnr)
  return vim.fn.getchangelist(bufnr or vim.api.nvim_get_current_buf()) or {}
end

local get_items = function(bufnr, unique)
  local changelist = get_change_list(bufnr)
  local processed = utils.process_list(changelist[1] or {}, changelist[2] or 0, unique)
  return processed
end

local default_config = {
  -- watch for changes ever 1000ms instead of being triggered on every change
  watch = true,
  setkeys = false,
  unique = true,
  notify = {
    lines_before = 8,
    lines_after = 3,
  },
  mappings = {
    ["g;"] = "next",
    ["g,"] = "prev",
    ["<esc>"] = "close",
  },
}

local start = function(opts)
  opts = vim.tbl_deep_extend("force", default_config, opts or {})
  if opts.setkeys then
    utils.set_keys("changes", opts.mappings)
  end
  if opts.watch then
    utils.watch_changes(opts, get_items, view)
  else
    local changes, _, curr_idx = get_items(nil, opts.unique)
    view.load(changes, curr_idx, opts)
  end
end

local stop = function()
  view.close()
end

-- start({ watch = true })
return { start = start, stop = stop }
