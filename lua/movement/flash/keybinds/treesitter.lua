local Flash = lambda.reqidx('flash')
local lib = require('movement.flash.nav')

local gen_dyn_matcher = function(gen_query, check)
  if type(gen_query) ~= 'function' then
    vim.notify(
      '@param{gen_query} in function{gen_dyn_matcher} must be a function that returns the treesitter query string',
      vim.log.levels.ERROR
    )
    return
  end
  check = check or 'full'

  return function(win, state)
    local wininfo = vim.fn.getwininfo(win)[1]
    local wintop = wininfo.topline - 1 ---@type number
    local winbot = wininfo.botline + 1 ---@type number
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_filetype = vim.fn.getbufvar(buf, '&filetype') or 'lua'
    local pattern_string = state.pattern.pattern

    local ranges = {} ---@type TSNode[]
    local matches = {} ---@type Flash.Match[]

    local parser = vim.treesitter.get_parser(buf)
    local syntax_tree = parser:parse()[1]
    local root = syntax_tree:root()
    local search_query = vim.treesitter.query.parse(buf_filetype, gen_query(pattern_string))

    for _, node, _ in search_query:iter_captures(root, buf, wintop, winbot) do
      table.insert(ranges, { node:range() })
    end

    for _, range in ipairs(ranges) do
      ---@type Flash.Match
      local match = {
        pos = { range[1] + 1, range[2] },
        end_pos = { range[3] + 1, range[4] - 1 },
      }
      local start_in_view = match.pos[1] > wintop and match.pos[1] < winbot
      local end_in_view = match.end_pos[1] > wintop and match.end_pos[1] < winbot
      local fully_in_view = start_in_view and end_in_view

      local test ---@type boolean
      if check == 'end' then
        test = end_in_view
      end
      if check == 'start' then
        test = start_in_view
      end
      if check == 'full' then
        test = fully_in_view
      end

      if test then
        table.insert(matches, match)
      end
    end

    return matches
  end
end

local basic_query = function(pattern_string)
  return ([[
  (
  (identifier) @capture
  (#match? @capture "^%s")
  )
  ]]):format(pattern_string)
end

local M = {}

M.remote_node = function()
  require('flash').jump({ mode = 'remote_ts' })
end
M.tree_search = function()
  Flash.treesitter_search({
    label = { before = true, after = true, style = 'inline' },
    remote_op = { restore = true },
  })
end
M.tree_search_op = function()
  Flash.treesitter_search({
    label = { before = true, after = true, style = 'inline' },
    remote_op = { restore = true },
  })
end

M.select_remote_dynamic = function()
  require('flash').jump({ mode = 'remote_ts' })
end
M.select_remote_next = function()
  require('flash').jump({ mode = 'remote_ts', treesitter = { starting_from_pos = true } })
end
M.select_remote_prev = function()
  require('flash').jump({ mode = 'remote_ts', treesitter = { ending_at_pos = true } })
end
M.select_remote_start = function()
  require('flash').jump({
    mode = 'remote_ts',
    treesitter = { start_of_node = true },
    jump = { pos = 'start' },
  })
end
M.select_remote_end = function()
  require('flash').jump({
    mode = 'remote_ts',
    treesitter = { end_of_node = true },
    jump = { pos = 'end' },
  })
end
M.select_cword = function()
  require('flash').jump({ mode = 'textcase', pattern = vim.fn.expand('<cword>') })
end
M.select_word = function()
  require('flash').jump({ mode = 'textcase', pattern = vim.fn.expand('<cWORD>') })
end
M.select_continue = function()
  require('flash').jump({ continue = true })
end

M.exchange_node = function()
  lib.swap_with({ mode = 'remote_ts' })
end
M.exchange_motion = function()
  lib.swap_with()
end
M.exchange_vline = function()
  lib.swap_with({ exchange = { visual_mode = 'V' } })
end
M.replace_remote = function()
  vim.api.nvim_feedkeys(';r', 'm', false)
  vim.schedule(function()
    require('flash').jump({ mode = 'remote_ts' })
  end)
end
M.replace_remote_motion = function()
  lib.swap_with({ exchange = { not_there = true } })
end
M.replace_remote_d_motion = function()
  lib.swap_with({ exchange = { not_there = true } })
end
M.replace_remote_c_motion = function()
  lib.swap_with({ exchange = { not_there = true } })
end
M.replace_node = function()
  lib.swap_with({ mode = 'remote_ts', exchange = { not_there = true } })
end
M.replace_d_node = function()
  lib.swap_with({ mode = 'remote_ts', exchange = { not_there = true } })
end
M.replace_c_node = function()
  lib.swap_with({ mode = 'remote_ts', exchange = { not_there = true } })
end

M.treesitter_unit = function()
  Flash.treesitter({
    filter = function(matches)
      ---@param m Flash.Match.TS
      -- for all matches,  match[n+1] should use previous match[n] label. Do in reverse order, to prevet copying first label to all matches
      for i = #matches, 2, -1 do
        matches[i].label = matches[i - 1].label
      end
      table.remove(matches, 1) -- remove first match, as it is same as word under cursor thus redundant with word motion
    end,
    label = {
      rainbow = {
        enabled = true,
      },
    },
  })
end

M.treesitter_dynamic = function()
  Flash.jump({
    matcher = gen_dyn_matcher(basic_query),
    -- select the range
    jump = { pos = 'range' },
  })
end

return M
