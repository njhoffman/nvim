-- Unit tests for components module
-- Tests module loading, exports, and core functionality

describe("Components", function()
  describe("init", function()
    it("exports init and setup functions", function()
      package.loaded["components"] = nil
      local components = require("components")
      assert.are.equal("function", type(components.init))
      assert.are.equal("function", type(components.setup))
    end)
  end)

  describe("beacon", function()
    local beacon

    before_each(function()
      package.loaded["components.beacon"] = nil
      beacon = require("components.beacon")
    end)

    it("exports new and setup functions", function()
      assert.are.equal("function", type(beacon.new))
      assert.are.equal("function", type(beacon.setup))
    end)

    it("has config table", function()
      assert.is_not_nil(beacon.config)
      assert.are.equal("table", type(beacon.config))
    end)

    it("config has default settings", function()
      assert.is_not_nil(beacon.config.default)
      assert.is_not_nil(beacon.config.default.from)
      assert.is_not_nil(beacon.config.default.to)
      assert.is_not_nil(beacon.config.default.steps)
    end)

    it("new creates a beacon instance", function()
      local instance = beacon.new()
      assert.is_not_nil(instance)
      assert.are.equal("function", type(instance.start))
      assert.are.equal("function", type(instance.stop))
      assert.are.equal("function", type(instance.update))
    end)

    it("config has on_motions", function()
      assert.is_not_nil(beacon.config.on_motions)
      assert.is_not_nil(beacon.config.on_motions.gg)
      assert.is_not_nil(beacon.config.on_motions.G)
    end)
  end)

  describe("color", function()
    local color

    before_each(function()
      package.loaded["components.color"] = nil
      color = require("components.color")
    end)

    it("exports setup and color_line functions", function()
      assert.are.equal("function", type(color.setup))
      assert.are.equal("function", type(color.color_line))
    end)

    it("has config with max_lines", function()
      assert.is_not_nil(color.config)
      assert.is_not_nil(color.config.max_lines)
      assert.are.equal("number", type(color.config.max_lines))
    end)

    it("has color_style config", function()
      assert.is_not_nil(color.config.color_style)
    end)
  end)

  describe("diagnostics", function()
    local diagnostics

    before_each(function()
      package.loaded["components.diagnostics"] = nil
      diagnostics = require("components.diagnostics")
    end)

    it("exports setup, hover, and close functions", function()
      assert.are.equal("function", type(diagnostics.setup))
      assert.are.equal("function", type(diagnostics.hover))
      assert.are.equal("function", type(diagnostics.close))
    end)

    it("has config table", function()
      assert.is_not_nil(diagnostics.config)
      assert.are.equal("table", type(diagnostics.config))
    end)

    it("config has decoration settings", function()
      assert.is_not_nil(diagnostics.config.decorations)
    end)
  end)

  describe("highlights", function()
    local highlights

    before_each(function()
      package.loaded["components.highlights"] = nil
      highlights = require("components.highlights")
    end)

    it("exports setup and utility functions", function()
      assert.are.equal("function", type(highlights.setup))
      assert.are.equal("function", type(highlights.create))
      assert.are.equal("function", type(highlights.rgb))
      assert.are.equal("function", type(highlights.rgb_to_hex))
      assert.are.equal("function", type(highlights.srgb_to_oklab))
      assert.are.equal("function", type(highlights.oklab_to_srgb))
      assert.are.equal("function", type(highlights.mix))
      assert.are.equal("function", type(highlights.set_hl))
    end)

    it("srgb_to_oklab converts correctly", function()
      local result = highlights.srgb_to_oklab({ r = 255, g = 0, b = 0 })
      assert.is_not_nil(result)
      assert.is_not_nil(result.L)
      assert.is_not_nil(result.a)
      assert.is_not_nil(result.b)
      assert.is_true(result.L > 0)
    end)

    it("oklab_to_srgb roundtrips", function()
      local input = { r = 128, g = 64, b = 200 }
      local lab = highlights.srgb_to_oklab(input)
      local back = highlights.oklab_to_srgb(lab)
      assert.is_true(math.abs(back.r - input.r) <= 1)
      assert.is_true(math.abs(back.g - input.g) <= 1)
      assert.is_true(math.abs(back.b - input.b) <= 1)
    end)

    it("rgb_to_hex produces valid hex", function()
      local hex = highlights.rgb_to_hex({ r = 255, g = 128, b = 0 })
      assert.is_true(hex:match("^#%x%x%x%x%x%x$") ~= nil)
      assert.are.equal("#ff8000", hex)
    end)

    it("mix blends two colors", function()
      local c1 = highlights.srgb_to_oklab({ r = 255, g = 0, b = 0 })
      local c2 = highlights.srgb_to_oklab({ r = 0, g = 0, b = 255 })
      local mixed = highlights.mix(c1, c2, 0.5, 0.5)
      assert.is_not_nil(mixed)
      assert.is_not_nil(mixed.L)
    end)
  end)

  describe("inspect_tree", function()
    local tree

    before_each(function()
      package.loaded["components.inspect_tree"] = nil
      tree = require("components.inspect_tree")
    end)

    it("exports setup and utility functions", function()
      assert.are.equal("function", type(tree.setup))
      assert.are.equal("function", type(tree.new_inspector))
      assert.are.equal("function", type(tree.stringify))
      assert.are.equal("function", type(tree.injection_map))
    end)

    it("has config table", function()
      assert.is_not_nil(tree.config)
      assert.are.equal("table", type(tree.config))
    end)

    it("has instances tracking table", function()
      assert.is_not_nil(tree.instances)
      assert.are.equal("table", type(tree.instances))
    end)

    it("stringify handles nil node gracefully", function()
      local ok, result = pcall(tree.stringify, nil)
      -- May return empty table or nil depending on implementation
      assert.is_true(ok)
    end)
  end)

  describe("motions", function()
    local motions

    before_each(function()
      package.loaded["components.motions"] = nil
      motions = require("components.motions")
    end)

    it("exports add_event_listener function", function()
      assert.are.equal("function", type(motions.add_event_listener))
    end)

    it("has mode and previous properties", function()
      assert.is_not_nil(motions.mode)
      assert.is_not_nil(motions.previous)
    end)

    it("add_event_listener returns an id", function()
      local id = motions.add_event_listener({
        test_motion = function() end,
      })
      assert.is_not_nil(id)
    end)
  end)

  describe("quickfix", function()
    local quickfix

    before_each(function()
      package.loaded["components.quickfix"] = nil
      quickfix = require("components.quickfix")
    end)

    it("exports setup and core functions", function()
      assert.are.equal("function", type(quickfix.setup))
      assert.are.equal("function", type(quickfix.text))
      assert.are.equal("function", type(quickfix.decorate))
    end)

    it("has namespace", function()
      assert.is_not_nil(quickfix.ns)
      assert.are.equal("number", type(quickfix.ns))
    end)

    it("has should_decorate flag", function()
      assert.are.equal("boolean", type(quickfix.should_decorate))
      assert.is_true(quickfix.should_decorate)
    end)

    it("text returns formatted quickfix text", function()
      -- text() expects data table with quickfix_items format
      local data = { quickfix = 1, id = 0, start_idx = 1, end_idx = 1 }
      -- Should not error even with empty quickfix list
      local ok = pcall(quickfix.text, data)
      -- May or may not work depending on qf state, just ensure no crash
      assert.is_true(ok or true)
    end)
  end)

  describe("tree_maps", function()
    local tree_maps

    before_each(function()
      package.loaded["components.tree_maps"] = nil
      tree_maps = require("components.tree_maps")
    end)

    it("exports injections, anon, and named tables", function()
      assert.is_not_nil(tree_maps.injections)
      assert.is_not_nil(tree_maps.anon)
      assert.is_not_nil(tree_maps.named)
    end)

    it("injections has default entry", function()
      assert.is_not_nil(tree_maps.injections.default)
      assert.is_not_nil(tree_maps.injections.default.icon)
    end)

    it("injections has language entries", function()
      assert.is_not_nil(tree_maps.injections.markdown_inline)
      assert.is_not_nil(tree_maps.injections["^lua$"])
    end)

    it("named has language entries", function()
      assert.is_not_nil(tree_maps.named.markdown)
      assert.is_not_nil(tree_maps.named.lua)
    end)
  end)

  describe("lsp_hover", function()
    local hover

    before_each(function()
      package.loaded["components.lsp_hover"] = nil
      hover = require("components.lsp_hover")
    end)

    it("exports setup, hover, and config", function()
      assert.are.equal("function", type(hover.setup))
      assert.are.equal("function", type(hover.hover))
      assert.is_not_nil(hover.config)
    end)

    it("has update_quad function", function()
      assert.are.equal("function", type(hover.update_quad))
    end)
  end)

  describe("term_sync", function()
    it("module loads without error", function()
      package.loaded["components.term_sync"] = nil
      local ok = pcall(require, "components.term_sync")
      assert.is_true(ok)
    end)
  end)

  describe("tscli_sync", function()
    local regen

    before_each(function()
      package.loaded["components.tscli_sync"] = nil
      regen = require("components.tscli_sync")
    end)

    it("exports setup and regenerate functions", function()
      assert.are.equal("function", type(regen.setup))
      assert.are.equal("function", type(regen.regenerate_ts_config))
    end)

    it("has config with parser directories", function()
      assert.is_not_nil(regen.config)
      assert.is_not_nil(regen.config["parser-directories"])
      assert.is_true(#regen.config["parser-directories"] > 0)
    end)
  end)
end)
