local process = require("lab.process")
local code_runner = require("lab.code_runner")
local logger = require("logger").init("lab")
local commands = require("lab.commands")

-- https://www.npmjs.com/package/lab
-- output sinks
--   enhanced or basic virtual text: can set padding, right align fixed,
--      after longest with limit, or edge of screen
--      customizable icons and separators and highlights
--      multiline show output on hover
--    popup float which can be on cursor or anchored to edge
--    split or another buffer
--    a file in  plain text or colorized
--    notification
--
-- possible to have sink type associated with size/type of message?
local lab = {}
local state = { active = false }

local default_opts = {
  code_runner = {
    enabled = true,
  },
  quick_data = {
    enabled = true,
  },
}

function lab.setup(opts)
  if state.active == true then
    logger:debug("setting up but already active")
    return
  end

  opts = vim.tbl_deep_extend("force", default_opts, opts or {})

  if opts.code_runner.enabled or opts.quick_data.enabled then
    logger:debug("setting up process")
    process:start()
  end

  if opts.code_runner.enabled then
    logger:debug("setting up code runner")
    code_runner.setup(opts)
  end

  if opts.quick_data.enabled then
    local has_cmp, cmp = pcall(require, "cmp")
    if has_cmp then
      logger:debug("setting up quick data")
      require("lab.quick_data").init()
    else
      vim.notify("Quick data feature requires nvim cmp", "error", { title = "lab.nvim" })
    end
  end

  commands.setup()
  state.active = true
end

function lab.reset()
  process:stop()
  process:start()
end

function lab.stop()
  process:stop()
end

return lab
