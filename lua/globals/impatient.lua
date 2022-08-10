-- mod resolve: $XDG_CACHE_HOME/nvim/luacache_modpaths
-- chunk cache: $XDG_CACHE_HOME/nvim/luacache_chunks
-- _G.__luacache_config = { modpaths = { enable = false } }
_G.__luacache_config = {
  chunks = {
    enable = true,
    path = vim.fn.stdpath('cache') .. '/luacache_chunks',
  },
  modpaths = {
    enable = true,
    path = vim.fn.stdpath('cache') .. '/luacache_modpaths',
  }
}
require('impatient')
