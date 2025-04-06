local updatetime = vim.api.nvim_get_option_value("updatetime", { scope = "global" })

local termcode = function(str)
  return vim.api.nvim_replace_termcodes(str, true, false, true)
end

-- -- local key_state = { typed = nil, keys = {} }
-- local log_key = function(parsed)
--   -- vim.dbglog(parsed.typed, parsed.keymap)
--   local mode = vim.dbglog(
--     string.format(
--       "%-6s %5s    %s",
--       "(" .. vim.fn.mode(true) .. ")",
--       vim.fn.strtrans(parsed.typed[2]),
--       vim.fn.strtrans(parsed.keymap[2])
--     )
--   )
-- end

-- local parse_key = function(keymap, typed)
--   local parse = function(key)
--     return { vim.fn.strtrans(key), vim.fn.keytrans(key) }
--   end

--   local parsed = {
--     typed = parse(typed),
--     keymap = parse(keymap),
--     mode = termcode(vim.fn.mode(true)),
--   }
--   vim.dbglog(parsed.typed, parsed.keymap)
--   log_key(parsed)
-- end

local state = { key = {}, timer_id = nil }

local onkey = function(keymap, typed)
  vim.dbglog(
    string.format("'%s' %16s", vim.fn.strtrans(vim.fn.keytrans(typed)), vim.fn.strtrans(keymap))
  )

  -- if  timer_id == nil then
  --   state.timer_id = vim.fn.timer_start(updatetime, function()

  --   end
  -- end
  -- table.insert(state.keys, { typed, keymap, vim.fn.getmode() })
  -- table.insert(keys, { typed, keymap, vim.fn.getmode() })

  --  typed is raw key input, keymap is after mappings applied
  -- parse_key(keymap, typed)
end

local ns_id = vim.api.nvim_create_namespace("keyutils")
vim.on_key(nil, ns_id)
vim.on_key(onkey, ns_id)
