local func_utils = require('treesitter._utils')
local ts_utils = require('nvim-treesitter.ts_utils')

-- get_named_children
-- get_next_node
-- get_node_at_cursor
-- get_node_range
-- get_node_text
-- get_previous_node
-- get_root_for_node
-- get_root_for_position
-- get_vim_range
-- goto_node
-- highlight_node
-- highlight_range
-- is_in_node_range
-- is_parent
-- memoize_by_buf_tick
-- node_length
-- node_to_lsp_range
-- swap_nodes
-- update_selection
-- Functions to Execute --

local function print_types(desired_types) -- {{{
  vim.cmd("m'")

  local api = vim.api

  current_desired_types = desired_types

  local nodes = get_nodes_in_array()

  local current_window = api.nvim_get_current_win()
  local current_line = vim.api.nvim_win_get_cursor(current_window)[1]

  local nodes_before_cursor = {}
  local nodes_after_cursor = {}

  local hash_table = {}

  for _, node in ipairs(nodes) do
    local start_row, start_col, end_row, end_col = node:range()

    if start_row + 1 < current_line then
      table.insert(nodes_before_cursor, node)
    elseif start_row + 1 > current_line then
      table.insert(nodes_after_cursor, node)
    end
  end

  local color_group = M.opts.highlight_group

  -- loop backwards through nodes_before_cursor
  local count = 1
  for i = #nodes_before_cursor, 1, -1 do
    local node = nodes_before_cursor[i]
    local node_type = node:type()
    local start_row, start_col = node:range()

    if not M.opts.left_hand_side[count] then
      break
    end

    if has_value(desired_types, node_type) then
      if start_col - 1 < 0 then
        start_col = 0
      else
        -- start_col = start_col - 1
        start_col = start_col
      end
      api.nvim_buf_set_extmark(0, ns, start_row, start_col, {
        virt_text = { { M.opts.left_hand_side[count], color_group } },
        virt_text_pos = 'overlay',
      })

      api.nvim_buf_set_extmark(0, ns, start_row, -1, {
        virt_text = { { ' ' .. M.opts.left_hand_side[count] .. ' <-- ' .. node_type, color_group } },
        virt_text_pos = 'eol',
      })

      hash_table[M.opts.left_hand_side[count]] = {}
      hash_table[M.opts.left_hand_side[count]].start_row = start_row
      hash_table[M.opts.left_hand_side[count]].start_col = start_col

      count = count + 1
    end
  end

  count = 1
  for i = 1, #nodes_after_cursor do
    local node = nodes_after_cursor[i]
    local node_type = node:type()
    local start_row, start_col = node:range()

    if not M.opts.right_hand_side[count] then
      break
    end

    if has_value(desired_types, node_type) then
      if start_col - 1 < 0 then
        start_col = 0
      else
        -- start_col = start_col - 1
        start_col = start_col
      end
      api.nvim_buf_set_extmark(0, ns, start_row, start_col, {
        virt_text = { { M.opts.right_hand_side[count], color_group } },
        virt_text_pos = 'overlay',
      })

      api.nvim_buf_set_extmark(0, ns, start_row, -1, {
        virt_text = {
          { ' ' .. M.opts.right_hand_side[count] .. ' <-- ' .. node_type, color_group },
        },
        virt_text_pos = 'eol',
      })

      hash_table[M.opts.right_hand_side[count]] = {}
      hash_table[M.opts.right_hand_side[count]].start_row = start_row
      hash_table[M.opts.right_hand_side[count]].start_col = start_col

      count = count + 1
    end
  end

  local key_count = 0
  for _, _ in pairs(hash_table) do
    key_count = key_count + 1
  end
  if key_count == 0 then
    return
  end

  vim.cmd([[redraw]])

  local ok, keynum = pcall(vim.fn.getchar)
  if ok then
    local key = string.char(keynum)
    if hash_table[key] then
      local start_row = hash_table[key].start_row + 1
      local start_col = hash_table[key].start_col

      vim.api.nvim_win_set_cursor(current_window, { start_row, start_col })
    end
  end

  api.nvim_buf_clear_namespace(0, ns, 0, -1)
end --}}}
