local state = require('histories.state')
local utils = require('histories.utils')

local get_hash = function(vis)
  return vim.fn.sha256(vim.fn.json_encode(vis))
end

local get_pos = function()
  local pos = vim.fn.getpos
  local curr = {
    select = {
      from = pos("'<"),
      to = pos("'>"),
    },
    change = { from = pos("'["), to = pos("']") },
  }
  local hash = {
    select = get_hash(curr.select),
    change = get_hash(curr.change),
  }
  return curr, hash
end

local has_valid_range = function(vis)
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local from_line = vis.from[2]
  local to_line = vis.to[2]
  local buf = vim.api.nvim_buf_get_lines(bufnr, from_line - 1, to_line, true)
  return #buf > 0 and vis.name == bufname
end

local log = function()
  for i, vis in ipairs(state.selects) do
    -- local timeago = vim.fn.strftime('%c', vis.time)
    local time_ago = os.difftime(os.time(), vis.time) + 1
    vim.dbglog(
      utils.right_align(#state.selects - i + 1, 3),
      utils.right_align(time_ago, 4),
      vis.type,
      utils.right_align(vis.from[2], 3)
        .. ':'
        .. utils.left_align(vis.from[3], 3)
        .. ' '
        .. utils.right_align(vis.to[2], 3)
        .. ':'
        .. utils.left_align(vis.to[3], 10),
      vim.fn.substitute(vis.name, vim.fn.getcwd() .. '/', '', 'g')
    )
  end
end

return {
  log = log,
  has_valid_range = has_valid_range,
  get_pos = get_pos,
}
