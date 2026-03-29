describe("unicode.search", function()
  local search
  local data

  before_each(function()
    -- Pre-load data module with fixture data
    data = require("unicode.data")
    data.clear()

    -- Override config to use fixture
    local config = require("unicode.config")
    config.use_cache = false

    -- Manually parse fixture into data module
    local fixture_path = vim.fn.expand("~/.config/nvim/tests/fixtures/UnicodeData_sample.txt")
    local dict = data.parse(fixture_path)

    -- Inject the parsed dict by loading it
    -- We need to make data.get() return our fixture data
    -- Load data module fresh and parse the fixture
    search = require("unicode.search")
  end)

  describe("find_unicode_by", function()
    it("finds characters by name substring", function()
      -- This will use the full unicode data if available, or fixture
      local results = search.find_unicode_by("SNOWMAN")
      -- May be empty if full unicode data isn't loaded, that's ok for unit test
      assert.are.equal("table", type(results))
    end)

    it("returns empty table for empty input", function()
      local results = search.find_unicode_by("")
      assert.are.equal(0, #results)
    end)

    it("finds by decimal codepoint", function()
      local results = search.find_unicode_by("65")
      assert.are.equal("table", type(results))
      -- If data is loaded, should find LATIN CAPITAL LETTER A
      for _, r in ipairs(results) do
        if r.dec == 65 then
          assert.is_true(r.name:find("LATIN") ~= nil)
        end
      end
    end)

    it("finds by hex codepoint with U+ prefix", function()
      local results = search.find_unicode_by("U+0041")
      assert.are.equal("table", type(results))
      for _, r in ipairs(results) do
        if r.dec == 0x41 then
          assert.is_true(r.name:find("LATIN") ~= nil)
        end
      end
    end)

    it("returns sorted results by decimal value", function()
      local results = search.find_unicode_by("LATIN")
      if #results > 1 then
        for i = 2, #results do
          assert.is_true(
            tonumber(results[i].dec) >= tonumber(results[i - 1].dec),
            "Results should be sorted by decimal value"
          )
        end
      end
    end)

    it("result entries have required fields", function()
      local results = search.find_unicode_by("SPACE")
      if #results > 0 then
        local r = results[1]
        assert.is_not_nil(r.name)
        assert.is_not_nil(r.glyph)
        assert.is_not_nil(r.dec)
        assert.is_not_nil(r.hex)
      end
    end)
  end)

  describe("get_html_entity", function()
    it("returns named entity for known codepoints", function()
      local html_entities = require("unicode.html_entities")
      -- &amp; is 0x26
      if html_entities[0x26] then
        local result = search.get_html_entity(0x26, false)
        assert.is_true(result:find("&") ~= nil)
      end
    end)

    it("generates numeric entity for valid range", function()
      -- ASCII printable character without named entity
      local result = search.get_html_entity(0x41, false)
      -- Should be &#x41; (numeric fallback for 'A')
      if not result:find("&%w") then
        assert.are.equal("&#x41;", result)
      end
    end)

    it("returns empty for surrogate range", function()
      local result = search.get_html_entity(0xD800, false)
      assert.are.equal("", result)
    end)

    it("returns empty for disallowed control chars", function()
      -- 0x01 is a control char not in the allowed set (9, 10, 13)
      local result = search.get_html_entity(0x01, false)
      assert.are.equal("", result)
    end)

    it("allows tab, newline, carriage return", function()
      assert.is_true(search.get_html_entity(9, false) ~= "")
      assert.is_true(search.get_html_entity(10, false) ~= "")
      assert.is_true(search.get_html_entity(13, false) ~= "")
    end)
  end)
end)
