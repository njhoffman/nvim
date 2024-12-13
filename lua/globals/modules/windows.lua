local get_wins = function(filter)
  local wins = {}
  for winnr in vim.fn.range(1, vim.fn.winnr("$")) do
    local winid = vim.fn.win_getid(winnr)

    -- vars = vim.fn.win_getvars(winid)
    -- local vars = vim.api.nvim_win_get_var(winid, 'dbg')
    table.insert(
      wins,
      vim.tbl_deep_extend("force", { winnr = winnr, winid = winid }, vim.fn.getwininfo(winid), {
        pos = vim.fn.win_getpos(winid),
        cursor = vim.fn.getcurpos(),
        bufs = vim.fn.win_findbuf(winid),
      })
    )
  end
end

local win_summary = function(filter)
  local wins = get_wins(filter)
  local line_summary = {}
end

-- local win_list = function(filter, opts)
--   local wins = get_wins()
-- end

local winutils = {
  summary = win_summary,
  -- winlist = win_list
  -- winlist_v1 = nil,
  -- winlist_v2 = nil,
  -- winlist_v3 = nil,
  -- winlist_v4 = nil,
}

return winutils
