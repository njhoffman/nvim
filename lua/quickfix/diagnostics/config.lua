local defaults = {
  debug = false,
  buf_clients_only = true,
  debounce_ms = 150,
  level = vim.diagnostic.severity.HINT,
  title = 'LSP Diagnostics',
}

local config = {}
config.setup = function(opts)
  local options = vim.tbl_deep_extend('force', defaults, opts or {})
  for k, v in pairs(options) do
    config[k] = v
  end
end

return config
