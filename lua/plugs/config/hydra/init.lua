local lsp = require('plugs.config.hydra.lsp')
local options = require('plugs.config.hydra.options')
local window = require('plugs.config.hydra.window')

local hydras = {}
hydras.lsp = lsp.hydra()
hydras.options = options.hydra()
hydras.window = window.hydra()

return hydras
