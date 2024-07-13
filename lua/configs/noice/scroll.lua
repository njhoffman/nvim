-- scroll in a float window
local scroll_in_float_win = function(move_step)
  local windows = vim.api.nvim_list_wins()

  for _, winid in ipairs(windows) do
    -- the float window's relative is none,
    -- then we can capture the float window
    if vim.api.nvim_win_get_config(winid).relative ~= '' then
      local bufid = vim.api.nvim_win_get_buf(winid)
      local max_line_num = vim.api.nvim_buf_line_count(bufid)
      local col_idx = vim.api.nvim_win_get_cursor(winid)[2]

      if move_step < 0 then
        -- upward moving
        -- if the top visible line of the current window
        -- is the first line, then don't do any move
        local row_idx = vim.fn.getwininfo(winid)[1].topline

        if row_idx + move_step <= 0 then
          break
        end
        -- set the cursor to the top visible line - 1
        vim.api.nvim_win_set_cursor(winid, { row_idx + move_step, col_idx })
        break
      else
        -- downward moving
        -- if the bottom visible line of the current window
        -- is the last line, then don't do any move
        local row_idx = vim.fn.getwininfo(winid)[1].botline

        if row_idx + move_step > max_line_num then
          break
        end
        -- set the cursor to the bottom visible line + 1
        vim.api.nvim_win_set_cursor(winid, { row_idx + move_step, col_idx })
        break
      end
    end
  end
end

return { scroll_float = scroll_in_float_win }
