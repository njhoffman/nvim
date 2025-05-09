local state = require("histories.state")
local select_utils = require("histories.selects.utils")

local last_hash = nil

local ns = vim.api.nvim_create_namespace("selects")

local create_mark = function(curr)
  -- let g:mark_id = nvim_buf_set_extmark(0, g:mark_ns, 0, 2, {})
  local end_line_length =
    vim.api.nvim_buf_get_lines(curr.pos.to[1], curr.pos.to[2] - 1, curr.pos.to[2], false)[1]:len()
  local end_col = curr.pos.to[3] == vim.v.maxcol and end_line_length or curr.pos.to[3]

  local mark =
    vim.api.nvim_buf_set_extmark(curr.pos.from[1], ns, curr.pos.from[2] - 1, curr.pos.from[3], {
      -- hl_group = "VisualRed",
      end_row = curr.pos.to[2] - 1,
      end_col = end_col,
    })
  return mark
end

local get_mark = function(mark_id, buf)
  return vim.api.nvim_buf_get_extmark_by_id(buf or 0, ns, mark_id, { details = true })
end

local truncate = function(buf, len)
  local new_state = {}
  local count = 0
  for _, v in ipairs(state.selects) do
    if v.buf == buf then
      count = count + 1
      if count <= len then
        table.insert(new_state, v)
      end
    else
      table.insert(new_state, v)
    end
  end
  state.selects = new_state
end

local add_select = function(curr, hash, max)
  if last_hash ~= hash and vim.fn.join(curr.pos.from, " ") ~= vim.fn.join(curr.pos.to, " ") then
    table.insert(state.selects, {
      hash = hash,
      buf = curr.buffer,
      type = curr.type,
      mark = create_mark(curr),
      name = vim.api.nvim_buf_get_name(curr.pos.to[1]),
      time = os.time(),
    })
    vim.dbglog("select", #state.selects, state.selects[#state.selects])
    last_hash = hash
  end

  truncate(curr.buffer, max)
end

-- return visual_str[tostring(vim.fn.mode())]
local watch = function(max)
  vim.api.nvim_create_autocmd({ "ModeChanged" }, {
    group = state.augroup,
    pattern = "*:*",
    desc = "Track changes out of visual mode to track selects history",
    callback = function(ev)
      local from, _ = unpack(vim.split(ev.match, ":"))
      if vim.tbl_contains({ "v", "V", "" }, from) then
        local curr, hash = select_utils.get_select_pos(ev.buf, from)
        add_select(curr, hash, max)
        -- select_utils.log()
      end
    end,
  })
end

-- vim.paste = (function(overridden)
--   return function(lines, phase)
--     overridden(lines, phase)
--   end
-- end)(vim.paste)

watch(5)

-- return { watch = watch }
