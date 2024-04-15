-- https://raw.githubusercontent.com/johmsalas/text-case.nvim/main/README.md

require('textcase').setup({
  prefix = 'gtt', -- ga
  default_keymappings_enabled = false,
  -- enabled_methods = { "to_upper_case", "to_lower_case", "to_snake_case", "to_dash_case",
  --   "to_title_dash_case", "to_constant_case", "to_dot_case", "to_phrase_case", "to_camel_case", "to_pascal_case",
  --   "to_title_case", "to_path_case", "to_upper_phrase_case", "to_lower_phrase_case", },
})
-- stylua: ignore
local key_defs = {
  { method_name = 'to_constant_case', quick_replace = 'gttn', operator = 'gton', lsp_rename = 'gtrn' },
  { method_name = 'to_camel_case',    quick_replace = 'gttc', operator = 'gtoc', lsp_rename = 'gtrc' },
  { method_name = 'to_snake_case',    quick_replace = 'gtts', operator = 'gtos', lsp_rename = 'gtrs' },
  { method_name = 'to_dash_case',     quick_replace = 'gttd', operator = 'gtod', lsp_rename = 'gtrd' },
  { method_name = 'to_pascal_case',   quick_replace = 'gttp', operator = 'gtop', lsp_rename = 'gtrp' },
  { method_name = 'to_upper_case',    quick_replace = 'gttU', operator = 'gtoU', lsp_rename = 'gtrU' },
  { method_name = 'to_lower_case',    quick_replace = 'gttu', operator = 'gtou', lsp_rename = 'gtru' },
  { method_name = 'to_title_case',    quick_replace = 'gttt', operator = 'gtot', lsp_rename = 'gtrt' },
  { method_name = "to_dot_case",      quick_replace = "gttD", operator = "gtoD", lsp_rename = "gtrD" },
  { method_name = "to_phrase_case",   quick_replace = "gttP", operator = "gtoP", lsp_rename = "gtrP" },
  { method_name = "to_path_case",     quick_replace = "gttf", operator = "gtof", lsp_rename = "gtrf" },
}

local map = require('mapper').map
local prefix = require('mapper').prefix

local register_keys = function(methods, keys, opts)
  prefix({ 'x', 'n' }, 'gtt', 'text case replace  ')
  prefix('n', 'gtr', 'text case lsp rename  ')
  prefix('n', 'gto', 'text case operator  ')

  local ns = 'textcase'
  for _, feature in ipairs({ 'line', 'eol', 'visual', 'operator', 'lsp_rename', 'current_word' }) do
    if keys[feature] ~= nil then
      local mode = 'n'
      if feature == 'visual' then
        mode = 'x'
      end
      local desc = methods.desc

      if feature == 'current_word' then
        desc = 'convert ' .. desc
      elseif feature == 'lsp_rename' then
        desc = 'LSP rename ' .. desc
      end

      map(
        mode,
        keys[feature],
        "<cmd>lua require('" .. ns .. "')." .. feature .. "('" .. methods.method_name .. "')<cr>",
        { desc = ' ' .. desc }
      )
    end
  end

  if keys['quick_replace'] ~= nil then
    local keybind = keys['quick_replace']
    local desc = 'convert ' .. methods.desc
    local command = "<cmd>lua require('"
      .. ns
      .. "')."
      .. 'quick_replace'
      .. "('"
      .. methods.method_name
      .. "')<cr>"

    map('n', keybind, command, { desc = ' ' .. desc })
    map('x', keybind, command, { desc = ' ' .. desc })
  end
end

local api = require('textcase.plugin.api')
for _, def in ipairs(key_defs) do
  register_keys(api[def.method_name], {
    quick_replace = def.quick_replace,
    operator = def.operator,
    lsp_rename = def.lsp_rename,
  })
end

map(
  { 'n', 'v' },
  'gt.',
  '<cmd>TextCaseOpenTelescope<CR>',
  { desc = ' telescope convert current' }
)
map('n', 'gtr.', '<cmd>TextCaseOpenTelescopeLSPChange<CR>', { desc = ' telescope convert lsp' })

-- '<cmd>TextCaseOpenTelescopeLSPChange<CR>',
-- '<cmd>TextCaseOpenTelescopeQuickChange<CR>',
-- SMART REPLACE: Select block of text, then use "Subs"
-- '<,'>Subs/find text/replace text
-- StepOne              step-one
-- STEP_ONE   StepOne
-- step-one   step_one  step_one

-- Upper case    	 LOREM IPSUM 	 textcase.api.to_constant_case
-- Lower case    	 lorem ipsum 	 textcase.api.to_lower_case
-- Snake case    	 lorem_ipsum 	 textcase.api.to_snake_case
-- Dash case     	 lorem-ipsum 	 textcase.api.to_dash_case
-- Constant case 	 LOREM_IPSUM 	 textcase.api.to_constant_case
-- Dot case      	 lorem.ipsum 	 textcase.api.to_dot_case
-- Camel case    	 loremIpsum  	 textcase.api.to_camel_case
-- Pascal case   	 LoremIpsum  	 textcase.api.to_pascal_case
-- Title case    	 Lorem Ipsum 	 textcase.api.to_title_case
-- Path case     	 lorem/ipsum 	 textcase.api.to_path_case
-- Phrase case   	 Lorem ipsum 	 textcase.api.to_phrase_case
