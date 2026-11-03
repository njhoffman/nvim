local M = {}

local highlighter = require("vim.treesitter.highlighter")

--- Find all positions where a highlight group is active in a buffer.
--- @param bufnr number
--- @param target_group string The highlight group to search for
--- @return table List of { lnum: number, col: number, end_col: number, capture: string }
local function find_hl_in_buffer(bufnr, target_group)
  local results = {}
  local buf_hl = highlighter.active[bufnr]
  if not buf_hl then
    return results
  end

  local line_count = vim.api.nvim_buf_line_count(bufnr)

  buf_hl.tree:for_each_tree(function(tstree, tree)
    if not tstree then
      return
    end

    local query = buf_hl:get_query(tree:lang())
    if not query or not query:query() then
      return
    end

    local root = tstree:root()
    local iter = query:query():iter_captures(root, bufnr, 0, line_count)

    for capture, node, _ in iter do
      local c = query._query.captures[capture]
      if not c then
        goto continue
      end

      -- Check if this capture's effective hl group matches the target
      local capture_hl = "@" .. c
      local resolved = vim.api.nvim_get_hl(0, { name = capture_hl, link = true })

      local matches = false
      if capture_hl == target_group then
        matches = true
      elseif resolved and resolved.link then
        -- Follow the link chain
        local seen = {}
        local current = resolved.link
        while current and not seen[current] do
          if current == target_group then
            matches = true
            break
          end
          seen[current] = true
          local next_hl = vim.api.nvim_get_hl(0, { name = current, link = true })
          current = next_hl and next_hl.link or nil
        end
      end

      if matches then
        local start_row, start_col, end_row, end_col = node:range()
        table.insert(results, {
          lnum = start_row + 1,
          col = start_col + 1,
          end_lnum = end_row + 1,
          end_col = end_col,
          capture = capture_hl,
        })
      end

      ::continue::
    end
  end, true)

  return results
end

--- Find where a highlight group is used across all open buffers.
--- Populates the quickfix list with results.
--- @param group_name string
function M.find_usage(group_name)
  local qf_items = {}

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if not vim.api.nvim_buf_is_loaded(bufnr) then
      goto continue
    end

    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if bufname == "" then
      goto continue
    end

    local results = find_hl_in_buffer(bufnr, group_name)
    for _, r in ipairs(results) do
      table.insert(qf_items, {
        bufnr = bufnr,
        lnum = r.lnum,
        col = r.col,
        text = string.format("[%s] via %s", group_name, r.capture),
      })
    end

    ::continue::
  end

  if #qf_items == 0 then
    vim.notify("No usage of '" .. group_name .. "' found in open buffers", vim.log.levels.INFO)
    return
  end

  vim.fn.setqflist({}, "r", {
    title = "Highlight Usage: " .. group_name,
    items = qf_items,
  })
  vim.cmd("copen")
end

return M
