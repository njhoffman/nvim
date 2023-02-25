local lsp = require("plugs.config.hydra-nvim.lsp")
local options = require("plugs.config.hydra-nvim.options")

local hydras = {}
hydras.lsp = lsp.hydra()
hydras.options = options.hydra()

return hydras
