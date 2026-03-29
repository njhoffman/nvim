local keymaps = require("tmux.keymaps")
local options = require("tmux.configuration.options")
local resize = require("tmux.resize.resize")

local M = {}
function M.setup()
  if options.resize.default_keymaps then
    keymaps.register("n", {
      ["<M-h>"] = [[<cmd>lua require'tmux'.resize_left()<cr>]],
      ["<M-j>"] = [[<cmd>lua require'tmux'.resize_bottom()<cr>]],
      ["<M-k>"] = [[<cmd>lua require'tmux'.resize_top()<cr>]],
      ["<M-l>"] = [[<cmd>lua require'tmux'.resize_right()<cr>]],
    })
  end
end

function M.to_left(large)
  resize.to("left", large)
end

function M.to_bottom(large)
  resize.to("down", large)
end

function M.to_top(large)
  resize.to("up", large)
end

function M.to_right(large)
  resize.to("right", large)
end

return M
