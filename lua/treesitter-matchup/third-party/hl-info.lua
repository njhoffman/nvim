-- From https://github.com/nvim-treesitter/playground
-- Copyright 2021
-- licensed under the Apache License 2.0
-- See nvim-treesitter.LICENSE-APACHE-2.0

local ts = vim.treesitter
local utils = require "treesitter-matchup.third-party.utils"
local highlighter = require "vim.treesitter.highlighter"

local M = {}

function M.get_treesitter_hl(cursor)
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = unpack(cursor or vim.api.nvim_win_get_cursor(0))
  row = row - 1

  local results = utils.get_hl_groups_at_position(bufnr, row, col)
  local highlights = {}
  for _, hl in pairs(results) do
    local line = { "@" .. hl.capture }
    if hl.priority then
      table.insert(line, hl.priority)
    end
    table.insert(highlights, line)
  end
  return highlights
end

function M.active()
  local buf = vim.api.nvim_get_current_buf()
  if highlighter.active[buf] then
    return true
  end
  return false
end

return M
