-- md_wrap_scroll: mini.animate scrolling is off while render-markdown shows wrapped table rows
local ws = require("modules.markdown.wrap_scroll")

local MOD = "render-markdown.core.ui"

-- A fake render-markdown decorator holding marks; n is its generation, bumped on every set.
local function decorator(marks)
  local d = { n = 1, marks = marks }
  function d.get(self)
    local out = {}
    for _, mark in ipairs(self.marks) do
      out[#out + 1] = {
        get = function()
          return mark
        end,
      }
    end
    return out
  end
  return d
end

local wrapped_mark = { replace = { {} }, opts = { conceal_lines = "" } }
local plain_mark = { opts = { virt_text = {} } }

describe("md_wrap_scroll", function()
  local buf, saved, fake

  before_each(function()
    saved = package.loaded[MOD]
    fake = { cache = {} }
    package.loaded[MOD] = fake
    buf = vim.api.nvim_create_buf(false, true)
  end)

  after_each(function()
    ws.on_clear({ buf = buf, win = 0 })
    package.loaded[MOD] = saved
    vim.api.nvim_buf_delete(buf, { force = true })
  end)

  local function render()
    ws.on_render({ buf = buf, win = 0 })
  end

  it("disables scroll animation when a row is wrapped", function()
    fake.cache[buf] = decorator({ plain_mark, wrapped_mark })
    render()
    assert.are.same({ scroll = { enable = false } }, vim.b[buf].minianimate_config)
  end)

  it("leaves buffers without wrapped rows alone", function()
    fake.cache[buf] = decorator({ plain_mark })
    render()
    assert.is_nil(vim.b[buf].minianimate_config)
  end)

  it("leaves buffers render-markdown has not seen alone", function()
    render()
    assert.is_nil(vim.b[buf].minianimate_config)
  end)

  it("keeps the buffer's own mini.animate settings and restores them", function()
    vim.b[buf].minianimate_config = { cursor = { enable = true }, scroll = { enable = true } }
    fake.cache[buf] = decorator({ wrapped_mark })
    render()
    assert.are.same(
      { cursor = { enable = true }, scroll = { enable = false } },
      vim.b[buf].minianimate_config
    )
    ws.on_clear({ buf = buf, win = 0 })
    assert.are.same(
      { cursor = { enable = true }, scroll = { enable = true } },
      vim.b[buf].minianimate_config
    )
  end)

  it("re-enables scrolling once a re-render has no wrapped rows", function()
    local d = decorator({ wrapped_mark })
    fake.cache[buf] = d
    render()
    d.marks, d.n = { plain_mark }, 2
    render()
    assert.is_nil(vim.b[buf].minianimate_config)
  end)

  it("reuses the answer until the decorator generation changes", function()
    local d = decorator({ wrapped_mark })
    fake.cache[buf] = d
    assert.is_true(ws.has_wrapped(buf))
    d.marks = { plain_mark }
    assert.is_true(ws.has_wrapped(buf))
    d.n = 2
    assert.is_false(ws.has_wrapped(buf))
  end)

  it("re-enables scrolling when rendering is cleared (insert mode)", function()
    fake.cache[buf] = decorator({ wrapped_mark })
    render()
    ws.on_clear({ buf = buf, win = 0 })
    assert.is_nil(vim.b[buf].minianimate_config)
  end)

  it("accepts 0 for the current buffer", function()
    fake.cache[buf] = decorator({ wrapped_mark })
    vim.api.nvim_set_current_buf(buf)
    assert.is_true(ws.has_wrapped(0))
  end)

  it("is a no-op when render-markdown is not installed", function()
    package.loaded[MOD] = nil
    package.preload[MOD] = function()
      error("not installed")
    end
    render()
    package.preload[MOD] = nil
    assert.is_nil(vim.b[buf].minianimate_config)
  end)
end)
