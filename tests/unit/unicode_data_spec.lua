describe("unicode.data", function()
  local data
  local cache
  local config

  before_each(function()
    data = require("unicode.data")
    cache = require("unicode.cache")
    config = require("unicode.config")
    data.clear()
  end)

  describe("parse", function()
    local fixture_path = vim.fn.expand("~/.config/nvim/tests/fixtures/UnicodeData_sample.txt")

    it("parses UnicodeData.txt into a dictionary", function()
      local dict, index = data.parse(fixture_path)
      assert.is_not_nil(dict)
      assert.is_true(vim.tbl_count(dict) > 0)
    end)

    it("maps decimal codepoints to names", function()
      local dict = data.parse(fixture_path)
      assert.are.equal("LATIN CAPITAL LETTER A (Lu)", dict[0x0041])
      assert.are.equal("LATIN SMALL LETTER A (Ll)", dict[0x0061])
    end)

    it("appends general category to name", function()
      local dict = data.parse(fixture_path)
      -- SPACE has category Zs
      assert.are.equal("SPACE (Zs)", dict[0x0020])
    end)

    it("uses Unicode_1_Name for control characters", function()
      local dict = data.parse(fixture_path)
      -- <control> entries fall back to field 11 (old name)
      assert.are.equal("NULL", dict[0x0000])
      assert.are.equal("CHARACTER TABULATION", dict[0x0009])
      assert.are.equal("LINE FEED", dict[0x000A])
    end)

    it("returns an index of decimal keys", function()
      local dict, index = data.parse(fixture_path)
      assert.are.equal("table", type(index))
      assert.is_true(#index > 0)
      -- Index should be in order of appearance
      assert.are.equal(0x0000, index[1])
    end)

    it("handles high codepoints (>= U+10000)", function()
      local dict = data.parse(fixture_path)
      assert.are.equal("GRINNING FACE (So)", dict[0x1F600])
    end)

    it("trims trailing spaces from names", function()
      local dict = data.parse(fixture_path)
      for _, name in pairs(dict) do
        assert.is_false(name:match("%s$") ~= nil, "Name has trailing space: " .. name)
      end
    end)
  end)

  describe("cache roundtrip", function()
    it("writes and reads cache correctly", function()
      local fixture_path = vim.fn.expand("~/.config/nvim/tests/fixtures/UnicodeData_sample.txt")
      local dict, index = data.parse(fixture_path)

      local tmp_cache = vim.fn.tempname() .. ".lua"
      cache.write(tmp_cache, dict, index)

      assert.are.equal(1, vim.fn.filereadable(tmp_cache))

      local loaded = cache.read(tmp_cache)
      assert.is_not_nil(loaded)
      assert.are.equal(dict[0x0041], loaded[0x0041])
      assert.are.equal(dict[0x0061], loaded[0x0061])
      assert.are.equal(dict[0x1F600], loaded[0x1F600])

      -- Cleanup
      vim.fn.delete(tmp_cache)
    end)

    it("returns nil for non-existent cache file", function()
      local result = cache.read("/tmp/nonexistent_unicode_cache_test.lua")
      assert.is_nil(result)
    end)

    it("returns nil for invalid cache file", function()
      local tmp = vim.fn.tempname() .. ".lua"
      vim.fn.writefile({ "this is not valid lua {{{" }, tmp)
      local result = cache.read(tmp)
      assert.is_nil(result)
      vim.fn.delete(tmp)
    end)
  end)
end)
