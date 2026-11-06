-- Notifications reach the log through noice's on_notify hook, from the real view config
vim.opt.rtp:append(vim.fn.expand("~/git/noice.nvim"))
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/nui.nvim")

local Config = require("noice.config")
local Message = require("noice.message")

describe("noice notification logging", function()
  local saved_logger, saved_notify, logged, shown, view

  local function show(content, level)
    local m = Message("notify", level)
    m:set(content)
    m.level = level
    view._messages = { m }
    view:show()
  end

  before_each(function()
    logged, shown = {}, {}
    saved_logger = package.loaded["lib.logger"]
    saved_notify = package.loaded["notify"]

    local function sink(name)
      return function(_, text)
        logged[#logged + 1] = { level = name, text = text }
      end
    end
    package.loaded["lib.logger"] = {
      init = function()
        return {
          trace = sink("trace"),
          debug = sink("debug"),
          info = sink("info"),
          warn = sink("warn"),
          error = sink("error"),
        }
      end,
    }
    package.loaded["notify"] = setmetatable({ notify = function() end }, {
      __call = function(_, content)
        shown[#shown + 1] = content
        return #shown
      end,
    })

    Config.setup({ views = require("configs.noice.views").config })
    view = require("noice.view").get_view("notify")
  end)

  after_each(function()
    package.loaded["lib.logger"] = saved_logger
    package.loaded["notify"] = saved_notify
  end)

  it("uses the plugin's notify backend, not a copy in the config", function()
    assert.same({}, vim.fn.glob(vim.fn.getcwd() .. "/lua/noice/**/*.lua", false, true))
  end)

  it("logs and shows a notification at its level", function()
    show("hello\n", "warn")
    assert.same({ { level = "warn", text = "hello" } }, logged)
    assert.equal(1, #shown)
  end)

  it("maps numeric levels", function()
    -- get_view caches the view, so don't leave the override behind for later tests
    view._opts.level = vim.log.levels.ERROR
    show("boom", "info")
    view._opts.level = nil
    assert.equal("error", logged[1].level)
  end)

  it("logs messages without a level as debug", function()
    show("quiet")
    assert.equal("debug", logged[1].level)
  end)
end)
