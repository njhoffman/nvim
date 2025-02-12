local state = require("histories.state")
local select_utils = require("histories.selects.utils")

local last = { select = nil, change = nil }

local ns = vim.api.nvim_create_namespace("selects")

local check_change = function(buf, curr, hash)
  if
    last.change ~= hash.change
    and vim.fn.join(curr.change.from, " ") ~= vim.fn.join(curr.change.to, " ")
  then
    local extmark_id =
      vim.api.nvim_buf_set_extmark(buf, ns, curr.change.from[2], curr.change.from[3], {
        end_row = curr.change.to[2],
        end_col = curr.change.to[3],
        virt_text = { { "change-" .. #state.selects, "Comment" } },
        virt_text_pos = "right_align",
      })
    table.insert(
      state.selects,
      vim.tbl_deep_extend("force", {}, curr.change, {
        id = extmark_id,
        name = vim.api.nvim_buf_get_name(curr.change.to[1]),
        time = os.time(),
        type = "change",
      })
    )
    vim.dbglog("change", #state.selects, state.selects[#state.selects])
    last.change = hash.change
  end
end

local check_select = function(curr, hash)
  -- let g:mark_id = nvim_buf_set_extmark(0, g:mark_ns, 0, 2, {})
  if
    last.select ~= hash.select
    and last.change ~= hash.select
    and vim.fn.join(curr.select.from, " ") ~= vim.fn.join(curr.select.to, " ")
  then
    local extmark_id = vim.api.nvim_buf_set_extmark(
      curr.change.to[1],
      ns,
      curr.change.from[2],
      curr.change.from[3],
      {
        end_row = curr.change.to[2],
        end_col = curr.change.to[3],
        virt_text = { { "select-" .. #state.selects, "Comment" } },
        virt_text_pos = "right_align",
      }
    )
    table.insert(
      state.selects,
      vim.tbl_deep_extend("force", {}, curr.select, {
        id = extmark_id,
        name = vim.api.nvim_buf_get_name(curr.select.to[1]),
        time = os.time(),
        type = "select",
      })
    )
    vim.dbglog("select", #state.selects, state.selects[#state.selects])
    last.select = hash.select
  end
  -- local max = 10
  -- trim entries after max_selects
  -- for _ = 1, #state.selects - max do
  --   table.remove(state.selects, 1)
  -- end
end

local visual_str = {
  ["v"] = true, -- Visual by character
  ["vs"] = true, -- Visual by character using |v_CTRL-O| in Select mode
  ["V"] = true, -- Visual by line
  ["Vs"] = true, -- Visual by line using |v_CTRL-O| in Select mode
  ["CTRL-V"] = true, -- Visual blockwise
  [""] = true, -- Visual blockwise
  ["CTRL-Vs"] = true, -- Visual blockwise using |v_CTRL-O| in Select mode
}
-- return visual_str[tostring(vim.fn.mode())]
local watch = function(max)
  vim.api.nvim_create_autocmd({ "ModeChanged" }, {
    group = state.augroup,
    pattern = "*:*",
    desc = "Track changes out of visual mode to track selects history",
    callback = function(ev)
      local from, _ = unpack(vim.split(ev.match, ":"))
      if vim.tbl_contains({ "v", "V", "" }, from) then
        local curr, hash = select_utils.get_pos(ev.buf, from)
        -- check_change(curr, hash)
        check_select(curr, hash)
        -- select_utils.log()
      end
    end,
  })
end

-- vim.paste = (function(overridden)
--   return function(lines, phase)
--     for i,line in ipairs(lines) do
--       -- Scrub ANSI color codes from paste input.
--       lines[i] = line:gsub('\27%[[0-9;mK]+', '')
--     end
--     overridden(lines, phase)
--   end
-- end)(vim.paste)
watch()

-- return { watch = watch }
