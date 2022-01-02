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
    local msg = "failed loading: " .. mod_name .. "\n " .. err
    vim.notify(msg, "error")
  end
end

if (config.Load.type == "async") then
  local async
  if config.Load.impatient == true then
    vim.notify("Using impatient optimization", "trace")
    load_module("impatient.lua.impatient")
    -- lua require'impatient'.enable_profile()
  end
  async = vim.loop.new_async(vim.schedule_wrap(function()
    for _, mod_name in ipairs({ "main.options", "packer_compiled", "plugins.bootstrap", "plugins.load" }) do
      load_module(mod_name)
    end

    for _, mod_name in ipairs({ "lsp.setup", "debuglog", "main.autocommands", "mappings", "mappings.ignored" }) do
      load_module(mod_name)
    end
    -- is this correct?
    local end_time = vim.fn.reltimestr(vim.fn.reltime(vim.g.start_time))
    vim.notify("Finished loading in " .. end_time, "trace")
  end))
  async:send()
else
  vim.notify("Using load type: normal", "trace")

  if config.Load.impatient == true then
    vim.notify("Using impatient optimization", "trace")
    load_module("impatient.lua.impatient")
    -- lua require'impatient'.enable_profile()
  end

  for _, mod_name in ipairs({ "options.options-test", "main.options", "plugins.load" }) do load_module(mod_name) end

  local status, _ = pcall(require, "packer_compiled")
  if not status then
    vim.notify("Error requiring packer_compiled.lua: running PackerSync to fix!", "warn")
    -- vim.cmd('PackerCompile')
  else
    vim.notify("Loaded packer_compiled successfully", "trace")
  end

  -- for _, mod_name in ipairs({'lsp.setup', 'main.autocommands', 'mappings', 'mappings.ignored' }) do
  for _, mod_name in ipairs({
    "lsp.lsp-config",
    "lsp.lsp-servers",
    "debuglog",
    "main.autocommands",
    "mappings",
    "dashboard",
  }) do load_module(mod_name) end

  local end_time = vim.fn.reltimestr(vim.fn.reltime(vim.g.start_time))
  vim.notify("Finished loading in " .. end_time, "trace")
end

-- require"plenary.profile".stop()
