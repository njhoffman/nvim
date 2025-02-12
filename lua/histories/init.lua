local providers = require("histories.providers")

local create_commands = function()
  vim.api.nvim_create_user_command("HistoryOpen", providers.start, {
    nargs = "?",
    complete = function()
      return { "changes", "jumps", "visual", "files" }
    end,
  })
end

local setup = function()
  create_commands()
  for _, provider in pairs(providers.providers) do
    if type(provider) == "table" and type(provider.init) == "function" then
      provider.init()
    end
  end
end

return { setup = setup }
