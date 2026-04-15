-- Unit tests for the registers module
-- Covers: config merging, state mode helpers, utils (register reading,
-- callback option handling, longest length), highlights (sign lookup),
-- and mappings (key table population).

local reset_modules = function()
  for mod, _ in pairs(package.loaded) do
    if mod:match("^registers") then
      package.loaded[mod] = nil
    end
  end
end

local save_registers = { "a", "b", "c", "d", "x", "y", "z" }
local clear_test_registers = function()
  for _, r in ipairs(save_registers) do
    vim.fn.setreg(r, "")
  end
end

describe("Registers", function()
  before_each(function()
    reset_modules()
    clear_test_registers()
  end)

  after_each(function()
    clear_test_registers()
  end)

  describe("config", function()
    it("get() returns nil before setup", function()
      local config = require("registers.config")
      assert.is_nil(config.get())
    end)

    it("setup() returns a fully populated options table", function()
      local config = require("registers.config")
      local opts = config.setup({})
      assert.is_not_nil(opts)
      assert.are.equal("string", type(opts.show))
      assert.are.equal("boolean", type(opts.show_empty))
      assert.are.equal("boolean", type(opts.register_user_command))
      assert.are.equal("table", type(opts.bind_keys))
      assert.are.equal("table", type(opts.symbols))
      assert.are.equal("table", type(opts.window))
      assert.are.equal("table", type(opts.sign_highlights))
    end)

    it("user override wins over default (show_empty)", function()
      local config = require("registers.config")
      local opts = config.setup({ show_empty = false })
      assert.is_false(opts.show_empty)
    end)

    it("get() returns the same table after setup", function()
      local config = require("registers.config")
      local opts = config.setup({})
      assert.are.equal(opts, config.get())
    end)
  end)

  describe("state", function()
    it("_previous_mode_is_visual returns true for visual modes", function()
      local state = require("registers.state")
      state._previous_mode = "v"
      assert.is_true(state._previous_mode_is_visual())
      state._previous_mode = "V"
      assert.is_true(state._previous_mode_is_visual())
      state._previous_mode = "\22" -- ^V
      assert.is_true(state._previous_mode_is_visual())
    end)

    it("_previous_mode_is_visual returns false for non-visual modes", function()
      local state = require("registers.state")
      state._previous_mode = "n"
      assert.is_false(state._previous_mode_is_visual())
      state._previous_mode = "i"
      assert.is_false(state._previous_mode_is_visual())
      state._previous_mode = "c"
      assert.is_false(state._previous_mode_is_visual())
    end)

    it("initializes new fields to sane defaults", function()
      local state = require("registers.state")
      assert.is_false(state._has_determined_register)
      assert.are.equal("", state._keys_to_press_at_the_very_end)
    end)
  end)

  describe("utils._read_registers", function()
    before_each(function()
      local config = require("registers.config")
      config.setup({ show = "abc", show_empty = true, hide_only_whitespace = true })
    end)

    it("populates filled registers into _register_values", function()
      vim.fn.setreg("a", "hello world")
      local utils = require("registers.utils")
      local state = require("registers.state")
      utils._read_registers()

      local found_a = false
      for _, r in ipairs(state._register_values) do
        if r.register == "a" then
          found_a = true
          break
        end
      end
      assert.is_true(found_a)
    end)

    it("places empty registers into _empty_registers", function()
      vim.fn.setreg("a", "")
      vim.fn.setreg("b", "")
      vim.fn.setreg("c", "")
      local utils = require("registers.utils")
      local state = require("registers.state")
      utils._read_registers()

      -- All three should be in empty_registers (no regcontents)
      assert.are.equal(3, #state._empty_registers)
    end)

    it("treats whitespace-only registers as empty when hide_only_whitespace=true", function()
      vim.fn.setreg("a", "   \t  ")
      vim.fn.setreg("b", "")
      vim.fn.setreg("c", "")
      local utils = require("registers.utils")
      local state = require("registers.state")
      utils._read_registers()

      local a_in_values = false
      for _, r in ipairs(state._register_values) do
        if r.register == "a" then
          a_in_values = true
          break
        end
      end
      assert.is_false(a_in_values)
      assert.is_true(vim.tbl_contains(state._empty_registers, "a"))
    end)

    it("replaces newline characters with the configured symbol", function()
      vim.fn.setreg("a", "line1\nline2")
      local utils = require("registers.utils")
      local state = require("registers.state")
      local config = require("registers.config")
      local opts = config.get()
      utils._read_registers()

      local a = nil
      for _, r in ipairs(state._register_values) do
        if r.register == "a" then
          a = r
          break
        end
      end
      assert.is_not_nil(a)
      assert.is_not_nil(a.line:find(opts.symbols.newline, 1, true))
    end)
  end)

  describe("utils._handle_callback_options", function()
    before_each(function()
      require("registers.config").setup({})
    end)

    it("calls the callback immediately when delay is 0", function()
      local utils = require("registers.utils")
      local state = require("registers.state")
      state._mode = "motion"

      local called = false
      local wrapped = utils._handle_callback_options(nil, function()
        called = true
      end)
      wrapped()
      assert.is_true(called)
    end)

    it("skips callback when current mode is not in if_mode", function()
      local utils = require("registers.utils")
      local state = require("registers.state")
      state._mode = "motion"

      local called = false
      local wrapped = utils._handle_callback_options({ if_mode = { "paste" } }, function()
        called = true
      end)
      wrapped()
      assert.is_false(called)
    end)

    it("runs the callback when current mode matches if_mode", function()
      local utils = require("registers.utils")
      local state = require("registers.state")
      state._mode = "motion"

      local called = false
      local wrapped = utils._handle_callback_options({ if_mode = { "motion" } }, function()
        called = true
      end)
      wrapped()
      assert.is_true(called)
    end)

    it("runs the 'after' callback after the main cb", function()
      local utils = require("registers.utils")
      local state = require("registers.state")
      state._mode = "motion"

      local order = {}
      local wrapped = utils._handle_callback_options({
        after = function()
          table.insert(order, "after")
        end,
      }, function()
        table.insert(order, "cb")
      end)
      wrapped()
      assert.are.same({ "cb", "after" }, order)
    end)
  end)

  describe("utils._longest_register_length", function()
    before_each(function()
      require("registers.config").setup({})
    end)

    it("returns 0 when no registers are loaded", function()
      local utils = require("registers.utils")
      local state = require("registers.state")
      state._register_values = {}
      assert.are.equal(0, utils._longest_register_length())
    end)

    it("returns the length of the longest register line", function()
      local utils = require("registers.utils")
      local state = require("registers.state")
      state._register_values = {
        { line = "short" },
        { line = "a longer line" },
        { line = "mid" },
      }
      assert.are.equal(#"a longer line", utils._longest_register_length())
    end)
  end)

  describe("highlights._highlight_for_sign", function()
    before_each(function()
      require("registers.config").setup({})
    end)

    it("returns the 'named' highlight for letter registers", function()
      local highlights = require("registers.highlights")
      local config = require("registers.config")
      local opts = config.get()
      assert.are.equal(opts.sign_highlights.named, highlights._highlight_for_sign("a"))
    end)

    it("returns the 'yank' highlight for register 0", function()
      local highlights = require("registers.highlights")
      local opts = require("registers.config").get()
      assert.are.equal(opts.sign_highlights.yank, highlights._highlight_for_sign("0"))
    end)

    it("returns the 'read_only' highlight for ':' register", function()
      local highlights = require("registers.highlights")
      local opts = require("registers.config").get()
      assert.are.equal(opts.sign_highlights.read_only, highlights._highlight_for_sign(":"))
    end)
  end)

  describe("mappings._fill_mappings", function()
    before_each(function()
      require("registers.config").setup({})
      -- Force a reload of mappings so _fill_mappings runs against fresh state
      package.loaded["registers.mappings"] = nil
    end)

    it("populates lowercase register keys into state._mappings", function()
      require("registers").setup({})
      local state = require("registers.state")
      -- Sanity: a-z and 0-9 should all be present (reserved j/k excluded)
      local expected = { "a", "b", "c", "x", "y", "z", "0", "1", "9", '"', "*", "+" }
      for _, key in ipairs(expected) do
        assert.is_not_nil(state._mappings[key], "expected state._mappings to contain key: " .. key)
      end
    end)

    it("does not populate reserved keys (normal/visual/insert/registers)", function()
      require("registers").setup({})
      local state = require("registers.state")
      assert.is_nil(state._mappings["normal"])
      assert.is_nil(state._mappings["visual"])
      assert.is_nil(state._mappings["insert"])
      assert.is_nil(state._mappings["registers"])
    end)

    it("adds uppercase variants for named registers", function()
      require("registers").setup({})
      local state = require("registers.state")
      -- At least one uppercase letter mapping should be present
      assert.is_not_nil(state._mappings["A"])
      assert.is_not_nil(state._mappings["Z"])
    end)
  end)
end)
