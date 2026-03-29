# nvim task list

- this file contains a wrapper/alias for nvim
  - /home/nicholas/.config/zsh/config/functions/nvim.sh
- config that maps to environment variables in nvim.sh

```lua
config = {
  log_file = "/tmp/nvimsocket.log",
  remote = {
    sockets_dir = "/tmp",
    -- 'tmux_window', 'tmux_session', or empty for always new instances (NVIM_UNIQUE)
    attach_on = "tmux_window",
  },
  sessions = {
    saved_dir = "$HOME/.local/share/nvim/sessions/saved",
    load_dir = "$HOME/.local/share/nvim/sessions/load",
    temp_dir = "/tmp/sessions",
  },
aliases = {
  sync = "nvim --headless '+Lazy! sync' +qa"
}
```

- i would like to extract this code into `config/nvim/loader.lua`
- handles parsing arguments and initializing or connecting to existing nvim instances through '--listen' and '--server' flags
- previously used neovim-remote but this is no longer necessary, just use vanilla nvim args
- if saved_dir contains a session, automatically load it, when neovim exits check if there is a session to load and load
  it or exit
- add tests and documentation after migrating the code
