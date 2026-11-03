-- lsp.keymaps: buffer-local diagnostics pickers must use telescope, not Snacks
local calls
local snacks_calls

local function fake_client()
  return { name = "fake", server_capabilities = {} }
end

local function invoke(lhs)
  local m = vim.fn.maparg(lhs, "n", false, true)
  assert.are.equal(1, m.buffer, lhs .. " is not buffer-local")
  assert.is_function(m.callback)
  m.callback()
end

describe("lsp.keymaps diagnostics pickers", function()
  local saved_launcher, saved_snacks, bufnr

  before_each(function()
    calls, snacks_calls = {}, {}
    saved_launcher = package.loaded["configs.telescope.launcher"]
    package.loaded["configs.telescope.launcher"] = function(...)
      table.insert(calls, { ... })
    end
    saved_snacks = _G.Snacks
    _G.Snacks = setmetatable({}, {
      __index = function(_, mod)
        return setmetatable({}, {
          __index = function(_, fn)
            return function()
              table.insert(snacks_calls, mod .. "." .. fn)
            end
          end,
        })
      end,
    })
    bufnr = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_set_current_buf(bufnr)
    require("lsp.keymaps").setup(fake_client(), bufnr)
  end)

  after_each(function()
    package.loaded["configs.telescope.launcher"] = saved_launcher
    _G.Snacks = saved_snacks
    vim.cmd("enew")
    pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
  end)

  it("<C-t> opens telescope diagnostics for the current buffer", function()
    invoke("<C-t>")
    assert.are.same({ { "builtin", "diagnostics", { bufnr = 0 } } }, calls)
    assert.are.same({}, snacks_calls)
  end)

  it("<M-t> opens telescope workspace diagnostics", function()
    invoke("<M-t>")
    assert.are.same({ { "builtin", "diagnostics" } }, calls)
    assert.are.same({}, snacks_calls)
  end)

  it("binds the diagnostics keys only in the attached buffer", function()
    local other = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_set_current_buf(other)
    assert.are_not.equal(1, vim.fn.maparg("<M-t>", "n", false, true).buffer)
    vim.api.nvim_buf_delete(other, { force = true })
  end)
end)
