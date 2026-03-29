local mapper = require("mapper")

local move = function(direction)
  return {
    "<cmd>lua require('tmux').move_" .. direction .. "()<cr>",
    "tmux navigate " .. direction,
  }
end

local resize = function(direction, large)
  local large_arg = large and "true" or ""
  return {
    "<cmd>lua require('tmux').resize_" .. direction .. "(" .. large_arg .. ")<cr>",
    "tmux resize " .. direction .. (large and " (large)" or ""),
  }
end

local map = function(modes, key, cmd)
  for _, mode in ipairs(modes) do
    local action = mode == "i" and "<esc>" .. cmd[1] or cmd[1]
    local opts = {
      desc = cmd[2],
      noremap = true,
      silent = true,
      nowait = true,
    }
    mapper.map(mode, key, action, opts)
  end
end

local keymaps = {}

keymaps.register = function(scope, mappings, options)
  scope = type(scope) == "string" and { scope } or scope
  local opts
  if options == nil then
    opts = { nowait = true }
  else
    opts = options
  end

  for _, s in ipairs(scope) do
    for key, value in pairs(mappings) do
      mapper.map(s, key, value, opts)
    end
  end
end

keymaps.setup_navigation = function()
  map({ "n", "i", "x" }, "<C-h>", move("left"))
  map({ "n", "i", "x" }, "<C-l>", move("right"))
  map({ "n", "i", "x" }, "<C-k>", move("top"))
  map({ "n", "i", "x" }, "<C-j>", move("bottom"))
end

keymaps.setup_resize = function()
  map({ "n", "i", "x" }, "<M-h>", resize("left"))
  map({ "n", "i", "x" }, "<M-l>", resize("right"))
  map({ "n", "i", "x" }, "<M-k>", resize("top"))
  map({ "n", "i", "x" }, "<M-j>", resize("bottom"))
  map({ "n", "i", "x" }, "<M-H>", resize("left", true))
  map({ "n", "i", "x" }, "<M-L>", resize("right", true))
  map({ "n", "i", "x" }, "<M-K>", resize("top", true))
  map({ "n", "i", "x" }, "<M-J>", resize("bottom", true))
end

return keymaps
