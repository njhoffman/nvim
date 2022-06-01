-- vim-profiler.py nvim -n 10
-- vim-profiler.py -n 5 nvim foo.cc -c ":exec ':normal ia' | :q\!"
-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

require("globals")
local config = require("config")

vim.notify(string.format("Initializing neovim at %s ... ", os.date("%H:%M:%S")), "trace")

local function load_module(mod_name)
  local ok, err = pcall(require, mod_name)
  if not ok then
    local msg = "failed loading: " .. mod_name .. "\n " .. vim.inspect(err)
    vim.notify(msg, "error")
  end
end

if config.Load.impatient == true then
  -- move packer_compiled.lua over to lua?
  vim.notify("Using impatient optimization", "trace")
  load_module("impatient.lua.impatient")
  -- impatient.enable_profile()
end

for _, mod_name in ipairs(
  {
    -- "options.options-test",
    "disable-builtins",
    "vim-options",
    "plugins.load"
  }
) do
  load_module(mod_name)
end

for _, mod_name in ipairs(
  {
    "project",
    "buffers",
    "autocommands",
    "lsp",
    "stats.list",
    "mappings",
    "commands",
    "dashboard"
  }
) do
  load_module(mod_name)
end

local end_time = vim.fn.reltimestr(vim.fn.reltime(vim.g.start_time))
vim.notify("Finished loading in " .. end_time, "debug")

-- require"plenary.profile".stop()
