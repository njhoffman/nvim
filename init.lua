vim.g.start_time = vim.fn.reltime()
local config = require("config")
local logger = require("logger").initLogger("init")

-- vim-profiler.py nvim -n 10
-- vim-profiler.py -n 5 nvim foo.cc -c ":exec ':normal ia' | :q\!"
-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

vim.notify(string.format("Initializing neovim at %s ... ", os.date("%H:%M:%S")), "trace")

local function load_module(mod_name)
  local ok, err = pcall(require, mod_name)
  if not ok then
    local msg = "failed loading: " .. mod_name .. "\n " .. vim.inspect(err)
    vim.notify(msg, "error")
  end
end

if config.Load.impatient == true then
  vim.notify("Using impatient optimization", "trace")
  load_module("impatient.lua.impatient")
  -- lua require'impatient'.enable_profile()
end

for _, mod_name in ipairs(
  {
    -- "options.options-test",
    "vim-options",
    "plugins.load"
  }
) do
  load_module(mod_name)
end

local status, _ = pcall(require, "packer_compiled")
if not status then
  -- vim.cmd('PackerCompile')
  vim.notify("Error requiring packer_compiled.lua: running PackerSync to fix!", "warn")
else
  vim.notify("Loaded packer_compiled successfully", "trace")
end

-- for _, mod_name in ipairs({'lsp.setup', 'main.autocommands', 'mappings', 'mappings.ignored' }) do
for _, mod_name in ipairs(
  {
    "lsp",
    "debuglog",
    "autocommands",
    "stats.list",
    "mappings",
    "commands",
    "dashboard"
  }
) do
  load_module(mod_name)
end

local end_time = vim.fn.reltimestr(vim.fn.reltime(vim.g.start_time))
vim.notify("Finished loading in " .. end_time, "trace")

-- require"plenary.profile".stop()
