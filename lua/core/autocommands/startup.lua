-- Startup autocommands: load time, VimEnter setup and window layout on resize.

local logger = require("lib.logger").init("startup")

local get_load_time = function()
  local load_time = vim.fn.reltimestr(vim.fn.reltime(vim.g.start_time))
  load_time = string.sub(string.gsub(load_time, " ", ""), 1, 5)
  vim.g.load_time = load_time

  vim.defer_fn(function()
    vim.api.nvim_command("Tip")
    vim.defer_fn(function()
      logger:info("servername: " .. vim.v.servername)
      logger:info("argv: " .. vim.inspect(vim.v.argv))
      vim.notify("Loaded in `" .. load_time .. "s`", 2, { filetype = "markdown" })
      -- vim.cmd("VimadeReload")
    end, 2000)
  end, 2000)
end

vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = get_load_time,
  desc = "Create startup time notification when vim is finished loading",
})

local barbar_enabled = function()
  local aucmds = vim.api.nvim_get_autocmds({ group = "barbar_render" })
  return #aucmds > 0
end

local window_adjust = function(w)
  return function() end
end

local w_start = {
  barbar = { off = 60, on = 100 },
  sidebar = { off = 80, on = -1 },
}

local w_resize = {
  barbar = { off = 60, on = 100 },
  sidebar = { off = 100, on = 120 },
}

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  pattern = "*",
  callback = window_adjust(w_start),
  desc = "Show or hide barbar and sidebar when vim is finished loading",
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  pattern = "*",
  callback = window_adjust(w_resize),
  desc = "Show or hide barbar and sidebar when the window is resized",
})

local get_command_val = function(name)
  local val = nil
  for i, arg in pairs(vim.v.argv) do
    if arg == "--" .. name then
      val = vim.v.argv[i + 1]
    end
  end
  return val
end

local cmd_val = get_command_val("startup-script")
if cmd_val ~= nil then
  vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function()
      vim.notify("Startup script: " .. cmd_val)
    end,
    desc = "Run startup script after vim is finished loading",
  })
end

cmd_val = get_command_val("startup-command")
if cmd_val ~= nil then
  vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function()
      vim.notify("Startup command: " .. cmd_val)
    end,
    desc = "Run startup commands after vim is finished loading",
  })
end
