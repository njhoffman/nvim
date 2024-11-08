-- local lsp = require("configs.hydra.lsp")
local options = require("configs.hydra.options")
local window = require("configs.hydra.window")

local hydras = {}
-- hydras.lsp = lsp.hydra()
hydras.options = options.hydra()
hydras.window = window.hydra()

-- TODO: options to add
-- mini-surround search methods
-- autopair fast warp faster, cursormove
return hydras
