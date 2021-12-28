
local spotify = require'nvim-spotify'

-- :SpotifyDevices
-- :Spotify

spotify.setup {
-- default opts
  status = {
    update_interval = 10000, -- the interval (ms) to check for what's currently playing
    format = '%s %t by %a' -- spotify-tui --format argument
  }
}

-- normal	Esc	Close
-- normal	q	Close
-- normal, insert	C-T	Search for Tracks
-- normal, insert	C-Y	Search for Playlists
-- normal, insert	C-L	Search for Albums
-- normal, insert	C-R	Search for Artists

-- vim.api.nvim_set_keymap("n", "<leader>sn", "<Plug>(SpotifySkip)",  { silent = true }) -- Skip the current track
-- vim.api.nvim_set_keymap("n", "<leader>sp", "<Plug>(SpotifyPause)", , { silent = true }) -- Pause/Resume the current track
-- vim.api.nvim_set_keymap("n", "<leader>ss", "<Plug>(SpotifySave)",  { silent = true }) -- Add the current track to your library
-- vim.api.nvim_set_keymap("n", "<leader>so", ":Spotify<CR>",  { silent = true }) -- Open Spotify Search window
-- vim.api.nvim_set_keymap("n", "<leader>sd", ":SpotifyDevices<CR>",  { silent = true }) -- Open Spotify Devices window

-- Statusline
-- You can display what's currently playing on your statusline. The example below shows how to show it on lualine, although the configuration should be quite similar on other statusline plugins:
-- local status = require'nvim-spotify'.status
-- status:start()
-- require('lualine').setup {
--     sections = {
--         lualine_x = {
--             status.listen
--         }
--     }
-- }
