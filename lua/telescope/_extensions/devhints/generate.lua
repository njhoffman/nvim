local output = require("devhints.output")

local get_devhints = function()
  local titles = output.all_titles()
  vim.dbglog("DEV", titles.parsed)
  return titles.parsed
end

return {
  get_devhints = get_devhints,
}
