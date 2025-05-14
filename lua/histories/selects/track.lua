local state = require("histories.state")
local utils = require("histories.selects.utils")

local last_hash = nil

local truncate = function(selects, buf, len)
  local new_state = {}
  local count = 0
  for _, v in ipairs(selects) do
    if v.buf == buf then
      count = count + 1
      if count <= len then
        table.insert(new_state, v)
      end
    else
      table.insert(new_state, v)
    end
  end
  return new_state
end

local add_select = function(curr, hash, max)
  if last_hash ~= hash and vim.fn.join(curr.pos.from, " ") ~= vim.fn.join(curr.pos.to, " ") then
    table.insert(state.selects, {
      hash = hash,
      buf = curr.buffer,
      type = curr.type,
      mark = utils.create_mark(curr.pos),
      name = vim.api.nvim_buf_get_name(curr.pos.to[1]),
      time = os.time(),
    })
    vim.dbglog("select add", #state.selects, state.selects[#state.selects], curr.pos)
    last_hash = hash
  end

  state.selects = truncate(state.selects, curr.buffer, max)
  state.select_idx = 0
end
local is_visual = function()
  return vim.tbl_contains({ "v", "V", "\22" }, vim.fn.mode())
end

local next = function()
  local selects = vim.fn.filter(state.selects, "v:val.buf == " .. vim.fn.bufnr())
  if #selects == 0 then
    state.select_idx = 0
    return
  end
  if is_visual() or state.select_idx == 0 then
    state.select_idx = state.select_idx + 1
  end
  state.select_idx = state.select_idx > #selects and 1 or state.select_idx
  vim.dbglog(state.select_idx)
  local select = selects[state.select_idx]
  local mark_range = utils.get_mark_range(select.mark, select.buf)
  vim.dbglog(mark_range, select)
  utils.select_range(mark_range, select.type)
end
local setup_keymaps = function()
  vim.keymap.set("n", "<C-5>", next, { noremap = true, silent = true })
  vim.keymap.set("x", "<C-5>", next, { noremap = true, silent = true })
end

-- return visual_str[tostring(vim.fn.mode())]
local watch = function(max)
  setup_keymaps()

  vim.api.nvim_create_autocmd({ "ModeChanged" }, {
    group = state.augroup,
    pattern = "*:*",
    desc = "Track changes out of visual mode to track selects history",
    callback = function(ev)
      local from, _ = unpack(vim.split(ev.match, ":"))
      if vim.tbl_contains({ "v", "V", "" }, from) then
        local curr, hash = utils.get_select_pos(ev.buf, from)
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
