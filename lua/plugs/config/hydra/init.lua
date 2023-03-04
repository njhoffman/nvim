local lsp = require("plugs.config.hydra.lsp")
local options = require("plugs.config.hydra.options")

local hydras = {}
hydras.lsp = lsp.hydra()
hydras.options = options.hydra()

return hydras
