describe("tmux.version", function()
  local parse = require("tmux.version.parse")
  local compare = require("tmux.version.compare")

  describe("parse", function()
    it("parses major.minor version", function()
      local v = parse.from("3.2")
      assert.are.same({ major = 3, minor = 2, patch = 0 }, v)
    end)

    it("parses version with patch letter", function()
      local v = parse.from("3.2a")
      assert.are.same({ major = 3, minor = 2, patch = 1 }, v)
    end)

    it("parses version with later patch letter", function()
      local v = parse.from("3.3c")
      assert.are.same({ major = 3, minor = 3, patch = 3 }, v)
    end)

    it("strips next- prefix", function()
      local v = parse.from("next-3.4")
      assert.are.same({ major = 3, minor = 4, patch = 0 }, v)
    end)

    it("strips next prefix without hyphen", function()
      local v = parse.from("next3.4")
      assert.are.same({ major = 3, minor = 4, patch = 0 }, v)
    end)

    it("returns empty table for nil", function()
      local v = parse.from(nil)
      assert.are.same({}, v)
    end)

    it("returns empty table for invalid format", function()
      local v = parse.from("invalid")
      assert.are.same({}, v)
    end)
  end)

  describe("compare", function()
    it("returns 0 for equal versions", function()
      local a = { major = 3, minor = 2, patch = 0 }
      local b = { major = 3, minor = 2, patch = 0 }
      assert.are.same({ result = 0 }, compare.with(a, b))
    end)

    it("returns 1 when base is greater (major)", function()
      local a = { major = 4, minor = 0, patch = 0 }
      local b = { major = 3, minor = 9, patch = 0 }
      assert.are.same({ result = 1 }, compare.with(a, b))
    end)

    it("returns -1 when base is lesser (major)", function()
      local a = { major = 2, minor = 0, patch = 0 }
      local b = { major = 3, minor = 0, patch = 0 }
      assert.are.same({ result = -1 }, compare.with(a, b))
    end)

    it("compares minor versions", function()
      local a = { major = 3, minor = 3, patch = 0 }
      local b = { major = 3, minor = 2, patch = 0 }
      assert.are.same({ result = 1 }, compare.with(a, b))
    end)

    it("compares patch versions", function()
      local a = { major = 3, minor = 2, patch = 1 }
      local b = { major = 3, minor = 2, patch = 3 }
      assert.are.same({ result = -1 }, compare.with(a, b))
    end)

    it("returns error for invalid base", function()
      local result = compare.with({}, { major = 3, minor = 2, patch = 0 })
      assert.is_not_nil(result.error)
      assert.is_nil(result.result)
    end)

    it("returns error for invalid relative", function()
      local result = compare.with({ major = 3, minor = 2, patch = 0 }, {})
      assert.is_not_nil(result.error)
      assert.is_nil(result.result)
    end)

    it("returns error when version field is not a number", function()
      local result = compare.with({ major = "3", minor = 2, patch = 0 }, { major = 3, minor = 2, patch = 0 })
      assert.is_not_nil(result.error)
    end)
  end)
end)
