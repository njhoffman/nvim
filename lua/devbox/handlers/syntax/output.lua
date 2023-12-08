local syn_utils = require('devbox.handlers.syntax.utils')
local ts_utils = require('nvim-treesitter.ts_utils')

local output_log = function(lines)
  for _, line in ipairs(lines) do
    vim.dbglog(line)
  end
end

local output_window = function(lines)
  return vim.lsp.util.open_floating_preview(lines, 'markdown', { border = 'single', pad_left = 4, pad_right = 4 })
end

local output_node = function(opts)
  local results = syn_utils.get_ts_node()
  local lines = syn_utils.get_node_lines(results)
  if opts.method == 'window' then
    output_window(lines)
  else
    output_log(lines)
  end
end

local output_hl = function(opts)
  local results = syn_utils.get_hl_captures()
  local lines = syn_utils.get_hl_lines(results)
  if opts.method == 'window' then
    output_window(lines)
  else
    output_log(lines)
  end
end

local get_node_lines = function(results, opts)
  opts = vim.tbl_deep_extend('keep', opts or {}, {
    full_path = false,
    show_range = true,
    include_anonymous = false,
    highlight_node = true,
    hl_group = 'TSPlaygroundFocus',
  })

  local lines = { '# Treesitter' }
  local node_under_cursor

  for _, node in ipairs(results) do
    local path = opts.full_path and node.full_path or node.path
    node_under_cursor = node
    vim.list_extend(lines, {
      '* Parser: ' .. node.parser,
      string.format('* %s: ', opts.full_path and 'Node path' or 'Node') .. path,
    })

    if opts.include_anonymous then
      vim.list_extend(lines, {
        ' - Anonymous: ' .. node.anonymous,
      })
    end

    if opts.show_range then
      vim.list_extend(lines, {
        '* Range: ',
        '  - Start row: ' .. node.start_row,
        '  - End row: ' .. node.end_row,
        '  - Start col: ' .. node.start_col,
        '  - End col: ' .. node.end_col,
      })
    end
  end

  if not node_under_cursor then
    lines[#lines + 1] = '* Node not found'
  end

  if opts.highlight_node and node_under_cursor then
    local ns = vim.api.nvim_create_namespace('nvim-treesitter-current-node')

    ts_utils.highlight_node(node_under_cursor, bufnr, ns, opts.hl_group)
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = vim.api.nvim_create_augroup('TSNodeUnderCursor', {}),
      buffer = bufnr,
      callback = function()
        require('nvim-treesitter-playground.internal').clear_highlights(bufnr, ns)
      end,
      desc = 'TSPlayground: clear highlights',
    })
  end
  return lines
end

local get_hl_lines = function(results)
  local lines = {}
  for source, matches in pairs(results) do
    table.insert(lines, '# ' .. source)
    for _, match in ipairs(matches) do
      table.insert(lines, match)
    end
    if #lines == 0 then
      table.insert(lines, '* No highlight groups found')
    end
  end

  return lines
end

return {
  node_lines = get_node_lines,
  hl_lines = get_hl_lines,
  output_hl = output_hl,
  output_node = output_node,
}
