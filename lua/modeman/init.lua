local logger = require("modeman.logger")
local visual = require("modeman.state.visual")
local operator = require("modeman.state.operator")
local ns = require("modeman.namespace")
local state = require("modeman.state")

local function mode_get_state(ev)
  local match = type(ev) == "table" and vim.fn.empty(ev.match) == 0 and ev.match
    or ":" .. vim.fn.mode(true)
  local from, mode = table.unpack(vim.split(match, ":"))
  return {
    from = vim.fn.empty(from) == 0 and vim.fn.keytrans(from),
    mode = vim.fn.empty(mode) == 0 and vim.fn.keytrans(mode),
    buf = ev and ev.buf or vim.api.nvim_get_current_buf(),
  }
end

local refresh_state = function(event)
  local curr = mode_get_state(event)
  local op_state = operator.get_state(curr)
  local vis_state = visual.get_state(curr)
  local new_state = vim.tbl_deep_extend("force", curr, op_state or {}, vis_state or {})

  if not vim.deep_equal(state.curr, new_state) then
    state.last = vim.fn.deepcopy(state.curr or {})
    state.curr = new_state
  end
  logger.log_mode(state.curr)
  -- vim.dbglog(vim.inspect(state.curr, { newline = "" }), vim.inspect(state.last, { newline = "" }))
end

refresh_state()

vim.api.nvim_create_autocmd("ModeChanged", {
  group = ns.augroup_id,
  pattern = "*:*",
  desc = "modeman: watches for mode changes to update highlights and run callbacks",
  callback = refresh_state,
})

return state
