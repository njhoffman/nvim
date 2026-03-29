local M = {}

function M.apply()
  local p = require("colorschemes.nord-nick.palette")
  require("colorschemes.nord-nick.editor").apply(p)
  require("colorschemes.nord-nick.syntax").apply(p)
  require("colorschemes.nord-nick.plugins").apply(p)
end

return M
