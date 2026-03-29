describe("tmux.configuration.options", function()
  local options

  before_each(function()
    package.loaded["tmux.configuration.options"] = nil
    options = require("tmux.configuration.options")
  end)

  it("has default copy_sync options", function()
    assert.are.equal(false, options.copy_sync.enable)
    assert.are.equal(false, options.copy_sync.redirect_to_clipboard)
    assert.are.equal(0, options.copy_sync.register_offset)
    assert.are.equal(true, options.copy_sync.sync_clipboard)
    assert.are.equal(true, options.copy_sync.sync_registers)
    assert.are.equal(true, options.copy_sync.sync_deletes)
    assert.are.equal(true, options.copy_sync.sync_unnamed)
  end)

  it("has default navigation options", function()
    assert.are.equal(true, options.navigation.cycle_navigation)
    assert.are.equal(false, options.navigation.default_keymaps)
    assert.are.equal(false, options.navigation.persist_zoom)
  end)

  it("has default resize options", function()
    assert.are.equal(false, options.resize.default_keymaps)
    assert.are.equal(1, options.resize.step_x)
    assert.are.equal(1, options.resize.step_y)
    assert.are.equal(3, options.resize.large_x)
    assert.are.equal(3, options.resize.large_y)
  end)

  it("merges user options via set()", function()
    options.set({ resize = { step_x = 5, step_y = 3 } })
    assert.are.equal(5, options.resize.step_x)
    assert.are.equal(3, options.resize.step_y)
    -- unchanged defaults preserved
    assert.are.equal(3, options.resize.large_x)
    assert.are.equal(false, options.resize.default_keymaps)
  end)

  it("does not overwrite with wrong types", function()
    options.set({ resize = { step_x = "bad" } })
    assert.are.equal(1, options.resize.step_x)
  end)

  it("ignores nil and empty string", function()
    options.set(nil)
    options.set("")
    assert.are.equal(1, options.resize.step_x)
  end)

  it("deep merges nested tables", function()
    options.set({ copy_sync = { ignore_buffers = { buffer0 = true } } })
    assert.are.equal(true, options.copy_sync.ignore_buffers.buffer0)
    assert.are.equal(false, options.copy_sync.ignore_buffers.empty)
  end)
end)
