describe("tmux.resize.resize", function()
  local resize
  local mock_tmux, mock_nvim, mock_layout, mock_options
  local separator_calls, statusline_calls

  before_each(function()
    -- Clear module cache
    for key, _ in pairs(package.loaded) do
      if key:match("^tmux%.") then
        package.loaded[key] = nil
      end
    end

    separator_calls = {}
    statusline_calls = {}

    -- Mock tmux wrapper
    mock_tmux = {
      is_tmux = true,
      resize = function() end,
    }
    package.loaded["tmux.wrapper.tmux"] = mock_tmux

    -- Mock nvim wrapper - default: single window (no splits)
    mock_nvim = {
      winnr = function()
        return 1
      end,
      resize = function() end,
      is_nvim_border = function()
        return true
      end,
      win_move_separator = function(winnr, offset)
        table.insert(separator_calls, { winnr = winnr, offset = offset })
      end,
      win_move_statusline = function(winnr, offset)
        table.insert(statusline_calls, { winnr = winnr, offset = offset })
      end,
    }
    package.loaded["tmux.wrapper.nvim"] = mock_nvim

    -- Mock layout - default: at tmux border
    mock_layout = {
      is_border = function()
        return true
      end,
    }
    package.loaded["tmux.layout"] = mock_layout

    -- Mock options
    mock_options = {
      resize = {
        step_x = 2,
        step_y = 1,
        large_x = 5,
        large_y = 3,
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

    -- Disable mini.animate integration for tests
    vim.g.minianimate_disable = true

    resize = require("tmux.resize.resize")
  end)

  describe("with nvim splits", function()
    it("moves separator left when split exists to the left", function()
      -- Windows: [2(left) | 1(current)]
      mock_nvim.winnr = function(dir)
        if dir == nil then
          return 1
        end
        if dir == "h" then
          return 2
        end
        return 1
      end

      resize.to("left")
      assert.are.equal(1, #separator_calls)
      assert.are.equal(2, separator_calls[1].winnr) -- left window
      assert.are.equal(-2, separator_calls[1].offset) -- step_x=2, negative
    end)

    it("moves separator left when only split to the right (resize left)", function()
      -- Windows: [1(current) | 2(right)]
      mock_nvim.winnr = function(dir)
        if dir == nil then
          return 1
        end
        if dir == "l" then
          return 2
        end
        return 1
      end

      resize.to("left")
      assert.are.equal(1, #separator_calls)
      assert.are.equal(1, separator_calls[1].winnr) -- current window
      assert.are.equal(-2, separator_calls[1].offset)
    end)

    it("moves separator right when split exists to the right", function()
      -- Windows: [1(current) | 2(right)]
      mock_nvim.winnr = function(dir)
        if dir == nil then
          return 1
        end
        if dir == "l" then
          return 2
        end
        return 1
      end

      resize.to("right")
      assert.are.equal(1, #separator_calls)
      assert.are.equal(1, separator_calls[1].winnr)
      assert.are.equal(2, separator_calls[1].offset)
    end)

    it("moves separator right via left window when only split to the left", function()
      -- Windows: [2(left) | 1(current)]
      mock_nvim.winnr = function(dir)
        if dir == nil then
          return 1
        end
        if dir == "h" then
          return 2
        end
        return 1
      end

      resize.to("right")
      assert.are.equal(1, #separator_calls)
      assert.are.equal(2, separator_calls[1].winnr) -- left window
      assert.are.equal(2, separator_calls[1].offset) -- positive = right
    end)

    it("moves statusline up when split exists above", function()
      -- Windows: [2(above)] / [1(current)]
      mock_nvim.winnr = function(dir)
        if dir == nil then
          return 1
        end
        if dir == "k" then
          return 2
        end
        return 1
      end

      resize.to("up")
      assert.are.equal(1, #statusline_calls)
      assert.are.equal(2, statusline_calls[1].winnr) -- upper window
      assert.are.equal(-1, statusline_calls[1].offset) -- step_y=1, negative
    end)

    it("moves statusline down when split exists below", function()
      -- Windows: [1(current)] / [2(below)]
      mock_nvim.winnr = function(dir)
        if dir == nil then
          return 1
        end
        if dir == "j" then
          return 2
        end
        return 1
      end

      resize.to("down")
      assert.are.equal(1, #statusline_calls)
      assert.are.equal(1, statusline_calls[1].winnr) -- current window
      assert.are.equal(1, statusline_calls[1].offset) -- step_y=1, positive
    end)

    it("moves statusline down from above window when only split above (resize down)", function()
      -- Windows: [2(above)] / [1(current)]
      mock_nvim.winnr = function(dir)
        if dir == nil then
          return 1
        end
        if dir == "k" then
          return 2
        end
        return 1
      end

      resize.to("down")
      assert.are.equal(1, #statusline_calls)
      assert.are.equal(2, statusline_calls[1].winnr) -- upper window
      assert.are.equal(1, statusline_calls[1].offset) -- positive = down
    end)

    it("moves statusline up via current window when only split below (resize up)", function()
      -- Windows: [1(current)] / [2(below)]
      mock_nvim.winnr = function(dir)
        if dir == nil then
          return 1
        end
        if dir == "j" then
          return 2
        end
        return 1
      end

      resize.to("up")
      assert.are.equal(1, #statusline_calls)
      assert.are.equal(1, statusline_calls[1].winnr) -- current window
      assert.are.equal(-1, statusline_calls[1].offset) -- negative = up
    end)
  end)

  describe("with tmux panes", function()
    it("resizes tmux pane when no nvim splits and tmux target available", function()
      local tmux_resize_called = {}
      mock_tmux.resize = function(dir, step)
        tmux_resize_called = { dir = dir, step = step }
      end

      -- Not at tmux border = tmux target available
      mock_layout.is_border = function()
        return false
      end

      resize.to("left")
      assert.are.equal("h", tmux_resize_called.dir)
      assert.are.equal(2, tmux_resize_called.step)
    end)

    it("resizes tmux when at border but only one nvim window", function()
      local tmux_resize_called = false
      mock_tmux.resize = function()
        tmux_resize_called = true
      end

      mock_layout.is_border = function()
        return true
      end
      -- Single nvim window: all winnr calls return 1
      mock_nvim.winnr = function()
        return 1
      end

      -- is_tmux_target: not is_border OR is_only_window
      -- is_border = true, is_only_window = true (winnr("1h") == winnr("1l"))
      -- so is_tmux_target = true
      resize.to("right")
      assert.is_true(tmux_resize_called)
    end)

    it("maps directions to hjkl for tmux", function()
      local directions_called = {}
      mock_tmux.resize = function(dir, step)
        table.insert(directions_called, dir)
      end
      mock_layout.is_border = function()
        return false
      end

      resize.to("left")
      resize.to("right")
      resize.to("up")
      resize.to("down")
      assert.are.same({ "h", "l", "k", "j" }, directions_called)
    end)
  end)

  describe("large resize", function()
    it("uses large step sizes for horizontal", function()
      -- Windows: [2(left) | 1(current)]
      mock_nvim.winnr = function(dir)
        if dir == nil then
          return 1
        end
        if dir == "h" then
          return 2
        end
        return 1
      end

      resize.to("left", true)
      assert.are.equal(1, #separator_calls)
      assert.are.equal(-5, separator_calls[1].offset) -- large_x=5
    end)

    it("uses large step for vertical", function()
      mock_nvim.winnr = function(dir)
        if dir == nil then
          return 1
        end
        if dir == "k" then
          return 2
        end
        return 1
      end

      resize.to("up", true)
      assert.are.equal(1, #statusline_calls)
      assert.are.equal(-3, statusline_calls[1].offset) -- large_y=3
    end)
  end)

  describe("nvim split priority over tmux", function()
    it("resizes nvim split even when tmux target exists", function()
      local tmux_resize_called = false
      mock_tmux.resize = function()
        tmux_resize_called = true
      end
      mock_layout.is_border = function()
        return false
      end

      -- Has split to the left
      mock_nvim.winnr = function(dir)
        if dir == nil then
          return 1
        end
        if dir == "h" then
          return 2
        end
        return 1
      end

      resize.to("left")
      assert.are.equal(1, #separator_calls)
      assert.is_false(tmux_resize_called)
    end)
  end)
end)
