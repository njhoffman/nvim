local utils = require("configs.chrome-remote.utils")
-- -- lua.chrome-remote.base6
-- local basepath = 'configs.chrome-remote.modules'
-- -- https://github.com/cyrus-and/chrome-remote-interface
-- -- https://unpkg.com/browse/chrome-remote-interface@0.29.0/README.md
-- local modules = {
--   -- scratch = require(basepath .. 'scratch'),
--   -- devtools = require(basepath .. 'devtools'),
--   -- textarea = require(basepath .. 'textarea'),
--   -- htmledit = require(basepath .. 'htmledit'),
--   -- restart = require(basepath .. 'restart'),
--   inspect = require(basepath .. '.inspect'),
-- }

-- https://theosteiner.de/debugging-javascript-frameworks-in-neovim
require("chrome-remote").setup({
  connection = {
    host = "localhost",
    port = 9222,
  },
})
--
-- vim.api.nvim_create_user_command(
--   'ChromeInspect',
--   coroutine.wrap(modules.inspect),
--   { desc = 'Inspect the contents of the currently running chrome instnce' }
-- )
-- -- scratch.
-- commands.
