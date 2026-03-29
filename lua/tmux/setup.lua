require("tmux").setup({
  copy_sync = {
    enable = false,
    redirect_to_clipboard = true,
  },
  navigation = {
    cycle_navigation = false,
    default_keymaps = false,
    persist_zoom = true,
  },
  resize = {
    default_keymaps = false,
    step_x = 2,
    step_y = 1,
    large_x = 5,
    large_y = 3,
  },
})

require("tmux.keymaps").setup_navigation()
require("tmux.keymaps").setup_resize()
