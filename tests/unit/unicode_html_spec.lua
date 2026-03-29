describe("unicode.html_entities", function()
  local html

  before_each(function()
    html = require("unicode.html_entities")
  end)

  describe("data structure", function()
    it("is a table", function()
      assert.are.equal("table", type(html))
    end)

    it("has entries", function()
      assert.is_true(vim.tbl_count(html) > 0)
    end)

    it("keys are numbers", function()
      for k, _ in pairs(html) do
        assert.are.equal("number", type(k), "Expected numeric key, got: " .. type(k))
        break
      end
    end)

    it("values are lists of strings", function()
      for _, v in pairs(html) do
        assert.are.equal("table", type(v))
        for _, entity in ipairs(v) do
          assert.are.equal("string", type(entity))
          -- HTML entities should start with & and end with ;
          assert.is_true(entity:match("^&.+;$") ~= nil, "Invalid entity format: " .. entity)
        end
        break
      end
    end)
  end)

  describe("known entities", function()
    it("contains &amp; for U+0026", function()
      local entries = html[0x0026]
      assert.is_not_nil(entries)
      local found = false
      for _, e in ipairs(entries) do
        if e == "&amp;" then
          found = true
        end
      end
      assert.is_true(found, "Expected &amp; in entries for U+0026")
    end)

    it("contains &lt; for U+003C", function()
      local entries = html[0x003C]
      assert.is_not_nil(entries)
      local found = false
      for _, e in ipairs(entries) do
        if e == "&lt;" then
          found = true
        end
      end
      assert.is_true(found, "Expected &lt; in entries for U+003C")
    end)

    it("contains &gt; for U+003E", function()
      local entries = html[0x003E]
      assert.is_not_nil(entries)
      local found = false
      for _, e in ipairs(entries) do
        if e == "&gt;" then
          found = true
        end
      end
      assert.is_true(found, "Expected &gt; in entries for U+003E")
    end)

    it("contains &nbsp; for U+00A0", function()
      local entries = html[0x00A0]
      assert.is_not_nil(entries)
      local found = false
      for _, e in ipairs(entries) do
        if e == "&nbsp;" then
          found = true
        end
      end
      assert.is_true(found, "Expected &nbsp; in entries for U+00A0")
    end)
  end)

  describe("multiple entities per codepoint", function()
    it("some codepoints have multiple entity names", function()
      -- Many codepoints have both long and short names
      local found_multi = false
      for _, v in pairs(html) do
        if #v > 1 then
          found_multi = true
          break
        end
      end
      assert.is_true(found_multi, "Expected at least one codepoint with multiple entities")
    end)
  end)
end)

describe("unicode.search.get_html_entity", function()
  local search

  before_each(function()
    search = require("unicode.search")
  end)

  describe("numeric fallback", function()
    it("generates &#xHH; for printable ASCII without named entity", function()
      -- 'A' (0x41) - might have a named entity or fallback to numeric
      local result = search.get_html_entity(0x41, false)
      assert.is_true(result ~= "", "Expected non-empty entity for U+0041")
    end)

    it("returns empty for control characters < 32 (except 9, 10, 13)", function()
      assert.are.equal("", search.get_html_entity(0x00, false))
      assert.are.equal("", search.get_html_entity(0x01, false))
      assert.are.equal("", search.get_html_entity(0x1F, false))
    end)

    it("allows tab (9), newline (10), carriage return (13)", function()
      assert.is_true(search.get_html_entity(9, false) ~= "")
      assert.is_true(search.get_html_entity(10, false) ~= "")
      assert.is_true(search.get_html_entity(13, false) ~= "")
    end)

    it("returns empty for surrogate range", function()
      assert.are.equal("", search.get_html_entity(0xD800, false))
      assert.are.equal("", search.get_html_entity(0xDFFF, false))
    end)

    it("returns empty for range 127-159", function()
      assert.are.equal("", search.get_html_entity(127, false))
      assert.are.equal("", search.get_html_entity(159, false))
    end)

    it("returns all entities when all=true", function()
      local single = search.get_html_entity(0x0026, false)
      local all = search.get_html_entity(0x0026, true)
      assert.is_true(#all >= #single, "all=true should return same or more content")
    end)
  end)
end)
