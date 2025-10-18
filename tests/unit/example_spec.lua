-- Example unit test using plenary.nvim
-- Tests basic Lua functionality and utilities

describe("Example Unit Tests", function()
  describe("Vim API", function()
    it("can access vim global", function()
      assert.is_not_nil(vim)
      assert.is_not_nil(vim.api)
    end)

    it("can get neovim version", function()
      local version = vim.version()
      assert.is_not_nil(version)
      assert.is_not_nil(version.major)
      assert.is_not_nil(version.minor)
    end)

    it("can create and delete buffer", function()
      local bufnr = vim.api.nvim_create_buf(false, true)
      assert.is_true(bufnr > 0)
      assert.is_true(vim.api.nvim_buf_is_valid(bufnr))

      vim.api.nvim_buf_delete(bufnr, { force = true })
      assert.is_false(vim.api.nvim_buf_is_valid(bufnr))
    end)
  end)

  describe("Lua Standard Library", function()
    it("can perform table operations", function()
      local tbl = { 1, 2, 3 }
      table.insert(tbl, 4)
      assert.are.same({ 1, 2, 3, 4 }, tbl)

      local removed = table.remove(tbl, 2)
      assert.are.equal(2, removed)
      assert.are.same({ 1, 3, 4 }, tbl)
    end)

    it("can perform string operations", function()
      local str = "hello world"
      assert.are.equal("HELLO WORLD", string.upper(str))
      assert.are.equal("hello world", string.lower(str))
      assert.is_true(string.find(str, "world") ~= nil)
    end)

    it("can use math operations", function()
      assert.are.equal(4, math.floor(4.7))
      assert.are.equal(5, math.ceil(4.2))
      assert.are.equal(4, math.abs(-4))
    end)
  end)

  describe("Vim Utility Functions", function()
    it("can use vim.fn functions", function()
      assert.are.equal(3, vim.fn.strlen("abc"))
      assert.is_true(vim.fn.has("nvim") == 1)
    end)

    it("can use vim.tbl_ utilities", function()
      local tbl1 = { a = 1, b = 2 }
      local tbl2 = { b = 3, c = 4 }
      local merged = vim.tbl_extend("force", tbl1, tbl2)
      assert.are.same({ a = 1, b = 3, c = 4 }, merged)

      local filtered = vim.tbl_filter(function(v)
        return v > 1
      end, { 1, 2, 3, 4 })
      assert.are.same({ 2, 3, 4 }, filtered)

      local mapped = vim.tbl_map(function(v)
        return v * 2
      end, { 1, 2, 3 })
      assert.are.same({ 2, 4, 6 }, mapped)
    end)

    it("can use vim.split", function()
      local parts = vim.split("a,b,c", ",")
      assert.are.same({ "a", "b", "c" }, parts)
    end)

    it("can use vim.startswith and vim.endswith", function()
      assert.is_true(vim.startswith("hello", "he"))
      assert.is_false(vim.startswith("hello", "lo"))
      assert.is_true(vim.endswith("hello", "lo"))
      assert.is_false(vim.endswith("hello", "he"))
    end)
  end)
end)
