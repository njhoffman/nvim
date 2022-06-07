-- vim-profiler.py nvim -n 10
-- vim-profiler.py -n 5 nvim foo.cc -c ":exec ':normal ia' | :q\!"
-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

local function load_module(mod_name)
  local ok, module = pcall(require, mod_name)
  if not ok then
    local msg = "failed loading: " .. mod_name .. "\n " .. vim.inspect(module)
    vim.notify(msg, "error")
  else
    return impatient
  end
end

load_module("impatient") -- .enable_profile

for _, mod_name in ipairs(
  {
    "globals",
    "disable-builtins",
    "user-options",
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
    "lsp",
    "stats.list",
    "mappings",
    "commands",
    "autocommands",
    "dashboard"
  }
) do
  load_module(mod_name)
end

vim.cmd [[
  BarbarColors
]]

local end_time = vim.fn.reltimestr(vim.fn.reltime(vim.g.start_time))
vim.notify("Finished loading in" .. end_time, "debug")

-- require "plenary.profile".stop()
