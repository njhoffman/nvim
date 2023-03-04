local async = require("hover.async")
local job = require("hover.async.job").job

local function enabled(done)
  local is_ft = vim.tbl_contains({
    "sh",
    "zsh",
    "tcl",
    "make",
  }, vim.bo.filetype)
  done(is_ft)
end

local execute = async.void(function(done)
  local is_tcl = vim.bo.filetype == "tcl"

  local output = job({ "man", is_tcl and "n" or "1", vim.fn.expand("<cword>") })
  if not output then
    done()
    return
  end

  local lines = vim.split(output, "\n")
  done({ lines = lines, filetype = "man" })
end)

require("hover").register({
  name = "man",
  menu = "Man",
  desc = "Man Pages",
  priority = 150,
  enabled = enabled,
  execute = execute,
})
