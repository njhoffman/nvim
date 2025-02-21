local assign = require("alt.assign")
local alt = require("alt.alt")
local state = require("alt.state")

local setup = function()
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = state.augroup_id,
    callback = assign.lookupAltFile,
  })

  vim.api.nvim_create_user_command(
    "AltAssign",
    assign.assignAltFile,
    { desc = "assign current alt file persistently" }
  )

  vim.api.nvim_create_user_command(
    "AltInspect",
    assign.inspectState,
    { desc = "output alt file state information" }
  )

  vim.api.nvim_create_user_command(
    "AltReopen",
    alt.reopenBuffer,
    { desc = "reopen the last closed buffer" }
  )

  vim.api.nvim_create_user_command(
    "AltLoad",
    alt.gotoAltBuffer,
    { desc = "goto the enhanced alternative buffer" }
  )

  vim.api.nvim_create_user_command(
    "AltClose",
    alt.betterClose,
    { desc = "smart window close with alt buffers" }
  )

  -- AltSelect, AltClear
end

return { setup = setup, statusline = alt.altStatusline }
