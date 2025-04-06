local state = require("histories.state")
local select_utils = require("histories.selects.utils")

local last = { select = nil, change = nil }

local ns = vim.api.nvim_create_namespace("selects")

local add_select = function(curr, hash)
  -- let g:mark_id = nvim_buf_set_extmark(0, g:mark_ns, 0, 2, {})
  vim.dbglog("add", curr, hash)
  if
    last.select ~= hash.select
    and vim.fn.join(curr.select.from, " ") ~= vim.fn.join(curr.select.to, " ")
  then
    local extmark_id =
      vim.api.nvim_buf_set_extmark(curr.select.to[1], ns, curr.select.from[2] - 1, 0, {
        virt_text = { { "-" .. #state.selects, "Comment" } },
        virt_text_pos = "right_align",
      })
    if curr.select.from[2] ~= curr.select.to[2] then
      local extmark_id =
        vim.api.nvim_buf_set_extmark(curr.select.to[1], ns, curr.select.to[2] - 1, 0, {
          virt_text = { { "select-" .. #state.selects, "Comment" } },
          virt_text_pos = "right_align",
        })
    end

    table.insert(
      state.selects,
      vim.tbl_deep_extend("force", {}, curr.select, {
        id = extmark_id,
        name = vim.api.nvim_buf_get_name(curr.select.to[1]),
        time = os.time(),
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
        vim.dbglog(curr)

        -- add_select(curr, hash)
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

watch()

-- return { watch = watch }
