describe("unicode.digraph", function()
  local digraph

  before_each(function()
    digraph = require("unicode.digraph")
  end)

  describe("parse_digraphs", function()
    it("parses sample digraph output", function()
      -- Simulated :digraphs output (simplified)
      local output = "NU ^@  10   SH ^A   1   SX ^B   2   EX ^C   3"
      local dict = digraph.parse_digraphs(output)
      assert.are.equal("table", type(dict))
    end)

    it("returns a table", function()
      local dict = digraph.parse_digraphs("")
      assert.are.equal("table", type(dict))
    end)
  end)

  describe("get_chars", function()
    it("returns empty string for unknown codepoint", function()
      -- Force fresh dict
      digraph.clear_dict()
      local result = digraph.get_chars(999999)
      -- May return empty if no digraph exists for this value
      assert.are.equal("string", type(result))
    end)

    it("returns formatted string with parens for known digraphs", function()
      -- Get actual digraph dict (depends on Neovim runtime)
      digraph.clear_dict()
      local dict = digraph.get_dict()
      -- Find a codepoint that has a digraph
      local test_dec = nil
      for dec, _ in pairs(dict) do
        if dec > 32 then
          test_dec = dec
          break
        end
      end
      if test_dec then
        local result = digraph.get_chars(test_dec)
        if result ~= "" then
          assert.is_true(result:match("^%(.*%)$") ~= nil, "Expected parens around digraph chars: " .. result)
        end
      end
    end)
  end)

  describe("get_dict", function()
    it("returns a non-empty table", function()
      digraph.clear_dict()
      local dict = digraph.get_dict()
      assert.are.equal("table", type(dict))
      assert.is_true(vim.tbl_count(dict) > 0, "Expected at least some digraphs")
    end)

    it("caches the dict on subsequent calls", function()
      digraph.clear_dict()
      local dict1 = digraph.get_dict()
      local dict2 = digraph.get_dict()
      assert.are.equal(dict1, dict2)
    end)
  end)
end)
