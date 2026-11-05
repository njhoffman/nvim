-- Sets up navigation keymaps and exposes the directional moves.

local keymaps = require("modules.tmux.keymaps")
local navigate = require("modules.tmux.navigation.navigate")
local options = require("modules.tmux.configuration.options")

local M = {}
function M.setup()
  if options.navigation.default_keymaps then
    keymaps.register({ "n", "x" }, {
      ["<C-h>"] = [[<cmd>lua require'modules.tmux'.move_left()<cr>]],
      ["<C-j>"] = [[<cmd>lua require'modules.tmux'.move_bottom()<cr>]],
      ["<C-k>"] = [[<cmd>lua require'modules.tmux'.move_top()<cr>]],
      ["<C-l>"] = [[<cmd>lua require'modules.tmux'.move_right()<cr>]],
    })
  end
end

function M.to_left()
  navigate.to("h")
end

function M.to_bottom()
  navigate.to("j")
end

function M.to_top()
  navigate.to("k")
end

function M.to_right()
  navigate.to("l")
end

return M
