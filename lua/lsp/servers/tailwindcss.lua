local lspconfig = require('lspconfig')
local util = lspconfig.util

local tailwindcss = function()
  lspconfig.tailwindcss.setup({
    root_pattern = util.root_pattern(
      'tailwind.config.js',
      'tailwind.config.ts',
      'postcss.config.js',
      'postcss.config.ts',
      'package.json',
      'node_modules',
      '.git'
    ),
    tailwindCSS = {
      classAttributes = { 'class', 'className', 'classList', 'ngClass' },
      rootFontSize = 16,
      colorDecorators = true,
      hovers = true,
      suggestions = true,
      codeActions = true,
      validate = true,
      inspect_port = nil,
      showPixelEquivalent = true,
      lint = {
        cssConflict = 'warning',
        invalidApply = 'error',
        invalidConfigPath = 'error',
        invalidScreen = 'error',
        invalidTailwindDirective = 'error',
        invalidVariant = 'error',
        recommendedVariantOrder = 'warning',
      },
    },
  })
end

return tailwindcss
