local filter_tbl = require("globals.modules.filter")

local M = {}

-- local format_

local is_numberslist = function(list)
  if not vim.islist(list) then
    return false
  end
  local is_num_list = true
  for _, item in ipairs(list) do
    is_num_list = is_num_list and type(item) == "number"
  end
  return is_num_list
end

-- list of numbers: buffer ids to filter windows by
-- bufnrs = {}, winnrs = {}, winids = {}, bufids = {}
-- variables, name, signs, lnum, loaded, listed, linecount,
-- hidden, command, changedtick, changed, bufnr, windows

M.get_windows = function(filter)
  local wins = {}
  for _, winnr in ipairs(vim.fn.range(1, vim.fn.winnr("$"))) do
    local winid = vim.fn.win_getid(winnr)
    -- vars = vim.fn.win_getvars(winid)
    -- local vars = vim.api.nvim_win_get_var(winid, 'dbg')
    table.insert(
      wins,
      vim.tbl_deep_extend(
        "force",
        {
          winnr = winnr,
          winid = winid,
        },
        vim.fn.getwininfo(winid),
        {
          pos = vim.api.nvim_win_get_position(winid),
          cursor = vim.fn.getcurpos(),
        }
      )
    )
  end

  if type(filter) == "function" then
    return filter(bufs)
  end

  return filter_tbl(bufs, filter)
end

-- 'hidden', 'listed', 'loaded', 'changed', 'windows'
M.get_buffers = function(filter)
  local bufs = {}

  local bufnrs = type(filter) == "number" and {
    filter,
  } or is_numberslist(filter) and filter or vim.api.nvim_list_bufs()

  for _, bufnr in ipairs(bufnrs) do
    -- primary window id and winnr
    local wins = {}
    for _winid in ipairs(vim.fn.win_findbuf(bufnr)) do
      table.insert(
        wins,
        vim.tbl_deep_extend("force", {
          bufnr = bufnr,
          winnr = vim.fn.bufwinnr(bufnr),
          winid = _winid,
        }, vim.fn.getwininfo(_winid))
      )
    end

    local winid = vim.fn.bufwinid(bufnr)
    table.insert(
      bufs,
      vim.tbl_deep_extend("force", {
        bufnr = bufnr,
        -- primary winid/winnr
        winnr = vim.fn.bufwinnr(bufnr),
        winid = winid,
      }, vim.fn.getbufinfo(bufnr), { wins = wins })
    )
  end

  if type(filter) == "function" then
    return filter(bufs)
  end

  return filter_tbl(bufs, filter)
end

vim.dbglog(M.get_windows())
-- vim.dbglog(M.get_buffers())
-- return M
