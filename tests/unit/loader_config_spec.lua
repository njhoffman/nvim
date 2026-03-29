local script_dir = vim.fn.stdpath("config") .. "/"
package.path = script_dir .. "loader/?.lua;" .. script_dir .. "loader/?/init.lua;" .. package.path

describe("loader/config", function()
  local config

  before_each(function()
    -- Clear cached module
    package.loaded["loader_config"] = nil
    config = require("loader_config")

    -- Clear env vars
    vim.env.NVIM_UNIQUE = nil
    vim.env.NVIM_LISTEN_ADDRESS = nil
    vim.env.NVIM_STARTUPTIME = nil
  end)

  it("returns default config", function()
    local cfg = config.load()
    assert.are.equal("/tmp/nvimsocket.log", cfg.log_file)
    assert.are.equal("tmux_window", cfg.remote.attach_on)
    assert.are.equal("/tmp", cfg.remote.sockets_dir)
    assert.are.equal("nvim", cfg.nvim_bin)
    assert.is_false(cfg.startuptime)
    assert.is_true(cfg.syslog)
  end)

  it("expands $HOME in paths", function()
    local cfg = config.load()
    local home = os.getenv("HOME")
    assert.is_not_nil(cfg.sessions.saved_dir:find(home, 1, true))
    assert.is_not_nil(cfg.gods_file:find(home, 1, true))
    assert.is_nil(cfg.sessions.saved_dir:find("$HOME", 1, true))
  end)

  it("maps NVIM_UNIQUE=session to tmux_session", function()
    vim.env.NVIM_UNIQUE = "session"
    local cfg = config.load()
    assert.are.equal("tmux_session", cfg.remote.attach_on)
  end)

  it("maps NVIM_UNIQUE=0 to none", function()
    vim.env.NVIM_UNIQUE = "0"
    local cfg = config.load()
    assert.are.equal("none", cfg.remote.attach_on)
  end)

  it("maps NVIM_LISTEN_ADDRESS and forces attach_on to none", function()
    vim.env.NVIM_LISTEN_ADDRESS = "/tmp/custom_socket"
    local cfg = config.load()
    assert.are.equal("/tmp/custom_socket", cfg.remote.listen_address)
    assert.are.equal("none", cfg.remote.attach_on)
  end)

  it("maps NVIM_STARTUPTIME=1 to file path", function()
    vim.env.NVIM_STARTUPTIME = "1"
    local cfg = config.load()
    assert.are.equal("/tmp/startuptime.txt", cfg.startuptime)
  end)
end)
