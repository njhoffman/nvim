-- scripts/luacov_merge.lua: adds up luacov hit counts from per-spec stats files
local merge = dofile(vim.fn.getcwd() .. "/scripts/luacov_merge.lua").merge

describe("luacov_merge", function()
  it("adds hits per file and line", function()
    local a = { ["lua/x.lua"] = { max = 3, max_hits = 2, [1] = 2, [3] = 1 } }
    local b = { ["lua/x.lua"] = { max = 3, max_hits = 5, [1] = 5, [2] = 1 } }
    local out = merge({ a, b })["lua/x.lua"]
    assert.are.equal(7, out[1])
    assert.are.equal(1, out[2])
    assert.are.equal(1, out[3])
    assert.are.equal(3, out.max)
    assert.are.equal(7, out.max_hits)
  end)

  it("keeps files that appear in only one stats file", function()
    local out = merge({
      { ["lua/a.lua"] = { max = 1, max_hits = 1, [1] = 1 } },
      { ["lua/b.lua"] = { max = 2, max_hits = 4, [2] = 4 } },
    })
    assert.are.equal(1, out["lua/a.lua"][1])
    assert.are.equal(4, out["lua/b.lua"][2])
    assert.is_nil(out["lua/b.lua"][1])
  end)

  it("uses the largest line count seen for a file", function()
    local out = merge({
      { ["lua/a.lua"] = { max = 2, max_hits = 0 } },
      { ["lua/a.lua"] = { max = 9, max_hits = 0 } },
    })
    assert.are.equal(9, out["lua/a.lua"].max)
  end)

  it("returns an empty table for no input", function()
    assert.are.same({}, merge({}))
  end)
end)
