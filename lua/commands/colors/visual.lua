local M = {}

local highlighter = require("vim.treesitter.highlighter")

--- Collect all highlight groups used in a buffer range.
--- @param bufnr number
--- @param start_row number 0-indexed
--- @param start_col number 0-indexed
--- @param end_row number 0-indexed
--- @param end_col number 0-indexed
--- @return table List of unique highlight group names
function M.collect_from_range(bufnr, start_row, start_col, end_row, end_col)
  local seen = {}
  local groups = {}

  local buf_hl = highlighter.active[bufnr]
  if not buf_hl then
    return groups
  end

  buf_hl.tree:for_each_tree(function(tstree, tree)
    if not tstree then
      return
    end

    local query = buf_hl:get_query(tree:lang())
    if not query or not query:query() then
      return
    end

    local root = tstree:root()
    local iter = query:query():iter_captures(root, bufnr, start_row, end_row + 1)

    for capture, node, _ in iter do
      local c = query._query.captures[capture]
      if not c then
        goto continue
      end

      local node_start_row, node_start_col, node_end_row, node_end_col = node:range()

      -- Check if node overlaps with the selection range
      local overlaps = not (
        node_end_row < start_row
        or (node_end_row == start_row and node_end_col <= start_col)
        or node_start_row > end_row
        or (node_start_row == end_row and node_start_col >= end_col)
      )

      if overlaps then
        local capture_name = "@" .. c
        if not seen[capture_name] then
          seen[capture_name] = true
          table.insert(groups, capture_name)
        end

        -- Also collect the resolved/linked group
        local resolved = vim.api.nvim_get_hl(0, { name = capture_name, link = true })
        if resolved and resolved.link and not seen[resolved.link] then
          seen[resolved.link] = true
          table.insert(groups, resolved.link)
        end
      end

      ::continue::
    end
  end, true)

  return groups
end

--- Visual selection handler: collect highlights from selection and open edit buffer.
--- @param opts table Command opts with range info
function M.from_visual(opts)
  local bufnr = vim.api.nvim_get_current_buf()
  local start_row = opts.line1 - 1
  local end_row = opts.line2 - 1

  -- Get column range from visual marks
  local start_col = 0
  local end_col = #(vim.api.nvim_buf_get_lines(bufnr, end_row, end_row + 1, false)[1] or "")

  local groups = M.collect_from_range(bufnr, start_row, start_col, end_row, end_col)

  if #groups == 0 then
    vim.notify("No highlight groups found in selection", vim.log.levels.INFO)
    return
  end

  local group_entries = {}
  for _, name in ipairs(groups) do
    table.insert(group_entries, { name = name })
  end

  require("commands.colors.edit_buffer").open(group_entries)
end

return M
