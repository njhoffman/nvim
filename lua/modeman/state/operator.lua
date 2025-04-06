local state = require("modeman.state")
local opfunc_defs = require("modeman.config.operator-map") or {}
local ns_op = vim.api.nvim_create_namespace("modeman/operator")

local is_op_mode = function(mode)
  return type(mode) == "string" and (mode:find("no") ~= nil)
end

local get_op = function(mode)
  return is_op_mode(mode) and vim.v.operator
end

local is_opfunc_mode = function(mode)
  return get_op(mode) == "g@"
end

local get_opfunc = function(mode)
  if not is_opfunc_mode(mode) then
    return nil
  end

  local opfunc =
    tostring(vim.api.nvim_get_option_value("operatorfunc", { scope = "global" })):gsub("'", '"')

  if not opfunc or opfunc == "" then
    return nil
  end

  if not opfunc_defs[opfunc] then
    return { opfunc = opfunc }
  end

  local opkeys, opdesc = table.unpack(opfunc_defs[opfunc])
  return { opfunc = opfunc, opkeys = opkeys, opdesc = opdesc }
end

local mode_to = function(curr, op_state)
  op_state =
    vim.tbl_deep_extend("force", op_state, { op = get_op(curr.mode) }, get_opfunc(curr.mode) or {})
  if op_state.opfunc then
    local oplist = not op_state.opkeys and state.opfuncs.missed or state.opfuncs.matched
    oplist[op_state.opfunc] = oplist[op_state.opfunc] and oplist[op_state.opfunc] + 1 or 0
  end
  return op_state
end

local key_state = { typed = nil, keys = {} }
local onkey = function(key, typed)
  -- key is after mappings applied, typed is before mappings applied
  -- if key == '\27' then was_cancelled = true end
  local trans = { key = vim.fn.keytrans(key), typed = vim.fn.strtrans(typed) }
  vim.dbglog("operator", key, typed, trans.key, trans.typed)
  if type(trans.key) == "string" and #trans.key > 0 then
    if type(trans.typed) == "string" and #trans.typed > 0 then
      key_state.typed = trans.typed
      table.insert(key_state.keys, trans.typed)
    else
      table.insert(key_state.keys, trans.key)
    end
  end
end

local get_state = function(curr)
  local op_state = {}
  if is_op_mode(curr.mode) then
    op_state = mode_to(curr, op_state)
    vim.on_key(onkey, ns_op)
  elseif is_op_mode(curr.from) then
    vim.on_key(nil, ns_op)
    if type(key_state.typed) == "string" and #key_state.typed > 0 then
      op_state = vim.tbl_deep_extend("force", op_state, key_state)
    end
    -- vim.dbglog(
    --   "op_from",
    --   vim.inspect(key_state, { newline = "" }),
    --   vim.inspect(op_state, { newline = "" })
    -- )
    key_state = { typed = nil, keys = {} }
  end
  return op_state
end

return { get_state = get_state }
