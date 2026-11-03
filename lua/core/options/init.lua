-- Options: the config's own registered options (user.lua, read with
-- utils.options.get_option_value) and the built-in vim options (vim.lua), in the order
-- globals loaded them before they moved here.
vim.import("core.options.user")
vim.import("core.options.vim")
