local script_dir = vim.fn.stdpath("config") .. "/"
package.path = script_dir .. "loader/?.lua;" .. script_dir .. "loader/?/init.lua;" .. package.path

describe("loader/socket", function()
  local socket

  before_each(function()
    package.loaded["loader_socket"] = nil
    socket = require("loader_socket")
  end)

  describe("get_prefix", function()
    it("returns nil when tmux is not active", function()
      local mock_tmux = { is_active = function() return false end }
      local config = { remote = { attach_on = "tmux_window" } }
      assert.is_nil(socket.get_prefix(config, mock_tmux))
    end)

    it("builds prefix with session and window for tmux_window mode", function()
      local mock_tmux = {
        is_active = function() return true end,
        session_id = function() return "0" end,
        window_id = function() return "@2" end,
      }
      local config = { remote = { attach_on = "tmux_window" } }
      assert.are.equal("nvim_0_@2", socket.get_prefix(config, mock_tmux))
    end)

    it("builds prefix with session only for tmux_session mode", function()
      local mock_tmux = {
        is_active = function() return true end,
        session_id = function() return "3" end,
        window_id = function() return "@1" end,
      }
      local config = { remote = { attach_on = "tmux_session" } }
      assert.are.equal("nvim_3", socket.get_prefix(config, mock_tmux))
    end)

    it("uses listen_address when set", function()
      local mock_tmux = {
        is_active = function() return true end,
        session_id = function() return "0" end,
      }
      local config = { remote = { attach_on = "tmux_window", listen_address = "/tmp/custom_addr" } }
      assert.are.equal("custom_addr", socket.get_prefix(config, mock_tmux))
    end)
  end)

  describe("find_existing", function()
    it("finds matching socket in directory", function()
      local lfs = require("lfs")
      local tmpdir = os.tmpname()
      os.remove(tmpdir)
      lfs.mkdir(tmpdir)

      -- Create fake socket files
      io.open(tmpdir .. "/nvim_0_@0_zeus", "w"):close()
      io.open(tmpdir .. "/nvim_0_@1_apollo", "w"):close()
      io.open(tmpdir .. "/other_file", "w"):close()

      local result = socket.find_existing(tmpdir, "nvim_0_@0")
      assert.are.equal(tmpdir .. "/nvim_0_@0_zeus", result)

      -- Cleanup
      os.remove(tmpdir .. "/nvim_0_@0_zeus")
      os.remove(tmpdir .. "/nvim_0_@1_apollo")
      os.remove(tmpdir .. "/other_file")
      lfs.rmdir(tmpdir)
    end)

    it("returns nil when no match", function()
      local lfs = require("lfs")
      local tmpdir = os.tmpname()
      os.remove(tmpdir)
      lfs.mkdir(tmpdir)

      io.open(tmpdir .. "/nvim_1_@0_hermes", "w"):close()

      local result = socket.find_existing(tmpdir, "nvim_0_@0")
      assert.is_nil(result)

      os.remove(tmpdir .. "/nvim_1_@0_hermes")
      lfs.rmdir(tmpdir)
    end)

    it("returns nil for nil prefix", function()
      assert.is_nil(socket.find_existing("/tmp", nil))
    end)
  end)

  describe("create", function()
    it("returns correct socket path", function()
      local path = socket.create("/tmp", "nvim_0_@0", "athena")
      assert.are.equal("/tmp/nvim_0_@0_athena", path)
    end)
  end)
end)
