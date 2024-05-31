local async = require('hover.async')
local synutils = require('utils.syntax')

local state = {
  bufnr = nil,
  winid = nil,
}

local function enabled(done)
  state.bufnr = vim.api.nvim_get_current_buf()
  state.winid = vim.api.nvim_get_current_win()
  -- local has_parser = vim.treesitter.has_parser(state.bufnr)
  local has_parser = true
  local cursor = vim.api.nvim_win_get_cursor(state.winid)
  local synitems = vim.fn.synstack(cursor[1], cursor[2])
  done(has_parser or (type(synitems) == 'table' and #synitems > 0))
end

local execute = async.void(function(done)
  local captures = {
    hl = synutils.get_highlights({ bufnr = state.bufnr }),
    node = { synutils.get_node({ bufnr = state.bufnr, highlight_node = false }) },
  }

  local lines = { hl = {}, node = {} }
  if captures.node and #captures.node > 0 then
    lines.node = synutils.get_node_lines(captures.node)
  end
  if captures.hl and #captures.hl > 0 then
    lines.hl = synutils.get_hl_lines(captures.hl)
  end

  local function concat_array(a, b)
    local result = { table.unpack(a) }
    table.move(b, 1, #b, #result + 1, result)
    return result
  end

  done({
    lines = concat_array(lines.node, lines.hl),
    filetype = 'markdown',
  })
end)

require('hover').register({
  name = 'syntax',
  menu = 'Syntax',
  desc = 'Syntax Items',
  priority = 150,
  enabled = enabled,
  execute = execute,
})
