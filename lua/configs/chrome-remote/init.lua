local utils = require("configs.chrome-remote.utils")

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
