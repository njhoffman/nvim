describe("unicode.names", function()
  local names

  before_each(function()
    names = require("unicode.names")
  end)

  describe("resolve", function()
    it("returns name from dictionary when available", function()
      local dict = { [0x0041] = "LATIN CAPITAL LETTER A (Lu)" }
      assert.are.equal("LATIN CAPITAL LETTER A (Lu)", names.resolve(0x0041, dict))
    end)

    it("falls back to ranges when not in dictionary", function()
      assert.are.equal("CJK Ideograph", names.resolve(0x4E00, {}))
      assert.are.equal("CJK Ideograph", names.resolve(0x9FFF, {}))
    end)

    it("identifies Hangul Syllables", function()
      assert.are.equal("Hangul Syllable", names.resolve(0xAC00, {}))
      assert.are.equal("Hangul Syllable", names.resolve(0xD7AF, {}))
    end)

    it("identifies Ideograph Extension A", function()
      assert.are.equal("Ideograph Extension A", names.resolve(0x3400, {}))
      assert.are.equal("Ideograph Extension A", names.resolve(0x4DB5, {}))
    end)

    it("identifies Ideograph Extension B", function()
      assert.are.equal("Ideograph Extension B", names.resolve(0x20000, {}))
    end)

    it("identifies Ideograph Extension C", function()
      assert.are.equal("Ideograph Extension C", names.resolve(0x2A700, {}))
    end)

    it("identifies surrogates", function()
      assert.are.equal("Non-Private Use High Surrogates", names.resolve(0xD800, {}))
      assert.are.equal("Private Use High Surrogates", names.resolve(0xDB80, {}))
      assert.are.equal("Low Surrogates", names.resolve(0xDC00, {}))
    end)

    it("identifies Private Use Zone", function()
      assert.are.equal("Private Use Zone", names.resolve(0xE000, {}))
      assert.are.equal("Private Use Zone", names.resolve(0xF8FF, {}))
    end)

    it("identifies exact special codepoints", function()
      assert.are.equal("<No Character (BOM)>", names.resolve(0xFFFE, {}))
      assert.are.equal("<No Character>", names.resolve(0xFFFF, {}))
    end)

    it("identifies plane boundary no-characters", function()
      assert.are.equal("<No Character>", names.resolve(0x1FFFE, {}))
      assert.are.equal("<No Character>", names.resolve(0x10FFFF, {}))
    end)

    it("identifies Tangut Ideographs", function()
      assert.are.equal("Tangut Ideograph", names.resolve(0x17000, {}))
    end)

    it("identifies Plane 15 private use", function()
      assert.are.equal("Character from Plane 15 for private use", names.resolve(0xF0000, {}))
    end)

    it("identifies Plane 16 private use", function()
      assert.are.equal("Character from Plane 16 for private use", names.resolve(0x100000, {}))
    end)

    it("returns 'Character not found' for unknown codepoints", function()
      assert.are.equal("Character not found", names.resolve(0xFDFF, {}))
    end)

    it("prefers dictionary over range fallback", function()
      local dict = { [0x4E00] = "CUSTOM NAME" }
      assert.are.equal("CUSTOM NAME", names.resolve(0x4E00, dict))
    end)

    it("handles nil dictionary", function()
      assert.are.equal("CJK Ideograph", names.resolve(0x4E00, nil))
      assert.are.equal("Character not found", names.resolve(0x0041, nil))
    end)

    it("identifies <No Character> range (FDD0-FDEF)", function()
      assert.are.equal("<No Character>", names.resolve(0xFDD0, {}))
      assert.are.equal("<No Character>", names.resolve(0xFDEF, {}))
    end)
  end)
end)
