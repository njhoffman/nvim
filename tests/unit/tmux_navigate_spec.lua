describe("tmux.navigation.navigate", function()
  local navigate
  local mock_tmux, mock_nvim, mock_layout, mock_options

  before_each(function()
    -- Clear module cache
    for key, _ in pairs(package.loaded) do
      if key:match("^tmux%.") then
        package.loaded[key] = nil
      end
    end

    -- Mock tmux wrapper
    mock_tmux = {
      is_tmux = true,
      is_zoomed = function()
        return false
      end,
      change_pane = function() end,
    }
    package.loaded["tmux.wrapper.tmux"] = mock_tmux

    -- Mock nvim wrapper
    mock_nvim = {
      is_nvim_border = function()
        return false
      end,
      wincmd = function() end,
      winnr = function()
        return 1
      end,
    }
    package.loaded["tmux.wrapper.nvim"] = mock_nvim

    -- Mock layout
    mock_layout = {
      is_border = function()
        return false
      end,
    }
    package.loaded["tmux.layout"] = mock_layout

    -- Mock options
    mock_options = {
      navigation = {
        cycle_navigation = true,
        persist_zoom = false,
      },
    }
    package.loaded["tmux.configuration.options"] = mock_options

    -- Mock log
    package.loaded["tmux.log"] = {
      debug = function() end,
      information = function() end,
      warning = function() end,
      error = function() end,
    }

    navigate = require("tmux.navigation.navigate")
  end)

  describe("has_tmux_target", function()
    it("returns false when not in tmux", function()
      mock_tmux.is_tmux = false
      assert.is_false(navigate.has_tmux_target("h"))
    end)

    it("returns false when zoomed and persist_zoom is true", function()
      mock_tmux.is_zoomed = function()
        return true
      end
      mock_options.navigation.persist_zoom = true
      assert.is_false(navigate.has_tmux_target("h"))
    end)

    it("returns true when not at tmux border", function()
      mock_layout.is_border = function()
        return false
      end
      assert.is_true(navigate.has_tmux_target("h"))
    end)

    it("returns true at border with cycle_navigation and opposite not at border", function()
      local borders = { h = true, l = false }
      mock_layout.is_border = function(dir)
        return borders[dir] or false
      end
      mock_options.navigation.cycle_navigation = true
      assert.is_true(navigate.has_tmux_target("h"))
    end)

    it("returns false at border without cycle_navigation", function()
      mock_layout.is_border = function()
        return true
      end
      mock_options.navigation.cycle_navigation = false
      assert.is_false(navigate.has_tmux_target("h"))
    end)
  end)

  describe("to", function()
    it("changes tmux pane when at nvim border with tmux target", function()
      local changed_direction = nil
      mock_nvim.is_nvim_border = function()
        return true
      end
      mock_tmux.change_pane = function(dir)
        changed_direction = dir
      end
      mock_layout.is_border = function()
        return false
      end

      navigate.to("h")
      assert.are.equal("h", changed_direction)
    end)

    it("moves within nvim when not at border", function()
      local wincmd_called = nil
      mock_nvim.is_nvim_border = function()
        return false
      end
      mock_nvim.wincmd = function(dir)
        wincmd_called = dir
      end

      navigate.to("l")
      assert.are.equal("l", wincmd_called)
    end)

    it("cycles to opposite edge when at nvim border with no tmux target", function()
      local wincmd_called = {}
      mock_nvim.is_nvim_border = function()
        return true
      end
      mock_tmux.is_tmux = false
      mock_options.navigation.cycle_navigation = true
      mock_nvim.wincmd = function(dir, count)
        wincmd_called = { dir = dir, count = count }
      end

      navigate.to("h")
      assert.are.equal("l", wincmd_called.dir)
      assert.are.equal(999, wincmd_called.count)
    end)
  end)
end)
