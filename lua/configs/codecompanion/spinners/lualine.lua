local M = {}
local state = {
  last_status = "Idle",
  animation = { "...", ".. ", ".  " },
  completed_time = nil,
}
function M.update_status(event)
  if event == "CodeCompanionRequestStarted" then
    state.last_status = "Awaiting Response"
    state.completed_time = nil
  elseif event == "CodeCompanionRequestStreaming" then
    state.last_status = "Streaming"
    state.completed_time = nil
  elseif event == "CodeCompanionRequestFinished" then
    state.last_status = "Completed"
    state.completed_time = vim.uv and vim.uv.hrtime() or nil
  elseif event == "CodeCompanionRequestError" then
    state.last_status = " Error"
    state.completed_time = nil
  elseif event == "CodeCompanionRequestCancelled" then
    state.last_status = "󰜺 Cancelled"
    state.completed_time = nil
  else
    state.last_status = "Idle"
    state.completed_time = nil
  end
end

function M.component()
  if state.last_status == "Awaiting Response" or state.last_status == "Streaming" then
    if vim.uv and vim.uv.hrtime then
      local animation_index = math.floor(vim.uv.hrtime() / (1e6 * 80)) % #state.animation + 1
      return state.last_status .. state.animation[animation_index]
    end
    return state.last_status
  elseif state.last_status == "Completed" then
    if
      state.completed_time
      and vim.uv
      and vim.uv.hrtime
      and (vim.uv.hrtime() - state.completed_time) > 2e9
    then
      state.last_status = "Idle"
      return ""
    end
    return state.last_status
  end
  return state.last_status ~= "Idle" and state.last_status or ""
end

vim.api.nvim_create_autocmd("User", {
  pattern = {
    "CodeCompanionRequestStarted",
    "CodeCompanionRequestStreaming",
    "CodeCompanionRequestFinished",
    "CodeCompanionRequestError",
    "CodeCompanionRequestCancelled",
  },
  callback = function(args)
    if args.match then
      M.update_status(args.match)
    end
  end,
})

return M.component
