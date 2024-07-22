-- TODO: move over to lua/lazy
local setup = require("utils.lazy.setup")
local configs = require("utils.lazy.configs")

local is_loaded = function(name)
  local plugins = require("lazy.core.config").spec.plugins
  return plugins[name] and plugins[name]._.loaded
end

local is_installed = function(name)
  local plugins = require("lazy.core.config").spec.plugins
  return plugins[name] and plugins[name]._.installed
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lazy",
  callback = function(ev)
    vim.api.nvim_buf_set_keymap(ev.buf, "n", "<ESC>", "q", {})
  end,
})

return {
  setup = setup,
  apply_configs = configs.apply,
  is_installed = is_installed,
  is_loaded = is_loaded,
}
