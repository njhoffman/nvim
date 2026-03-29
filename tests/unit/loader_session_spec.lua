local script_dir = vim.fn.stdpath("config") .. "/"
package.path = script_dir .. "loader/?.lua;" .. script_dir .. "loader/?/init.lua;" .. package.path

describe("loader/session", function()
  local session
  local lfs = require("lfs")

  local function make_tmpdir()
    local tmpdir = os.tmpname()
    os.remove(tmpdir)
    lfs.mkdir(tmpdir)
    return tmpdir
  end

  local function touch(path)
    io.open(path, "w"):close()
  end

  local function rm_rf(dir)
    for entry in lfs.dir(dir) do
      if entry ~= "." and entry ~= ".." then
        os.remove(dir .. "/" .. entry)
      end
    end
    lfs.rmdir(dir)
  end

  before_each(function()
    package.loaded["loader_session"] = nil
    session = require("loader_session")
  end)

  describe("get_reload", function()
    it("finds _runonce.vim matching prefix", function()
      local tmpdir = make_tmpdir()
      touch(tmpdir .. "/nvim_0_@0_zeus_runonce.vim")
      touch(tmpdir .. "/nvim_0_@1_apollo_runonce.vim")

      local result = session.get_reload(tmpdir, "nvim_0_@0")
      assert.are.equal(tmpdir .. "/nvim_0_@0_zeus_runonce.vim", result)

      rm_rf(tmpdir)
    end)

    it("returns nil when no match", function()
      local tmpdir = make_tmpdir()
      touch(tmpdir .. "/nvim_1_@0_hermes_runonce.vim")

      local result = session.get_reload(tmpdir, "nvim_0_@0")
      assert.is_nil(result)

      rm_rf(tmpdir)
    end)

    it("returns nil for nil prefix", function()
      assert.is_nil(session.get_reload("/tmp", nil))
    end)
  end)

  describe("get_saved", function()
    it("finds session by tmux session name", function()
      local tmpdir = make_tmpdir()
      touch(tmpdir .. "/main")
      touch(tmpdir .. "/work")

      local result = session.get_saved(tmpdir, "main")
      assert.are.equal(tmpdir .. "/main", result)

      rm_rf(tmpdir)
    end)

    it("returns nil for unknown session name", function()
      local tmpdir = make_tmpdir()
      touch(tmpdir .. "/main")

      local result = session.get_saved(tmpdir, "other")
      assert.is_nil(result)

      rm_rf(tmpdir)
    end)

    it("returns nil for nil session name", function()
      assert.is_nil(session.get_saved("/tmp", nil))
    end)
  end)

  describe("clean_temp", function()
    it("removes matching _temp.vim files", function()
      local tmpdir = make_tmpdir()
      touch(tmpdir .. "/nvim_0_@0_zeus_temp.vim")
      touch(tmpdir .. "/nvim_0_@1_apollo_temp.vim")

      session.clean_temp(tmpdir, "nvim_0_@0")

      -- nvim_0_@0 should be removed, @1 should remain
      assert.is_nil(io.open(tmpdir .. "/nvim_0_@0_zeus_temp.vim", "r"))
      assert.is_not_nil(io.open(tmpdir .. "/nvim_0_@1_apollo_temp.vim", "r"))

      rm_rf(tmpdir)
    end)
  end)

  describe("prepare_reload", function()
    it("renames _runonce.vim to _temp.vim", function()
      local tmpdir = make_tmpdir()
      local runonce = tmpdir .. "/nvim_0_@0_zeus_runonce.vim"
      touch(runonce)

      local new_path = session.prepare_reload(runonce)
      assert.are.equal(tmpdir .. "/nvim_0_@0_zeus_temp.vim", new_path)
      assert.is_nil(io.open(runonce, "r"))
      assert.is_not_nil(io.open(new_path, "r"))

      rm_rf(tmpdir)
    end)
  end)
end)
