local init_config = function()
  local config = {}
  -- TODO: enable env variable override
  local dir_path = os.getenv('HOME') .. '/.local/share/nvim/devdocs'
  config.DATA_DIR = dir_path
  config.DOCS_DIR = dir_path .. '/docs'
  config.INDEX_PATH = dir_path .. '/index.json'
  config.LOCK_PATH = dir_path .. '/docs-lock.json'
  config.REGISTRY_PATH = dir_path .. '/registery.json'
  return config
end

return init_config
