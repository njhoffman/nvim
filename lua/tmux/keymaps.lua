local api = vim.api

local keymaps = {}
keymaps.register = function(scope, mappings, options)
  scope = type(scope) == "string" and { scope } or scope
  local opts
  if options == nil then
    opts = {
      nowait = true,
      silent = true,
      noremap = true,
    }
  else
    opts = options
  end

  for _, s in ipairs(scope) do
    for key, value in pairs(mappings) do
      api.nvim_set_keymap(s, key, value, opts)
    end
  end
end

return keymaps
