--- Tests for bars.nvim statusline configuration.
--- Tests individual components, highlight setup, config structure, and themes.

describe("Bars Statusline", function()
  describe("Components", function()
    describe("file_size", function()
      it("returns empty for unnamed buffer", function()
        local file_size = require("bars.components.file_size")
        local buf = vim.api.nvim_create_buf(false, true)
        local win = vim.api.nvim_get_current_win()
        local result = file_size.value(buf, win)
        assert.are.equal("", result)
        vim.api.nvim_buf_delete(buf, { force = true })
      end)

      it("returns formatted size for a file", function()
        local file_size = require("bars.components.file_size")
        local tmp = vim.fn.tempname()
        vim.fn.writefile({ string.rep("x", 500) }, tmp)
        local buf = vim.fn.bufadd(tmp)
        vim.fn.bufload(buf)
        local win = vim.api.nvim_get_current_win()
        local result = file_size.value(buf, win)
        assert.is_truthy(result:match("%d"))
        assert.is_truthy(result:match("[bkMGT]"))
        vim.api.nvim_buf_delete(buf, { force = true })
        vim.fn.delete(tmp)
      end)
    end)

    describe("cursor_position", function()
      it("returns line:col format", function()
        local cursor_pos = require("bars.components.cursor_position")
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "hello", "world" })
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, buf)
        vim.api.nvim_win_set_cursor(win, { 2, 3 })
        local result = cursor_pos.value(buf, win)
        assert.is_truthy(result:match("2:4"))
        vim.api.nvim_buf_delete(buf, { force = true })
      end)
    end)

    describe("line_count", function()
      it("returns %%L in normal mode", function()
        local line_count = require("bars.components.line_count")
        local buf = vim.api.nvim_create_buf(false, true)
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, buf)
        local result = line_count.value(buf, win)
        assert.is_truthy(result:match("%%L"))
        vim.api.nvim_buf_delete(buf, { force = true })
      end)
    end)

    describe("filetype", function()
      it("returns lowercase filetype", function()
        local filetype = require("bars.components.filetype")
        local buf = vim.api.nvim_create_buf(false, true)
        vim.bo[buf].filetype = "Lua"
        local win = vim.api.nvim_get_current_win()
        local result = filetype.value(buf, win)
        assert.is_truthy(result:match("lua"))
        vim.api.nvim_buf_delete(buf, { force = true })
      end)
    end)

    describe("encoding", function()
      it("returns empty for utf-8", function()
        local encoding = require("bars.components.encoding")
        local buf = vim.api.nvim_create_buf(false, true)
        local win = vim.api.nvim_get_current_win()
        local result = encoding.value(buf, win)
        assert.are.equal("", result)
        vim.api.nvim_buf_delete(buf, { force = true })
      end)
    end)

    describe("fileformat", function()
      it("returns a format string", function()
        local fileformat = require("bars.components.fileformat")
        local buf = vim.api.nvim_create_buf(false, true)
        local win = vim.api.nvim_get_current_win()
        local result = fileformat.value(buf, win)
        assert.is_truthy(#result > 0)
        vim.api.nvim_buf_delete(buf, { force = true })
      end)
    end)

    describe("search_count", function()
      it("returns empty when no search active", function()
        local search_count = require("bars.components.search_count")
        local buf = vim.api.nvim_create_buf(false, true)
        local win = vim.api.nvim_get_current_win()
        local result = search_count.value(buf, win)
        assert.are.equal("", result)
        vim.api.nvim_buf_delete(buf, { force = true })
      end)
    end)

    describe("line_percentage", function()
      it("returns Top at first line", function()
        local line_pct = require("bars.components.line_percentage")
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "a", "b", "c", "d", "e" })
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, buf)
        vim.api.nvim_win_set_cursor(win, { 1, 0 })
        local result = line_pct.value(buf, win)
        assert.is_truthy(result:match("Top"))
        vim.api.nvim_buf_delete(buf, { force = true })
      end)

      it("returns Bot at last line", function()
        local line_pct = require("bars.components.line_percentage")
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "a", "b", "c", "d", "e" })
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, buf)
        vim.api.nvim_win_set_cursor(win, { 5, 0 })
        local result = line_pct.value(buf, win)
        assert.is_truthy(result:match("Bot"))
        vim.api.nvim_buf_delete(buf, { force = true })
      end)

      it("returns All for single-line buffer", function()
        local line_pct = require("bars.components.line_percentage")
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "only line" })
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, buf)
        local result = line_pct.value(buf, win)
        assert.is_truthy(result:match("All"))
        vim.api.nvim_buf_delete(buf, { force = true })
      end)
    end)

    describe("scroll_bar", function()
      it("returns block characters", function()
        local scroll_bar = require("bars.components.scroll_bar")
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "a", "b", "c" })
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, buf)
        local result = scroll_bar.value(buf, win)
        assert.is_truthy(#result > 0)
        vim.api.nvim_buf_delete(buf, { force = true })
      end)
    end)

    describe("git_diff", function()
      it("returns empty when no gitsigns data", function()
        local git_diff = require("bars.components.git_diff")
        local buf = vim.api.nvim_create_buf(false, true)
        local win = vim.api.nvim_get_current_win()
        assert.are.equal("", git_diff.added(buf, win))
        assert.are.equal("", git_diff.changed(buf, win))
        assert.are.equal("", git_diff.removed(buf, win))
        vim.api.nvim_buf_delete(buf, { force = true })
      end)

      it("returns count when gitsigns data exists", function()
        local git_diff = require("bars.components.git_diff")
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_var(buf, "gitsigns_status_dict", {
          added = 3,
          changed = 1,
          removed = 2,
        })
        local win = vim.api.nvim_get_current_win()
        local added = git_diff.added(buf, win)
        local changed = git_diff.changed(buf, win)
        local removed = git_diff.removed(buf, win)
        assert.is_truthy(added:match("3"))
        assert.is_truthy(changed:match("1"))
        assert.is_truthy(removed:match("2"))
        vim.api.nvim_buf_delete(buf, { force = true })
      end)
    end)

    describe("misc_stats", function()
      it("returns a string with throttle behavior", function()
        local misc_stats = require("bars.components.misc_stats")
        local buf = vim.api.nvim_create_buf(false, true)
        local win = vim.api.nvim_get_current_win()
        local result1 = misc_stats.value(buf, win)
        assert.is_truthy(#result1 > 0)
        local result2 = misc_stats.value(buf, win)
        assert.are.equal(result1, result2)
        vim.api.nvim_buf_delete(buf, { force = true })
      end)
    end)

    describe("hostname", function()
      it("returns a non-empty string", function()
        local hostname = require("bars.components.hostname")
        local buf = vim.api.nvim_create_buf(false, true)
        local win = vim.api.nvim_get_current_win()
        local result = hostname.value(buf, win)
        assert.is_truthy(#result > 0)
        vim.api.nvim_buf_delete(buf, { force = true })
      end)
    end)

    describe("datetime", function()
      it("returns a time string", function()
        local datetime = require("bars.components.datetime")
        local buf = vim.api.nvim_create_buf(false, true)
        local win = vim.api.nvim_get_current_win()
        local result = datetime.value(buf, win)
        assert.is_truthy(result:match("%d+:%d+"))
        vim.api.nvim_buf_delete(buf, { force = true })
      end)
    end)

    describe("tabs", function()
      it("returns empty with single tab", function()
        local tabs = require("bars.components.tabs")
        local buf = vim.api.nvim_create_buf(false, true)
        local win = vim.api.nvim_get_current_win()
        local result = tabs.value(buf, win)
        assert.are.equal("", result)
        vim.api.nvim_buf_delete(buf, { force = true })
      end)
    end)

    describe("selection_count", function()
      it("returns empty in normal mode", function()
        local selection_count = require("bars.components.selection_count")
        local buf = vim.api.nvim_create_buf(false, true)
        local win = vim.api.nvim_get_current_win()
        local result = selection_count.value(buf, win)
        assert.are.equal("", result)
        vim.api.nvim_buf_delete(buf, { force = true })
      end)
    end)
  end)

  describe("Highlights", function()
    local highlights

    before_each(function()
      highlights = require("configs.bars.highlights")
    end)

    it("defines color palette", function()
      assert.is_not_nil(highlights.colors)
      assert.is_not_nil(highlights.colors.bg)
      assert.is_not_nil(highlights.colors.fg)
      assert.is_not_nil(highlights.colors.cyan)
    end)

    it("sets up highlight groups without error", function()
      assert.has_no.errors(function()
        highlights.setup()
      end)
    end)

    it("creates expected highlight groups", function()
      highlights.setup()
      local groups = {
        "BarsSL_ModeNormal", "BarsSL_ModeInsert", "BarsSL_ModeVisual",
        "BarsSL_Project", "BarsSL_FileInfo", "BarsSL_GitBranch",
        "BarsSL_ScrollBar", "BarsSL_LinePct",
        -- Bubble theme
        "BarsSL_BubbleBuf", "BarsSL_BubbleGit",
        -- Rainbow theme
        "BarsSL_RainbowMode", "BarsSL_RainbowGit",
        -- Pure theme
        "BarsSL_PureMode", "BarsSL_PurePath",
      }
      for _, group in ipairs(groups) do
        assert.is_true(
          vim.fn.hlexists(group) == 1,
          "Highlight group " .. group .. " should exist"
        )
      end
    end)
  end)

  describe("Statusline Config", function()
    local sl_config

    before_each(function()
      sl_config = require("configs.bars.statusline")
    end)

    it("has a default style with components", function()
      assert.is_not_nil(sl_config.default)
      assert.is_not_nil(sl_config.default.components)
      assert.is_true(#sl_config.default.components > 0)
    end)

    it("has all 6 theme styles", function()
      local styles = { "default", "minimal", "stealth", "bubble", "rainbow", "pure" }
      for _, name in ipairs(styles) do
        assert.is_not_nil(sl_config[name], "Missing style: " .. name)
        assert.is_not_nil(sl_config[name].components, "Missing components for: " .. name)
        assert.is_true(#sl_config[name].components > 0, "Empty components for: " .. name)
      end
    end)

    it("has help and quickfix styles", function()
      assert.is_not_nil(sl_config.help)
      assert.is_not_nil(sl_config.quickfix)
      assert.is_function(sl_config.help.condition)
      assert.is_function(sl_config.quickfix.condition)
    end)

    it("all default components have valid kind field", function()
      for _, component in ipairs(sl_config.default.components) do
        assert.is_not_nil(component.kind, "Component missing kind field")
        assert.is_truthy(
          type(component.kind) == "string",
          "Component kind must be a string"
        )
      end
    end)

    it("all condition functions are callable", function()
      local buf = vim.api.nvim_create_buf(false, true)
      local win = vim.api.nvim_get_current_win()
      for i, component in ipairs(sl_config.default.components) do
        if type(component.condition) == "function" then
          assert.has_no.errors(function()
            component.condition(buf, win, "")
          end, "Condition function failed for component " .. i)
        end
      end
      vim.api.nvim_buf_delete(buf, { force = true })
    end)

    it("all theme components have valid kind field", function()
      local styles = { "minimal", "stealth", "bubble", "rainbow", "pure" }
      for _, name in ipairs(styles) do
        for i, component in ipairs(sl_config[name].components) do
          assert.is_not_nil(
            component.kind,
            name .. " component " .. i .. " missing kind field"
          )
        end
      end
    end)
  end)

  describe("Themes", function()
    local themes

    before_each(function()
      themes = require("configs.bars.themes")
    end)

    it("lists all 6 available themes", function()
      assert.is_not_nil(themes.available)
      assert.are.equal(6, #themes.available)
      local expected = { "slashed", "minimal", "stealth", "bubble", "rainbow", "pure" }
      for _, name in ipairs(expected) do
        assert.is_truthy(
          vim.tbl_contains(themes.available, name),
          "Missing theme: " .. name
        )
      end
    end)

    it("returns config for all known themes", function()
      for _, name in ipairs(themes.available) do
        local config = themes.get(name)
        assert.is_not_nil(config, "Theme " .. name .. " returned nil")
        assert.is_not_nil(config.components, "Theme " .. name .. " has no components")
      end
    end)

    it("returns nil for unknown theme", function()
      assert.is_nil(themes.get("nonexistent_theme"))
    end)
  end)
end)
