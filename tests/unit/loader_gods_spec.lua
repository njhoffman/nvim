local script_dir = vim.fn.stdpath("config") .. "/"
package.path = script_dir .. "loader/?.lua;" .. script_dir .. "loader/?/init.lua;" .. package.path

describe("loader/gods", function()
  local gods

  before_each(function()
    package.loaded["loader_gods"] = nil
    gods = require("loader_gods")
  end)

  it("parses greekgods.txt format", function()
    -- Create a temp file with test data
    local tmpfile = os.tmpname()
    local f = io.open(tmpfile, "w")
    f:write("APOLLO        | God of music\n")
    f:write("ZEUS          | King of gods\n")
    f:write("HERMES        | Messenger god\n")
    f:close()

    local parsed = gods._parse_gods_file(tmpfile)
    assert.are.equal(3, #parsed)
    assert.are.equal("apollo", parsed[1])
    assert.are.equal("zeus", parsed[2])
    assert.are.equal("hermes", parsed[3])

    os.remove(tmpfile)
  end)

  it("returns lowercase names", function()
    local tmpfile = os.tmpname()
    local f = io.open(tmpfile, "w")
    f:write("POSEIDON      | God of the sea\n")
    f:close()

    local parsed = gods._parse_gods_file(tmpfile)
    assert.are.equal("poseidon", parsed[1])

    os.remove(tmpfile)
  end)

  it("returns 'unknown' for missing file", function()
    math.randomseed(1)
    local name = gods.random("/nonexistent/file.txt")
    assert.are.equal("unknown", name)
  end)

  it("returns a name from the real gods file", function()
    math.randomseed(os.time())
    local home = os.getenv("HOME")
    local name = gods.random(home .. "/.config/zsh/greekgods.txt")
    assert.is_not_nil(name)
    assert.is_true(#name > 0)
    assert.are_not.equal("unknown", name)
  end)
end)
