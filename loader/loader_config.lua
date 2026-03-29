local M = {}

local home = os.getenv("HOME") or ""

local function expand_path(path)
  return path:gsub("%$HOME", home)
end

local function deep_copy(t)
  if type(t) ~= "table" then
    return t
  end
  local copy = {}
  for k, v in pairs(t) do
    copy[k] = deep_copy(v)
  end
  return copy
end

local defaults = {
  log_file = "/tmp/nvimsocket.log",
  syslog = true,
  nvim_bin = "nvim",
  startuptime = false,
  remote = {
    sockets_dir = "/tmp",
    attach_on = "tmux_window", -- "tmux_window" | "tmux_session" | "none"
  },
  sessions = {
    saved_dir = "$HOME/.local/share/nvim/sessions/saved",
    load_dir = "$HOME/.local/share/nvim/sessions/restart",
    temp_dir = "/tmp/sessions",
  },
  gods_file = "$HOME/.config/zsh/greekgods.txt",
}

-- Map NVIM_UNIQUE env var to attach_on value
local unique_map = {
  window = "tmux_window",
  session = "tmux_session",
  ["0"] = "none",
}

function M.load()
  local cfg = deep_copy(defaults)

  -- Environment variable overrides
  local nvim_unique = os.getenv("NVIM_UNIQUE")
  if nvim_unique then
    cfg.remote.attach_on = unique_map[nvim_unique] or cfg.remote.attach_on
  end

  local listen_addr = os.getenv("NVIM_LISTEN_ADDRESS")
  if listen_addr then
    cfg.remote.listen_address = listen_addr
    cfg.remote.attach_on = "none"
  end

  local startuptime = os.getenv("NVIM_STARTUPTIME")
  if startuptime == "1" then
    cfg.startuptime = "/tmp/startuptime.txt"
  end

  -- Expand $HOME in all paths
  cfg.log_file = expand_path(cfg.log_file)
  cfg.sessions.saved_dir = expand_path(cfg.sessions.saved_dir)
  cfg.sessions.load_dir = expand_path(cfg.sessions.load_dir)
  cfg.sessions.temp_dir = expand_path(cfg.sessions.temp_dir)
  cfg.gods_file = expand_path(cfg.gods_file)

  return cfg
end

return M
