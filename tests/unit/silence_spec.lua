-- :Silence: message routes against the real noice router and filters
vim.opt.rtp:append(vim.fn.expand("~/git/noice.nvim"))
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/nui.nvim")

local Config = require("noice.config")
local Message = require("noice.message")
local Router = require("noice.message.router")

-- The first route matching a message decides, as in Router.update
local function first_route(message)
  for _, route in ipairs(Router._routes) do
    if message:is(route.filter) then
      return route
    end
  end
end

local function skipped(event, kind)
  local route = first_route(Message(event, kind))
  return route ~= nil and route.opts.skip == true
end

describe("silence", function()
  local silence, saved_notify, saved_plugin, saved_setup, setup_calls, sentinel

  before_each(function()
    saved_notify = vim.notify
    vim.notify = function() end
    saved_plugin = package.loaded["notify"]
    package.loaded["notify"] = {
      pending = function()
        return 0
      end,
      history = function()
        return {}
      end,
      dismiss = function() end,
      setup = function() end,
    }

    Config.setup({})
    -- Stands in for the routes the config installs: matches everything, as the catch-all defaults do
    Router._routes = {}
    sentinel = { filter = {}, opts = {} }
    table.insert(Router._routes, sentinel)

    setup_calls = 0
    local noice = require("noice")
    saved_setup = noice.setup
    noice.setup = function()
      setup_calls = setup_calls + 1
    end

    package.loaded["core.commands.silence"] = nil
    silence = require("core.commands.silence")
  end)

  after_each(function()
    vim.notify = saved_notify
    package.loaded["notify"] = saved_plugin
    require("noice").setup = saved_setup
    Router._routes = {}
  end)

  it("skips messages and notifications ahead of existing routes", function()
    silence.silence_start()
    assert.is_true(skipped("msg_show", ""))
    assert.is_true(skipped("msg_show", "emsg"))
    assert.is_true(skipped("notify", "info"))
  end)

  it("keeps blocking prompts visible", function()
    silence.silence_start()
    for _, kind in ipairs({ "confirm", "confirm_sub", "number_prompt", "return_prompt" }) do
      assert.is_false(skipped("msg_show", kind))
    end
  end)

  it("leaves the cmdline alone", function()
    silence.silence_start()
    assert.is_false(skipped("cmdline", nil))
  end)

  it("restores the routes on stop", function()
    silence.silence_start()
    assert.equal(2, #Router._routes)
    silence.silence_stop()
    assert.equal(1, #Router._routes)
    assert.equal(sentinel, Router._routes[1])
    assert.is_false(skipped("msg_show", ""))
  end)

  it("toggles back and forth without collecting routes", function()
    silence.silence_toggle()
    silence.silence_toggle()
    silence.silence_toggle()
    assert.equal(2, #Router._routes)
    silence.silence_toggle()
    assert.equal(1, #Router._routes)
  end)

  it("never calls noice.setup, which would reset the user's options", function()
    silence.silence_start()
    silence.silence_stop()
    assert.equal(0, setup_calls)
  end)
end)
