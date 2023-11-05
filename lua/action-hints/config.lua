local default_definitions_color
local default_references_color
local default_codeactions_color

if vim.o.termguicolors then
  default_definitions_color = '#6dd8e6'
  default_references_color = '#ff6666'
  default_codeactions_color = '#3388ff'
else
  default_definitions_color = 'green'
  default_references_color = 'red'
  default_codeactions_color = 'blue'
end

local default_config = {
  debounce_delays = {
    references = 200,
    definitions = 200,
    codeactions = 200,
  },
  template = {
    definitions = { text = ' ⊛', color = default_definitions_color },
    references = { text = ' ↱%s', color = default_references_color },
    codeactions = { text = ' %s', color = default_codeactions_color },
  },
  use_virtual_text = false,
}

local config = default_config

local setup = function(options)
  if options == nil then
    options = {}
  end

  -- Merge keys
  for k, v in pairs(options) do
    if k == 'template' and type(v) == 'table' then
      for tk, tv in pairs(v) do
        config.template[tk] = tv
      end
    else
      config[k] = v
    end
  end
  return config
end

return { setup = setup, values = config }
