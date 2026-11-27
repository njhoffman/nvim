-- test_isolation: specs run by scripts/run_tests.sh write logs and state to a temp dir, not to the
-- user's ~/.local/share/nvim (NVIM_TEST_HOME); run directly, these checks are skipped.
local home = vim.env.NVIM_TEST_HOME

describe("test isolation", function()
  if not home or home == "" then
    pending("NVIM_TEST_HOME not set (spec run outside scripts/run_tests.sh)")
    return
  end

  local function under_home(path)
    return vim.startswith(vim.fn.resolve(path), vim.fn.resolve(home) .. "/")
  end

  it("puts data, state and cache under NVIM_TEST_HOME", function()
    for _, what in ipairs({ "data", "state", "cache" }) do
      assert.is_true(under_home(vim.fn.stdpath(what)), what .. ": " .. vim.fn.stdpath(what))
    end
  end)

  it("still finds the plugins through stdpath('data')", function()
    assert.are.equal(1, vim.fn.isdirectory(vim.fn.stdpath("data") .. "/lazy/plenary.nvim"))
  end)

  it("writes lib.logger files under NVIM_TEST_HOME", function()
    local logger = require("lib.logger").init("test_isolation", { module = 0 })
    logger:warn("isolation check")
    local path = vim.fn.stdpath("data") .. "/nvim-test_isolation.log"
    assert.is_true(under_home(path))
    assert.are.equal(1, vim.fn.filereadable(path))
  end)
end)
