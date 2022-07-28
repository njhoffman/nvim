vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    local end_time = vim.fn.reltimestr(vim.fn.reltime(vim.g.start_time))
    end_time = string.sub(string.gsub(end_time, ' ', ''), 1, 5)
    vim.notify("Loaded in " .. end_time .. 's', "debug", { anchor = 'TC' })
  end,
  desc = "Create startup time notification when vim is finished loading",
})

local get_command_val = function(name)
  local val = nil
  for i, arg in vim.v.argv do
    if arg == '--' .. name then
      val = vim.v.argv[i + 1]
    end
  end
  return val
end

local cmd_val = get_command_val('startup-script')
if cmd_val ~= nil then
  vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function()
      vim.notify('Startup script: ' .. cmd_val)
    end,
    desc = "Run startup script after vim is finished loading",
  })

end

cmd_val = get_command_val('startup-command')
if cmd_val ~= nil then
  vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function()
      vim.notify('Startup command: ' .. cmd_val)
    end,
    desc = "Run startup commands after vim is finished loading",
  })
end
